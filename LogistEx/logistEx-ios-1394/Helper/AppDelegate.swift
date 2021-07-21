/**
 *
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author     : Shiv Charan Panjeta < shiv@toxsl.com >
 *
 * All Rights Reserved.
 * Proprietary and confidential :  All information contained herein is, and remains
 * the property of ToXSL Technologies Pvt. Ltd. and its partners.
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 */

import UIKit
import GooglePlaces
import GoogleMaps
import SDWebImage
import IQKeyboardManagerSwift
import GoogleSignIn
import UserNotifications
import UserNotificationsUI
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var sideMenuVC  = SlideMenuController()
    var bookPostDict = BookNowDict()
    var isAppLaunchFromNotification = false
    var notificationDataDictionary  = NSDictionary()
    var notificationType = String()
    var preferredLang = "en"
    var objVariableSaveModel = VariableSaveModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupKeys()
        application.registerForRemoteNotifications()
        application.applicationIconBadgeNumber = 0
        generateDeviceToken(application)
        handlePushFromDidLaunch(launchOptions)
        return true
    }
    //MARK:-   Set Keys
    func setupKeys() -> Void {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        GMSServices.provideAPIKey(ApiKey.googleMapsPlacesApi)
        GMSPlacesClient.provideAPIKey(ApiKey.googleMapsPlacesApi)
        GIDSignIn.sharedInstance().clientID = ApiKey.googleClientId
        LocationManagerClass.sharedLocationManager().startStandardUpdates()
        Language.DoTheSwizzling()
        STPPaymentConfiguration.shared.publishableKey = ApiKey.stripePublishKey
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func handlePushFromDidLaunch(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Void {
        let remoteNotif = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any]
        isAppLaunchFromNotification = remoteNotif != nil ? true : false
        if KAppDelegate.isAppLaunchFromNotification == true {
            self.perform(#selector(self.postNotificationIfLaunchedFromAppIcon(_:)), with: remoteNotif, afterDelay: 3)
        }
    }
    @objc func postNotificationIfLaunchedFromAppIcon(_ notification: NSDictionary) {
        let visibleController  = getCurrentController()
        manageNotificationsClicks(withContoller: visibleController, and: notification)
    }
    func generateDeviceToken(_ application: UIApplication) -> Void {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                    })
                }
            }
        }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        UserDefaults.standard.set(token, forKey: "device_token")
        print(token)
    }
    func application(_ application: UIApplication, didRegister notificationSettings: UNNotificationSettings) {
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo as NSDictionary
        notificationDataDictionary  = userInfo
        print(userInfo)
        let visibleVC = getCurrentController()
        if KAppDelegate.isAppLaunchFromNotification == false {
            manageNotificationsWithOutClicks(withContoller: visibleVC, and: userInfo)
        }
        completionHandler([.badge, .alert, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo as NSDictionary
        notificationDataDictionary = userInfo
        print(userInfo)
        let visibleVC  = getCurrentController()
    //    if KAppDelegate.isAppLaunchFromNotification == false {
            manageNotificationsClicks(withContoller: visibleVC, and: userInfo)
     //   }
        completionHandler()
    }
    
    //MARK:- ManageNotifications
    func manageNotificationsClicks(withContoller controller : UIViewController, and userInfo: NSDictionary) -> Void {
        let actionType  = userInfo["action"] as? String ?? ""
        var orderId = Int()
        var typeId = Int()
        orderId = Proxy.shared.isValueInt(userInfo["model_id"] as Any)
        typeId = Proxy.shared.isValueInt(userInfo["type_id"] as Any)
        let dict = ["orderId": orderId,"typeId": typeId]
        
        switch actionType {
        case NotificationAction.acceptRequest,NotificationAction.updateStatus,NotificationAction.approve:
            if typeId == BookingState.completed.rawValue {
                if !controller.isKind(of: MyBookingsVC.self) {
                    let objController = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: "MyBookingsVC") as! MyBookingsVC
                    controller.navigationController?.pushViewController(objController, animated: true)
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MyBooking"), object: dict, userInfo: nil)
                }
            } else {
                if !controller.isKind(of: GetNearByDriverVC.self) {
                    if controller.isKind(of: CancelbookingVC.self) {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DismissController"), object: dict, userInfo: nil)
                    } else {
                        let objController = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: "GetNearByDriverVC") as! GetNearByDriverVC
                        objController.objGetNearByDriverVM.bookingId = orderId
                        objController.objGetNearByDriverVM.type = typeId
                        controller.navigationController?.pushViewController(objController, animated: true)
                    }
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TrackOrder"), object: dict, userInfo: nil)
                }
            }
        case NotificationAction.cancelBooking , NotificationAction.changeAmountRequest,NotificationAction.amountRequest, NotificationAction.paymentNotification :
            if !controller.isKind(of: MyBookingsVC.self) {
                let objController = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: "MyBookingsVC") as! MyBookingsVC
                controller.navigationController?.pushViewController(objController, animated: true)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MyBooking"), object: dict, userInfo: nil)
            }
            
        case NotificationAction.newMessage:
            var orderId = Int()
            var fromId = Int()
            var fromName = String()
            var userId = Int()
            orderId = Proxy.shared.isValueInt(userInfo["model_id"] as Any)
            fromId = Proxy.shared.isValueInt(userInfo["from_id"] as Any)
            fromName = userInfo["from_name"] as? String ?? ""
            userId = Proxy.shared.isValueInt(userInfo["user_id"] as Any)
            let dict = ["fromId": fromId,"fromName": fromName,"orderId": orderId, "userId": userId] as [String : Any]
            if !controller.isKind(of: ChatVC.self) {
                let objController = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                objController.objChatVM.toUserId = "\(userId)"
                objUserModel.id = fromId // userId
                objController.objChatVM.toUserName = fromName
                objController.objChatVM.bookingId = "\(orderId)"
                controller.navigationController?.pushViewController(objController, animated: true)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewMessage"), object: dict, userInfo: nil)
            }
        default:
            break
        }
    }
    
    //MARK:- ManageNotifications
    func manageNotificationsWithOutClicks(withContoller controller : UIViewController, and userInfo: NSDictionary) -> Void {
        let actionType  = userInfo["action"] as? String ?? ""
        var orderId = Int()
        var typeId = Int()
        orderId = Proxy.shared.isValueInt(userInfo["model_id"] as Any)
        typeId = Proxy.shared.isValueInt(userInfo["type_id"] as Any)
        let dict = ["orderId": orderId,"typeId": typeId,"actionType": actionType] as [String : Any]
        switch actionType {
        case NotificationAction.acceptRequest,NotificationAction.updateStatus,NotificationAction.acceptScheduledRequest:
            if typeId == BookingState.completed.rawValue {
                if controller.isKind(of: MyBookingsVC.self) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MyBooking"), object: dict, userInfo: nil)
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TrackOrder"), object: dict, userInfo: nil)
                }
            } else {
                if controller.isKind(of: GetNearByDriverVC.self) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TrackOrder"), object: dict, userInfo: nil)
                }
                if controller.isKind(of: CancelbookingVC.self) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DismissController"), object: dict, userInfo: nil)
                }
            }
        case NotificationAction.cancelBooking ,NotificationAction.changeAmountRequest :
            if controller.isKind(of: MyBookingsVC.self) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MyBooking"), object: dict, userInfo: nil)
            }
        default:
            break
        }
    }
    
    //MARK:- GetCurrentController
    func getCurrentController() -> UIViewController {
        if let viewC = UIApplication.shared.topMostViewController() {
            if let revealViewC = viewC  as? SlideMenuController {
                if let navigationCntrl = revealViewC.mainViewController as? UINavigationController {
                    return navigationCntrl.visibleViewController!
                }
            } else {
                return viewC
            }
        } else if let viewC = UIApplication.shared.topMostViewController() as? UINavigationController {
            return viewC.visibleViewController!
        } else if let viewC = UIApplication.shared.topMostViewController(){
            return viewC
        }
        return UIViewController()
    }
}

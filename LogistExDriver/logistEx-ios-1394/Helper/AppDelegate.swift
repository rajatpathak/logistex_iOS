//
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
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import UserNotifications
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var sideMenuVC  = SlideMenuController()
    var window: UIWindow?
    var isAppLaunchFromNotification = false
    var notificationDataDictionary  = NSDictionary()
    var notificationType = String()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        GMSPlacesClient.provideAPIKey(Keys.googleKey)
        GMSServices.provideAPIKey(Keys.googleKey)
        GIDSignIn.sharedInstance().clientID = Keys.googleClientId
        LocationManagerClass.sharedLocationManager().startStandardUpdates()
        application.statusBarStyle = .lightContent
        application.registerForRemoteNotifications()
        application.applicationIconBadgeNumber = 0
        generateDeviceToken(application)
        handlePushFromDidLaunch(launchOptions)
        Language.DoTheSwizzling()
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func handlePushFromDidLaunch(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Void {
        let remoteNotif = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any]
        isAppLaunchFromNotification = remoteNotif != nil ? true : false
        if KAppDelegate.isAppLaunchFromNotification == true {
            self.perform(#selector(self.postNotificationIfLaunchedFromAppIcon(_:)), with: remoteNotif, afterDelay: 1)
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
        let visibleVC   = getCurrentController()
        if KAppDelegate.isAppLaunchFromNotification == false {
            manageNotificationsClicks(withContoller: visibleVC, and: userInfo)
        }
        completionHandler()
    }
    
    //MARK:- ManageNotifications
    func manageNotificationsClicks(withContoller controller : UIViewController, and userInfo: NSDictionary) -> Void {
        let actionType  = userInfo["action"] as? String ?? ""
        switch actionType {
        case NotificationAction.newRequest:
            var orderId = String()
            var typeId = String()
            orderId = Proxy.shared.isValueString(userInfo["model_id"] as Any)
            typeId = Proxy.shared.isValueString(userInfo["type_id"] as Any)
            let dict = ["orderId": orderId,"typeId": typeId]
            
            if !controller.isKind(of: AllRequestVC.self) {
                let objController = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "AllRequestVC") as! AllRequestVC
                controller.navigationController?.pushViewController(objController, animated: true)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewRequest"), object: dict, userInfo: nil)
            }
        case NotificationAction.newMessage:
            var orderId = String()
            var fromId = String()
            var fromName = String()
            var userId = String()
            orderId = Proxy.shared.isValueString(userInfo["model_id"] as Any)
            fromId = Proxy.shared.isValueString(userInfo["from_id"] as Any)
            fromName = Proxy.shared.isValueString(userInfo["from_name"] as Any)
            userId = Proxy.shared.isValueString(userInfo["user_id"] as Any)
            let dict = ["fromId": fromId,"fromName": fromName,"orderId": orderId, "userId": userId]
            if !controller.isKind(of: ChatVC.self) {
                let objController = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                objController.title = TitleValue.chatUser
                objController.objChatVM.toUserId = "\(userId)"
                //objUserModel.userId = userId
                objController.objChatVM.toUserName = fromName
                objController.objChatVM.bookingId = "\(orderId)"
                controller.navigationController?.pushViewController(objController, animated: true)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewMessage"), object: dict, userInfo: nil)
            }
        case NotificationAction.cancelBooking, NotificationAction.rating:
            var orderId = String()
            var typeId = String()
            orderId = Proxy.shared.isValueString(userInfo["model_id"] as Any)
            typeId = Proxy.shared.isValueString(userInfo["type_id"] as Any)
            let dict = ["orderId": orderId,"typeId": typeId]
            if !controller.isKind(of: MyBookingVC.self) {
                let objController = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "MyBookingVC") as! MyBookingVC
                objController.title = TitleValue.rate
                controller.navigationController?.pushViewController(objController, animated: true)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MyBooking"), object: dict, userInfo: nil)
            }
        case NotificationAction.acceptAmountRequest,NotificationAction.acceptRequest,NotificationAction.approve,NotificationAction.success:
            var orderId = String()
            var typeId = String()
            orderId = Proxy.shared.isValueString(userInfo["model_id"] as Any)
            typeId = Proxy.shared.isValueString(userInfo["type_id"] as Any)
            let dict = ["orderId": orderId,"typeId": typeId]
            if !controller.isKind(of: HomeVC.self) {
                let objController = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                controller.navigationController?.pushViewController(objController, animated: true)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewChangeRequest"), object: dict, userInfo: nil)
            }
        case NotificationAction.newMessageAdmin:
            var orderId = String()
            var fromId = String()
            var fromName = String()
            var userId = String()
            orderId = Proxy.shared.isValueString(userInfo["model_id"] as Any)
            fromId = Proxy.shared.isValueString(userInfo["from_id"] as Any)
            fromName = Proxy.shared.isValueString(userInfo["from_name"] as Any)
            userId = Proxy.shared.isValueString(userInfo["user_id"] as Any)
            let dict = ["fromId": fromId,"fromName": fromName,"orderId": orderId, "userId": userId]
            if !controller.isKind(of: ChatVC.self) {
                let objController = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                objController.objChatVM.toUserId = "\(fromId)"
                objUserModel.userId = userId
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
        var orderId = String()
        var typeId = String()
        orderId = Proxy.shared.isValueString(userInfo["model_id"] as Any)
        typeId = Proxy.shared.isValueString(userInfo["type_id"] as Any)
        let dict = ["orderId": orderId,"typeId": typeId]
        switch actionType {
        case NotificationAction.newRequest:
            if controller.isKind(of: HomeVC.self) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewRequest"), object: dict, userInfo: nil)
            }
        case NotificationAction.cancelBooking:
            if !controller.isKind(of: MyBookingVC.self) {
                let objController = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "MyBookingVC") as! MyBookingVC
                objController.title = TitleValue.rate
                objController.objMyBookingVM.notificationType = typeId
                controller.navigationController?.pushViewController(objController, animated: true)
                
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MyBooking"), object: dict, userInfo: nil)
            }
          
        case NotificationAction.acceptAmountRequest,NotificationAction.acceptRequest,NotificationAction.approve,NotificationAction.success:
                    var orderId = String()
                    var typeId = String()
                    orderId = Proxy.shared.isValueString(userInfo["model_id"] as Any)
                    typeId = Proxy.shared.isValueString(userInfo["type_id"] as Any)
                    let dict = ["orderId": orderId,"typeId": typeId]
                    if !controller.isKind(of: HomeVC.self) {
                        let objController = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        controller.navigationController?.pushViewController(objController, animated: true)
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewChangeRequest"), object: dict, userInfo: nil)
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
        } else if let viewC   = UIApplication.shared.topMostViewController() as? UINavigationController {
            return viewC.visibleViewController!
        }
        return UIViewController()
    }
}

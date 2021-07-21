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

import NVActivityIndicatorView

let KAppDelegate = UIApplication.shared.delegate as! AppDelegate
@available(iOS 13.0, *)
let SceneDelegateInstance = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate

class Proxy {
    static var shared: Proxy {
        return Proxy()
    }
    fileprivate init(){}
    
    //MARK:- Common Methods
    func accessTokenNil() -> String {
        if let accessToken = UserDefaults.standard.object(forKey: "access_token") as? String {
            return accessToken
        } else {
            return ""
        }
    }
    //MARK:- REGISTER NIB FOR TABLE VIEW
    func registerNib(_ tblView: UITableView,identifierCell:String){
        let nib = UINib(nibName: identifierCell, bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: identifierCell)
    }
    func registerCollViewNib(_ collView: UICollectionView,identifierCell:String){
        let nib = UINib(nibName: identifierCell, bundle: nil)
        collView.register(nib, forCellWithReuseIdentifier: identifierCell)//register(nib, forCellReuseIdentifier: identifierCell)
    }
    
    
    //MARK:- Get Device Token
    func deviceToken() -> String {
        var deviceTokken =  ""
        if UserDefaults.standard.object(forKey: "device_token") == nil {
            deviceTokken = "00000000055"
            
        } else {
            deviceTokken = UserDefaults.standard.object(forKey: "device_token")! as! String
        }
        return deviceTokken
    }
    //MARK:- Latitude Method
    func getLatitude() -> String {
        if UserDefaults.standard.object(forKey: "lat") != nil {
            let currentLat =  UserDefaults.standard.object(forKey: "lat") as! String
            return currentLat
        }
        return ""
    }
    
    //MARK:- Longitude Method
    func getLongitude() -> String {
        if UserDefaults.standard.object(forKey: "long") != nil {
            let currentLong =  UserDefaults.standard.object(forKey: "long") as! String
            return currentLong
        }
        return ""
    }
    //MARK:- Longitude Method
       func getCourse() -> Double {
           if UserDefaults.standard.object(forKey: "head") != nil {
               let currentLong =  UserDefaults.standard.object(forKey: "head") as! Double
               return currentLong
           }
        return 0.0
       }
    func getCurrentAddress() -> String {
        if UserDefaults.standard.object(forKey: "address") != nil {
            let currentLong =  UserDefaults.standard.object(forKey: "address") as! String
            return currentLong
        }
        return ""
    }
    func statusBarColor(scrrenColor: String){
        UIApplication.shared.statusBarStyle = scrrenColor == "Black" ? .lightContent : .default
    }
    func UTCToLocal(UTCDateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Input Format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        guard let UTCDate = dateFormatter.date(from: UTCDateString) else { return ""}
        dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss" // Output Format
        dateFormatter.timeZone = TimeZone.current
        let UTCToCurrentFormat = dateFormatter.string(from: UTCDate)
        return UTCToCurrentFormat
    }
    //MARK:- Display Toast
    func displayStatusAlert(_ userMessage: String) {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                let window:UIWindow =  sd.window!
                window.rootViewController?.view.makeToast(message: userMessage,
                                                          duration: TimeInterval(2.0),
                                                          position: .bottom,
                                                          title: "",
                                                          backgroundColor: .black,
                                                          titleColor: .white,
                                                          messageColor: .white,
                                                          font: nil)
                window.makeKeyAndVisible()
            }
        } else {
            KAppDelegate.window?.rootViewController?.view.makeToast(message: userMessage,
                                                                    duration: TimeInterval(2.0),
                                                                    position: .bottom,
                                                                    title: "",
                                                                    backgroundColor: .black,
                                                                    titleColor: .white,
                                                                    messageColor: .white,
                                                                    font: nil)
            KAppDelegate.window?.makeKeyAndVisible()
        }
    }
    func openSettingApp() {
        
        UIApplication.shared.keyWindow?.rootViewController?.showAlertControllerWithStyle(alertStyle: .alert,  title: AlertMessages.connectionProblem,  message: AlertMessages.checkInternetConn, customActions: [AlertMessages.cancel, AlertMessages.settings], cancelTitle: "", needOK: false, completion: { (actionIndex) in
            if actionIndex == 1 {
                let url:URL = URL(string: UIApplication.openSettingsURLString)!
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: {
                        (success) in })
                } else {
                    guard UIApplication.shared.openURL(url) else {
                        Proxy.shared.displayStatusAlert(AlertMessages.reviewNetworkConn)
                        return
                    }
                }
            }
        })
    }
    
    //MARK: - HANDLE ACTIVITY
    func showActivityIndicator() {
        let activityData = ActivityData(size:  CGSize(width: 100, height: 100), message: AlertMessages.loading, type: .ballScaleRippleMultiple, color: .white, padding: CGFloat(60.0), backgroundColor: UIColor(red: 0/255, green:0/255, blue: 0/255, alpha: 0.5), textColor: .white)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
    }
    
    func hideActivityIndicator()  {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
    
    func expiryDateCheckMethod(expiryDate: String)->Bool  {
        let dateInFormat = DateFormatter()
        dateInFormat.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateInFormat.dateFormat = "yyyy-MM-dd"
        let expiryDate = dateInFormat.date(from: expiryDate)
        if Date().compare(expiryDate!) == .orderedDescending {
            displayDateCheckAlert()
            return false
        }
        return true
    }
    func changeDateFormat(dateStr:String, oldFormat:String = "yyyy-MM-dd HH:mm:ss", newFormat:String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = oldFormat
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = newFormat
        let date: Date? = dateFormatterGet.date(from: dateStr)
        return dateFormatter.string(from: date!)
    }
    func displayDateCheckAlert() {if #available(iOS 13.0, *) {
        let scene = UIApplication.shared.connectedScenes.first
        if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            let window:UIWindow =  sd.window!
            window.rootViewController?.showAlertControllerWithStyle(alertStyle: .alert,
                                                                    title: "Demo Expired",
                                                                    message: "Please contact with the team",
                                                                    customActions: [],
                                                                    cancelTitle: "Ok",
                                                                    needOK: true, completion: { (index) in
                                                                        
            })
            window.makeKeyAndVisible()
        }
    } else {
        KAppDelegate.window?.rootViewController?.showAlertControllerWithStyle(alertStyle: .alert,
                                                                              title: "Demo Expired",
                                                                              message: "Please contact with the team",
                                                                              customActions: [],
                                                                              cancelTitle: "Ok",
                                                                              needOK: true, completion: { (index) in
                                                                                
        })
        KAppDelegate.window?.makeKeyAndVisible()
        }
    }
    
    //MARK:- Logout Method
    func logout(_ completion:@escaping() -> Void){
        WebServiceProxy.shared.getData(Apis.logout, showIndicator: true) { (response) in
            UserDefaults.standard.set("", forKey: "access_token")
            UserDefaults.standard.setValue("", forKey: "Sort")
            UserDefaults.standard.setValue("", forKey: "Filter")
            UserDefaults.standard.synchronize()
            completion()
        }
    }
    func openGoogleMap(currentLat : String , currentLong : String ,destinationLat : String , destinationLong : String) {
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
            
            if let url = URL(string: "comgooglemaps-x-callback://?saddr\(currentLat),\(currentLong)=&daddr=\(destinationLat),\(destinationLong)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }}
        else {
            //Open in browser
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=\(currentLat),\(currentLong)&daddr=\(destinationLat),\(destinationLong)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
    }
    
    func isValueInt(_ value: Any) -> Int{
        
        var finalVal = Int()
        if let  idVal   = value as? Int{
            finalVal = idVal
        } else if let  idVal   = value as? Double{
            finalVal = Int(idVal)
        } else  if let idVal = value as? String{
            finalVal = Int(idVal) ?? 0
        }
        return finalVal
    }
    func isValueString(_ value: Any) -> String{
        
        var finalVal = ""
        if let idVal   = value as? Int{
            finalVal = "\(idVal)"
        } else if let  idVal   = value as? Double{
            finalVal = "\(idVal)"
        } else if let idVal = value as? String{
            finalVal = idVal
        }
        return finalVal
    }
    func isValueDouble(_ value: Any) -> Double{
        
        var finalVal = Double()
        if let  idVal = value as? Int{
            finalVal = Double(idVal)
        } else if let idVal = value as? Double {
            finalVal = idVal
        } else  if let idVal = value as? String{
            finalVal = Double(idVal) ?? 0.0
        }
        return finalVal
    }
}


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
import SwiftyDrop
import NVActivityIndicatorView

let KAppDelegate = UIApplication.shared.delegate as! AppDelegate

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
    
    func statusBarColor(scrrenColor: String){
        UIApplication.shared.statusBarStyle = scrrenColor == "Black" ? .lightContent : .default
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
    func hitlogoutApi(_ completion:@escaping() -> Void){
        WebServiceProxy.shared.getData(urlStr: Apis.logout, showIndicator: true) { (ApiResponse) in
            if ApiResponse!.success {
                UserDefaults.standard.set("", forKey: "access_token")
                UserDefaults.standard.synchronize()
                completion()
            } else {
                Proxy.shared.displayStatusAlert(message: "", state: .error)
            }
        }
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
    
    //MARK:- Display Toast
    func displayStatusAlert(message:String, state: DropState){
        Drop.down(message, state: state, duration: 3.5 )
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
                        Proxy.shared.displayStatusAlert(message: AlertMessages.reviewNetworkConn, state: .error)
                        return
                    }
                }
            }
        })
    }
    
    //MARK: - HANDLE ACTIVITY
    func showActivityIndicator() {
        let activityData = ActivityData()
        NVActivityIndicatorView.DEFAULT_TYPE =  NVActivityIndicatorType.ballClipRotatePulse
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 100, height: 100)
        NVActivityIndicatorView.DEFAULT_PADDING = CGFloat(60.0)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0/255, green:0/255, blue: 0/255, alpha: 0.5)
        NVActivityIndicatorView.DEFAULT_COLOR =  UIColor.white
        NVActivityIndicatorView.DEFAULT_TEXT_COLOR =  UIColor.white
        NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE = AlertMessages.loading
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
    }
    
    func hideActivityIndicator()  {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
    
    func changeDateFormat(dateStr:String, oldFormat:String = "yyyy-MM-dd HH:mm:ss", newFormat:String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = oldFormat
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = newFormat
        let date: Date? = dateFormatterGet.date(from: dateStr)
        return dateFormatter.string(from: date!)
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
    
    //MARK:- Logout Method
    func logout(){
        WebServiceProxy.shared.getData(urlStr: Apis.logout, showIndicator: true) { (response) in
            UserDefaults.standard.set("", forKey: "access_token")
            UserDefaults.standard.synchronize()
            KAppDelegate.window?.rootViewController?.root(selectedStoryboard: .main, identifier: .loginVC) 
            Proxy.shared.hideActivityIndicator()
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
    func isValidInput(_ input:String) -> Bool {
           let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
           
           if input.rangeOfCharacter(from: characterset.inverted) != nil {
               return false
           }
           return true
           
       }
    //MARK:- Language Selected String For Key
    func languageSelectedStringForKey(key: String) -> String {
        var path = String()
        if let languageStrVal = UserDefaults.standard.object(forKey: "Language") {
            if languageStrVal as! String ==  ChooseLanguage.english.rawValue {
                path = Bundle.main.path(forResource: "en", ofType: "lproj")!
            } else {
                path = Bundle.main.path(forResource:"es", ofType: "lproj")!
            }
        } else {
            path = Bundle.main.path(forResource:"en", ofType: "lproj")!
        }
        let languageBundle: Bundle = Bundle(path: path)!
        let str: String = languageBundle.localizedString(forKey: key, value: "", table: nil)
        return str
    }
    
}

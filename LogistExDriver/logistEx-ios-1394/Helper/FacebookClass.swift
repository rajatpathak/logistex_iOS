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
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import FacebookLogin
import FacebookCore

typealias FBSuccessHandler = (_ success:NSDictionary) -> Void
typealias FBFailHandler = (_ success:AnyObject) -> Void


class FacebookClass: NSObject {
    
    //MARK:- Variables
    var vc: UIViewController!
    var loginFail: FBFailHandler?
    var loginSucess: FBSuccessHandler?
    
    static var facebookClass: FacebookClass!
    
    class func sharedInstance() -> FacebookClass {
        
        if(facebookClass == nil) {
            facebookClass = FacebookClass()
        }
        return facebookClass
    }
    
    //MARK: - Logout Facebook
    /**
     For Logout From Facebook
     */
    func logoutFromFacebook() {
        
        if NetworkReachabilityManager()!.isReachable {
            let loginManager = LoginManager()
            if let cookies = HTTPCookieStorage.shared.cookies {
                for cookie in cookies {
                    if cookie.domain.contains("facebook.com") {
                        HTTPCookieStorage.shared.deleteCookie(cookie)
                    }
                }
            }
            loginManager.logOut()
        }
        else {
            Proxy.shared.displayStatusAlert(AlertMessages.checkInternetConn)
        }
    }
    
    //MARK: - Login with Facebook
    
    func loginWithFacebook(viewController: UIViewController, successHandler: @escaping FBSuccessHandler, failHandler: @escaping FBFailHandler) {
        
        vc = viewController
        loginFail = failHandler
        loginSucess = successHandler
        
        if NetworkReachabilityManager()!.isReachable {
            let loginManager = LoginManager()
            loginManager.logIn(permissions: ["public_profile", "email", "user_friends"], from: viewController) { (result, error) in
                if (error != nil) {
                    self.removeFbData()
                    Proxy.shared.showActivityIndicator()
                } else if (result?.isCancelled)! {
                    self.removeFbData()
                } else {
                    if (result?.grantedPermissions.contains("email"))! && (result?.grantedPermissions.contains("public_profile"))! {
                        self.fetchFacebookProfile()
                    }
                }
            }
        }
        else {
            self.loginFail!(AlertMessages.checkInternetConn as AnyObject)
        }
    }
    
    //MARK: - Fetch the user profile details
    func fetchFacebookProfile() {
        if AccessToken.current != nil {
            let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields" :"email,name,picture"])
            Proxy.shared.showActivityIndicator()
            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                if !((error) != nil) {
                    let resultDic = result as? NSDictionary
                    self.loginSucess!(resultDic!)
                }
            })
        }
    }
    
    /**
     For Logout From Facebook
     */
    func removeFbData() {
        let fbManager = LoginManager()
        fbManager.logOut()
        // AccessToken.setCurrent(nil)
    }
}

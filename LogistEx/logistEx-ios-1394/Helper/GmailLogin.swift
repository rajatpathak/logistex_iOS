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
//import Google
import GoogleSignIn

typealias SuccessHandler = (_ success:GIDGoogleUser) -> Void
typealias FailHandler = (_ success:AnyObject) -> Void


class GmailLogin: NSObject, GIDSignInDelegate {
//GIDSignInUIDelegate {
    
    var objCurrentVC: UIViewController!
    var loginFail: FailHandler?
    var loginSucess: SuccessHandler?
    var responseData = [""]
    static var gmailClass: GmailLogin!
    
    class func sharedInstance() -> GmailLogin {
        if(gmailClass == nil) {
            gmailClass = GmailLogin()
        }
        return gmailClass
    }
    
    
    func loginWithGmail(viewController: UIViewController, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) {
        objCurrentVC = viewController
        GIDSignIn.sharedInstance().presentingViewController = objCurrentVC
        loginFail = failHandler
        loginSucess = successHandler
        GIDSignIn.sharedInstance().delegate = self
       // GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func logoutGmail() {
        GIDSignIn.sharedInstance().signOut()
    }
    //****************** Gmail Login Delegate Methods *********************
    public func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        objCurrentVC.present(viewController, animated: false, completion: nil)
    }
    
    public func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        objCurrentVC.dismiss(animated: false, completion: nil)
    }
    
    //Login Success
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            loginSucess!(user)
        } else {
            loginFail!(error.localizedDescription as AnyObject)
        }
    }
    
    //Login Fail
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!, withError error: Error!) {
        loginFail!(error.localizedDescription as AnyObject)
    }
}

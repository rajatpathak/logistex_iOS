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
class ForgotPasswordVM: NSObject{
    
    //MARK:- Forgot Password Api
    func hitForgotPasswordApi(postParam: ForgotPassword, completion: @escaping()-> Void){
        if postParam.isValidForgotFields(){
            let param = ["User[email]": postParam.emailId!,
                         "User[role_id]": postParam.roleId!] as [String:AnyObject]
            WebServiceProxy.shared.postData(urlStr: Apis.forgotPassword, params: param, showIndicator: true) { (response) in
                completion()
                Proxy.shared.displayStatusAlert(message: (response?.message)!, state: .info)
            }
        }
    }
}


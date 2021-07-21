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

class ForgotPasswordVM: NSObject {
    
    func hitForgotPasswordApi(_ request: ForgotRequest, completion:@escaping() -> Void){
        if validData(request: request){
            let param = ["User[email]": request.email,
                         "User[role_id]": request.role
                ] as [String: AnyObject]
            
            WebServiceProxy.shared.postData(Apis.forgot, params: param as Dictionary<String, AnyObject>, showIndicator: true, completion: { (response)  in
                if response.success {
                    completion()
                } else {
                    Proxy.shared.displayStatusAlert(response.message ?? "")
                }
            })
        }
    }
    /**
     Check validation
     */
    func validData(request: ForgotRequest) -> Bool {
        if request.email!.isBlank {
            Proxy.shared.displayStatusAlert(AlertMessages.email.localized)
            return false
        } else if !request.email!.isValidEmail {
            Proxy.shared.displayStatusAlert(AlertMessages.validEmail.localized)
            return false
        }
        return true
    }
}

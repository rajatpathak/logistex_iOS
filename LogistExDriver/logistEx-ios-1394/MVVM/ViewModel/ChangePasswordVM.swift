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

class ChangePasswordVM: NSObject {
    
    //MARK:- api api for changes Password
    func hitChangePasswordApi(_ request: ChangePasswordRequest,completion:@escaping() -> Void) {
        if  validData(request){
            let param = ["User[newPassword]": request.newPassword] as [String:AnyObject]
            
            WebServiceProxy.shared.postData(Apis.changePassword, params: param, showIndicator: true) { (response) in
                if response.success {
                    
                    completion()
                } else {
                    Proxy.shared.displayStatusAlert(response.message ?? "")
                }
            }
        }
    }
    /**
     check validation
     */
    func validData(_ request: ChangePasswordRequest) -> Bool {
        if (request.newPassword?.isBlank)!{
            Proxy.shared.displayStatusAlert(AlertMessages.newPassword.localized)
        } else if request.newPassword!.count < 8 {
            Proxy.shared.displayStatusAlert(AlertMessages.passwordLimit.localized)
        } else if(request.confirmPassword?.isBlank)!{
            Proxy.shared.displayStatusAlert(AlertMessages.confirmPassword.localized)
        } else if request.confirmPassword != request.newPassword {
            Proxy.shared.displayStatusAlert(AlertMessages.notMatch.localized)
        } else{
            return true
        }
        return false
    }
}

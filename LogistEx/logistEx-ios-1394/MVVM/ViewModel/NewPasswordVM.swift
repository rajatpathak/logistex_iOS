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
class NewPasswordVM: NSObject {
    
    //MARK:- Change Password Api
    func hitChangePasswordApi(postParam: ChangePassword, completion:@escaping() -> Void){
        if postParam.validData(){
            let param = [
            "User[newPassword]": postParam.newPassword,
            "User[confirm_password]": postParam.confirmNewPassword ] as [String:AnyObject]
            WebServiceProxy.shared.postData(urlStr: Apis.changePassword, params: param, showIndicator: true) { (response) in
                completion()
            }
        }
    }
}

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
class SignUpVM: NSObject {
    
    var isProfileUpdted = false
    let objGalleryCameraImage = GalleryCameraImage()
    var currency = String()
    
    func hitSignUpApi(postParam: SignUp, imageDict: Dictionary<String, UIImage>, completion: @escaping() -> Void ){
        if postParam.validSignUpData() {
            
            let param = [
                "User[first_name]": postParam.firstName!,
                "User[last_name]": postParam.lastName!,
                "User[email]": postParam.emailId!,
                "User[contact_no]": postParam.mobileNumber!,
                "User[password]": postParam.password!,
                "User[currency]": postParam.currency!,
                "User[role_id]": "\(postParam.roleId!)"] as [String: AnyObject]
            
            WebServiceProxy.shared.uploadImage(param, parametersImage: imageDict, addImageUrl: Apis.signUp, showIndicator: true) { (response) in
                if response["error"] as? String ?? "" == "" {
                   completion()
                   Proxy.shared.displayStatusAlert(message: "Verification link sent to your email", state: .success)
                } else {
                  Proxy.shared.displayStatusAlert(message: response["error"] as? String ?? "", state: .error)
                }
            }
        }
    }
}

extension SignUpVC : PassImageDelegate {
    
    func getSelectedImage(selectImage: UIImage) {
        imgVwSignUp.image = selectImage
        objSignUpVM.isProfileUpdted = true
    }
}

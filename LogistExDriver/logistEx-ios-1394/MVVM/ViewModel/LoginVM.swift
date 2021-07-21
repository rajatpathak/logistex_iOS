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
import AuthenticationServices

class LoginVM: NSObject {
    
    //MARK:- Variables
    var languagePicker = UIPickerView()
    var toolBar = UIToolbar()
    var arrLanguage = [TitleValue.english,TitleValue.spanish]
    var selectedLanguage = ChooseLanguage.english.rawValue
    
    //MARK:- Hit Login Api
    func hitLoginApi(_ request: LoginRequest,completion:@escaping() -> Void) {
        if validData(request){
            
            let param = [
                "LoginForm[username]": request.name,
                "LoginForm[password]": request.password,
                "LoginForm[role_id]": request.role,
                "LoginForm[device_name]": DeviceInfo.deviceName,
                "LoginForm[device_token]": Proxy.shared.deviceToken(),
                "LoginForm[device_type]": DeviceInfo.deviceType,
                ] as [String:AnyObject]
            
            WebServiceProxy.shared.postData(Apis.login, params: param, showIndicator: true) { (response) in
                if response.success {
                    if let auth = response.data!["access-token"] as? String {
                        UserDefaults.standard.set(auth, forKey: "access_token")
                        UserDefaults.standard.synchronize()
                    }
                    if let userDetailDict = response.data!["user_detail"] as? NSDictionary {
                        objUserModel.saveData(userDetailDict)
                    }
                    completion()
                } else {
                    Proxy.shared.displayStatusAlert(response.message ?? "")
                }
            }
        }
    }
    
    //MARK:- Api For Facebook Login
    func hitFacebookLoginApi(_ request: FacebookRequest, completion:@escaping() -> Void) {
        let param = [
            "User[email]": request.email,
            "LoginForm[device_token]": Proxy.shared.deviceToken(),
            "LoginForm[device_type]": DeviceInfo.deviceType,
            "LoginForm[device_name]": DeviceInfo.deviceName,
            "User[role_id]": request.role,
            "User[full_name]": request.name,
            "User[userId]": request.userId,
            "User[provider]": request.provider] as [String:AnyObject]
        
        WebServiceProxy.shared.postData(Apis.socialLogin, params: param, showIndicator: true) { (response) in
            if response.success {
                if let auth = response.data!["access-token"] as? String {
                    UserDefaults.standard.set(auth, forKey: "access_token")
                    UserDefaults.standard.synchronize()
                }
                if let userDetailDict = response.data!["detail"] as? NSDictionary {
                    objUserModel.saveData(userDetailDict)
                }
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
    
    //MARK:-  Check Data Validation
    func validData(_ request: LoginRequest) -> Bool {
        if (request.name?.isBlank)!{
            Proxy.shared.displayStatusAlert(AlertMessages.email.localized)
        } else if !request.name!.isValidEmail {
            Proxy.shared.displayStatusAlert(AlertMessages.validEmail.localized)
        } else if (request.password?.isBlank)!{
            Proxy.shared.displayStatusAlert(AlertMessages.password.localized)
        } else {
            return true
        }
        return false
    }
}

@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        var userIdentifier,userFirstName,userLastName,userEmail,userFullName:String?
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
             userIdentifier = appleIDCredential.user
             userFirstName = appleIDCredential.fullName!.givenName
             userLastName = appleIDCredential.fullName!.familyName
             userEmail = appleIDCredential.email
             userFullName = "\(userFirstName ?? "") \(userLastName ?? "")"
            }
            let request = FacebookRequest(email: userEmail, name: userFirstName, role: "\(Role.driver.rawValue)", userId: userIdentifier, provider: Provider.apple)
        self.objLoginVM.hitFacebookLoginApi(request) {
        self.rootWithDrawer(identifier: "HomeVC")
            Proxy.shared.displayStatusAlert(AlertMessages.loginSuccess.localized)
        }
       
    }
}

@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension LoginVC: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return objLoginVM.arrLanguage[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        btnChooseLanguage.setTitle(objLoginVM.arrLanguage[row], for: .normal)
        switch row {
        case 0:
            objLoginVM.selectedLanguage = ChooseLanguage.english.rawValue
        case 1:
            objLoginVM.selectedLanguage = ChooseLanguage.spanish.rawValue
        default:
            break
        }
    }
}

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

import Foundation
import UIKit

class SignInVM: NSObject {
    
    //MARK:- Variables
    var languagePicker = UIPickerView()
    var toolBar = UIToolbar()
    var arrLanguage = [PassTitles.english,PassTitles.spanish]
    var selectedLanguage = ChooseLanguage.english.rawValue
    
    func hitSignInApi(postParam: Login,completion: @escaping() ->Void){
        if postParam.validLoginData() {
            let param = [
                "LoginForm[username]": postParam.emailId!,
                "LoginForm[password]": postParam.password!,
                "LoginForm[role_id]" : postParam.roleId!,
                "LoginForm[device_type]" : DeviceInfo.deviceType,
                "LoginForm[device_token]" : Proxy.shared.deviceToken(),
                "LoginForm[device_name]" : DeviceInfo.deviceName  ] as [String:AnyObject]
            
            WebServiceProxy.shared.postData(urlStr: Apis.signIn, params: param, showIndicator: true) { response in
                if let userDetailDict = response?.data!["user_detail"] as? Dictionary<String, AnyObject> {
                    objUserModel.setData(dictData: userDetailDict)
                    completion()
                } else {
                    Proxy.shared.displayStatusAlert(message: (response?.message!)!, state: .error)
                }
            }
        }
    }
    //MARK:- Api For Facebook Login
    func hitFacebookLoginApi(_ request: Facebook, completion:@escaping() -> Void) {
        let param = [
            "User[email]": request.email,
            "LoginForm[device_token]": Proxy.shared.deviceToken(),
            "LoginForm[device_type]": DeviceInfo.deviceType,
            "LoginForm[device_name]": DeviceInfo.deviceName,
            "User[role_id]": request.role,
            "User[full_name]": request.name,
            "User[userId]": request.userId,
            "User[provider]": request.provider] as [String:AnyObject]
        
        WebServiceProxy.shared.postData(urlStr: Apis.socialLogin, params: param, showIndicator: true) { (response) in
            if let userDetailDict = response?.data!["detail"] as? Dictionary<String, AnyObject> {
                objUserModel.setData(dictData: userDetailDict)
                completion()
            } else {
                Proxy.shared.displayStatusAlert(message: (response?.message!)!, state: .error)
            }
        }
    }
}

extension SignInVC: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return objSignInVM.arrLanguage[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        btnChooseLanguage.setTitle(objSignInVM.arrLanguage[row], for: .normal)
        switch row {
        case 0:
            objSignInVM.selectedLanguage = ChooseLanguage.english.rawValue
        case 1:
            objSignInVM.selectedLanguage = ChooseLanguage.spanish.rawValue
        default:
            break
        }
    }
}

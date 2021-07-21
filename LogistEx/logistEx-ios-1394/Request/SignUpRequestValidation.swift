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

struct SignUp{
    let firstName, lastName, emailId, password ,confirmPassword,currency, mobileNumber: String?
    let roleId : Int?
    let btnTerms : UIButton?
    
    func validSignUpData() -> Bool{
        if self.firstName!.isEmpty{
            Proxy.shared.displayStatusAlert(message: AlertMessages.firstName.localized, state: .warning)
            return false
        }else if self.lastName!.isEmpty{
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterLastName.localized, state: .warning)
            return false
        }else if self.emailId!.isEmpty{
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterEmail.localized, state: .warning)
            return false
        }else if !self.emailId!.isValidEmail{
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterValidEmail.localized, state: .warning)
            return false
        }else if self.password!.isEmpty{
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterPassword.localized, state: .warning)
            return false
        }else if self.password!.count < 8 {
            Proxy.shared.displayStatusAlert(message: AlertMessages.paswrdLimit.localized, state: .warning)
            return false
        }else if self.confirmPassword!.isEmpty{
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterConfirmPassword.localized, state: .warning)
            return false
        }else if self.password! != self.confirmPassword! {
            Proxy.shared.displayStatusAlert(message: AlertMessages.doesNotMatch.localized, state: .warning)
            return false
        }else if self.mobileNumber!.isEmpty{
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterPhoneNumber.localized, state: .warning)
            return false
        } else if self.mobileNumber!.count < 5 {
            Proxy.shared.displayStatusAlert(message: AlertMessages.phoneValidation.localized, state: .warning)
            return false
        } else if self.currency!.isEmpty {
            Proxy.shared.displayStatusAlert(message: AlertMessages.chooseCurrency.localized, state: .warning)
            return false
        } else if !btnTerms!.isSelected {
            Proxy.shared.displayStatusAlert(message: AlertMessages.acceptTermsAndCondition.localized, state: .warning)
            return false
        }
        return true
    }
    
}

extension SignUpVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFldPhone {
            let maxLength = 15
            let currentString: NSString = txtFldPhone.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtFldSelectCurrency{
            let controller = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: "SelectCountryPopUpVC") as! SelectCountryPopUpVC
            controller.objSelectCountryPopUpVM.objCountryData = { (currencyName,currencySymbol,currencyId) in
                self.txtFldSelectCurrency.text = "\(currencyName) \(currencySymbol)"
                self.objSignUpVM.currency = currencyId
            }
            self.present(controller, animated: true, completion: nil)
            return false
        }
        return true
    }
}

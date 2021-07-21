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

struct Profile {
    let firstName, lastName, email, mobileNumber ,currency, address: String?
    
    
    
    //MARK:- Check Validation
    func validData() -> Bool{
        if self.firstName!.isBlank {
            Proxy.shared.displayStatusAlert(message: AlertMessages.firstName.localized, state: .warning)
        } else if self.lastName!.isBlank {
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterLastName.localized, state: .warning)
        } else if self.email!.isEmpty{
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterEmail.localized, state: .warning)
            return false
        } else if !self.email!.isValidEmail{
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterValidEmail.localized, state: .warning)
            return false
        } else if self.mobileNumber!.isEmpty{
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterPhoneNumber.localized, state: .warning)
            return false
        } else if self.currency!.isEmpty{
            Proxy.shared.displayStatusAlert(message: AlertMessages.selectCurrency.localized, state: .warning)
            return false
        } else {
            return true
        }
        return false
    }
}
extension MyProfileVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtFldSelectCurrency {
            let controller = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: "SelectCountryPopUpVC") as! SelectCountryPopUpVC
            controller.objSelectCountryPopUpVM.objCountryData = { (currencyName,currencySymbol,currencyId) in
                self.txtFldSelectCurrency.text = "\(currencyName) \(currencySymbol)"
                self.objMyProfileVM.currency = currencyId
            }
            self.present(controller, animated: true, completion: nil)
            return false
        } else if textField == txtFldChangeLanguage {
            pickUp(txtFldChangeLanguage)
        }
        return true
    }
}

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

struct ForgotPassword {
    let emailId: String?
    let roleId: Int?
    
    func isValidForgotFields() -> Bool {
        if self.emailId!.isBlank {
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterEmail.localized, state: .warning)
        } else if !self.emailId!.isValidEmail {
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterValidEmail.localized, state: .warning)
        } else {
            return true
        }
        return false
    }
}

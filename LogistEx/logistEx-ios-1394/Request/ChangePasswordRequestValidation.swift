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
struct ChangePassword {
    let newPassword, confirmNewPassword : String?
    
    func validData() -> Bool {
        if self.newPassword!.isBlank {
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterPassword.localized, state: .warning)
        } else if self.newPassword!.count < 8 {
            Proxy.shared.displayStatusAlert(message: AlertMessages.paswrdLimit.localized, state: .warning)
        } else if self.confirmNewPassword!.isBlank {
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterConfirmPassword.localized, state: .warning)
        } else if self.newPassword != self.confirmNewPassword {
            Proxy.shared.displayStatusAlert(message: AlertMessages.doesNotMatch.localized, state: .warning)
        } else{
            return true
        }
        return false
    }
}

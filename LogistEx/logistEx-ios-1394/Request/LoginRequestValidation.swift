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

struct Login {
    let roleId : Int?
    let emailId, password : String?
    
    func validLoginData() -> Bool{
        if self.emailId!.isEmpty{
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterEmail.localized, state: .warning)
            return false
        } else if !self.emailId!.isValidEmail {
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterValidEmail.localized, state: .warning)
            return false
        } else if self.password!.isEmpty {
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterPassword.localized, state: .warning)
            return false
        }
        return true
    }
}
struct Facebook {
    let email: String?
    let name: String?
    let role: String?
    let userId: String?
    let provider: String?
}

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

struct ContactUs {
    let fullName, email, selectReason, enterReason: String?
    
    func validContactUs()-> Bool{
        if self.fullName!.isBlank{
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterFullName.localized, state: .warning)
        }else if self.email!.isBlank{
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterEmail.localized, state: .warning)
        }else if self.selectReason!.isBlank{
             Proxy.shared.displayStatusAlert(message: AlertMessages.selectReason.localized, state: .warning)
        }else if self.enterReason!.isBlank{
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterReason.localized, state: .warning)
        }else{
            return true
        }
        return false
    }
}

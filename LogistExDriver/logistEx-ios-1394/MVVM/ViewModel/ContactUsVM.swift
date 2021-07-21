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

class ContactUsVM: NSObject {
    
    //MARK:- Variables
    var selectedReason = String()
    
    //MARK:- Contact Us Api
    func apiContactUs(request: ContactUsRequest,  completion:@escaping() -> Void) {
        
        if validData(request: request) {
            let paramDict = [
                "User[full_name]": request.name,
                "User[email]": request.email,
                "User[reason]": request.selectedReason,
                "User[message]": request.message] as [String:AnyObject]
            
            WebServiceProxy.shared.postData(Apis.contactUs, params: paramDict, showIndicator: true) { response in
                if response.success {
                    completion()
                } else {
                    Proxy.shared.displayStatusAlert(response.message ?? "")
                }
            }
        }
    }
    
    //MARK:- Check Validation
    func validData(request: ContactUsRequest) -> Bool {
        if request.name!.isBlank {
            Proxy.shared.displayStatusAlert(AlertMessages.fullName.localized)
        } else if request.email!.isBlank {
            Proxy.shared.displayStatusAlert(AlertMessages.email.localized)
        } else if !request.email!.isValidEmail {
            Proxy.shared.displayStatusAlert(AlertMessages.validEmail.localized)
        } else if request.selectedReason!.isBlank {
            Proxy.shared.displayStatusAlert(AlertMessages.selectReason.localized)
        }  else if request.message!.isBlank {
            Proxy.shared.displayStatusAlert(AlertMessages.message.localized)
        } else {
            return true
        }
        return false
    }
}

extension ContactUsVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtFldSelectReason {
            let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "SelectVehiclePopupVC") as! SelectVehiclePopupVC
            controller.title = TitleValue.chooseReason
            controller.objSelectVehiclePopupVM.objVehicleCategory = { (id,title) in
                self.objContactUsVM.selectedReason = "\(id)"
                self.txtFldSelectReason.text = title
            }
            self.present(controller, animated: true, completion: nil)
            return false
        }
        return true
    }
}

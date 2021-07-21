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
class ContactUsVM: NSObject{
    
    //MARK:- ContactUs Api
    func hitContactUsApi(postParam: ContactUs, completion: @escaping()-> Void){
        if postParam.validContactUs(){
            let param = [
                "User[full_name]": postParam.fullName,
                "User[email]": postParam.email,
                "User[reason]": postParam.selectReason,
                "User[message]" : postParam.enterReason] as [String: AnyObject]
            
            WebServiceProxy.shared.postData(urlStr: "\(Apis.contactUs)", params: param, showIndicator: true) { (response) in
                completion()
            }
        }
    }
}
extension ContactUsVC: CategoryDelegateProtocol{
    func sendCategoryData(id: Int, title: String) {
        if txtFldSelectReason.isSelected == true{
            txtFldSelectReason.text = title
        }
    }
}
extension ContactUsVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtFldSelectReason {
             txtFldSelectReason.isSelected = true
            presentVC(selectedStoryboard: .main, identifier: .selectReasonVC)
            return false
        }
        return true
    }
}

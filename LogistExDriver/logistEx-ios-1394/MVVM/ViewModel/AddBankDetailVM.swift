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

class AddBankDetailVM: NSObject {
    
    //MARK:- Add Bank Account Api
    func addBankAccountApi(_ request: AddBankAccount, url: String, completion:@escaping() -> Void) {
        if validData(request){
            let param = [
                "BankAccount[account_number]": request.accountNo!,
                "BankAccount[bank_name]": request.bankName!,
                "BankAccount[account_name]": request.accountName!,
                "BankAccount[bank_code]":request.bankCode!] as [String:AnyObject]
            
            WebServiceProxy.shared.postData(url, params: param , showIndicator: true, completion: { (response)  in
                if response.success {
                    if let detailDict = response.data?["detail"] as? NSDictionary {
                        objUserModel.bankName = detailDict["bank_name"] as? String ?? ""
                        objUserModel.accountName = detailDict["account_name"] as? String ?? ""
                        objUserModel.bankCode = detailDict["bank_code"] as? String ?? ""
                        objUserModel.accountNo = Proxy.shared.isValueString(detailDict["account_number"] as Any)
                    }
                    completion()
                }
                else {
                    Proxy.shared.displayStatusAlert(response.data?["message"] as? String ?? "")
                }
            })
        }
    }
    //MARK:-  Check Data Validation
    func validData(_ request: AddBankAccount) -> Bool {
        if (request.bankName?.isBlank)! {
            Proxy.shared.displayStatusAlert(AlertMessages.bankName.localized)
        } else if (request.accountNo?.isBlank)! {
            Proxy.shared.displayStatusAlert(AlertMessages.accountNo.localized)
        } else if (request.accountName?.isBlank)! {
            Proxy.shared.displayStatusAlert(AlertMessages.accountName.localized)
        } else if (request.bankCode?.isBlank)! {
            Proxy.shared.displayStatusAlert(AlertMessages.bankCode.localized)
        } else {
            return true
        }
        return false
    }
}

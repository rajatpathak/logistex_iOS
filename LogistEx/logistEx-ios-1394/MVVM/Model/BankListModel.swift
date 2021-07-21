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
class BankListModel: NSObject {
    
    var bankName = String()
    var routingNo = String()
    var accountNo = String()
    var logoFile = String()
    var id = Int()
    var swiftCode = String()
    var emailId = String()
    var phoneNo = String()
    var intermediaryBank = String()
    var ibanNo = String()
    var beneficiaryName = String()
    
    func handleData(_ dict: NSDictionary) {
        emailId = dict["email"] as? String ?? ""
        bankName = dict["name"] as? String ?? ""
        swiftCode = dict["swift_code"] as? String ?? ""
        routingNo = dict["routing_number"] as? String ?? ""
        accountNo = dict["account_number"] as? String ?? ""
        logoFile = dict["logo_file"] as? String ?? ""
        id = Proxy.shared.isValueInt(dict["id"] as Any)
        phoneNo = dict["phone_number"] as? String ?? ""
        intermediaryBank = dict["intermediary_bank"] as? String ?? ""
        ibanNo = dict["iban"] as? String ?? ""
        beneficiaryName = dict["beneficiary"] as? String ?? ""
    }
}

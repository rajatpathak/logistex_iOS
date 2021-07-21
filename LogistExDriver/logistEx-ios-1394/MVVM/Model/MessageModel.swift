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

class MessageModel {
    
    var toUserId = Int()
    var fromUserId = String()
    var fromUserName = String()
    var createdOn = String()
    var date = String()
    var message = String()
    var requeiredDate = Date()
    
    func handleData(_ dict: NSDictionary) {
        toUserId = Proxy.shared.isValueInt(dict["to_user_id"] as Any)
        fromUserId = Proxy.shared.isValueString(dict["from_user_id"] as Any)
        message = dict["message"] as? String ?? ""
        createdOn = dict["created_on"] as? String ?? ""
        date = dict["created_on_date"] as? String ?? ""
        requeiredDate = date.getDateFromStr()
        fromUserName = dict["from_user_name"] as? String ?? ""
    }
}

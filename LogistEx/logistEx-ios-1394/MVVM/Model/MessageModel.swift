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
    var fromUserId = Int()
    var fromUserName = String()
    var createdOn = String()
    var date = String()
    var message = String()
    
    func handleData(_ dict: Dictionary<String, AnyObject>) {
        toUserId = dict.getValueInInt(dict["to_user_id"] as AnyObject)
        fromUserId = dict.getValueInInt(dict["from_user_id"] as AnyObject)
        message = dict["message"] as? String ?? ""
        createdOn = dict["created_on"] as? String ?? ""
        date = dict["created_on_date"] as? String ?? ""
        fromUserName = dict["from_user_name"] as? String ?? ""
    }
}

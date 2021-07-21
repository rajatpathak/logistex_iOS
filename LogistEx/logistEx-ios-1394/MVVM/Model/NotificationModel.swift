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

class NotificationModel{
    var id = Int()
    var modelId = Int()
    var desc = String()
    var createdOn = String()
    
    func setNotificationList(dictData: Dictionary<String, AnyObject>){
        id = dictData["id"] as? Int ?? 0
        modelId = dictData["model_id"] as? Int ?? 0
        desc = dictData["description"] as? String ?? ""
        // convert date
        let createdOnVal =  dictData["created_on"] as? String ?? ""
        createdOn = Proxy.shared.UTCToLocal(UTCDateString: createdOnVal)
    }
}

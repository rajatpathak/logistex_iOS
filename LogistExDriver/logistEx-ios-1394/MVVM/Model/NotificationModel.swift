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

class NotificationModel: NSObject {
    
    var title = String()
    var createdOn = String()
    var bookingId = String()
    
    func handleData(_ dict: NSDictionary) {
        title = dict["title"] as? String ?? ""
        // convert date
        let createdOnVal =  dict["created_on"] as? String ?? ""
        createdOn = Proxy.shared.UTCToLocal(UTCDateString: createdOnVal)
        
        bookingId = Proxy.shared.isValueString(dict["model_id"] as Any)
    }
}

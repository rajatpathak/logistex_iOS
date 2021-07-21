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

class EarningModel: NSObject {
    
    var amount = Double()
    var orderId = Int()
    var createdOn = String()
    var pickupLocation = String()
    var dropupLocation = String()
    var currency = String()
    var currencyId = String()
   
    
    func handleData(_ dict: NSDictionary) {
        orderId = Proxy.shared.isValueInt(dict["id"] as Any)
        pickupLocation = dict["pickup_location"] as? String ?? ""
        dropupLocation = dict["destination_location"] as? String ?? ""
        amount = Proxy.shared.isValueDouble(dict["amount"] as Any)
        // convert date
        let createdOnVal =  dict["created_on"] as? String ?? ""
        createdOn = Proxy.shared.UTCToLocal(UTCDateString: createdOnVal)
        
        currency = dict["currency"] as? String ?? ""
        currencyId = Proxy.shared.isValueString(dict["currency_id"] as Any)
    }
}

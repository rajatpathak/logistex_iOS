
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

class AllRequestModel: NSObject {
    
    var destLat = String()
    var destLong = String()
    var pickupLat = String()
    var pickupLong = String()
    var pickupLocation = String()
    var dropupLocation = String()
    var pickupDate = String()
    var orderId = Int()
    var amount = Double()
    var currency = String()
    
    var bookingType = String()
    func handleData(_ dict: NSDictionary) {
        if let bookingDict = dict["booking"] as? NSDictionary {
            currency = bookingDict["currency"] as? String ?? ""
            amount = Proxy.shared.isValueDouble(bookingDict["amount"] as Any)
            orderId = Proxy.shared.isValueInt(bookingDict["id"] as Any)
            destLat = bookingDict["destination_latitude"] as? String ?? ""
            destLong = bookingDict["destination_longitude"] as? String ?? ""
            pickupLat = bookingDict["pickup_latitude"] as? String ?? ""
            pickupLong = bookingDict["pickup_longitude"] as? String ?? ""
            pickupLocation = bookingDict["pickup_location"] as? String ?? ""
           
            // convert date
            let createdOnVal =  bookingDict["pickup_date"] as? String ?? ""
            pickupDate = Proxy.shared.UTCToLocal(UTCDateString: createdOnVal)
            
            dropupLocation = bookingDict["destination_location"] as? String ?? ""
            bookingType = Proxy.shared.isValueString(bookingDict["type_id"] as Any)
        }
    }
}

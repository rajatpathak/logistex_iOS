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

class DriverDetailModel: NSObject {
    
    var bookingId = String()
    var destLat = String()
    var destLong = String()
    var pickupLat = String()
    var pickupLong = String()
    var pickupLocation = String()
    var dropupLocation = String()
    var deliveryTime = String()
    var pickupDate = String()
    var desc = String()
    var buildingBlock = String()
    var pickupContactNo = String()
    var contactName = String()
    var floorNo = String()
    var roomNo = String()
    var ratingComment = String()
    var paymentMethod = Int()
    var bookingState = Int()
    var custContact = String()
    var custName = String()
    var qualityRating = Double()
    var serviceRating = Double()
    var deliveryRating = Double()
    var custProfile = String()
    var custId = Int()
    var amount = Double()
    var currency = String()
    var currencySymbol = String()


    var arrFiles = NSMutableArray()
    var userRating = Double()
    var comment = String()
    var custAverageRating = Double()
    var signature = String()

    func handleData(_ dict: NSDictionary) {
        bookingId = Proxy.shared.isValueString(dict["id"] as Any)
        amount = Proxy.shared.isValueDouble(dict["amount"] as Any)
        currency = dict["currency"] as? String ?? ""
        currencySymbol = dict["currency_symbol"] as? String ?? ""
        // convert date
        let pickupDateVal =  dict["pickup_date"] as? String ?? ""
        pickupDate = Proxy.shared.UTCToLocal(UTCDateString: pickupDateVal)
        
        let deliverDate =  dict["delivery_time"] as? String ?? ""
        deliveryTime = Proxy.shared.UTCToLocal(UTCDateString: deliverDate)
        
        destLat = dict["destination_latitude"] as? String ?? ""
        destLong = dict["destination_longitude"] as? String ?? ""
        pickupLat = dict["pickup_latitude"] as? String ?? ""
        pickupLong = dict["pickup_longitude"] as? String ?? ""
        pickupLocation = dict["pickup_location"] as? String ?? ""
        dropupLocation = dict["destination_location"] as? String ?? ""
        pickupContactNo = dict["contact_number"] as? String ?? ""
        contactName = dict["contact_name"] as? String ?? ""
        buildingBlock = dict["building_block"] as? String ?? ""
        floorNo = dict["floor"] as? String ?? ""
        roomNo = dict["room_no"] as? String ?? ""
        bookingState = Proxy.shared.isValueInt(dict["state_id"] as Any)
        paymentMethod = Proxy.shared.isValueInt(dict["payment_method"] as Any)
        custAverageRating = Proxy.shared.isValueDouble(dict["user_avg_rating"] as Any)
        signature = dict["signature_file"] as? String ?? ""

        if let arrFile = dict["files"] as? [NSDictionary] {
            for dict in arrFile {
                arrFiles.add(dict)
            }
        }
        
        if let ratingDict = dict["User_rating"] as? NSDictionary {
            comment = ratingDict["comment"] as? String ?? ""
            userRating = Proxy.shared.isValueDouble(ratingDict["rating"] as Any)
        }
        
        if let createdByDict =  dict["createdBy"] as? NSDictionary {
            custContact = createdByDict["contact_no"] as? String ?? ""
            custName = createdByDict["full_name"] as? String ?? ""
            custProfile = createdByDict["profile_file"] as? String ?? ""
            custId = Proxy.shared.isValueInt(createdByDict["id"] as Any)
        }
        
        if let ratingDict =  dict["driver_rating"] as? NSDictionary {
            qualityRating = Proxy.shared.isValueDouble(ratingDict["quality_rating"] as Any)
            deliveryRating = Proxy.shared.isValueDouble(ratingDict["delivery_rating"] as Any)
            serviceRating = Proxy.shared.isValueDouble(ratingDict["service_rating"] as Any)
            ratingComment = ratingDict["comment"] as? String ?? ""
        }
    }
}

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

class AccepRequestModel: NSObject {
    
    var bookingId = String()
    var destLat = String()
    var destLong = String()
    var pickupLat = String()
    var pickupLong = String()
    var pickupLocation = String()
    var dropupLocation = String()
    var pickupDate = String()
    var desc = String()
    var dropBuildingBlock = String()
    var pickupBuildingBlock = String()
    var pickupContactNo = String()
    var pickupContactName = String()
    var pickupFloorNo = String()
    var pickupRoomNo = String()
    var dropContactNo = String()
    var dropContactName = String()
    var dropFloorNo = String()
    var dropRoomNo = String()
    var paymentMethod = Int()
    var isNagotiableAmount = Int()
    var isReschudled = Int()
    var amountChangeRequestStatus = Int()
    var bookingState = Int()
    var custContact = String()
    var custName = String()
    var custProfile = String()
    var deliveryTime = String()
    var custId = Int()
    var bookingType = String()
    var amount = Double()
    var finalAmount = Double()
    var paymentStatus = Int()

    var arrFiles = NSMutableArray()
    var currency = String()
    var currencySymbol = String()

    

    func saveData(_ dict: NSDictionary) {
        if let bookingData = dict["booking_data"] as? NSDictionary {
            bookingId = Proxy.shared.isValueString(bookingData["booking_id"] as Any)
            if let bookingDict = bookingData["booking"] as? NSDictionary {
                amount = Proxy.shared.isValueDouble(bookingDict["amount"] as Any)
                finalAmount = Proxy.shared.isValueDouble(bookingDict["new_amount"] as Any)
                currency = bookingDict["currency"] as? String ?? ""
                currencySymbol = bookingDict["currency_symbol"] as? String ?? ""
                pickupDate = bookingDict["pickup_date"] as? String ?? ""
                destLat = bookingDict["destination_latitude"] as? String ?? ""
                destLong = bookingDict["destination_longitude"] as? String ?? ""
                pickupLat = bookingDict["pickup_latitude"] as? String ?? ""
                pickupLong = bookingDict["pickup_longitude"] as? String ?? ""
                pickupLocation = bookingDict["pickup_location"] as? String ?? ""
                dropupLocation = bookingDict["destination_location"] as? String ?? ""
                pickupContactNo = bookingDict["pickup_contact_number"] as? String ?? ""
                pickupContactName = bookingDict["pickup_contact_name"] as? String ?? ""
                pickupBuildingBlock = bookingDict["pickup_block"] as? String ?? ""
                pickupFloorNo = bookingDict["pickup_floor"] as? String ?? ""
                pickupRoomNo = bookingDict["pickup_room"] as? String ?? ""
                dropFloorNo = bookingDict["floor"] as? String ?? ""
                dropRoomNo = bookingDict["room_no"] as? String ?? ""
                dropContactNo = bookingDict["contact_number"] as? String ?? ""
                dropContactName = bookingDict["contact_name"] as? String ?? ""
                desc = bookingDict["description"] as? String ?? ""
                dropBuildingBlock = bookingDict["building_block"] as? String ?? ""
                bookingType = Proxy.shared.isValueString(bookingDict["type_id"] as Any)
                bookingState = Proxy.shared.isValueInt(bookingDict["state_id"]  as Any)
                paymentMethod = Proxy.shared.isValueInt(bookingDict["payment_method"] as Any)
                isNagotiableAmount = Proxy.shared.isValueInt(bookingDict["is_negotiable"] as Any)
                isReschudled = Proxy.shared.isValueInt(bookingDict["is_reschedule"] as Any)
                amountChangeRequestStatus = Proxy.shared.isValueInt(bookingDict["amount_request"] as Any)
                paymentStatus = Proxy.shared.isValueInt(bookingDict["payment_status"] as Any)
                deliveryTime = bookingDict["delivery_time"] as? String ?? ""
                arrFiles = []
                if let arrFile = bookingData["files"] as? [NSDictionary] {
                    for dict in arrFile {
                        arrFiles.add(dict)
                    }
                }
            }
            if let createdByDict =  bookingData["createdBy"] as? NSDictionary {
                custContact = createdByDict["contact_no"] as? String ?? ""
                custName = createdByDict["full_name"] as? String ?? ""
                custProfile = createdByDict["profile_file"] as? String ?? ""
                custId = Proxy.shared.isValueInt(createdByDict["id"] as Any)
            }
        }
    }
}

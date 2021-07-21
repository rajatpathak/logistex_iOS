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

class CurrentRequestModel: NSObject {
    var destLat = String()
    var destLong = String()
    var pickupLat = String()
    var pickupLong = String()
    var pickupLocation = String()
    var dropupLocation = String()
    var orderId = Int()
    var orderAmount = Double()
    var currency = String()
    var currencySymbol = String()
    var desc = String()
    var pickupBuildingBlock = String()
    var pickupContactNo = String()
    var pickupContactName = String()
    var pickupFloorNo = String()
    var pickupRoomNo = String()
    var dropBuildingBlock = String()
    var dropContactNo = String()
    var dropContactName = String()
    var dropFloorNo = String()
    var dropRoomNo = String()
    var arrFiles = NSMutableArray()
    
    func handleData(_ dict: NSDictionary) {
        if let bookingDict = dict["booking"] as? NSDictionary {
            orderId = Proxy.shared.isValueInt(bookingDict["id"] as Any)
            orderAmount = Proxy.shared.isValueDouble(bookingDict["amount"] as Any)
            currency = bookingDict["currency"] as? String ?? ""
            currencySymbol = bookingDict["currency_symbol"] as? String ?? ""
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
            dropBuildingBlock = bookingDict["building_block"] as? String ?? ""
            desc = bookingDict["description"] as? String ?? ""
        }
        arrFiles = []
        if let arrFile = dict["files"] as? [NSDictionary] {
            for dict in arrFile {
                arrFiles.add(dict)
            }
        }
    }
}

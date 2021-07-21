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

class PaymentVM: NSObject {
    
    var orderId = Int()
    var paymentMode = Int()
    var imgPaymentScreenshot = UIImage()
    var paypalUrl = String()
    //MARK:- Hit Book Api
    func hitBookingApi(completion:@escaping(_ orderId: Int)->()){
        let paramDict = NSMutableDictionary()
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[pickup_location]"] ?? "")", forKey: "Booking[pickup_location]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[pickup_latitude]"] ?? "")", forKey: "Booking[pickup_latitude]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[pickup_longitude]"] ?? "")", forKey: "Booking[pickup_longitude]")
        
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[pickup_floor]"] ?? "")", forKey: "Booking[pickup_floor]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[pickup_room]"] ?? "")", forKey: "Booking[pickup_room]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[pickup_contact_name]"] ?? "")", forKey: "Booking[pickup_contact_name]")
        
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[pickup_block]"] ?? "")", forKey: "Booking[pickup_block]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[pickup_contact_number]"] ?? "")", forKey: "Booking[pickup_contact_number]")
        
        // drop off
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[destination_location]"] ?? "")", forKey: "Booking[destination_location]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[destination_latitude]"] ?? "")", forKey: "Booking[destination_latitude]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[destination_longitude]"] ?? "")", forKey: "Booking[destination_longitude]")
        
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[floor]"] ?? "")", forKey: "Booking[floor]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[room_no]"] ?? "")", forKey: "Booking[room_no]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[contact_name]"] ?? "")", forKey: "Booking[contact_name]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[building_block]"] ?? "")", forKey: "Booking[building_block]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[contact_number]"] ?? "")", forKey: "Booking[contact_number]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[is_favorite]"] ?? "")", forKey: "Booking[is_favorite]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[type_id]"] ?? "")", forKey: "Booking[type_id]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[description]"] ?? "")", forKey: "Booking[description]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[vehicle_type]"] ?? "")", forKey: "Booking[vehicle_type]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[pickup_date]"] ?? "")", forKey: "Booking[pickup_date]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[promo_code]"] ?? "")", forKey: "Booking[promo_code]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[amount]"] ?? "")", forKey: "Booking[amount]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[discount_amount]"] ?? "")", forKey: "Booking[discount_amount]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[currency]"] ?? "")", forKey: "Booking[currency]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[nagotiable]"] ?? "")", forKey: "Booking[is_negotiable]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[payment_method]"] ?? "")", forKey: "Booking[payment_method]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[card_holder_name]"] ?? "")", forKey: "Booking[card_holder_name]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[card_number]"] ?? "")", forKey: "Booking[card_number]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[card_exp_year]"] ?? "")", forKey: "Booking[card_expiry_year]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[card_exp_month]"] ?? "")", forKey: "Booking[card_expiry_month]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[card_cvv]"] ?? "")", forKey: "Booking[card_cvv]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[card_token]"] ?? "")", forKey: "Booking[card_token]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[bank_id]"] ?? "")", forKey: "Booking[selected_bank_id]")
        paramDict.setValue("\(KAppDelegate.bookPostDict.dictValue["Booking[sender_name]"] ?? "")", forKey: "Booking[sender_name]")
        
        for index in 0..<KAppDelegate.bookPostDict.arrServiceId.count {
            paramDict.setValue("\(KAppDelegate.bookPostDict.arrServiceId[index])", forKey: "BookingService[service_id][\(index)]")
        }
        
        let imageDict = NSMutableDictionary()
        for index in 0..<KAppDelegate.bookPostDict.arrSelectedImage.count {
            imageDict.setValue(KAppDelegate.bookPostDict.arrSelectedImage[index], forKey: "File[title][\(index)]")
        }
        imageDict.setValue(imgPaymentScreenshot, forKey: "Booking[payment_file]")
        WebServiceProxy.shared.uploadImage(paramDict as! [String : AnyObject], parametersImage: imageDict as! [String : UIImage], addImageUrl: Apis.makeBooking, showIndicator: true) { response in
            
            self.paypalUrl = response["paypal_url"] as? String ?? ""
            if let detailDict = response["detail"] as? Dictionary<String, AnyObject> {
                self.orderId = detailDict.getValueInInt(detailDict["id"] as AnyObject)
                completion(self.orderId)
            }
        }
    }
}

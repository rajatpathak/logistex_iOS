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

struct BookNowDict {
    var arrSelectedImage = [UIImage]()
    var arrServiceId = [Int]()
    
    var dictValue = [
        "Booking[distance]" : "",
        "Booking[pickup_location]" : "",
        "Booking[pickup_latitude]" : "",
        "Booking[pickup_longitude]" : "",
        
        "Booking[destination_location]" : "",
        "Booking[destination_latitude]" : "",
        "Booking[destination_longitude]" : "",
        
        "Booking[pickup_floor]" : "",
        "Booking[pickup_room]" : "",
        "Booking[pickup_contact_name]" : "",
        "Booking[pickup_block]" : "",
        "Booking[pickup_contact_number]" : "",
        
        "Booking[floor]" : "",
        "Booking[room_no]" : "",
        "Booking[contact_name]" : "",
        "Booking[building_block]" : "",
        "Booking[contact_number]" : "",
        
        "Booking[is_favorite]" : "",
        "Booking[type_id]" : "", //BookingType
        "Booking[service_type]" : "", //ServiceType
        "Booking[service_type_title]" : "", //ServiceTypetitle
        "Booking[nagotiable]" : "",
        "Booking[description]" : "",
        "Booking[vehicle_type]" : "",
        "Booking[pickup_date]" : "", //
        "Booking[currency]" : "",
        "Booking[currency_title]" : "",
        "Booking[currency_symbol]" : "",
        "Booking[promo_code]" : "",
        "Booking[amount]" : "",
        "Booking[payment_method]" : "",
        "Booking[card_holder_name]" : "",
        "Booking[card_number]" : "",
        "Booking[card_exp_month]" : "",
        "Booking[card_exp_year]" : "",
        "Booking[card_cvv]" : "",
        "Booking[card_token]" : "",
        "Booking[sender_name]" : "",
        "Booking[selected_bank_id]" : "", 


        "Booking[discount_amount]" : "" ] as Dictionary
}

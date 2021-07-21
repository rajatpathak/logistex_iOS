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

class RateBookingVM: NSObject {
    
    var objBookingModel = BookingModel()
    
    func togglFavBanDriver(requestType : DriverState, success:@escaping()->()){
        WebServiceProxy.shared.getData(urlStr: "\(Apis.toggleFavBanDriver)?id=\(objBookingModel.driverId)&type=\(requestType.rawValue)", showIndicator: true) { response in
            success()
            Proxy.shared.displayStatusAlert(message: (response?.message)!, state: .success)
        }
    }
    
    func addDriverRating(postParam : Dictionary<String, AnyObject>, success:@escaping()->()){
        WebServiceProxy.shared.postData(urlStr: "\(Apis.rateDriver)?booking_id=\(objBookingModel.id)&to_user=\(objBookingModel.driverId)", params: postParam, showIndicator: true) { response in
            success()
            Proxy.shared.displayStatusAlert(message: (response?.message)!, state: .success)
        }
    }
}

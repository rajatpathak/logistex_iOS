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

class GetNearByDriverVM: NSObject {
    
    //MARK:- Variables
    var timer: Timer?
    var bookingId = Int()
    var type = Int()
    
    //MARK:- Get Driver Current Location
    func getDriverLocationApi(_ bookingId : Int, completion:@escaping(_ response: Dictionary<String,AnyObject>) -> Void) {
        WebServiceProxy.shared.getData(urlStr: "\(Apis.getDriverLocation)?id=\(bookingId)", showIndicator: false) { (response) in
            completion((response?.data)!)
        }
    }
    //MARK:- Cancel Booking Api
     func getCancelBookingApi(_ id: String, completion: @escaping()-> Void){
         WebServiceProxy.shared.getData(urlStr: "\(Apis.cancelBooking)?id=\(id)", showIndicator: true) { (response) in
             completion()
         }
     }
   
}

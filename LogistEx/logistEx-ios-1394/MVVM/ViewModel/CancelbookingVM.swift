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

class CancelbookingVM: NSObject {
    
    //MARK:- Variable Declaration
    var timer = Timer()
    var counter = 30
    
    //MARK:- Cancel Booking Api
    func getCancelBookingApi(_ id: String, completion: @escaping()-> Void){
        WebServiceProxy.shared.getData(urlStr: "\(Apis.cancelBooking)?id=\(id)", showIndicator: true) { (response) in
            completion()
        }
    }
}

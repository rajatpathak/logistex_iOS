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
import Lightbox

class BookingDetailVM: NSObject{
    
    //MARK:- Variables
    var detailId = Int()
    var objBookingDetailModel = BookingModel()
    
    //MARK:- Booking Detail Api
    func getBookingDetail(_ id: Int, completion: @escaping()->Void){
        WebServiceProxy.shared.getData(urlStr: "\(Apis.bookingDetail)?id=\(id)", showIndicator: true) { (response) in
            if let detailDict = response?.data?["details"] as? Dictionary<String, AnyObject> {
                self.objBookingDetailModel = BookingModel()
                self.objBookingDetailModel.setBookingDetail(dictData: detailDict)
            }
            completion()
        }
    }
}
extension BookingDetailVC: LightboxControllerPageDelegate, LightboxControllerDismissalDelegate  {
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        debugPrint(page)
    }
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
    }
}

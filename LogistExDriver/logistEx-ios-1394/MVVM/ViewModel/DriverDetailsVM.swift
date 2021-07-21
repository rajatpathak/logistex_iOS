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

class DriverDetailsVM: NSObject {
    
    //MARK:- Variables
    var bookingId = String()
    var objDriverDetailModel = DriverDetailModel()
    
    //MARK:- Hit Booking Detail Api
    func hitBookingDetailApi(_ id: String,completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.bookingDetail)?id=\(id)", showIndicator: true) { (response) in
            if response.success {
                if let detailDict = response.data?["details"] as? NSDictionary {
                    self.objDriverDetailModel = DriverDetailModel()
                    self.objDriverDetailModel.handleData(detailDict)
                }
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
}
extension DriverDetailsVC: LightboxControllerPageDelegate, LightboxControllerDismissalDelegate  {
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        debugPrint(page)
    }
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
    }
}

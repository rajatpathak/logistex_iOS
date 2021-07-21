/**
 *
 *@copyright : OZVID Technologies Pvt Ltd. < www.ozvid.com >
 *@author     : Shiv Charan Panjeta < shiv@ozvid.com >
 *
 * All Rights Reserved.
 * Proprietary and confidential :  All information contained herein is, and remains
 * the property of OZVID Technologies Pvt Ltd. and its partners.
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 */

import UIKit

class PaymentWebViewVM: NSObject {
    
    //MARK:- Variables
    var pageLoad = Bool ()
    var responseUrl = String()
    var paypalWebUrl = String()
    var complition : completionHandler?
    typealias completionHandler = (String) -> Void
    var bookingId = Int()

    //MARK:- Api Pay with paypal api
    func addConnectAcountApi(requestId: Int ,finalUrl : String, completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData(urlStr: "\(finalUrl)\(requestId)", showIndicator: false) { (response) in
            completion()
        }
    }
}


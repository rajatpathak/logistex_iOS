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

class OrderDetailVM: NSObject {
    
    //MARK:- Hit Accept Request Api
    func hitAcceptRequestApi(_ id: String, completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.acceptRequest)?id=\(id)", showIndicator: true) { (response) in
            if response.success {
                objUserModel.objAccepRequestModel.saveData(response.data!)
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
    //MARK:- Hit Accept Scheduled Request Api
    func hitAcceptScheduledRequestApi(_ id: String, completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.acceptScheduledRequest)?id=\(id)", showIndicator: true) { (response) in
            if response.success {
                objUserModel.objAccepRequestModel.saveData(response.data!)
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
    //MARK:- Hit Reject Request Api
    func hitRejectRequestApi(_ id: String, completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.rejectRequest)?id=\(id)", showIndicator: true) { (response) in
            if response.success {
                 objUserModel.objAccepRequestModel.saveData(response.data!)
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
}

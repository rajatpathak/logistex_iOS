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

class AboutUsVM: NSObject {
    
    //MARK:- Variables
    var desc = String()
    
    //MARK:- Hit Get Pages Api
    func hitGetPagesApi(_ type: String, completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.page)?type=\(type)", showIndicator: true) { (response) in
            if response.success {
                if let detailDict = response.data?["detail"] as? NSDictionary {
                    self.desc = detailDict["description"] as? String ?? ""
                }
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
}

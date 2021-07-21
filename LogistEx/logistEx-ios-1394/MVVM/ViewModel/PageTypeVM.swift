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

class PageTypeVM: NSObject {
    
    //MARK:- Variables
    var cameFrom = String()
    var type = Int()
    var desc = String()

    //MARK:- Get Pages Api
    func getPagesApi(_ type: Int, completion:@escaping() ->Void){
        WebServiceProxy.shared.getData(urlStr: "\(Apis.pageType)?type=\(type)", showIndicator: true) { (response) in
            if response!.success{
                if let detailDict = response?.data!["detail"] as? Dictionary<String, AnyObject>{
                    self.desc = detailDict["description"] as? String ?? ""
                }
                 completion()
            }else{
                Proxy.shared.displayStatusAlert(message: (response?.message!)!, state: .error)
            }
           
        }
    }
}

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

import Foundation
class VehicleCategoryListModel: NSObject {
    
    var title = String()
    var id = Int()
    
    func handleData(_ dict: NSDictionary) {
        title = dict["title"] as? String ?? ""
        id = Proxy.shared.isValueInt(dict["id"] as Any)
    }
}

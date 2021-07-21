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
class VechicleTypeListModel: NSObject {
    
    var title = String()
    var id = Int()
    
    func handleData(_ dict: NSDictionary) {
        if let title = dict["title"] as? String{
            self.title = title
        }
        if let title = dict["brand"] as? String{
            self.title = title
        }
        
        if let title = dict["color"] as? String{
            self.title = title
        }
        id = Proxy.shared.isValueInt(dict["id"] as Any)
    }
}



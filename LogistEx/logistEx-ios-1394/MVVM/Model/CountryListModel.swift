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

class CountryListModel: NSObject {
    var countryName = String()
    var id = Int()
    var currency = String()
    var currencySymbol = String()

    
    func handleData(_ dict: NSDictionary) {
        countryName = dict["name"] as? String ?? ""
        id = Proxy.shared.isValueInt(dict["id"] as Any)
        currency = dict["currency"] as? String ?? ""
        currencySymbol = dict["currency_symbol"] as? String ?? ""
    }
}

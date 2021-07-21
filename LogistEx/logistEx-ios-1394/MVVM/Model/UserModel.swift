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

var objUserModel = UserModel()

struct UserModel {
    var id = Int(), currencyId = String()
    var fullname = String(), firstName = String(), lastName = String(),contactNumber = String(),email = String(), profileImage = String(),address = String()
    var currency = String(), driverCountry = String()
    var currencySymbol = String()
    
    mutating func setData(dictData: Dictionary<String, AnyObject>){
        
        id = dictData.getValueInInt(dictData["id"] as AnyObject)
        fullname = dictData["full_name"] as? String ?? ""
        firstName = dictData["first_name"] as? String ?? ""
        lastName = dictData["last_name"] as? String ?? ""
        email = dictData["email"] as? String ?? ""
        contactNumber = dictData["contact_no"] as? String ?? ""
        profileImage = dictData["profile_file"] as? String ?? ""
        address = dictData["address"] as? String ?? ""
        currency = dictData["currency"] as? String ?? ""
        currencySymbol = dictData["currency_symbol"] as? String ?? ""
        driverCountry = dictData["driver_country"] as? String ?? ""
        currencyId = dictData.getValueInString(dictData["currency_id"] as AnyObject)
        
        if let auth = dictData["access_token"] as? String{
            UserDefaults.standard.set(auth, forKey: "access_token")
            UserDefaults.standard.synchronize()
        }
    }
}

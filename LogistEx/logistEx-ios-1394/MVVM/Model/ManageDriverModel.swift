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

class ManageDriverModel: NSObject {
    
    var driverName = String()
    var driverProfile = String()
    var vehicleNo = String()
    var id = Int()
    
    func handleData(dict: Dictionary<String,AnyObject>) {
        if let userDict = dict["user"] as? Dictionary<String,AnyObject> {
            id = userDict.getValueInInt(userDict["id"] as AnyObject)
            driverName = userDict["full_name"] as? String ?? ""
            vehicleNo = userDict[""] as? String ?? ""
            driverProfile = userDict["profile_file"] as? String ?? ""
            if let vehicleDetail = userDict["vehicle"] as? Dictionary<String, AnyObject> {
                vehicleNo = vehicleDetail["vehicle_number"] as? String ?? ""
            }
        }
    }
}

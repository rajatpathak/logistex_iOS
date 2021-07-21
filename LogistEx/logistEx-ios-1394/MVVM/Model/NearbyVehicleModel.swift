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

class NearbyVehicleModel {
    
    var id = Int()
    var stateId = Int()
    var typeId = Int()
    var vehicleTypeId = Int()
    var vehicleType : VehicleType?
    var time = Int()
    var distance = String()
    var baseFare = String()
    var chargeFare = String()
    var totalPrice = Int()
    var vehicleImg = String()
    var vehicleTitle  = String()
    
    
    func setNearbyVehicle( dictData: Dictionary<String, AnyObject> ) {
        id = dictData["id"] as? Int ?? 0
        distance = dictData["distance"] as? String ?? ""
        baseFare = dictData["base_fare"] as? String ?? ""
        chargeFare = dictData["charge_rate"] as? String ?? ""
        stateId = dictData["state_id"] as? Int ?? 0
        totalPrice = Proxy.shared.isValueInt(dictData["total_price"] as Any)
        time = dictData["time"] as? Int ?? 0
        vehicleTypeId = dictData["vehicle_type"] as? Int ?? 0
        typeId = dictData["type_id"] as? Int ?? 0
        vehicleImg = dictData["image_file"] as? String ?? ""
        vehicleTitle = dictData["title"] as? String ?? ""

    }
}

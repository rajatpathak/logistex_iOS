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

class AdditionalServiceModel: NSObject {
    
    var id : Int!
    var bookingId : Int!
    var serviceId : Int!
    var objAdditionServiceModel : AdditionalServicesModel?

    /*
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    
    init(fromDictionary dictionary: [String:Any]) {
      
        id = dictionary["id"] as? Int
        bookingId = dictionary["booking_id"] as? Int
        serviceId = dictionary["service_id"] as? Int
        
        if let dictData =  dictionary["service"] as? Dictionary<String, AnyObject> {
            objAdditionServiceModel = AdditionalServicesModel(fromDictionary: dictData)
        }
    }
}

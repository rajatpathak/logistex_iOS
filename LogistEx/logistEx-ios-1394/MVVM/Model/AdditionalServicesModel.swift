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

class AdditionalServicesModel: NSObject {
     
    var amount : String!
    var createdById : Int!
    var createdOn : String!
    var descriptionField : String!
    var id : Int!
    var stateId : Int!
    var title : String!
    var typeId : Int!
    var isSelected = false

    /*
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    
    init(fromDictionary dictionary: [String:Any]){
        amount = dictionary["amount"] as? String
        createdById = dictionary["created_by_id"] as? Int
        createdOn = dictionary["created_on"] as? String
        descriptionField = dictionary["description"] as? String
        id = dictionary["id"] as? Int
        stateId = dictionary["state_id"] as? Int
        title = dictionary["title"] as? String
        typeId = dictionary["type_id"] as? Int
    }
}


extension NSObject {
    
    func genericValueConversion<T>(value: T) -> String {
          return "\(value)"
        
//        switch value {
//        case is Int:
//            return "\(value)"
//        case is String :
//            if value != ""
//            return value as! String
//        case is Double:
//            return "\(value)"
//        default:
//            break
//        }
//        return ""
    }
}

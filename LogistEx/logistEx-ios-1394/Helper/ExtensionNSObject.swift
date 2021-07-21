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

extension Dictionary {
    
    func getValueInString(_ value:AnyObject ) -> String {
        var returnVal = ""
        if let valInt = value as? Int {
            returnVal = "\(valInt)"
        } else if let valS = value as? String {
            returnVal = valS != "" ? valS : "0.0"
        } else if let valD = value as? Double {
            returnVal = "\(valD)"
        } else {
            returnVal = "0"
        }
        return returnVal
    }
    
    func  getValueInInt(_ value: AnyObject) -> Int {
        var finalVal = Int()
        if let  idVal = value as? Int{
            finalVal = idVal
        } else if let  idVal = value as? Double{
            finalVal = Int(idVal)
        } else  if let idVal = value as? String{
            finalVal = idVal == "" ? 0 : Int(idVal)!
        }
        return finalVal
    }
    
    func getValueIndouble(_ value: AnyObject) -> Double {
        var finalVal = Double()
        if let  idVal = value as? Int{
            finalVal = Double(idVal)
        } else  if let idVal = value as? String{
            finalVal = idVal == "" ? 0.0 : Double(idVal)!
        } else if let  idVal = value as? Double{
            finalVal = idVal
        }
        return finalVal
    }
}

extension NSMutableArray {    
    func arrayToJsonString() -> String {
        var returnVal = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                returnVal = jsonString
            }
        } catch let error as NSError{
            debugPrint(error.description)
        }
        return returnVal
    }
    
    func arrToStringUsingKey (key:String) -> String {
        var conString = String()
        if self.count > 0 && !key.isEmpty {
            for i in 0..<self.count{
                if i != self.count-1 {
                    conString += "\((self[i] as! NSMutableDictionary).value(forKey: key)!), "
                } else {
                    conString += "\((self[i] as! NSMutableDictionary).value(forKey: key)!)"
                }
            }
        }
        return conString
    }
}

extension NSMutableDictionary {
    //Change any object to jsonString
    func jsonString() -> String? {
        var finalString = String()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            //Convert back to string. Usually only do this for debugging
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                let test = String(JSONString.filter { !"\n".contains($0) })
                finalString =  test }
        } catch {
            Proxy.shared.displayStatusAlert(message: "\(error)", state: .error)
        }
        return finalString
    }
}

extension NSObject {
    
    private struct AssociatedKeys {
        static var DescriptiveName = "customTag"
    }
    
    var customTag: Int? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.DescriptiveName) as? Int
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self, &AssociatedKeys.DescriptiveName, newValue as Int?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
}

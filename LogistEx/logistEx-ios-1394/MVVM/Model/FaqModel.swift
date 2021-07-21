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
class FaqModel{
    
    var id = Int()
    var question = String()
    var answer = String()
    
    func setFaqData(dictData: Dictionary<String, AnyObject>){
        id = dictData["id"] as? Int ?? 0
        question = dictData["question"] as? String ?? ""
        answer = dictData["answer"] as? String ?? ""
    }
}

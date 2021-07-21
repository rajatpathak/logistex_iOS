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
class AddCardVM: NSObject {
    
    //MARK:- Variable
    var objPaymentVM = PaymentVM()
     var expiryMonth = Int()
     var expiryYear = Int()
    
    //MARK:- Hit Add Card Api
    func hitAddCard(_ request: AddCardRequest,completion:@escaping() -> Void){
        let param = [
            "card_number": request.cardNubmer! ,
            "exp_month": request.expiryMonth!,
            "exp_year" :request.expiryYear!,
            "cvc" :request.cvv!,
            ] as [String:AnyObject]

        WebServiceProxy.shared.postData(urlStr: Apis.cardDetails, params: param as? Dictionary<String, AnyObject>, showIndicator: true, completion: { (response)  in
            if response!.success {
                completion()
            } else {
                Proxy.shared.displayStatusAlert(message: response?.data!["error"] as? String ?? "", state: .error)
            }
        })
    }
}

extension AddCardVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtFldCardNumber{
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    return true
                } else {
                    if range.location >= 19 {
                        return false
                    } else {
                        switch range.location {
                        case 3,8,13:
                            txtFldCardNumber.text = "\(textField.text!)\(string)-"
                            return false
                        default:
                            break
                        }
                    }
                }
                return true
            }
        }else if textField == txtFldCvv {
            if range.location >= 3  {
                return false
            }
        } else if textField == txtFldExpiryDate
        {
            if range.length > 0
            {
                return true
            }
            
            //Dont allow empty strings
            if string == " "{
                return false
            }
            
            //Check for max length including the spacers we added
            if range.location >= 5
            {
                return false
            }
            var originalText = textField.text
            //Put / space after 2 digit
            if range.location == 2
            {
                originalText?.append("/")
                textField.text = originalText
            }
        }
        return true
    }
    
}

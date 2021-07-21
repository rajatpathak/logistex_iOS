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
class BankDetailsVM: NSObject {
    
    //MARK: Variables
    var objBankListModel = BankListModel()
    var bankId = Int()
    var isImageSelected = Int()
    var objGalleryCameraImage = GalleryCameraImage()
    var objPaymentVM = PaymentVM()
    
    //MARK:- Hit Bank List List Api
    func hitBankDetailsApi(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData(urlStr: "\(Apis.bankDetials)?id=\(bankId)", showIndicator: true) { (response) in
            
            if let dictDetails = response?.data!["detail"] as? NSDictionary {
                self.objBankListModel.handleData(dictDetails)
                completion()
            }
        }
    }
    //MARK:- Hit Payment Api
    func hitPaymentApi(bankId : String , senderName : String ,requestId: String, parametersImage:[String : UIImage], completion:@escaping() -> Void) {
        
        let param = [
            "Booking[selected_bank_id]" : bankId,
            "Booking[sender_name]": senderName,
        ] as [String: AnyObject]
        
        WebServiceProxy.shared.uploadImage(param, parametersImage: parametersImage, addImageUrl: "\(Apis.payment)?booking_id=\(requestId)", showIndicator: true) { (response) in
            if response["error"] as? String ?? "" == "" {
                completion()
            } else {
                Proxy.shared.displayStatusAlert(message: response["error"] as? String ?? "", state: .error)
            }
        }
    }
    
//    func hitPaymentApi(bookingId : Int , completion:@escaping() -> Void) {
//        WebServiceProxy.shared.getData(urlStr: "\(Apis.payment)?booking_id=\(bookingId)", showIndicator: true) { (response) in
//            completion()
//        }
//    }
    
    //MARK:- Hit Accept /Reject Request Api
    func hitAcceptRejectRequestApi(bankId : String , senderName : String ,requestId: String, stateId : String, parametersImage:[String : UIImage], completion:@escaping() -> Void) {
        
        let param = [
            "Booking[selected_bank_id]" : bankId,
            "Booking[sender_name]": senderName,
        ] as [String: AnyObject]
        
        WebServiceProxy.shared.uploadImage(param, parametersImage: parametersImage, addImageUrl: "\(Apis.acceptRejectAmountRequest)?id=\(requestId)&state_id=\(stateId)", showIndicator: true) { (response) in
            if response["error"] as? String ?? "" == "" {
                completion()
            } else {
                Proxy.shared.displayStatusAlert(message: response["error"] as? String ?? "", state: .error)
            }
        }
    }
    
}

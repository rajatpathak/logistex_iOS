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
import Lightbox

class StartJourneyVM: NSObject {
    
    //MARK:- Variables
    var signaturePath = UIImage()
    
    //MARK:- Update Booking Status
    func hitUpdateBookingApi(_ id: String, state: String, completion:@escaping() -> Void) {
        switch objUserModel.objAccepRequestModel.bookingState {
        case StateRequest.pickup.rawValue:
            let imgParam = ["Booking[signature_file]": signaturePath] 
            WebServiceProxy.shared.uploadImage(apiName: "\(Apis.updateBookingStatus)?id=\(id)&state=\(state)", imageDictionary: imgParam, showIndicator: true) { (response) in
                if response.success {
                    objUserModel.objAccepRequestModel.bookingState = Proxy.shared.isValueInt(response.data?["booking_state"] as Any)
                    objUserModel.objAccepRequestModel.deliveryTime = Proxy.shared.isValueString(response.data?["delivery_time"] as Any)
                    completion()
                } else {
                    Proxy.shared.displayStatusAlert(response.message ?? "")
                }
            }
        default:
            WebServiceProxy.shared.getData("\(Apis.updateBookingStatus)?id=\(id)&state=\(state)", showIndicator: true) { (response) in
                if response.success {
                    objUserModel.objAccepRequestModel.bookingState = Proxy.shared.isValueInt(response.data?["booking_state"] as Any)
                    objUserModel.objAccepRequestModel.deliveryTime = Proxy.shared.isValueString(response.data?["delivery_time"] as Any)
                    completion()
                } else {
                    Proxy.shared.displayStatusAlert(response.message ?? "")
                }
            }
        }
    }
    // MARK:- Hit Apply Amount Changes Api
    func hitApplyChangesApi(_ bookingId: String,userId : String,amount: String, completion:@escaping() -> Void) {
        
        let param = ["AmountChangeRequest[booking_id]": bookingId ,
                     "AmountChangeRequest[user_id]": userId ,
                     "AmountChangeRequest[amount]": amount
        ] as [String:AnyObject]
        WebServiceProxy.shared.postData(Apis.applyAmountChange, params: param, showIndicator: true) { (response) in
            if response.success {
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
    //MARK:- Hit Reject Request Api
    func hitRejectRequestApi(_ id: String, completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.declinedRequest)?id=\(id)", showIndicator: true) { (response) in
            if response.success {
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
    func notifyToUserPayment(_ id: String, completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.paymentNotification)?booking_id=\(id)", showIndicator: true) { (response) in
            if response.success {
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
    
    // MARK:- Hit Reschudle Api
    func hitReschudleApi(_ bookingId: String,newLocationTitle : String,newLocationLat: String,newLocationLong: String ,completion:@escaping() -> Void) {
        
        let param = ["Booking[new_pickup_location]": newLocationTitle ,
                     "Booking[new_pickup_latitude]": newLocationLat ,
                     "Booking[new_pickup_longitude]": newLocationLong
        ] as [String:AnyObject]
        WebServiceProxy.shared.postData("\(Apis.reschduledRequest)?booking_id=\(bookingId)", params: param, showIndicator: true) { (response) in
            if response.success {
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
}

extension StartJourneyView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objUserModel.objAccepRequestModel.arrFiles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dict = objUserModel.objAccepRequestModel.arrFiles[indexPath.row] as? [String : Any]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StartJourneyCVC", for: indexPath) as! StartJourneyCVC
        cell.imgVwInstructions.sd_setImage(with: URL(string: dict?["file"] as! String) , placeholderImage: #imageLiteral(resourceName: "ic_default_user"))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = objUserModel.objAccepRequestModel.arrFiles[indexPath.row] as? [String : Any]
        let file = dict?["file"] as? String ?? ""
        if file != "" {
            let images = [LightboxImage(imageURL: URL.init(string: file)!)]
            let controller = LightboxController(images: images)
            controller.pageDelegate = self
            controller.dismissalDelegate = self
            controller.dynamicBackground = true
            controller.modalPresentationStyle = .fullScreen
            objParent.navigationController?.present(controller, animated: true, completion: nil)
        }
    }
}
extension StartJourneyView: LightboxControllerPageDelegate, LightboxControllerDismissalDelegate  {
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        debugPrint(page)
    }
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
    }
}
extension StartJourneyView   {
    
    func alertAmountNotificationSendToUser() {
        DispatchQueue.main.async {
            let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
            let controller = UIAlertController(title: AppInfo.appName, message: AlertMessages.paymentIsPending.localized, preferredStyle: .alert)
            
            let valueBtnYes = "\(lang == ChooseLanguage.spanish.rawValue ? AlertMessages.yesSpa : AlertMessages.yes)"
            let okAction = UIAlertAction(title: valueBtnYes, style: .default) { (action) in
                self.objStartJourneyVM.notifyToUserPayment(objUserModel.objAccepRequestModel.bookingId) {
                    Proxy.shared.displayStatusAlert(AlertMessages.requestSentSuccesfully.localized)
                }
            }
            let cancelAction = UIAlertAction(title: AlertMessages.no.localized, style: .default, handler: nil)
            controller.addAction(okAction)
            controller.addAction(cancelAction)
            controller.view.tintColor = Color.app
            self.objParent.present(controller, animated: true, completion: nil)
        }
    }
    
    func alertApplyAmountChange() {
        DispatchQueue.main.async {
            let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
            let controller = UIAlertController(title: AppInfo.appName, message: AlertMessages.applyAmountChangeConfirmation.localized, preferredStyle: .alert)
            
            let valueBtnYes = "\(lang == ChooseLanguage.spanish.rawValue ? AlertMessages.yesSpa : AlertMessages.yes)"
            
            let okAction = UIAlertAction(title: valueBtnYes, style: .default) { (action) in
                self.objStartJourneyVM.hitApplyChangesApi(objUserModel.objAccepRequestModel.bookingId, userId: "\(objUserModel.objAccepRequestModel.custId)", amount: self.txtFldChangeAmount.text!) {
                    Proxy.shared.displayStatusAlert(AlertMessages.applyChangeRequest.localized)
                    self.btnApply.isHidden = true
                    objUserModel.objAccepRequestModel.amountChangeRequestStatus = ChangeAmountRequstState.send.rawValue
                }
            }
            let cancelAction = UIAlertAction(title: AlertMessages.no.localized, style: .default, handler: nil)
            controller.addAction(okAction)
            controller.addAction(cancelAction)
            controller.view.tintColor = Color.app
            self.objParent.present(controller, animated: true, completion: nil)
        }
    }
    func declinedAlert() {
        DispatchQueue.main.async {
            let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
            let controller = UIAlertController(title: AppInfo.appName, message: AlertMessages.declinedRequestConfirmation.localized, preferredStyle: .alert)
            
            let valueBtnYes = "\(lang == ChooseLanguage.spanish.rawValue ? AlertMessages.yesSpa : AlertMessages.yes)"
            
            let okAction = UIAlertAction(title: valueBtnYes, style: .default) { (action) in
                self.objStartJourneyVM.hitRejectRequestApi(objUserModel.objAccepRequestModel.bookingId) {
                    self.objParent.rootWithDrawer(identifier: "HomeVC")
                    objUserModel.objAccepRequestModel = AccepRequestModel()
                }
            }
            let cancelAction = UIAlertAction(title: AlertMessages.no.localized, style: .default, handler: nil)
            controller.addAction(okAction)
            controller.addAction(cancelAction)
            controller.view.tintColor = Color.app
            self.objParent.present(controller, animated: true, completion: nil)
        }
    }
    func reschudledAlert() {
        DispatchQueue.main.async {
            let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
            let controller = UIAlertController(title: AppInfo.appName, message: AlertMessages.reschudledRequestConfirmation.localized, preferredStyle: .alert)
            
            let valueBtnYes = "\(lang == ChooseLanguage.spanish.rawValue ? AlertMessages.yesSpa : AlertMessages.yes)"
            let okAction = UIAlertAction(title: valueBtnYes, style: .default) { (action) in
                self.objStartJourneyVM.hitReschudleApi(objUserModel.objAccepRequestModel.bookingId, newLocationTitle: Proxy.shared.getCurrentAddress(), newLocationLat: Proxy.shared.getLatitude(), newLocationLong: Proxy.shared.getLongitude()) {
                    Proxy.shared.displayStatusAlert("Booking rescheduled successfully")
                    self.btnReschudleTrip.isHidden = true
                }
            }
            let cancelAction = UIAlertAction(title: AlertMessages.no.localized, style: .default, handler: nil)
            controller.addAction(okAction)
            controller.addAction(cancelAction)
            controller.view.tintColor = Color.app
            self.objParent.present(controller, animated: true, completion: nil)
        }
    }
}

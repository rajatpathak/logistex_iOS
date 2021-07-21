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

class BookingChangePriceRequestVM: NSObject {
    
    //MARK:- Variables
    var bookingModel = BookingModel()
    var paypalWebUrl = String()
    
    //MARK:- Hit Accept /Reject Request Api
    func hitAcceptRejectRequestApi(_ id: String, stateId : String, completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData(urlStr: "\(Apis.acceptRejectAmountRequest)?id=\(id)&state_id=\(stateId)", showIndicator: true) { (response) in
            self.paypalWebUrl = response?.data!["paypal_url"] as? String ?? ""
            if response!.success {
                completion()
            } else {
                Proxy.shared.displayStatusAlert(message: response?.message ?? "", state: .error)
            }
        }
    }
    
}
extension BookingChangePriceRequestVC {
    //MARK:- Show Details
    func showDetails(){
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        let bookingDict = objBookingChangePriceRequestVM.bookingModel
        
        KAppDelegate.objVariableSaveModel.currencyTitle = bookingDict.currency
        KAppDelegate.objVariableSaveModel.currencySymbol = bookingDict.currencySymbol
        KAppDelegate.objVariableSaveModel.amount = bookingDict.changeRequestAmount
        KAppDelegate.objVariableSaveModel.isChangeRequest = AlertMessages.yes
        lblOrderId.text = PassTitles.oderId.localized + " - \(bookingDict.id)"
        lblPickUp.text = bookingDict.pickUpLocation
        lblDrop.text = bookingDict.dropLocation
        lblAmount.text = "\(bookingDict.currencySymbol) \(bookingDict.amount) \(bookingDict.currency)"
        lblChangedAmount.text = "\(bookingDict.currencySymbol) \(bookingDict.changeRequestAmount) \(bookingDict.currency)"
        
        if lang == ChooseLanguage.spanish.rawValue {
            self.lblHeader.text = PassTitles.rateChangesSpa
            self.lblStaticBookingAmount.text = PassTitles.amountSuggestedSpa
            self.lblStaticRequestAmount.text = PassTitles.amountRequestedSpa
        } else {
            self.lblHeader.text = PassTitles.rateChanges
            self.lblStaticBookingAmount.text = PassTitles.amountSuggested
            self.lblStaticRequestAmount.text = PassTitles.amountRequested
        }
    }
    func acceptRequestAlert() {
        
        DispatchQueue.main.async {
            let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
            let controller = UIAlertController(title: AppInfo.appName, message: AlertMessages.accept.localized, preferredStyle: .alert)
            
            let valueBtnOk = "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.yesSpa : PassTitles.yes)"
            
            let okAction = UIAlertAction(title: valueBtnOk, style: .default) { (action) in
                
                switch self.objBookingChangePriceRequestVM.bookingModel.paymentMethod {
                case PaymentMethod.bankTransfer.rawValue:
                    KAppDelegate.objVariableSaveModel.requestId = self.objBookingChangePriceRequestVM.bookingModel.id
                    self.pushVC(selectedStoryboard: .main, identifier: .bankList)
                    
                case PaymentMethod.paypal.rawValue:
                    
                    self.objBookingChangePriceRequestVM.hitAcceptRejectRequestApi("\(self.objBookingChangePriceRequestVM.bookingModel.id)", stateId: "\(AmountRequestState.accept.rawValue)") {
                  
                        if self.objBookingChangePriceRequestVM.paypalWebUrl != ""{
                                let controller  = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: "PaymentWebViewVC") as! PaymentWebViewVC
                                let url = URL(string: self.objBookingChangePriceRequestVM.paypalWebUrl)
                                let lastPath = url?.lastPathComponent as? String ?? "0"
                                controller.objPaymentWebViewVM.complition = {
                                    title in
                                    if title != ""{
                                        self.rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC)
                                    }
                                }
                                controller.objPaymentWebViewVM.bookingId = Int(lastPath)!
                                controller.objPaymentWebViewVM.paypalWebUrl = self.objBookingChangePriceRequestVM.paypalWebUrl
                                self.navigationController?.pushViewController(controller, animated: true)
                            
                        }
                        
                    }
                default:
                    self.objBookingChangePriceRequestVM.hitAcceptRejectRequestApi("\(self.objBookingChangePriceRequestVM.bookingModel.id)", stateId: "\(AmountRequestState.accept.rawValue)") {
                        Proxy.shared.displayStatusAlert(message: AlertMessages.changeAmountAcceptSuccessfully.localized, state: .success)
                        self.popToBack()
                    }
                }
            }
            let cancelAction = UIAlertAction(title: AlertMessages.no.localized, style: .default, handler: nil)
            controller.addAction(okAction)
            controller.addAction(cancelAction)
            controller.view.tintColor = Color.app
            self.present(controller, animated: true, completion: nil)
        }
    }
    func rejectRequestAlert() {
        DispatchQueue.main.async {
            let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
            let controller = UIAlertController(title: AppInfo.appName, message: AlertMessages.reject.localized, preferredStyle: .alert)
            
            let valueBtnOk = "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.yesSpa : PassTitles.yes)"
            
            let okAction = UIAlertAction(title: valueBtnOk, style: .default) { (action) in
                self.objBookingChangePriceRequestVM.hitAcceptRejectRequestApi("\(self.objBookingChangePriceRequestVM.bookingModel.id)", stateId: "\(AmountRequestState.reject.rawValue)") {
                    Proxy.shared.displayStatusAlert(message: AlertMessages.changeAmountRejectSuccessfully.localized, state: .success)
                    self.popToBack()
                }
            }
            let cancelAction = UIAlertAction(title: AlertMessages.no.localized, style: .default, handler: nil)
            controller.addAction(okAction)
            controller.addAction(cancelAction)
            controller.view.tintColor = Color.app
            self.present(controller, animated: true, completion: nil)
        }
    }
}

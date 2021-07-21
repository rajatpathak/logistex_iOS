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
class BankDetailVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblBaneficierName: UILabel!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblAccontNo: UILabel!
    @IBOutlet weak var lblRoutingNo: UILabel!
    @IBOutlet weak var lblIntermdiaryBank: UILabel!
    @IBOutlet weak var lblIbanNo: UILabel!
    @IBOutlet weak var lblSwiftCode: UILabel!
    @IBOutlet weak var lblPhoneNo: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtFldSenderName: UITextField!
    @IBOutlet weak var imgVwPayment: UIImageView!
    @IBOutlet weak var btnCross: UIButton!
    
    //MARK:- Variables
    var objBankDetailsVM = BankDetailsVM()
    
    
    //MARK:- Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        objBankDetailsVM.hitBankDetailsApi {
            self.showDetails()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        objPassImageDelegate = self
    }
    func showDetails(){
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        lblBankName.text = objBankDetailsVM.objBankListModel.bankName
        lblHeader.text = objBankDetailsVM.objBankListModel.bankName
        lblBaneficierName.text = objBankDetailsVM.objBankListModel.beneficiaryName
        lblAccontNo.text = objBankDetailsVM.objBankListModel.accountNo
        lblRoutingNo.text = objBankDetailsVM.objBankListModel.routingNo
        lblIntermdiaryBank.text = objBankDetailsVM.objBankListModel.intermediaryBank
        lblIbanNo.text = objBankDetailsVM.objBankListModel.ibanNo
        lblSwiftCode.text = objBankDetailsVM.objBankListModel.swiftCode
        lblEmail.text = objBankDetailsVM.objBankListModel.emailId
        lblPhoneNo.text = objBankDetailsVM.objBankListModel.phoneNo
        
        if KAppDelegate.objVariableSaveModel.requestId != 0 {
            if lang == ChooseLanguage.spanish.rawValue {
                lblTotalAmount.text =
                    "\(PassTitles.totalSpa) \(KAppDelegate.objVariableSaveModel.currencySymbol) \(KAppDelegate.objVariableSaveModel.amount) \(KAppDelegate.objVariableSaveModel.currencyTitle)"
            } else {
                lblTotalAmount.text =
                    "\(PassTitles.total) \(KAppDelegate.objVariableSaveModel.currencySymbol) \(KAppDelegate.objVariableSaveModel.amount) \(KAppDelegate.objVariableSaveModel.currencyTitle)"
            }
        } else {
            let currencyTitle = "\(KAppDelegate.bookPostDict.dictValue["Booking[currency_title]"] ?? "")"
            let currencySymbol = "\(KAppDelegate.bookPostDict.dictValue["Booking[currency_symbol]"] ?? "")"
            if lang == ChooseLanguage.spanish.rawValue {
                lblTotalAmount.text =
                    "\(PassTitles.totalSpa) \(currencySymbol) \(KAppDelegate.bookPostDict.dictValue["Booking[amount]"]!) \(currencyTitle)"
            } else {
                lblTotalAmount.text =
                    "\(PassTitles.total) \(currencySymbol) \(KAppDelegate.bookPostDict.dictValue["Booking[amount]"]!) \(currencyTitle)"
            }
        }
        
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        popToBack()
    }
    @IBAction func actionCross(_ sender: UIButton) {
        objBankDetailsVM.isImageSelected = 0
        imgVwPayment.image = nil
        btnCross.isHidden = true
        imgVwPayment.isHidden = true
        
    }
    @IBAction func actionSave(_ sender: UIButton) {
        if txtFldSenderName.text!.isBlank{
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterSenderName.localized, state: .warning)
        } else if objBankDetailsVM.isImageSelected == 0 {
            Proxy.shared.displayStatusAlert(message: AlertMessages.uploadPaymentScreenshot.localized, state: .warning)
        } else {
            KAppDelegate.bookPostDict.dictValue.updateValue(txtFldSenderName.text!, forKey: "Booking[sender_name]")
            KAppDelegate.bookPostDict.dictValue.updateValue( "\(objBankDetailsVM.bankId)", forKey: "Booking[selected_bank_id]")
            objBankDetailsVM.objPaymentVM.imgPaymentScreenshot = imgVwPayment.image!
            if KAppDelegate.objVariableSaveModel.requestId != 0 {
                let bankIdVal =  KAppDelegate.bookPostDict.dictValue["Booking[selected_bank_id]"]
                let senderNameVal =  KAppDelegate.bookPostDict.dictValue["Booking[sender_name]"]
                let imageDict = ["Booking[payment_file]": imgVwPayment.image] as! [String : UIImage]
                
                if KAppDelegate.objVariableSaveModel.isChangeRequest == AlertMessages.no {
                    self.objBankDetailsVM.hitPaymentApi(bankId: "\(bankIdVal!)", senderName: senderNameVal!, requestId: "\(KAppDelegate.objVariableSaveModel.requestId)", parametersImage: imageDict) {
                        Proxy.shared.displayStatusAlert(message: AlertMessages.paymentRequestApproval.localized, state: .success)
                        self.rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC)
                    }
                } else {
                    self.objBankDetailsVM.hitAcceptRejectRequestApi(bankId: "\(bankIdVal!)", senderName: senderNameVal!, requestId: "\(KAppDelegate.objVariableSaveModel.requestId)", stateId: "\(AmountRequestState.accept.rawValue)", parametersImage: imageDict) {
                        Proxy.shared.displayStatusAlert(message: AlertMessages.changeAmountAcceptSuccessfully.localized, state: .success)
                        self.rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC)
                    }
                }
            } else {
                objBankDetailsVM.objPaymentVM.hitBookingApi { (orderId) in
                    KAppDelegate.bookPostDict = BookNowDict()
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: HomeVC.self) {
                            _ =  self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                    Proxy.shared.displayStatusAlert(message: AlertMessages.paymentRequestApproval.localized, state: .success)
                }
            }
        }
    }
    @IBAction func actionAddPhoto(_ sender: UIButton) {
        objPassImageDelegate = self
        objBankDetailsVM.isImageSelected = 1
        objBankDetailsVM.objGalleryCameraImage.customActionSheet(removeProfile: false, controller: self)
    }
}
extension BankDetailVC : PassImageDelegate {
    //MARK:- Get Selected Image function
    func getSelectedImage(selectImage: UIImage) {
        imgVwPayment.image = selectImage
        imgVwPayment.isHidden = false
        btnCross.isHidden = false
    }
}


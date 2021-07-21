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
import Stripe
class AddCardVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var txtFldCvv: UITextField!
    @IBOutlet weak var txtFldNameOnCard: UITextField!
    @IBOutlet weak var txtFldCardNumber: UITextField!
    @IBOutlet weak var txtFldExpiryDate: UITextField!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    //MARK:- Variable
    var objAddCardVM = AddCardVM()
    
    //MARK:- Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        UITextField.connectAllTxtFieldFields(txtfields: [txtFldNameOnCard,txtFldCardNumber,txtFldExpiryDate,txtFldCvv])
        txtFldNameOnCard.text = objUserModel.fullname
    }
    
    //MARK:- Button actions
    @IBAction func actionBack(_ sender: Any) {
        popToBack()
    }
    @IBAction func actionSave(_ sender: Any) {
        
        if txtFldNameOnCard.text!.isBlank{
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterCardHolderName.localized, state: .warning)
        } else if !Proxy.shared.isValidInput(txtFldNameOnCard.text!){
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterValidCardHolderName.localized, state: .warning)
        } else if txtFldCardNumber.text!.isBlank{
            Proxy.shared.displayStatusAlert(message: AlertMessages.cardNumber.localized, state: .warning)
        } else if txtFldCardNumber.text!.count <= 18 {
             Proxy.shared.displayStatusAlert(message: AlertMessages.cardNumberValid.localized, state: .warning)
        } else if txtFldExpiryDate.text!.isBlank {
            Proxy.shared.displayStatusAlert(message: AlertMessages.expiryYear.localized, state: .warning)
        } else if txtFldExpiryDate.text!.count <= 4{
             Proxy.shared.displayStatusAlert(message: AlertMessages.expiryYearValid.localized, state: .warning)
        } else if txtFldCvv.text!.isBlank{
            Proxy.shared.displayStatusAlert(message: AlertMessages.cvv.localized, state: .warning)
        } else if txtFldCvv.text!.count <= 2{
             Proxy.shared.displayStatusAlert(message: AlertMessages.cvvValid.localized, state: .warning)
        } else {
            let yearStr = txtFldExpiryDate.text?.substring(from:(txtFldExpiryDate.text?.index((txtFldExpiryDate.text?.endIndex)!, offsetBy: -2))!)
            objAddCardVM.expiryYear = Int(yearStr!)!
            
            let firstIndex = txtFldExpiryDate.text?.index((self.txtFldExpiryDate.text?.startIndex)!, offsetBy: 2)
            
            let monthStr = txtFldExpiryDate.text?.substring(to: firstIndex!)
            objAddCardVM.expiryMonth = Int(monthStr!)!
            btnSubmit.isUserInteractionEnabled = false
            getToken{(token) in
                
                KAppDelegate.bookPostDict.dictValue.updateValue(token, forKey: "Booking[card_token]")
                KAppDelegate.bookPostDict.dictValue.updateValue(self.txtFldNameOnCard.text!, forKey: "Booking[card_holder_name]")
                
                KAppDelegate.bookPostDict.dictValue.updateValue(self.txtFldCardNumber.text!, forKey: "Booking[card_number]")
                
                KAppDelegate.bookPostDict.dictValue.updateValue("\(self.objAddCardVM.expiryMonth)", forKey: "Booking[card_exp_month]")
                
                KAppDelegate.bookPostDict.dictValue.updateValue("\(self.objAddCardVM.expiryYear)", forKey: "Booking[card_exp_year]")
                
                KAppDelegate.bookPostDict.dictValue.updateValue(self.txtFldCvv.text!, forKey: "Booking[card_cvv]")
                
                self.objAddCardVM.objPaymentVM.hitBookingApi { (orderId) in
                    KAppDelegate.bookPostDict = BookNowDict()
                    objSearchDriverDelegate?.setData(orderId: "\(orderId)")
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: HomeVC.self) {
                            _ =  self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
            }
        }
    }
    private func getToken(_ completion:@escaping(_ token:String) -> Void){
        
        let cardParams = STPCardParams()
        cardParams.number = txtFldCardNumber.text!
        cardParams.expMonth = UInt(objAddCardVM.expiryMonth)
        cardParams.expYear = UInt(objAddCardVM.expiryYear)
        cardParams.cvc = txtFldCvv!.text
        
        STPAPIClient.shared.createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let token = token,error == nil
                else {
                    self.btnSubmit.isUserInteractionEnabled = true
                    Proxy.shared.displayStatusAlert(message: AlertMessages.cardDetailsInCorrect.localized, state: .warning)
                    return
            }
            completion("\(token)")
        }
    }
}

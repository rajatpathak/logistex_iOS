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
import SkyFloatingLabelTextField

class ForgotPasswordVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var txtFldEmail: SkyFloatingLabelTextField!
    
    //MARK:- Object
    var objForgotPasswordVM = ForgotPasswordVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFldEmail.titleFormatter = {$0}
        UITextField.connectAllTxtFieldFields(txtfields: [txtFldEmail])
    }
    
    //MARK:- IBActions
    @IBAction func actionCross(_ sender: Any) {
        dismiss()
    }
    @IBAction func actionSend(_ sender: Any) {
        view.endEditing(true)
        let request = ForgotRequest(email: txtFldEmail.text, role: "\(Role.driver.rawValue)")
        objForgotPasswordVM.hitForgotPasswordApi(request) {
            self.dismiss()
            Proxy.shared.displayStatusAlert(AlertMessages.resetPassword.localized)
        }
    }
}

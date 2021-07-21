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

class ChangePasswordVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var txtFldNewPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldConfirmPassword: SkyFloatingLabelTextField!
    
    //MARK:- Object
    var objChangePasswordVM = ChangePasswordVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFldNewPassword.titleFormatter = {$0}
        txtFldConfirmPassword.titleFormatter = {$0}
        UITextField.connectAllTxtFieldFields(txtfields: [txtFldNewPassword,txtFldConfirmPassword])
    }
    
    //MARK:- IBActions
    @IBAction func actionBack(_ sender: Any) {
        pop()
    }
    @IBAction func actionShowNewPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        txtFldNewPassword.isSecureTextEntry = !sender.isSelected
    }
    @IBAction func actionShowConfirmPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        txtFldConfirmPassword.isSecureTextEntry = !sender.isSelected
    }
    @IBAction func actionSubmit(_ sender: Any) {
        view.endEditing(true)
        let request = ChangePasswordRequest(newPassword: txtFldNewPassword.text, confirmPassword: txtFldConfirmPassword.text)
        objChangePasswordVM.hitChangePasswordApi(request) {
            Proxy.shared.logout {
                self.root(identifier: "LoginVC")
                objUserModel = UserModel()
                Proxy.shared.displayStatusAlert(AlertMessages.changePassword.localized)
            }
        }
    }
}

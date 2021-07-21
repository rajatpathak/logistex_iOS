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
class NewPasswordVC: UIViewController {
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var txtFldNewPassword: UITextField!
    @IBOutlet weak var txtFldConfirmPassword: UITextField!
    
    //MARK:- VARIABLES
    var objNewPasswordVM = NewPasswordVM()
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        UITextField.connectAllTxtFieldFields(txtfields: [txtFldNewPassword,txtFldConfirmPassword])
        
    }
    //MARK:- IBACTIONS
    @IBAction func actionBack(_ sender: UIButton) {
        popToBack()
    }
    @IBAction func actionSubmit(_ sender: UIButton) {
        let request = ChangePassword(newPassword: txtFldNewPassword.text!, confirmNewPassword: txtFldConfirmPassword.text!)
        objNewPasswordVM.hitChangePasswordApi(postParam: request){
            UserDefaults.standard.set("", forKey: "access-token")
            self.rootWithoutDrawer(selectedStoryboard: .main, identifier: .loginVC)
            Proxy.shared.displayStatusAlert(message: AlertMessages.changePassword.localized, state: .success)
        }
    }
    @IBAction func actionShowNewPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        txtFldNewPassword.isSecureTextEntry = sender.isSelected
    }
    @IBAction func actionShowConfirmPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        txtFldConfirmPassword.isSecureTextEntry = sender.isSelected
    }
}

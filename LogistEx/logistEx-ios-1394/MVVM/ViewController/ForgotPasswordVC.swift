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
class ForgotPasswordVC: UIViewController {
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var txtFldEmail: UITextField!
    
    //MARK:- VARIABLES
    var objForgotPasswordVM = ForgotPasswordVM()
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    //MARK:- IBACTIONS
    @IBAction func actionDismiss(_ sender: UIButton) {
        dismissController()
    }
    @IBAction func actionProceed(_ sender: UIButton) {
        let postParam = ForgotPassword.init(emailId: txtFldEmail.text!, roleId: 2)
        objForgotPasswordVM.hitForgotPasswordApi(postParam: postParam){
            self.dismissController()
        }
    }
}

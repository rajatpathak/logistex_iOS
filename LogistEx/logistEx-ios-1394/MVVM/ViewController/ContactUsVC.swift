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

class ContactUsVC: UIViewController {
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var txtFldFullName: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldSelectReason: UITextField!
    @IBOutlet weak var txtFldReason: UITextField!
    
    //MARK:- VARIABLES
    var objContactUsVM = ContactUsVM()
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        UITextField.connectAllTxtFieldFields(txtfields: [txtFldFullName,txtFldEmail,txtFldSelectReason,txtFldReason])
        showContactData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        objCategoryDelegateProtocol = self
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.white)
    }
    func showContactData(){
        txtFldFullName.text = objUserModel.fullname
        txtFldEmail.text = objUserModel.email
    }
    //MARK:- IBACTIONS
    @IBAction func actionSubmit(_ sender: UIButton) {
        view.endEditing(true)
        let request = ContactUs(fullName: txtFldFullName.text!, email: txtFldEmail.text!, selectReason: txtFldSelectReason.text!, enterReason: txtFldReason.text!)
        objContactUsVM.hitContactUsApi(postParam: request) {
            self.contactAlert()
        }
    }
    @IBAction func actionDrawer(_ sender: UIButton) {
        KAppDelegate.sideMenuVC.openLeft()
    }
    
    func contactAlert() {
        let controller = UIAlertController(title: AppInfo.appName, message: AlertMessages.mailSend.localized, preferredStyle: .alert)
        let okAction = UIAlertAction(title: AlertMessages.ok.localized, style: .default) { (action) in
            self.rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC)
        }
        controller.addAction(okAction)
        controller.view.tintColor = Color.app
        self.present(controller, animated: true, completion: nil)
    }
}

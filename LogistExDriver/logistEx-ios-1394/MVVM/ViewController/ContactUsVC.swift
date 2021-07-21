
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
import IQKeyboardManagerSwift


class ContactUsVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var txtFldSelectReason: SkyFloatingLabelTextField!
    @IBOutlet weak var txtVwMessage: IQTextView!
    @IBOutlet weak var txtFldFullName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldEmail: SkyFloatingLabelTextField!
    
    //MARK:- Object
    var objContactUsVM = ContactUsVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.white)
    }
    //MARK:- IBActions
    @IBAction func actionBack(_ sender: Any) {
        KAppDelegate.sideMenuVC.openLeft()
    }
    @IBAction func actionSubmit(_ sender: Any) {
        view.endEditing(true)
        let request = ContactUsRequest(name: txtFldFullName.text, email: txtFldEmail.text, selectedReason: "\(objContactUsVM.selectedReason)", message: txtVwMessage.text)
        objContactUsVM.apiContactUs(request: request) {
            self.rootWithDrawer(identifier: "HomeVC")
            Proxy.shared.displayStatusAlert(AlertMessages.enquirySubmitted.localized)
        }
    }
    func setDetails() {
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        txtVwMessage.placeholder = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.typeMessageSpa : TitleValue.typeMessage)"
        txtFldEmail.text = objUserModel.email
        txtFldFullName.text = objUserModel.fullName
        txtFldSelectReason.titleFormatter = {$0}
        txtFldFullName.titleFormatter = {$0}
        txtFldEmail.titleFormatter = {$0}
        UITextField.connectAllTxtFieldFields(txtfields: [txtFldFullName,txtFldEmail,txtFldSelectReason])
    }
}

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

class AddBankDetailVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var txtFldAccountNo: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldBankName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldAccountName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldBankCode: SkyFloatingLabelTextField!
    
    //MARK:- Object
    var objAddBankDetailVM = AddBankDetailVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFldAccountNo.titleFormatter = {$0}
        txtFldBankName.titleFormatter = {$0}
        txtFldAccountName.titleFormatter = {$0}
        txtFldBankCode.titleFormatter = {$0}
        txtFldAccountNo.text = objUserModel.accountNo
        txtFldBankName.text = objUserModel.bankName
        txtFldAccountName.text = objUserModel.accountName
        txtFldBankCode.text = objUserModel.bankCode
        UITextField.connectAllTxtFieldFields(txtfields: [txtFldBankName,txtFldAccountNo,txtFldAccountName,txtFldBankCode])
    }
    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.black)
    }
    //MARK:- IBActions
    @IBAction func actionBack(_ sender: Any) {
        pop()
    }
    @IBAction func actionSave(_ sender: Any) {
        view.endEditing(true)
        let request = AddBankAccount(accountName: txtFldAccountName.text, bankName: txtFldBankName.text, accountNo: txtFldAccountNo.text, bankCode: txtFldBankCode.text)
        let url = objUserModel.accountNo != "" ? "\(Apis.updateBankAccount)?id=\(objUserModel.bankId)" : Apis.addBankAccount
        objAddBankDetailVM.addBankAccountApi(request, url: url) {
            self.pop()
        }
    }
}

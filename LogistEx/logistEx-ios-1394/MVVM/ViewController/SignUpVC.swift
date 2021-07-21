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
class SignUpVC: UIViewController {
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var imgVwSignUp: UIImageView!
    @IBOutlet weak var txtFldFirstName: UITextField!
    @IBOutlet weak var txtFldLastName: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPassword: UITextField!
    @IBOutlet weak var txtFldConfirmPassword: UITextField!
    @IBOutlet weak var txtFldPhone: UITextField!
    @IBOutlet weak var btnAcceptTermsCondition: UIButton!
    @IBOutlet weak var txtFldSelectCurrency: UITextField!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    
    //MARK:- Variables
    var objSignUpVM = SignUpVM()
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        lblHeader.text = "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.registerSpa : PassTitles.register)"
        btnRegister.setTitle("\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.registerSpa : PassTitles.register)", for: .normal)
        UITextField.connectAllTxtFieldFields(txtfields: [ txtFldFirstName, txtFldLastName, txtFldEmail, txtFldPassword, txtFldConfirmPassword, txtFldPhone])
        
    }
    //MARK:- IBACTIONS
    @IBAction func actionTermsCondition(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func actionRegistered(_ sender: UIButton) {
        let postParam = SignUp(firstName: txtFldFirstName.text!, lastName: txtFldLastName.text!, emailId: txtFldEmail.text!, password: txtFldPassword.text!, confirmPassword: txtFldConfirmPassword.text!, currency: objSignUpVM.currency, mobileNumber: txtFldPhone.text!, roleId: 2, btnTerms: btnAcceptTermsCondition)
            var imageDict = [String:UIImage]()
            imageDict = objSignUpVM.isProfileUpdted ? ["User[profile_file]": imgVwSignUp.image!] : [:]
            objSignUpVM.hitSignUpApi(postParam: postParam, imageDict: imageDict){
                self.popToBack()
            }
    }
    @IBAction func actionBack(_ sender: UIButton) {
        popToBack()
    }
    @IBAction func actionLogIn(_ sender: UIButton) {
        popToBack()
    }
    @IBAction func actionEye(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        txtFldPassword.isSecureTextEntry = sender.isSelected
    }
    @IBAction func actionConfirmEye(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        txtFldConfirmPassword.isSecureTextEntry = sender.isSelected
    }
    @IBAction func actionTermsPolicy(_ sender: UIButton) {
        let objpageTypeVC = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: IdentifiersVC.pageTypeVC.rawValue) as! PageTypeVC
        objpageTypeVC.title = PassTitles.termsAndCondition.localized
        objpageTypeVC.objPageTypeVM.cameFrom = PassTitles.termsAndCondition
        self.navigationController?.pushViewController(objpageTypeVC, animated: true)       
    }
    @IBAction func actionUploadImage(_ sender: UIButton) {
        objPassImageDelegate = self
        objSignUpVM.objGalleryCameraImage.customActionSheet(removeProfile: false, controller: self)
    }
}

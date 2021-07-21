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

class SignUpVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var btnChangeImage: UIButton!
    @IBOutlet weak var imgVwUser: RoundedImage!
    @IBOutlet weak var txtFldFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldConfirmPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldContact: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldNumberPlate: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldSelectCat: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldSelectType: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldVehicleBrand: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldVehicleColor: SkyFloatingLabelTextField!
    @IBOutlet weak var colVwLicense: UICollectionView!
    @IBOutlet weak var colVwNumberPlate: UICollectionView!
    @IBOutlet weak var colVwRoadTax: UICollectionView!
    @IBOutlet weak var colVwIdCard: UICollectionView!
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var btnAcceptTerms: UIButton!
    @IBOutlet weak var colVwInsurance: UICollectionView!
    @IBOutlet weak var txtFldLicenseExpDate: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldInsuranceExpDate: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldSelectCountry: SkyFloatingLabelTextField!

    //MARK:- Object
    var objSignUpVM = SignUpVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDetail()
    }
    
    //MARK:- IBActions
    @IBAction func actionBack(_ sender: Any) {
        pop()
    }
    @IBAction func actionChangeImage(_ sender: Any) {
        objSignUpVM.objGalleryFunctions.customActionSheet(false)
        objSignUpVM.selectedType = TitleValue.profile
    }
    @IBAction func actionShowPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        txtFldPassword.isSecureTextEntry = !sender.isSelected
    }
    @IBAction func actionShowConfirmPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        txtFldConfirmPassword.isSecureTextEntry = !sender.isSelected
    }
    @IBAction func actionTermsCondition(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func actionSignUp(_ sender: Any) {
        view.endEditing(true)
        let request = SignupRequest(firstName: txtFldFirstName.text, lastName: txtFldLastName.text, email: txtFldEmail.text, password: txtFldPassword.text, confirmPassword: txtFldConfirmPassword.text, contact: txtFldContact.text, role: "\(Role.driver.rawValue)", vehicleType: objSignUpVM.serviceId,category: objSignUpVM.catId, brand: "\(objSignUpVM.brandId)", color: "\(objSignUpVM.colorId)", vehicleNo: txtFldNumberPlate.text,licenseExpDate: txtFldLicenseExpDate.text, insuranceExpDate: txtFldInsuranceExpDate.text, currency: objSignUpVM.currency, profile:  objSignUpVM.image, license: objSignUpVM.arrLicense, numberPlate: objSignUpVM.arrNumberPlate, roadTax: objSignUpVM.arrRoadTax, idCard: objSignUpVM.arrIdProof, insurance: objSignUpVM.arrInsurance, term: btnAcceptTerms.isSelected)
        
        objSignUpVM.hitSignUpApi(request) {
            self.verificationAlert()
        }
    }
    @IBAction func actionLogin(_ sender: Any) {
        pop()
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        let termsRange = lang == ChooseLanguage.spanish.rawValue ? (lblTerms.text! as NSString).range(of: "Términos y condiciones") : (lblTerms.text! as NSString).range(of: "Terms & Conditions")
        if gesture.didTapAttributedTextInLabel(label: lblTerms, inRange: termsRange) {
            push(identifier: "TermConditionVC", titleStr: TitleValue.termsCondition)
        }
    }
    func setUpDetail() {
        galleryCameraImageObj = self
        DispatchQueue.main.async {
            self.colVwIdCard.reloadData()
            self.colVwRoadTax.reloadData()
            self.colVwLicense.reloadData()
            self.colVwNumberPlate.reloadData()
        }
        txtFldFirstName.titleFormatter = {$0}
        txtFldLicenseExpDate.titleFormatter = {$0}
        txtFldInsuranceExpDate.titleFormatter = {$0}
        txtFldLastName.titleFormatter = {$0}
        txtFldEmail.titleFormatter = {$0}
        txtFldPassword.titleFormatter = {$0}
        txtFldConfirmPassword.titleFormatter = {$0}
        txtFldNumberPlate.titleFormatter = {$0}
        txtFldContact.titleFormatter = {$0}
        txtFldSelectType.titleFormatter = {$0}
        txtFldSelectCat.titleFormatter = {$0}
        txtFldVehicleBrand.titleFormatter = {$0}
        txtFldVehicleColor.titleFormatter = {$0}
        txtFldSelectCountry.titleFormatter = {$0}
        UITextField.connectAllTxtFieldFields(txtfields: [txtFldFirstName,txtFldLastName,txtFldEmail,txtFldPassword,txtFldConfirmPassword,txtFldContact,txtFldSelectType,txtFldSelectCat,txtFldVehicleBrand,txtFldContact,txtFldSelectCountry,txtFldNumberPlate])
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        let text = lang == ChooseLanguage.spanish.rawValue ? "Acepto Términos y condiciones" : "I accept Terms & Conditions"
        lblTerms.text = text
        self.lblTerms.textColor =  UIColor.lightGray
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = lang == ChooseLanguage.spanish.rawValue ? (text as NSString).range(of: "Términos y condiciones") : (text as NSString).range(of: "Terms & Conditions")
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: Font.avenirMedium, size: 17)!, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range1)
        lblTerms.attributedText = underlineAttriString
        lblTerms.isUserInteractionEnabled = true
        lblTerms.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
    }
    func verificationAlert() {
        let controller = UIAlertController(title: AppInfo.appName, message: AlertMessages.verificationLink.localized, preferredStyle: .alert)
        let okAction = UIAlertAction(title: AlertMessages.ok.localized, style: .default) { (action) in
            self.pop()
        }
        controller.addAction(okAction)
        controller.view.tintColor = Color.app
        self.present(controller, animated: true, completion: nil)
    }
}

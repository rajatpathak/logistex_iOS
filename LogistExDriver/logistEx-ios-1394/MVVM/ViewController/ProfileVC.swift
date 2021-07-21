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
import Lightbox

class ProfileVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var btnChangeImage: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var imgVwUser: RoundedImage!
    @IBOutlet weak var txtFldFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldNo: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldServiceType: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldNumberPlate: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldVehicleCat: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldVehicleBrand: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldVehicleColor: SkyFloatingLabelTextField!
    @IBOutlet weak var colVwLicense: UICollectionView!
    @IBOutlet weak var colVwNumberPlate: UICollectionView!
    @IBOutlet weak var colVwRoadTax: UICollectionView!
    @IBOutlet weak var colVwIdCard: UICollectionView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtFldChangePassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldLicenseExpDate: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldInsuranceExpDate: SkyFloatingLabelTextField!
    @IBOutlet weak var colVwInsurance: UICollectionView!
    @IBOutlet weak var txtFldSelectCountry: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldAddBankDetail: SkyFloatingLabelTextField!
    @IBOutlet weak var vwPasswordHeightCnst: NSLayoutConstraint!
    @IBOutlet weak var vwChangePassword: UIView!
    @IBOutlet weak var btnOpenImage: UIButton!
    @IBOutlet weak var vwChangeLangHeightCnst: NSLayoutConstraint!
    @IBOutlet weak var txtFldChangeLanguage: SkyFloatingLabelTextField!
    @IBOutlet weak var vwChangeLanguage: UIView!
    
    //MARK:- Object
    var objProfileVM = ProfileVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        enableFields(false)
        setUserDetail()
    }
    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.white)
    }
    //MARK:- IBActions
    @IBAction func actionSave(_ sender: UIButton) {
        view.endEditing(true)
        let request = UpdateProfileRequest(firstName: txtFldFirstName.text, lastName: txtFldLastName.text, email: txtFldEmail.text, contact: txtFldNo.text, role: "\(Role.driver.rawValue)", vehicleType: objProfileVM.serviceId, category: "\(objProfileVM.catId)", vehicleNo: txtFldNumberPlate.text, brand: "\(objProfileVM.brandId)", color: "\(objProfileVM.colorId)", licenseExpDate: txtFldLicenseExpDate.text, insuranceExpDate: txtFldInsuranceExpDate.text, currency: objProfileVM.currency, profile: imgVwUser.image, license: objProfileVM.arrLicense, numberPlate: objProfileVM.arrNumberPlate, roadTax: objProfileVM.arrRoadTax, idCard: objProfileVM.arrIdProof, insurance: objProfileVM.arrInsurance)
     
        objProfileVM.hitUpdateProfileApi(request) {
            self.shownVisibility()
            self.colVwLicense.reloadData()
            self.colVwIdCard.reloadData()
            self.colVwNumberPlate.reloadData()
            self.colVwRoadTax.reloadData()
            self.colVwInsurance.reloadData()
        }
    }
    @IBAction func actionBack(_ sender: Any) {
        pop()
    }
    @IBAction func actionEdit(_ sender: UIButton) {
        if !btnEdit.isSelected {
            btnEdit.isSelected = true
            btnEdit.isHidden = true
        }
        colVwLicense.reloadData()
        colVwIdCard.reloadData()
        colVwNumberPlate.reloadData()
        colVwRoadTax.reloadData()
        colVwInsurance.reloadData()
        vwPasswordHeightCnst.constant = 0
        vwChangePassword.isHidden = true
        vwChangeLangHeightCnst.constant = 0
        vwChangeLanguage.isHidden = true
        btnChangeImage.isHidden = false
        btnOpenImage.isHidden = true
        btnSave.isHidden = false
        btnSave.isSelected = false
        enableFields(true)
        
        if objUserModel.serviceTypeId == 0  {
            txtFldServiceType.isUserInteractionEnabled = true
            txtFldVehicleCat.isUserInteractionEnabled = true
            txtFldVehicleColor.isUserInteractionEnabled = true
            txtFldVehicleBrand.isUserInteractionEnabled = true
        } else {
            txtFldServiceType.isUserInteractionEnabled = false
            txtFldVehicleCat.isUserInteractionEnabled = false
            txtFldVehicleColor.isUserInteractionEnabled = false
            txtFldVehicleBrand.isUserInteractionEnabled = false
        }
    }
    func setUserDetail() {
        galleryCameraImageObj = self
        txtFldSelectCountry.titleFormatter = {$0}
        txtFldChangeLanguage.titleFormatter = {$0}
        txtFldFirstName.titleFormatter = {$0}
        txtFldLastName.titleFormatter = {$0}
        txtFldEmail.titleFormatter = {$0}
        txtFldNo.titleFormatter = {$0}
        txtFldServiceType.titleFormatter = {$0}
        txtFldLicenseExpDate.titleFormatter = {$0}
        txtFldInsuranceExpDate.titleFormatter = {$0}
        txtFldNumberPlate.titleFormatter = {$0}
        txtFldVehicleCat.titleFormatter = {$0}
        txtFldVehicleBrand.titleFormatter = {$0}
        txtFldVehicleColor.titleFormatter = {$0}
        imgVwUser.sd_setImage(with: URL(string: objUserModel.profile), placeholderImage: #imageLiteral(resourceName: "ic_default_user"))
        txtFldFirstName.text = objUserModel.firstName
        txtFldLastName.text = objUserModel.lastName
        txtFldEmail.text = objUserModel.email
        txtFldNo.text = objUserModel.contact
        objProfileVM.catId = "\(objUserModel.categoryId)"
        objProfileVM.serviceId = "\(objUserModel.serviceTypeId)"
        let lang = UserDefaults.standard.value(forKey: "Language") as? String
        txtFldNumberPlate.text = objUserModel.vehicleNo
        txtFldVehicleColor.text = objUserModel.colorTitle
        txtFldVehicleBrand.text = objUserModel.brandTitle
        txtFldServiceType.text = objUserModel.serviceTitle
        objProfileVM.serviceId = "\(objUserModel.serviceTypeId)"
        objProfileVM.colorId = "\(objUserModel.colorId)"
        objProfileVM.brandId = "\(objUserModel.brandId)"
        objProfileVM.catId = "\(objUserModel.vehicleCat)"
        objProfileVM.currency = "\(objUserModel.currencyId)"
        txtFldLicenseExpDate.text = objUserModel.licenseExpDate
        txtFldInsuranceExpDate.text = objUserModel.insuranceExpDate
        txtFldSelectCountry.text = objUserModel.contact == "" || objUserModel.contact == "<null>" ? "" : "\(objUserModel.driverCountry) (\(objUserModel.currency))"
        txtFldChangeLanguage.text = lang == ChooseLanguage.spanish.rawValue ? TitleValue.spanish : TitleValue.english
        txtFldVehicleCat.text = objUserModel.vehicleCatTitle
        
        if lang == ChooseLanguage.spanish.rawValue {
            txtFldAddBankDetail.attributedPlaceholder = NSAttributedString(string: objUserModel.bankName == "" ? TitleValue.addBankDetailSpa : TitleValue.bankDetailSpa, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        } else {
            txtFldAddBankDetail.attributedPlaceholder = NSAttributedString(string: objUserModel.bankName == "" ? TitleValue.addBankDetail : TitleValue.bankDetail, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        }
        UITextField.connectAllTxtFieldFields(txtfields: [txtFldFirstName,txtFldLastName,txtFldNo,txtFldNumberPlate])
    }
    func enableFields(_ enable: Bool) {
        txtFldFirstName.isUserInteractionEnabled = enable
        txtFldLastName.isUserInteractionEnabled = enable
        txtFldNumberPlate.isUserInteractionEnabled = enable
        txtFldInsuranceExpDate.isUserInteractionEnabled = enable
        txtFldLicenseExpDate.isUserInteractionEnabled = enable
        txtFldSelectCountry.isUserInteractionEnabled = enable
        
        if objUserModel.contact == "" || objUserModel.contact == "<null>" {
            txtFldNo.isUserInteractionEnabled = enable
        } else {
            txtFldNo.isUserInteractionEnabled = false
        }
        if objUserModel.serviceTypeId == 0  {
            txtFldServiceType.isUserInteractionEnabled = false
            txtFldVehicleCat.isUserInteractionEnabled = false
            txtFldVehicleColor.isUserInteractionEnabled = false
            txtFldVehicleBrand.isUserInteractionEnabled = false
        } else {
            txtFldServiceType.isUserInteractionEnabled = true
            txtFldVehicleCat.isUserInteractionEnabled = true
            txtFldVehicleColor.isUserInteractionEnabled = true
            txtFldVehicleBrand.isUserInteractionEnabled = true
        }
    }
    @IBAction func actionChangeProfile(_ sender: Any) {
        objProfileVM.objGalleryFunctions.customActionSheet(false)
        objProfileVM.selectedType = TitleValue.profile
    }
    func shownVisibility() {
        if !btnSave.isSelected {
            btnSave.isSelected = true
            btnSave.isHidden = true
        }
        vwPasswordHeightCnst.constant = 55
        vwChangePassword.isHidden = false
        vwChangeLangHeightCnst.constant = 55
        vwChangeLanguage.isHidden = false
        btnEdit.isHidden = false
        btnEdit.isSelected = false
        btnOpenImage.isHidden = false
        btnChangeImage.isHidden = true
        enableFields(false)
        rootWithDrawer(identifier: "HomeVC")
        Proxy.shared.displayStatusAlert(AlertMessages.updated.localized)
    }
    @IBAction func actionOpenImage(_ sender: Any) {
        if objUserModel.profile != "" {
            let images = [LightboxImage(imageURL: URL.init(string: objUserModel.profile)!)]
            let controller = LightboxController(images: images)
            controller.pageDelegate = self
            controller.dismissalDelegate = self
            controller.dynamicBackground = true
            controller.modalPresentationStyle = .fullScreen
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
    }
    
    func pickUp(_ textField : UITextField){
        objProfileVM.languagePicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        objProfileVM.languagePicker.delegate = self
        objProfileVM.languagePicker.dataSource = self
        objProfileVM.languagePicker.backgroundColor = UIColor.white
        txtFldChangeLanguage.inputView = objProfileVM.languagePicker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        let lang = UserDefaults.standard.value(forKey: "Language") as? String
        objProfileVM.languagePicker.selectRow(lang == ChooseLanguage.spanish.rawValue ? 1 : 0 , inComponent: 0, animated: true)
        txtFldChangeLanguage.text = lang == ChooseLanguage.spanish.rawValue ? TitleValue.spanish : TitleValue.english
        objProfileVM.selectedLanguage = lang == ChooseLanguage.spanish.rawValue ? ChooseLanguage.spanish.rawValue : ChooseLanguage.english.rawValue
    }
    @objc func doneClick() {
        UserDefaults.standard.set(objProfileVM.selectedLanguage, forKey:"Language")
        UserDefaults.standard.synchronize()
        txtFldChangeLanguage.resignFirstResponder()
        rootWithDrawer(identifier: "HomeVC")
    }
    @objc func cancelClick() {
        txtFldChangeLanguage.resignFirstResponder()
    }
}

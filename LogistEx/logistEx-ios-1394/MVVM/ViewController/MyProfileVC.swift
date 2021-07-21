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
import Lightbox

class MyProfileVC: UIViewController {
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var imgVwProfile: UIImageView!
    @IBOutlet weak var txtFldFirstName: UITextField!
    @IBOutlet weak var txtFldLastName: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldMobileNumber: UITextField!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var txtFldSelectCurrency: UITextField!
    @IBOutlet weak var vwChangePassword: UIView!
    @IBOutlet weak var vwPasswordHeightCnst: NSLayoutConstraint!
    @IBOutlet weak var btnDrawer: UIButton!
    @IBOutlet weak var btnOpenImage: UIButton!
    @IBOutlet weak var txtFldChangeLanguage: UITextField!
    @IBOutlet weak var vwChangeLanguage: UIView!
    @IBOutlet weak var vwLanguageHeightCnst: NSLayoutConstraint!
    
    //MARK:- VARIABLES
    var objMyProfileVM = MyProfileVM()
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        showProfileData()
        UITextField.connectAllTxtFieldFields(txtfields: [txtFldFirstName,txtFldLastName,txtFldSelectCurrency])
    }
    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.white)
    }
    func enableTxtFld(_ enable: Bool) {
        txtFldFirstName.isUserInteractionEnabled = enable
        txtFldLastName.isUserInteractionEnabled = enable
        txtFldSelectCurrency.isUserInteractionEnabled = enable
        btnCamera.isHidden = !enable
        if objUserModel.contactNumber == "" || objUserModel.contactNumber == "<null>" {
            txtFldMobileNumber.isUserInteractionEnabled = enable
        } else {
            txtFldMobileNumber.isUserInteractionEnabled = false
        }
    }
    
    func showProfileData(){
        enableTxtFld(false)
        txtFldFirstName.text = objUserModel.firstName
        txtFldLastName.text = objUserModel.lastName
        txtFldMobileNumber.text = objUserModel.contactNumber
        txtFldEmail.text = objUserModel.email
        imgVwProfile.sd_setImage(with: URL(string: objUserModel.profileImage), placeholderImage: #imageLiteral(resourceName: "ic_drawer_pic"))
        txtFldSelectCurrency.text = objUserModel.currency
        objMyProfileVM.currency = objUserModel.currencyId
        let lang = UserDefaults.standard.value(forKey: "Language") as? String
        txtFldChangeLanguage.text = lang == ChooseLanguage.spanish.rawValue ? PassTitles.spanish : PassTitles.english
    }
    
    //MARK:- IBACTIONS
    @IBAction func actionChangePassword(_ sender: UIButton) {
        pushVC(selectedStoryboard: .main, identifier: .newPasswordVC)
    }
    @IBAction func actionDrawer(_ sender: UIButton) {
        popToBack() 
    }
    @IBAction func actionEdit(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            vwChangePassword.isHidden = true
            vwChangeLanguage.isHidden = true
            btnOpenImage.isHidden = true
            enableTxtFld(true)
            vwPasswordHeightCnst.constant = 0
            vwLanguageHeightCnst.constant = 0
        } else {
            let requestUpdate = Profile(firstName: txtFldFirstName.text,
                                        lastName: txtFldLastName.text,
                                        email : txtFldEmail.text,
                                        mobileNumber: txtFldMobileNumber.text,
                                        currency: objMyProfileVM.currency,
                                        address: objUserModel.address)
            let imageDict = ["User[profile_file]": imgVwProfile.image] as! [String : UIImage]
            objMyProfileVM.updateProfileApi(postParam: requestUpdate, parametersImage: imageDict){
                self.showProfileData()
                sender.isSelected = false
                self.enableTxtFld(false)
                self.btnOpenImage.isHidden = false
                self.vwChangePassword.isHidden = false
                self.vwChangeLanguage.isHidden = false
                self.vwPasswordHeightCnst.constant = 40
                self.vwLanguageHeightCnst.constant = 65
            }
        }
    }
    func pickUp(_ textField : UITextField){
     
        objMyProfileVM.languagePicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        objMyProfileVM.languagePicker.delegate = self
        objMyProfileVM.languagePicker.dataSource = self
        objMyProfileVM.languagePicker.backgroundColor = UIColor.white
        txtFldChangeLanguage.inputView = objMyProfileVM.languagePicker
        
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
        objMyProfileVM.languagePicker.selectRow(lang == ChooseLanguage.spanish.rawValue ? 1 : 0 , inComponent: 0, animated: true)
        txtFldChangeLanguage.text = lang == ChooseLanguage.spanish.rawValue ? PassTitles.spanish : PassTitles.english
        objMyProfileVM.selectedLanguage = lang == ChooseLanguage.spanish.rawValue ? ChooseLanguage.spanish.rawValue : ChooseLanguage.english.rawValue
    }
    @objc func doneClick() {
        UserDefaults.standard.set(objMyProfileVM.selectedLanguage, forKey:"Language")
        UserDefaults.standard.synchronize()
        txtFldChangeLanguage.resignFirstResponder()
        rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC)
    }
    @objc func cancelClick() {
        txtFldChangeLanguage.resignFirstResponder()
    }
    @IBAction func actionProfileCamera(_ sender: UIButton) {
        objPassImageDelegate = self
        objMyProfileVM.isProfileUpdate = true
        objMyProfileVM.objGalleryCameraImage.customActionSheet(removeProfile: false, controller: self)
    }
    @IBAction func actionOpenImage(_ sender: Any) {
        if objUserModel.profileImage != "" {
            let images = [LightboxImage(imageURL: URL(string: objUserModel.profileImage)!)]
            let controller = LightboxController(images: images)
            controller.pageDelegate = self
            controller.dismissalDelegate = self
            controller.dynamicBackground = true
            controller.modalPresentationStyle = .fullScreen
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
    }
}


extension MyProfileVC : PassImageDelegate {
    func getSelectedImage(selectImage: UIImage) {
        imgVwProfile.image = selectImage
    } 
}


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
import AuthenticationServices

class LoginVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var txtFldEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFldPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var btnRemember: UIButton!
    @IBOutlet weak var btnChooseLanguage: UIButton!
    
    //MARK:- Object
    var objLoginVM = LoginVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDetail()
    }
    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.white)
    }
    
    //MARK:- IBActions
    @IBAction func actionRememberMe(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func actionForgotPassword(_ sender: Any) {
        present(identifier: "ForgotPasswordVC")
    }
    
    @IBAction func actionGoogle(_ sender: Any) {
        GmailLogin.sharedInstance().loginWithGmail(viewController: self, successHandler: { (result) in
            let request = FacebookRequest(email: result.profile.email, name: result.profile.name, role: "\(Role.driver.rawValue)", userId: result.userID, provider: Provider.google)
            self.objLoginVM.hitFacebookLoginApi(request) {
                self.rootWithDrawer(identifier: "HomeVC")
                Proxy.shared.displayStatusAlert(AlertMessages.loginSuccess.localized)
            }
        }) { (error) in
        }
    }
    @IBAction func actionAppleLogin(_ sender: Any) {
        
        if #available(iOS 13.0, *) {
                     let request = ASAuthorizationAppleIDProvider().createRequest()
                     request.requestedScopes = [.fullName, .email]
                     let controller = ASAuthorizationController(authorizationRequests: [request])
                     controller.delegate = self
                     controller.presentationContextProvider = self
                     controller.performRequests()
                 } else {
                    Proxy.shared.displayStatusAlert(AlertMessages.updateIosVersion.localized)

                 }
        
    }
    @IBAction func actionLogin(_ sender: Any) {
        view.endEditing(true)
        let request = LoginRequest(name: txtFldEmail.text, password: txtFldPassword.text, role: "\(Role.driver.rawValue)")
        objLoginVM.hitLoginApi(request) {
            if self.btnRemember.isSelected {
                UserDefaults.standard.setValue(self.txtFldEmail.text, forKey: "email")
                UserDefaults.standard.setValue(self.txtFldPassword.text, forKey: "password")
                UserDefaults.standard.synchronize()
            } else {
                UserDefaults.standard.setValue(nil, forKey: "email")
                UserDefaults.standard.setValue(nil, forKey: "password")
                UserDefaults.standard.synchronize()
            }
            self.rootWithDrawer(identifier: "HomeVC")
            Proxy.shared.displayStatusAlert(AlertMessages.loginSuccess.localized)
        }
    }
    @IBAction func actionShowPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        txtFldPassword.isSecureTextEntry = !sender.isSelected
    }
    @IBAction func actionClickHere(_ sender: Any) {
        push(identifier: "SignUpVC")
    }
    @IBAction func actionSociallogin(_ sender: Any) {
        FacebookClass.sharedInstance().loginWithFacebook(viewController: self, successHandler: { (userDict) in
            let email = userDict["email"] as? String ?? ""
            let userId = Proxy.shared.isValueString(userDict["id"] as Any)
            let userName = userDict["name"] as? String ?? ""
            let request = FacebookRequest(email: email, name: userName, role: "\(Role.driver.rawValue)", userId: userId, provider: Provider.facebook)
            self.objLoginVM.hitFacebookLoginApi(request) {
                self.rootWithDrawer(identifier: "HomeVC")
                Proxy.shared.displayStatusAlert(AlertMessages.loginSuccess.localized)
            }
        }) { (error) in
            Proxy.shared.displayStatusAlert(error as? String ?? "")
        }
    }
    func setDetail() {
        if UserDefaults.standard.value(forKey: "email") != nil {
            txtFldEmail.text = UserDefaults.standard.value(forKey: "email" ) as? String
            txtFldPassword.text = UserDefaults.standard.value(forKey: "password" ) as? String
            btnRemember.isSelected = true
        } else {
            txtFldEmail.text = ""
            txtFldPassword.text = ""
            btnRemember.isSelected = false
        }
        
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        btnChooseLanguage.setTitle(lang == ChooseLanguage.spanish.rawValue ? TitleValue.spanish : TitleValue.english, for: .normal)
        objLoginVM.languagePicker.selectRow(lang == ChooseLanguage.spanish.rawValue ? 1 : 0 , inComponent: 0, animated: true)
        txtFldPassword.titleFormatter = {$0}
        txtFldEmail.titleFormatter = {$0}
        UITextField.connectAllTxtFieldFields(txtfields: [txtFldEmail,txtFldPassword])
        if UserDefaults.standard.object(forKey: "OpenPicker") as? String != "True" {
            customPicker()
        }
    }
    @IBAction func actionChooseLan(_ sender: Any) {
        customPicker()
    }
    @objc func onDoneButtonTapped() {
        UserDefaults.standard.set(objLoginVM.selectedLanguage, forKey:"Language")
        UserDefaults.standard.synchronize()
        objLoginVM.toolBar.removeFromSuperview()
        objLoginVM.languagePicker.removeFromSuperview()
        btnChooseLanguage.isUserInteractionEnabled = true
        UserDefaults.standard.setValue("True", forKey: "OpenPicker")
        self.view.layoutIfNeeded()
        root(identifier: "LoginVC")
    }
    func customPicker() {
        objLoginVM.languagePicker.delegate = self
        objLoginVM.languagePicker.backgroundColor = UIColor.white
        objLoginVM.languagePicker.setValue(UIColor.black, forKey: "textColor")
        objLoginVM.languagePicker.autoresizingMask = .flexibleWidth
        objLoginVM.languagePicker.contentMode = .center
        objLoginVM.languagePicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 220, width: UIScreen.main.bounds.size.width, height: 220)
        self.view.addSubview(objLoginVM.languagePicker)
        objLoginVM.toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 220, width: UIScreen.main.bounds.size.width, height: 50))
        objLoginVM.toolBar.barStyle = .default
        objLoginVM.toolBar.items = [UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        objLoginVM.languagePicker.selectRow(lang == ChooseLanguage.spanish.rawValue ? 1 : 0 , inComponent: 0, animated: true)
        btnChooseLanguage.setTitle(lang == ChooseLanguage.spanish.rawValue ? TitleValue.spanish : TitleValue.english, for: .normal)
        objLoginVM.selectedLanguage = lang == ChooseLanguage.spanish.rawValue ? ChooseLanguage.spanish.rawValue : ChooseLanguage.english.rawValue
        self.view.addSubview(objLoginVM.toolBar)
        btnChooseLanguage.isUserInteractionEnabled = false
    }
}

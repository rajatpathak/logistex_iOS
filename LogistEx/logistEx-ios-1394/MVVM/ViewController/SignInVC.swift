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
import AuthenticationServices

class SignInVC: UIViewController {
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPassword: UITextField!
    @IBOutlet weak var btnRemember: UIButton!
    @IBOutlet weak var btnChooseLanguage: UIButton!
    
    //MARK:- VARIABLES
    var objSignInVM = SignInVM()
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        UITextField.connectAllTxtFieldFields(txtfields: [txtFldEmail,txtFldPassword])
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        btnChooseLanguage.setTitle(lang == ChooseLanguage.spanish.rawValue ? PassTitles.spanish : PassTitles.english, for: .normal)
        objSignInVM.languagePicker.selectRow(lang == ChooseLanguage.spanish.rawValue ? 1 : 0 , inComponent: 0, animated: true)
        if UserDefaults.standard.object(forKey: "email") != nil {
            txtFldEmail.text = UserDefaults.standard.object(forKey: "email") as? String
            txtFldPassword.text = UserDefaults.standard.object(forKey: "password") as? String
            btnRemember.isSelected = true
        } else {
            txtFldEmail.text = ""
            txtFldPassword.text = ""
            btnRemember.isSelected = false
        }
    
        if UserDefaults.standard.object(forKey: "OpenPicker") as? String != "True" {
            customPicker()
        }
    }

    //MARK:- IBACTIONS
    @IBAction func actionBack(_ sender: UIButton) {
        popToBack()
        self.rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC)
    }
    
    @IBAction func actionLogin(_ sender: UIButton) {
        view.endEditing(true)
        let postParam = Login(roleId: Role.user.rawValue, emailId: txtFldEmail.text!, password: txtFldPassword.text!)
        
        objSignInVM.hitSignInApi(postParam: postParam){
            self.rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC)
            if self.btnRemember.isSelected {
                UserDefaults.standard.set(self.txtFldEmail.text!, forKey: "email")
                UserDefaults.standard.set(self.txtFldPassword.text!, forKey: "password")
                UserDefaults.standard.synchronize()
            } else {
                UserDefaults.standard.set("", forKey: "email")
                UserDefaults.standard.set("", forKey: "password")
                UserDefaults.standard.synchronize()
            }
            Proxy.shared.displayStatusAlert(message: AlertMessages.loginSuccess.localized, state: .success)
        }
    }
    
    @IBAction func actionForgotPassword(_ sender: UIButton) {
        presentVC(selectedStoryboard: .main, identifier: .forgotPasswordVC)
    }
    @IBAction func actionAppleLogin(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self as? ASAuthorizationControllerDelegate
            controller.presentationContextProvider = self
            controller.performRequests()
        } else {
            Proxy.shared.displayStatusAlert(message: AlertMessages.updateIosVersion.localized, state: .error)
        }
        
    }
    @IBAction func actionGoogleLogin(_ sender: Any) {
        GmailLogin.sharedInstance().loginWithGmail(viewController: self, successHandler: { (result) in
            let request = Facebook(email: result.profile.email, name: result.profile.name, role: "\(Role.user.rawValue)", userId: result.userID, provider: Provider.google)
            self.objSignInVM.hitFacebookLoginApi(request) {
                self.rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC)
                   Proxy.shared.displayStatusAlert(message: AlertMessages.loginSuccess.localized, state: .success)
            }
        }) { (error) in
        }
    }
    
    @IBAction func actionSignup(_ sender: UIButton) {
        pushVC(selectedStoryboard: .main, identifier: .signUpVC)
    }
    
    @IBAction func actionRememberMe(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func actionShowHide(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        txtFldPassword.isSecureTextEntry = sender.isSelected
    }
    
    @IBAction func actionLoginWithFacebook(_ sender: UIButton) {
        FacebookClass.sharedInstance().loginWithFacebook(viewController: self, successHandler: { (userDict) in
            let email = userDict["email"] as? String ?? ""
            let userId = userDict.getValueInString(userDict["id"] as AnyObject)
            let userName = userDict["name"] as? String ?? ""
            let request = Facebook(email: email, name: userName, role: "\(Role.user.rawValue)", userId: userId, provider: Provider.facebook)
            self.objSignInVM.hitFacebookLoginApi(request) {
                self.rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC)
                Proxy.shared.displayStatusAlert(message: AlertMessages.loginSuccess.localized, state: .success)
            }
        }) { (error) in
            Proxy.shared.displayStatusAlert(message: error as? String ?? "", state: .error)
        }
    }
    @IBAction func actionChooseLan(_ sender: Any) {
        customPicker()
    }
    @objc func onDoneButtonTapped() {
        UserDefaults.standard.set(objSignInVM.selectedLanguage, forKey:"Language")
        UserDefaults.standard.synchronize()
        objSignInVM.toolBar.removeFromSuperview()
        objSignInVM.languagePicker.removeFromSuperview()
        btnChooseLanguage.isUserInteractionEnabled = true
        UserDefaults.standard.setValue("True", forKey: "OpenPicker")
        self.view.layoutIfNeeded()
        rootWithoutDrawer(selectedStoryboard: .main, identifier: .loginVC)
    }
    func customPicker() {
        objSignInVM.languagePicker.delegate = self
        objSignInVM.languagePicker.backgroundColor = UIColor.white
        objSignInVM.languagePicker.setValue(UIColor.black, forKey: "textColor")
        objSignInVM.languagePicker.autoresizingMask = .flexibleWidth
        objSignInVM.languagePicker.contentMode = .center
        objSignInVM.languagePicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 220, width: UIScreen.main.bounds.size.width, height: 220)
        self.view.addSubview(objSignInVM.languagePicker)
        objSignInVM.toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 220, width: UIScreen.main.bounds.size.width, height: 50))
        objSignInVM.toolBar.barStyle = .default
        objSignInVM.toolBar.items = [UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        objSignInVM.languagePicker.selectRow(lang == ChooseLanguage.spanish.rawValue ? 1 : 0 , inComponent: 0, animated: true)
        btnChooseLanguage.setTitle(lang == ChooseLanguage.spanish.rawValue ? PassTitles.spanish : PassTitles.english, for: .normal)
        objSignInVM.selectedLanguage = lang == ChooseLanguage.spanish.rawValue ? ChooseLanguage.spanish.rawValue : ChooseLanguage.english.rawValue
        self.view.addSubview(objSignInVM.toolBar)
        btnChooseLanguage.isUserInteractionEnabled = false
    }
}
@available(iOS 13.0, *)
extension SignInVC: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        var userIdentifier,userFirstName,userLastName,userEmail,userFullName:String?
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
             userIdentifier = appleIDCredential.user
             userFirstName = appleIDCredential.fullName!.givenName
             userLastName = appleIDCredential.fullName!.familyName
             userEmail = appleIDCredential.email
             userFullName = "\(userFirstName ?? "") \(userLastName ?? "")"
            }
              let request = Facebook(email: userEmail, name: userFirstName, role: "\(Role.user.rawValue)", userId: userIdentifier, provider: Provider.apple)
                    self.objSignInVM.hitFacebookLoginApi(request){
                    self.rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC)
                    Proxy.shared.displayStatusAlert(message: AlertMessages.loginSuccess.localized, state: .success)

                }
       
    }
}

@available(iOS 13.0, *)
extension SignInVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

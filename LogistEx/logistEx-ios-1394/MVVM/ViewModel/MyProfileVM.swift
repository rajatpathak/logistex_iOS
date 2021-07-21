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

class MyProfileVM: NSObject{
    
    //MARK:- Variables
    var objGalleryCameraImage = GalleryCameraImage()
    var isProfileUpdate = false
    var imageFor = ""
    var currency = String()
    var languagePicker = UIPickerView()
    var arrLanguage = [PassTitles.english,PassTitles.spanish]
    var selectedLanguage = ChooseLanguage.english.rawValue
    
    //MARK:- Update Profile Api
    func updateProfileApi(postParam: Profile,parametersImage:[String : UIImage], completion:@escaping() -> Void) {
        if postParam.validData() {
            let param = [
                "User[first_name]" : postParam.firstName,
                "User[last_name]": postParam.lastName,
                "User[contact_no]": postParam.mobileNumber,
                "User[email]": objUserModel.email,
                "User[address]" : postParam.address,
                "User[currency]" : postParam.currency
                ] as [String: AnyObject]
            
            WebServiceProxy.shared.uploadImage(param, parametersImage: parametersImage, addImageUrl: Apis.updateProfile, showIndicator: true) { (response) in
                if let detailDict = response["detail"] as? Dictionary<String, AnyObject> {
                    objUserModel.setData(dictData: detailDict)
                }
                completion()
            }
        }
    }
}

extension MyProfileVC: LightboxControllerPageDelegate, LightboxControllerDismissalDelegate  {
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        debugPrint(page)
    }
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
    }
}

extension MyProfileVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return objMyProfileVM.arrLanguage.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return objMyProfileVM.arrLanguage[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtFldChangeLanguage.text = objMyProfileVM.arrLanguage[row]
        switch row {
        case 0:
            objMyProfileVM.selectedLanguage = ChooseLanguage.english.rawValue
        case 1:
            objMyProfileVM.selectedLanguage = ChooseLanguage.spanish.rawValue
        default:
            break
        }
    }
}

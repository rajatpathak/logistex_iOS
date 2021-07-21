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
import PKCCrop

class SignUpVM: NSObject {
    
    //MARK:- Variables
    var objGalleryFunctions = GalleryCameraImage()
    var arrLicense = NSMutableArray()
    var arrNumberPlate = NSMutableArray()
    var arrRoadTax = NSMutableArray()
    var arrIdProof = NSMutableArray()
    var arrInsurance = NSMutableArray()
    var selectedType = String()
    var catId = String()
    var serviceId = ""
    var catTitle = String()
    var image: UIImage?
    var currency = String()
    var brandId = String()
    var colorId = String()
    
    //MARK:- Hit Signup Api
    func hitSignUpApi(_ request: SignupRequest,completion:@escaping() -> Void) {
        if validData(request){
            
            let param = [
                "User[first_name]": request.firstName!,
                "User[last_name]": request.lastName!,
                "User[email]": request.email!,
                "User[password]": request.password!,
                "User[contact_no]": request.contact!,
                "User[role_id]": request.role!,
                "User[category_id]": request.vehicleType!, // transport/taxi
                "Vehicle[type_id]": request.category!, // category id(1,3,5)
                "Vehicle[brand_id]": request.brand!,
                "Vehicle[color_id]": request.color!,
                "Vehicle[vehicle_number]": request.vehicleNo!,
                "User[license_expiry_date]": request.licenseExpDate!,
                "User[insurance_expiry_date]": request.insuranceExpDate!,
                "User[currency]": request.currency!
                ] as [String:AnyObject]
            
            var paramImage = [String:UIImage]()
            paramImage["User[profile_file]"] = request.profile
            for i in 0..<arrLicense.count {
                paramImage["Vehicle[license_image][\(i)]"] = arrLicense[i] as? UIImage
            }
            for i in 0..<arrRoadTax.count {
                paramImage["Vehicle[roadtax_image][\(i)]"] = arrRoadTax[i] as? UIImage
            }
            for i in 0..<arrIdProof.count {
                paramImage["Vehicle[id_card_image][\(i)]"] = arrIdProof[i] as? UIImage
            }
            for i in 0..<arrNumberPlate.count {
                paramImage["Vehicle[vehicle_image][\(i)]"] = arrNumberPlate[i] as? UIImage
            }
            for i in 0..<arrInsurance.count {
                paramImage["Vehicle[insurance_file][\(i)]"] = arrInsurance[i] as? UIImage
            }
            WebServiceProxy.shared.uploadImage(apiName: Apis.signup, paramsDictionary: param, imageDictionary: paramImage, showIndicator: true) { (response) in
                if response.success {
                    completion()
                } else {
                    Proxy.shared.displayStatusAlert(response.message ?? "")
                }
            }
        }
    }
    
    //MARK:-  Check Data Validation
    func validData(_ request: SignupRequest) -> Bool {
        if request.profile == nil {
            Proxy.shared.displayStatusAlert(AlertMessages.profile.localized)
        } else if (request.firstName?.isBlank)!{
            Proxy.shared.displayStatusAlert(AlertMessages.firstName.localized)
        } else if (request.lastName?.isBlank)!{
            Proxy.shared.displayStatusAlert(AlertMessages.lastName.localized)
        } else if (request.email?.isBlank)!{
            Proxy.shared.displayStatusAlert(AlertMessages.email.localized)
        } else if !request.email!.isValidEmail {
            Proxy.shared.displayStatusAlert(AlertMessages.validEmail.localized)
        } else if (request.password?.isBlank)! {
            Proxy.shared.displayStatusAlert(AlertMessages.password.localized)
        } else if request.password!.count < 8 {
            Proxy.shared.displayStatusAlert(AlertMessages.passwordLimit.localized)
        } else if (request.confirmPassword!.isBlank) {
            Proxy.shared.displayStatusAlert(AlertMessages.confirmPassword.localized)
        } else if request.password != request.confirmPassword {
            Proxy.shared.displayStatusAlert(AlertMessages.notMatch.localized)
        } else if (request.contact!.isBlank)  {
            Proxy.shared.displayStatusAlert(AlertMessages.mobileNumber.localized)
        } else if request.contact!.count < 5 {
            Proxy.shared.displayStatusAlert(AlertMessages.enterVaildPhoneNo.localized)
        } else if (request.vehicleType!.isBlank)  {
            Proxy.shared.displayStatusAlert(AlertMessages.vehicleType.localized)
        } else if (request.category!.isBlank)  {
            Proxy.shared.displayStatusAlert(AlertMessages.vehicleCategory.localized)
        } else if (request.brand!.isBlank)  {
            Proxy.shared.displayStatusAlert(AlertMessages.vehicleBrand.localized)
        } else if (request.color!.isBlank)  {
            Proxy.shared.displayStatusAlert(AlertMessages.vehicleColor.localized)
        }  else if (request.currency!.isBlank)  {
            Proxy.shared.displayStatusAlert(AlertMessages.selectCountry.localized)
        } else if request.license?.count == 0 {
            Proxy.shared.displayStatusAlert(AlertMessages.license.localized)
        } else if (request.licenseExpDate!.isBlank) {
            Proxy.shared.displayStatusAlert(AlertMessages.licenseExp.localized)
        } else if (request.vehicleNo!.isBlank)  {
            Proxy.shared.displayStatusAlert(AlertMessages.vehicleNo.localized)
        } else if request.numberPlate!.count == 0 {
            Proxy.shared.displayStatusAlert(AlertMessages.vehicleImg.localized)
        } else if request.roadTax!.count == 0 {
            Proxy.shared.displayStatusAlert(AlertMessages.roadTax.localized)
        } else if request.idCard!.count == 0  {
            Proxy.shared.displayStatusAlert(AlertMessages.idCard.localized)
        } else if (request.insuranceExpDate!.isBlank) {
            Proxy.shared.displayStatusAlert(AlertMessages.insuranceExp.localized)
        } else if request.insurance!.count == 0 {
            Proxy.shared.displayStatusAlert(AlertMessages.insuranceImg.localized)
        } else if request.term == false {
            Proxy.shared.displayStatusAlert(AlertMessages.termsCondition.localized)
        } else {
            return true
        }
        return false
    }
}

extension SignUpVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var value = Int()
        switch collectionView {
        case colVwLicense:
            value = objSignUpVM.arrLicense.count+1
        case colVwNumberPlate:
            value = objSignUpVM.arrNumberPlate.count+1
        case colVwRoadTax:
            value = objSignUpVM.arrRoadTax.count+1
        case colVwIdCard:
            value = objSignUpVM.arrIdProof.count+1
        case colVwInsurance:
            value = objSignUpVM.arrInsurance.count+1
        default:
            break
        }
        return value
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let licenseCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LicenseCVC", for: indexPath) as! LicenseCVC
        switch collectionView {
        case colVwLicense:
            licenseCell.imgVwLicense.image = indexPath.row == 0 ? UIImage(named: "ic_add_image"): objSignUpVM.arrLicense[indexPath.row-1] as? UIImage
            licenseCell.btnCross.isHidden = indexPath.row == 0
            licenseCell.btnCross.tag = indexPath.row
            licenseCell.btnCross.addTarget(self, action: #selector(actionRemoveLicense(_ :)), for: .touchUpInside)
        case colVwNumberPlate:
            licenseCell.imgVwLicense.image = indexPath.row == 0 ? UIImage(named: "ic_add_image") : objSignUpVM.arrNumberPlate[indexPath.row-1] as? UIImage
            licenseCell.btnCross.isHidden = indexPath.row == 0
            licenseCell.btnCross.tag = indexPath.row
            licenseCell.btnCross.addTarget(self, action: #selector(actionRemoveNoPlate(_ :)), for: .touchUpInside)
        case colVwRoadTax:
            licenseCell.imgVwLicense.image = indexPath.row == 0 ? UIImage(named: "ic_add_image") : objSignUpVM.arrRoadTax[indexPath.row-1] as? UIImage
            licenseCell.btnCross.isHidden = indexPath.row == 0
            licenseCell.btnCross.tag = indexPath.row
            licenseCell.btnCross.addTarget(self, action: #selector(actionRemoveToadTax(_ :)), for: .touchUpInside)
        case colVwIdCard:
            licenseCell.imgVwLicense.image = indexPath.row == 0 ? UIImage(named: "ic_add_image") : objSignUpVM.arrIdProof[indexPath.row-1] as? UIImage
            licenseCell.btnCross.isHidden = indexPath.row == 0
            licenseCell.btnCross.tag = indexPath.row
            licenseCell.btnCross.addTarget(self, action: #selector(actionRemoveIdCard(_ :)), for: .touchUpInside)
        case colVwInsurance:
            licenseCell.imgVwLicense.image = indexPath.row == 0 ? UIImage(named: "ic_add_image") : objSignUpVM.arrInsurance[indexPath.row-1] as? UIImage
            licenseCell.btnCross.isHidden = indexPath.row == 0
            licenseCell.btnCross.tag = indexPath.row
            licenseCell.btnCross.addTarget(self, action: #selector(actionInsurance(_ :)), for: .touchUpInside)
        default:
            break
        }
        return licenseCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case colVwLicense:
            objSignUpVM.objGalleryFunctions.customActionSheet(false)
            objSignUpVM.selectedType = TitleValue.license
        case colVwIdCard:
            objSignUpVM.objGalleryFunctions.customActionSheet(false)
            objSignUpVM.selectedType = TitleValue.idCard
        case colVwNumberPlate:
            objSignUpVM.objGalleryFunctions.customActionSheet(false)
            objSignUpVM.selectedType = TitleValue.noPlate
        case colVwRoadTax:
            objSignUpVM.objGalleryFunctions.customActionSheet(false)
            objSignUpVM.selectedType = TitleValue.roadTax
        case colVwInsurance:
            objSignUpVM.objGalleryFunctions.customActionSheet(false)
            objSignUpVM.selectedType = TitleValue.insurance
        default:
            break
        }
    }
    
    @objc func actionRemoveLicense(_ sender: UIButton) {
        objSignUpVM.arrLicense.removeObject(at: sender.tag-1)
        colVwLicense.reloadData()
    }
    @objc func actionRemoveNoPlate(_ sender: UIButton) {
        objSignUpVM.arrNumberPlate.removeObject(at: sender.tag-1)
        colVwNumberPlate.reloadData()
    }
    @objc func actionRemoveToadTax(_ sender: UIButton) {
        objSignUpVM.arrRoadTax.removeObject(at: sender.tag-1)
        colVwRoadTax.reloadData()
    }
    @objc func actionRemoveIdCard(_ sender: UIButton) {
        objSignUpVM.arrIdProof.removeObject(at: sender.tag-1)
        colVwIdCard.reloadData()
    }
    @objc func actionInsurance(_ sender: UIButton) {
        objSignUpVM.arrInsurance.removeObject(at: sender.tag-1)
        colVwInsurance.reloadData()
    }
}

extension SignUpVC: PassImageDelegate {
    func passSelectedImgCrop(selectImage: UIImage) {
        tocrop(getImage: selectImage)
    }
}

extension SignUpVC: PKCCropDelegate{
    
    func tocrop(getImage: UIImage!){
        PKCCropHelper.shared.degressBeforeImage = UIImage(named: "rotate_left")
        PKCCropHelper.shared.degressAfterImage = UIImage(named: "rotate_right")
        PKCCropHelper.shared.isNavigationBarShow = false
        let cropVC = PKCCrop().cropViewController(getImage)
        cropVC.delegate = self
        cropVC.modalPresentationStyle = .fullScreen
        self.present(cropVC, animated: true, completion: nil)
    }
    func pkcCropImage(_ image: UIImage?, originalImage: UIImage?) {
        switch objSignUpVM.selectedType {
        case TitleValue.profile:
            objSignUpVM.image = image!
            imgVwUser.image = objSignUpVM.image
        case TitleValue.idCard:
            objSignUpVM.arrIdProof.add(image!)
            colVwIdCard.reloadData()
        case TitleValue.roadTax:
            objSignUpVM.arrRoadTax.add(image!)
            colVwRoadTax.reloadData()
        case TitleValue.noPlate:
            objSignUpVM.arrNumberPlate.add(image!)
            colVwNumberPlate.reloadData()
        case TitleValue.license:
            objSignUpVM.arrLicense.add(image!)
            colVwLicense.reloadData()
        case TitleValue.insurance:
            objSignUpVM.arrInsurance.add(image!)
            colVwInsurance.reloadData()
        default:
            break
        }
    }
    func pkcCropCancel(_ viewController: PKCCropViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    func pkcCropComplete(_ viewController: PKCCropViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
            
        case txtFldSelectType:
            let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "SelectVehicleTypePopupVC") as! SelectVehicleTypePopupVC
            controller.objSelectVehicleTypePopupVM.complition = {
                (id,title) in
                self.objSignUpVM.serviceId = "\(id)"
                self.txtFldSelectType.text = title
                self.objSignUpVM.catId = ""
                self.txtFldSelectCat.text = ""
            }
            controller.objSelectVehicleTypePopupVM.isApiHit = TitleValue.vehicleTypeList
            self.present(controller, animated: true, completion: nil)
            return false
            
        case txtFldVehicleBrand:
            
            let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "SelectVehicleTypePopupVC") as! SelectVehicleTypePopupVC
            controller.objSelectVehicleTypePopupVM.complition = {
                (id,title) in
                self.objSignUpVM.brandId = "\(id)"
                self.txtFldVehicleBrand.text = title
            }
            controller.objSelectVehicleTypePopupVM.isApiHit = TitleValue.vehicleBrand
            self.present(controller, animated: true, completion: nil)
            return false
            
        case txtFldVehicleColor:
            
            let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "SelectVehicleTypePopupVC") as! SelectVehicleTypePopupVC
            controller.objSelectVehicleTypePopupVM.complition = {
                (id,title) in
                self.objSignUpVM.colorId = "\(id)"
                self.txtFldVehicleColor.text = title
            }
            controller.objSelectVehicleTypePopupVM.isApiHit = TitleValue.vehicleColor
            self.present(controller, animated: true, completion: nil)
            return false
            
            
        case txtFldSelectCat:
            let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "SelectVehiclePopupVC") as! SelectVehiclePopupVC
            controller.objSelectVehiclePopupVM.objVehicleCategory = { (id,title) in
                self.objSignUpVM.catId = "\(id)"
                self.objSignUpVM.catTitle = title
                self.txtFldSelectCat.text = title
            }
            controller.title = self.objSignUpVM.serviceId
            self.present(controller, animated: true, completion: nil)
            return false
        case txtFldLicenseExpDate:
            let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
            controller.dateStr = txtFldLicenseExpDate.text ?? ""
            controller.objPassDate = { (date) in
                self.txtFldLicenseExpDate.text = date
            }
            self.present(controller, animated: true, completion: nil)
            return false
        case txtFldInsuranceExpDate:
            let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
            controller.dateStr = txtFldInsuranceExpDate.text ?? ""
            controller.objPassDate = { (date) in
                self.txtFldInsuranceExpDate.text = date
            }
            self.present(controller, animated: true, completion: nil)
            return false
        case txtFldSelectCountry:
            let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "SelectCountryPopUpVC") as! SelectCountryPopUpVC
            controller.objSelectCountryPopUpVM.objCountryData = { (name,currencyId,currency) in
                self.txtFldSelectCountry.text = "\(name) (\(currency))"
                self.objSignUpVM.currency = currencyId
            }
            self.present(controller, animated: true, completion: nil)
            return false
        default:
            break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case txtFldContact:
            let maxLength = 15
            let currentString: NSString = txtFldContact.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        default:
            break
        }
        return true
    }
}

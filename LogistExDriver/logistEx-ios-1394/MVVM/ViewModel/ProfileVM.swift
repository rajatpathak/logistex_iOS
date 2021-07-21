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
import SDWebImage
import Lightbox

class ProfileVM: NSObject {
    
    //MARK:- Variables
    var objGalleryFunctions = GalleryCameraImage()
    var arrLicense = NSMutableArray()
    var arrNumberPlate = NSMutableArray()
    var arrRoadTax = NSMutableArray()
    var arrIdProof = NSMutableArray()
    var arrInsurance = NSMutableArray()
    var selectedType = String()
    var catId = String()
    var image: UIImage?
    var currency = String()
    var languagePicker = UIPickerView()
    var arrLanguage = [TitleValue.english,TitleValue.spanish]
    var selectedLanguage = ChooseLanguage.english.rawValue
    var brandId = String()
    var colorId = String()
    var serviceId = String()
    
    //MARK:- Hit Update Profile Api
    func hitUpdateProfileApi(_ request: UpdateProfileRequest,completion:@escaping() -> Void) {
        if validData(request){
            
            let param = [
                "User[first_name]": request.firstName!,
                "User[last_name]": request.lastName!,
                "User[email]": request.email!,
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
            WebServiceProxy.shared.uploadImage(apiName: Apis.updateProfile, paramsDictionary: param, imageDictionary: paramImage, showIndicator: true) { (response) in
                if response.success {
                    if let detailDict = response.data?["detail"] as? NSDictionary {
                        objUserModel.saveData(detailDict)
                    }
                    completion()
                } else {
                    Proxy.shared.displayStatusAlert(response.message ?? "")
                }
            }
        }
    }
    
    //MARK:-  Check Data Validation
    func validData(_ request: UpdateProfileRequest) -> Bool {
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
        } else if (request.contact!.isBlank)  {
            Proxy.shared.displayStatusAlert(AlertMessages.mobileNumber.localized)
        } else if (request.category!.isBlank)  {
            Proxy.shared.displayStatusAlert(AlertMessages.vehicleCategory.localized)
        } else if (request.category!.isBlank)  {
            Proxy.shared.displayStatusAlert(AlertMessages.vehicleCategory.localized)
        } else if (request.brand!.isBlank)  {
            Proxy.shared.displayStatusAlert(AlertMessages.vehicleBrand.localized)
        } else if (request.currency!.isBlank) {
            Proxy.shared.displayStatusAlert(AlertMessages.selectCountry.localized)
        } else if request.license!.count == 0 && objUserModel.arrLicense.count == 0 {
            Proxy.shared.displayStatusAlert(AlertMessages.license.localized)
        } else if (request.licenseExpDate!.isBlank) {
            Proxy.shared.displayStatusAlert(AlertMessages.licenseExp.localized)
        } else if (request.vehicleNo!.isBlank)  {
            Proxy.shared.displayStatusAlert(AlertMessages.vehicleNo.localized)
        } else if request.numberPlate!.count == 0 && objUserModel.arrNumberPlate.count == 0 {
            Proxy.shared.displayStatusAlert(AlertMessages.vehicleImg.localized)
        } else if request.roadTax!.count == 0 && objUserModel.arrRoadTax.count == 0 {
            Proxy.shared.displayStatusAlert(AlertMessages.roadTax.localized)
        } else if request.idCard!.count == 0 && objUserModel.arrIdCard.count == 0 {
            Proxy.shared.displayStatusAlert(AlertMessages.idCard.localized)
        } else if (request.insuranceExpDate!.isBlank) {
            Proxy.shared.displayStatusAlert(AlertMessages.insuranceExp.localized)
        } else if request.insurance!.count == 0 && objUserModel.arrInsurance.count == 0 {
            Proxy.shared.displayStatusAlert(AlertMessages.insuranceImg.localized)
        } else {
            return true
        }
        return false
    }
    //MARK:- Hit Delete File Api
    func hitDeleteFile(_ id: String, completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.delete)?id=\(id)", showIndicator: true) { (response) in
            if response.success {
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
}
extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var value = Int()
        switch collectionView {
        case colVwLicense:
            var count = Int()
            count = btnEdit.isSelected ? objProfileVM.arrLicense.count+1 : objProfileVM.arrLicense.count
            value = objUserModel.arrLicense.count+count
        case colVwNumberPlate:
            var count = Int()
            count = btnEdit.isSelected ? objProfileVM.arrNumberPlate.count+1 : objProfileVM.arrNumberPlate.count
            value = objUserModel.arrNumberPlate.count+count
        case colVwRoadTax:
            var count = Int()
            count = btnEdit.isSelected ? objProfileVM.arrRoadTax.count+1 : objProfileVM.arrRoadTax.count
            value = objUserModel.arrRoadTax.count+count
        case colVwIdCard:
            var count = Int()
            count = btnEdit.isSelected ? objProfileVM.arrIdProof.count+1 : objProfileVM.arrIdProof.count
            value = objUserModel.arrIdCard.count+count
        case colVwInsurance:
            var count = Int()
            count = btnEdit.isSelected ? objProfileVM.arrInsurance.count+1 : objProfileVM.arrInsurance.count
            value = objUserModel.arrInsurance.count+count
        default:
            break
        }
        return value
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let licenseCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LicenseCVC", for: indexPath) as! LicenseCVC
        switch collectionView {
        case colVwLicense:
            if indexPath.row == 0 && btnEdit.isSelected {
                licenseCell.imgVwLicense.image =  UIImage(named: "ic_add_image")
            } else {
                var arrCount = Int()
                arrCount = btnEdit.isSelected ? objUserModel.arrLicense.count+1 :objUserModel.arrLicense.count
                if indexPath.row < arrCount {
                    licenseCell.imgVwLicense.sd_setImage(with: URL(string: objUserModel.arrLicense[btnEdit.isSelected ? indexPath.row - 1 : indexPath.row] as! String), placeholderImage: #imageLiteral(resourceName: "ic_default_user"))
                }else {
                    var arrLicenseCount = Int()
                    arrLicenseCount = btnEdit.isSelected ? objUserModel.arrLicense.count+1 : objUserModel.arrLicense.count
                    licenseCell.imgVwLicense.image = objProfileVM.arrLicense[indexPath.row - arrLicenseCount] as? UIImage
                }
            }
            licenseCell.btnCross.isHidden = !btnEdit.isSelected || btnEdit.isSelected && indexPath.row == 0
            licenseCell.btnCross.tag = indexPath.row
            licenseCell.btnCross.addTarget(self, action: #selector(actionRemoveLicense(_ :)), for: .touchUpInside)
        case colVwNumberPlate:
            if indexPath.row == 0 && btnEdit.isSelected {
                licenseCell.imgVwLicense.image =  UIImage(named: "ic_add_image")
            } else {
                var arrCount = Int()
                arrCount = btnEdit.isSelected ? objUserModel.arrNumberPlate.count+1 : objUserModel.arrNumberPlate.count
                if indexPath.row < arrCount {
                    licenseCell.imgVwLicense.sd_setImage(with: URL(string: objUserModel.arrNumberPlate[btnEdit.isSelected ? indexPath.row - 1 : indexPath.row] as! String), placeholderImage: #imageLiteral(resourceName: "ic_default_user"))
                }else {
                    var arrCount = Int()
                    arrCount = btnEdit.isSelected ? objUserModel.arrNumberPlate.count+1 : objUserModel.arrNumberPlate.count
                    licenseCell.imgVwLicense.image = objProfileVM.arrNumberPlate[indexPath.row - arrCount] as? UIImage
                }
            }
            licenseCell.btnCross.isHidden = !btnEdit.isSelected || btnEdit.isSelected && indexPath.row == 0
            licenseCell.btnCross.tag = indexPath.row
            licenseCell.btnCross.addTarget(self, action: #selector(actionRemoveNoPlate(_ :)), for: .touchUpInside)
        case colVwRoadTax:
            if indexPath.row == 0 && btnEdit.isSelected {
                licenseCell.imgVwLicense.image =  UIImage(named: "ic_add_image")
            } else {
                var arrCount = Int()
                arrCount = btnEdit.isSelected ? objUserModel.arrRoadTax.count+1 : objUserModel.arrRoadTax.count
                if indexPath.row < arrCount {
                    licenseCell.imgVwLicense.sd_setImage(with: URL(string: objUserModel.arrRoadTax[btnEdit.isSelected ? indexPath.row - 1 : indexPath.row] as! String), placeholderImage: #imageLiteral(resourceName: "ic_default_user"))
                }else {
                    var arrCount = Int()
                    arrCount = btnEdit.isSelected ? objUserModel.arrRoadTax.count+1 : objUserModel.arrRoadTax.count
                    licenseCell.imgVwLicense.image = objProfileVM.arrRoadTax[indexPath.row - arrCount] as? UIImage
                }
            }
            licenseCell.btnCross.isHidden = !btnEdit.isSelected || btnEdit.isSelected && indexPath.row == 0
            licenseCell.btnCross.tag = indexPath.row
            licenseCell.btnCross.addTarget(self, action: #selector(actionRemoveToadTax(_ :)), for: .touchUpInside)
        case colVwIdCard:
            if indexPath.row == 0 && btnEdit.isSelected {
                licenseCell.imgVwLicense.image =  UIImage(named: "ic_add_image")
            } else {
                var arrCount = Int()
                arrCount = btnEdit.isSelected ? objUserModel.arrIdCard.count+1 : objUserModel.arrIdCard.count
                if indexPath.row < arrCount {
                    licenseCell.imgVwLicense.sd_setImage(with: URL(string: objUserModel.arrIdCard[btnEdit.isSelected ? indexPath.row - 1 : indexPath.row] as! String), placeholderImage: #imageLiteral(resourceName: "ic_default_user"))
                }else {
                    var arrCount = Int()
                    arrCount = btnEdit.isSelected ? objUserModel.arrIdCard.count+1 : objUserModel.arrIdCard.count
                    licenseCell.imgVwLicense.image = objProfileVM.arrIdProof[indexPath.row - arrCount] as? UIImage
                }
            }
            licenseCell.btnCross.isHidden = !btnEdit.isSelected || btnEdit.isSelected && indexPath.row == 0
            licenseCell.btnCross.tag = indexPath.row
            licenseCell.btnCross.addTarget(self, action: #selector(actionRemoveIdCard(_ :)), for: .touchUpInside)
        case colVwInsurance:
            if indexPath.row == 0 && btnEdit.isSelected {
                licenseCell.imgVwLicense.image =  UIImage(named: "ic_add_image")
            } else {
                var arrCount = Int()
                arrCount = btnEdit.isSelected ? objUserModel.arrInsurance.count+1 : objUserModel.arrInsurance.count
                if indexPath.row < arrCount {
                    licenseCell.imgVwLicense.sd_setImage(with: URL(string: objUserModel.arrInsurance[btnEdit.isSelected ? indexPath.row - 1 : indexPath.row] as! String), placeholderImage: #imageLiteral(resourceName: "ic_default_user"))
                }else {
                    var arrCount = Int()
                    arrCount = btnEdit.isSelected ? objUserModel.arrInsurance.count+1 : objUserModel.arrInsurance.count
                    licenseCell.imgVwLicense.image = objProfileVM.arrInsurance[indexPath.row - arrCount] as? UIImage
                }
            }
            licenseCell.btnCross.isHidden = !btnEdit.isSelected || btnEdit.isSelected && indexPath.row == 0
            licenseCell.btnCross.tag = indexPath.row
            licenseCell.btnCross.addTarget(self, action: #selector(actionInsurance(_ :)), for: .touchUpInside)
        default:
            break
        }
        return licenseCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if btnEdit.isSelected {
            if indexPath.row == 0 {
                switch collectionView {
                case colVwLicense:
                    objProfileVM.objGalleryFunctions.customActionSheet(false)
                    objProfileVM.selectedType = TitleValue.license
                case colVwIdCard:
                    objProfileVM.objGalleryFunctions.customActionSheet(false)
                    objProfileVM.selectedType = TitleValue.idCard
                case colVwNumberPlate:
                    objProfileVM.objGalleryFunctions.customActionSheet(false)
                    objProfileVM.selectedType = TitleValue.noPlate
                case colVwRoadTax:
                    objProfileVM.objGalleryFunctions.customActionSheet(false)
                    objProfileVM.selectedType = TitleValue.roadTax
                case colVwInsurance:
                    objProfileVM.objGalleryFunctions.customActionSheet(false)
                    objProfileVM.selectedType = TitleValue.insurance
                default:
                    break
                }
            } else {
                let controller = LightboxController()
                switch collectionView {
                case colVwLicense:
                    if indexPath.row < objUserModel.arrLicense.count+1{
                        let images = [LightboxImage(imageURL: URL.init(string: objUserModel.arrLicense[indexPath.row-1] as! String)!)]
                        controller.images = images
                    }else {
                        let images = [LightboxImage(image: (objProfileVM.arrLicense[indexPath.row-objUserModel.arrLicense.count-1] as? UIImage)!)]
                        controller.images = images
                    }
                case colVwRoadTax:
                    if indexPath.row < objUserModel.arrRoadTax.count+1{
                        let images = [LightboxImage(imageURL: URL.init(string: objUserModel.arrRoadTax[indexPath.row-1] as! String)!)]
                        controller.images = images
                    }else {
                        let images = [LightboxImage(image: (objProfileVM.arrRoadTax[indexPath.row-objUserModel.arrRoadTax.count-1] as? UIImage)!)]
                        controller.images = images
                    }
                case colVwIdCard:
                    if indexPath.row < objUserModel.arrIdCard.count+1{
                        let images = [LightboxImage(imageURL: URL.init(string: objUserModel.arrIdCard[indexPath.row-1] as! String)!)]
                        controller.images = images
                    }else {
                        let images = [LightboxImage(image: (objProfileVM.arrIdProof[indexPath.row-objUserModel.arrIdCard.count-1] as? UIImage)!)]
                        controller.images = images
                    }
                case colVwNumberPlate:
                    if indexPath.row < objUserModel.arrNumberPlate.count+1{
                        let images = [LightboxImage(imageURL: URL.init(string: objUserModel.arrNumberPlate[indexPath.row-1] as! String)!)]
                        controller.images = images
                    }else {
                        let images = [LightboxImage(image: (objProfileVM.arrNumberPlate[indexPath.row-objUserModel.arrNumberPlate.count-1] as? UIImage)!)]
                        controller.images = images
                    }
                case colVwInsurance:
                    if indexPath.row < objUserModel.arrInsurance.count+1{
                        let images = [LightboxImage(imageURL: URL.init(string: objUserModel.arrInsurance[indexPath.row-1] as! String)!)]
                        controller.images = images
                    }else {
                        let images = [LightboxImage(image: (objProfileVM.arrInsurance[indexPath.row-objUserModel.arrInsurance.count-1] as? UIImage)!)]
                        controller.images = images
                    }
                default:
                    break
                }
                controller.pageDelegate = self
                controller.dismissalDelegate = self
                controller.dynamicBackground = true
                controller.modalPresentationStyle = .fullScreen
                self.navigationController?.present(controller, animated: true, completion: nil)
            }
        }else {
            let controller = LightboxController()
            switch collectionView {
            case colVwLicense:
                if indexPath.row < objUserModel.arrLicense.count{
                    let images = [LightboxImage(imageURL: URL.init(string: objUserModel.arrLicense[indexPath.row] as! String)!)]
                    controller.images = images
                }else {
                    let images = [LightboxImage(image: (objProfileVM.arrLicense[indexPath.row-objUserModel.arrLicense.count] as? UIImage)!)]
                    controller.images = images
                }
            case colVwRoadTax:
                if indexPath.row < objUserModel.arrRoadTax.count{
                    let images = [LightboxImage(imageURL: URL.init(string: objUserModel.arrRoadTax[indexPath.row] as! String)!)]
                    controller.images = images
                }else {
                    let images = [LightboxImage(image: (objProfileVM.arrRoadTax[indexPath.row-objUserModel.arrRoadTax.count] as? UIImage)!)]
                    controller.images = images
                }
            case colVwIdCard:
                if indexPath.row < objUserModel.arrIdCard.count{
                    let images = [LightboxImage(imageURL: URL.init(string: objUserModel.arrIdCard[indexPath.row] as! String)!)]
                    controller.images = images
                }else {
                    let images = [LightboxImage(image: (objProfileVM.arrIdProof[indexPath.row-objUserModel.arrIdCard.count] as? UIImage)!)]
                    controller.images = images
                }
            case colVwNumberPlate:
                if indexPath.row < objUserModel.arrNumberPlate.count{
                    let images = [LightboxImage(imageURL: URL.init(string: objUserModel.arrNumberPlate[indexPath.row] as! String)!)]
                    controller.images = images
                }else {
                    let images = [LightboxImage(image: (objProfileVM.arrNumberPlate[indexPath.row-objUserModel.arrNumberPlate.count] as? UIImage)!)]
                    controller.images = images
                }
            case colVwInsurance:
                if indexPath.row < objUserModel.arrInsurance.count{
                    let images = [LightboxImage(imageURL: URL.init(string: objUserModel.arrInsurance[indexPath.row] as! String)!)]
                    controller.images = images
                }else {
                    let images = [LightboxImage(image: (objProfileVM.arrInsurance[indexPath.row-objUserModel.arrInsurance.count] as? UIImage)!)]
                    controller.images = images
                }
            default:
                break
            }
            controller.pageDelegate = self
            controller.dismissalDelegate = self
            controller.dynamicBackground = true
            controller.modalPresentationStyle = .fullScreen
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
    }
}

extension ProfileVC: PassImageDelegate {
    func passSelectedImgCrop(selectImage: UIImage) {
        tocrop(getImage: selectImage)
    }
}

extension ProfileVC: PKCCropDelegate{
    
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
        switch objProfileVM.selectedType {
        case TitleValue.profile:
            objProfileVM.image = image!
            imgVwUser.image = objProfileVM.image
        case TitleValue.idCard:
            objProfileVM.arrIdProof.add(image!)
            colVwIdCard.reloadData()
        case TitleValue.roadTax:
            objProfileVM.arrRoadTax.add(image!)
            colVwRoadTax.reloadData()
        case TitleValue.noPlate:
            objProfileVM.arrNumberPlate.add(image!)
            colVwNumberPlate.reloadData()
        case TitleValue.license:
            objProfileVM.arrLicense.add(image!)
            colVwLicense.reloadData()
        case TitleValue.insurance:
            objProfileVM.arrInsurance.add(image!)
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

extension ProfileVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
            
        case txtFldServiceType:
            
            let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "SelectVehicleTypePopupVC") as! SelectVehicleTypePopupVC
            controller.objSelectVehicleTypePopupVM.complition = {
                (id,title) in
                self.objProfileVM.serviceId = "\(id)"
                self.txtFldServiceType.text = title
                self.objProfileVM.catId = ""
                self.txtFldVehicleCat.text = ""
            }
            controller.objSelectVehicleTypePopupVM.isApiHit = TitleValue.vehicleTypeList
            self.present(controller, animated: true, completion: nil)
            return false
            
        case txtFldVehicleBrand:
            
            let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "SelectVehicleTypePopupVC") as! SelectVehicleTypePopupVC
            controller.objSelectVehicleTypePopupVM.complition = {
                (id,title) in
                self.objProfileVM.brandId = "\(id)"
                self.txtFldVehicleBrand.text = title
            }
            controller.objSelectVehicleTypePopupVM.isApiHit = TitleValue.vehicleBrand
            self.present(controller, animated: true, completion: nil)
            return false
            
        case txtFldVehicleColor:
            
            let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "SelectVehicleTypePopupVC") as! SelectVehicleTypePopupVC
            controller.objSelectVehicleTypePopupVM.complition = {
                (id,title) in
                self.objProfileVM.colorId = "\(id)"
                self.txtFldVehicleColor.text = title
            }
            controller.objSelectVehicleTypePopupVM.isApiHit = TitleValue.vehicleColor
            self.present(controller, animated: true, completion: nil)
            return false
            
        case txtFldVehicleCat:
            let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "SelectVehiclePopupVC") as! SelectVehiclePopupVC
            controller.objSelectVehiclePopupVM.objVehicleCategory = { (id,title) in
                self.objProfileVM.catId = "\(id)"
                self.txtFldVehicleCat.text = title
            }
            controller.title = self.objProfileVM.serviceId
            self.present(controller, animated: true, completion: nil)
            return false
            
            
        case txtFldChangePassword:
            push(identifier: "ChangePasswordVC")
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
            if objUserModel.objAccepRequestModel.bookingId != "" {
                Proxy.shared.displayStatusAlert(AlertMessages.cantChangeCountry.localized)
            } else {
                let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "SelectCountryPopUpVC") as! SelectCountryPopUpVC
                controller.objSelectCountryPopUpVM.objCountryData = { (name,currencyId,currencyName) in
                    self.txtFldSelectCountry.text = "\(name) (\(currencyName))"
                    self.objProfileVM.currency = currencyId
                }
                self.present(controller, animated: true, completion: nil)
            }
            return false
        case txtFldAddBankDetail:
            push(identifier: "AddBankDetailVC")
            return false
        case txtFldChangeLanguage:
            pickUp(txtFldChangeLanguage)
        default:
            break
        }
        return true
    }
}
extension ProfileVC: LightboxControllerPageDelegate, LightboxControllerDismissalDelegate  {
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        debugPrint(page)
    }
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
    }
}

extension ProfileVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return objProfileVM.arrLanguage.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return objProfileVM.arrLanguage[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtFldChangeLanguage.text = objProfileVM.arrLanguage[row]
        switch row {
        case 0:
            objProfileVM.selectedLanguage = ChooseLanguage.english.rawValue
        case 1:
            objProfileVM.selectedLanguage = ChooseLanguage.spanish.rawValue
        default:
            break
        }
    }
    @objc func actionRemoveLicense(_ sender: UIButton) {
        if sender.tag < objUserModel.arrLicense.count+1 {
            objProfileVM.hitDeleteFile("\(objUserModel.arrLicenseID[sender.tag-1] as? Int ?? 0)") {
                objUserModel.arrLicense.removeObject(at: sender.tag-1)
                objUserModel.arrLicenseID.removeObject(at: sender.tag-1)
                self.colVwLicense.reloadData()
            }
        } else {
            objProfileVM.arrLicense.removeObject(at: sender.tag-(objUserModel.arrLicense.count+1))
            colVwLicense.reloadData()
        }
    }
    @objc func actionRemoveNoPlate(_ sender: UIButton) {
        if sender.tag < objUserModel.arrNumberPlate.count+1 {
            objProfileVM.hitDeleteFile("\(objUserModel.arrNumberPlateID[sender.tag-1] as? Int ?? 0)") {
                objUserModel.arrNumberPlate.removeObject(at: sender.tag-1)
                objUserModel.arrNumberPlateID.removeObject(at: sender.tag-1)
                self.colVwNumberPlate.reloadData()
            }
        } else {
            objProfileVM.arrNumberPlate.removeObject(at: sender.tag-(objUserModel.arrNumberPlate.count+1))
            colVwNumberPlate.reloadData()
        }
    }
    @objc func actionRemoveToadTax(_ sender: UIButton) {
        if sender.tag < objUserModel.arrRoadTax.count+1 {
            objProfileVM.hitDeleteFile("\(objUserModel.arrRoadTaxID[sender.tag-1] as? Int ?? 0)") {
                objUserModel.arrRoadTax.removeObject(at: sender.tag-1)
                objUserModel.arrRoadTaxID.removeObject(at: sender.tag-1)
                self.colVwRoadTax.reloadData()
            }
        } else {
            objProfileVM.arrRoadTax.removeObject(at: sender.tag-(objUserModel.arrRoadTax.count+1))
            colVwRoadTax.reloadData()
        }
    }
    @objc func actionRemoveIdCard(_ sender: UIButton) {
        if sender.tag < objUserModel.arrIdCard.count+1 {
            objProfileVM.hitDeleteFile("\(objUserModel.arrIdCardID[sender.tag-1] as? Int ?? 0)") {
                objUserModel.arrIdCard.removeObject(at: sender.tag-1)
                objUserModel.arrIdCardID.removeObject(at: sender.tag-1)
                self.colVwIdCard.reloadData()
            }
        } else {
            objProfileVM.arrIdProof.removeObject(at: sender.tag-(objUserModel.arrIdCard.count+1))
            colVwIdCard.reloadData()
        }
    }
    @objc func actionInsurance(_ sender: UIButton) {
        if sender.tag < objUserModel.arrInsurance.count+1 {
            objProfileVM.hitDeleteFile("\(objUserModel.arrInsuranceID[sender.tag-1] as? Int ?? 0)") {
                objUserModel.arrInsurance.removeObject(at: sender.tag-1)
                objUserModel.arrInsuranceID.removeObject(at: sender.tag-1)
                self.colVwInsurance.reloadData()
            }
        } else {
            objProfileVM.arrInsurance.removeObject(at: sender.tag-(objUserModel.arrInsurance.count+1))
            colVwInsurance.reloadData()
        }
    }
}

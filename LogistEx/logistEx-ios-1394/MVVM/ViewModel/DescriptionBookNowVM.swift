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

class DescriptionBookNowVM: NSObject {
    //MARK:- Variables
    var arrSelectedImage = [UIImage]()
    var objGalleryCameraImage = GalleryCameraImage()
    var vwPickerDateTime = UIDatePicker()
    var selectedDate = String()
    var selectedTime = String()
    var currency = String()
    var currencySymbol = String()
    var currencyTitle = String()
    var isNagotiable = Int()
    private var SelectedPicker = PickerType.selectDate
    
    private enum PickerType {
        case selectDate
        case selectTime
    }
}

extension DescriptionBookNowVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objDescriptionBookNowVM.arrSelectedImage.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionBookNowCVC", for: indexPath) as! DescriptionBookNowCVC
        
        if indexPath.row == 0 {
            cell.btnDelete.isHidden = true
            cell.imgVwPhotos.image = #imageLiteral(resourceName: "ic_add_image")
        } else {
            cell.imgVwPhotos.image = objDescriptionBookNowVM.arrSelectedImage[indexPath.row-1]
            cell.btnDelete.isHidden = false
            cell.btnDelete.tag = indexPath.row - 1
            cell.btnDelete.addTarget(self, action: #selector(removePhoto(_ :)), for: .touchUpInside)
            
        }   
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            objPassImageDelegate = self
            if objDescriptionBookNowVM.arrSelectedImage.count < 5 {
                objDescriptionBookNowVM.objGalleryCameraImage.customActionSheet(removeProfile: false, controller: self)
            } else {
                Proxy.shared.displayStatusAlert(message: AlertMessages.maxPhotoSelected.localized, state: .warning)
            }
        } else {
            let dict = objDescriptionBookNowVM.arrSelectedImage[indexPath.row-1]
            let images = [LightboxImage(image: dict)]
            let controller = LightboxController(images: images)
            controller.pageDelegate = self
            controller.dismissalDelegate = self
            controller.dynamicBackground = true
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func removePhoto(_ sender:UIButton){
        objDescriptionBookNowVM.arrSelectedImage.remove(at: sender.tag)
        clcVwSelectedImages.reloadData()
    }
}


extension DescriptionBookNowVC : PassImageDelegate {
    
    func getSelectedImage(selectImage: UIImage) {
        objDescriptionBookNowVM.arrSelectedImage.append(selectImage)
        clcVwSelectedImages.reloadData()
    }
}
extension DescriptionBookNowVC  {
    //MARK:- SetData Function
    func setData(){
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        txtFldSelectDate.inputView = objDescriptionBookNowVM.vwPickerDateTime
        txtFldSelectTime.inputView = objDescriptionBookNowVM.vwPickerDateTime
        txtVwDescprition.placeholder =  PassTitles.typeHere.localized
        txtFldSelectDate.isHidden = KAppDelegate.bookPostDict.dictValue["Booking[type_id]"]! == "\(BookingType.bookNow.rawValue)"
        txtFldSelectTime.isHidden = KAppDelegate.bookPostDict.dictValue["Booking[type_id]"]! == "\(BookingType.bookNow.rawValue)"
       
        let serviceTypeTitle = KAppDelegate.bookPostDict.dictValue["Booking[service_type_title]"]
        if serviceTypeTitle == "Transport" || serviceTypeTitle == "Transporte" {
            vwAddImages.isHidden = false
            vwAddImgesHghtCnst.constant = 170
        } else {
            vwAddImages.isHidden = KAppDelegate.bookPostDict.dictValue["Booking[type_id]"]! == "\(BookingType.bookNow.rawValue)"
            vwAddImgesHghtCnst.constant = KAppDelegate.bookPostDict.dictValue["Booking[type_id]"]! == "\(BookingType.bookNow.rawValue)" ? 0 : 170
        }
        objDescriptionBookNowVM.isNagotiable = 0
        objDescriptionBookNowVM.vwPickerDateTime.addTarget(self, action: #selector(selectDateTime(_ :)), for: .valueChanged )
        if lang == ChooseLanguage.spanish.rawValue {
            self.btnNagotiable.setTitle(PassTitles.negotiableSpa, for: .normal)
            lblWillingPay.text = PassTitles.willingPaySpa
        } else {
            self.btnNagotiable.setTitle(PassTitles.negotiable, for: .normal)
            lblWillingPay.text = PassTitles.willingPay
        }
        txtFldCurrency.text = "\(objUserModel.currency) \(objUserModel.currencySymbol)"
        objDescriptionBookNowVM.currency = objUserModel.currencyId
        objDescriptionBookNowVM.currencySymbol = objUserModel.currencySymbol
        objDescriptionBookNowVM.currencyTitle = objUserModel.currency
        KAppDelegate.bookPostDict.dictValue.updateValue(objDescriptionBookNowVM.currency, forKey: "Booking[currency]")
        KAppDelegate.bookPostDict.dictValue.updateValue(self.objDescriptionBookNowVM.currencyTitle, forKey: "Booking[currency_title]")
        KAppDelegate.bookPostDict.dictValue.updateValue(self.objDescriptionBookNowVM.currencySymbol, forKey: "Booking[currency_symbol]")
    }
}
extension DescriptionBookNowVC: LightboxControllerPageDelegate, LightboxControllerDismissalDelegate  {
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        debugPrint(page)
    }
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
    }
}
extension DescriptionBookNowVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        objDescriptionBookNowVM.vwPickerDateTime.reloadInputViews()
        
        if textField == txtFldSelectDate {
            objDescriptionBookNowVM.vwPickerDateTime.datePickerMode = .date
            objDescriptionBookNowVM.vwPickerDateTime.minimumDate = NSCalendar.current.date(byAdding: .day, value: 0, to: Date())
            txtFldSelectDate.isSelected = true
            txtFldSelectTime.isSelected = false
        } else if textField == txtFldSelectTime {
            objDescriptionBookNowVM.vwPickerDateTime.datePickerMode = .time
            txtFldSelectTime.isSelected = true
            txtFldSelectDate.isSelected = false
        } else if textField == txtFldCurrency {
            let controller = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: "SelectCountryPopUpVC") as! SelectCountryPopUpVC
            controller.objSelectCountryPopUpVM.objCountryData = { (currencyName,currencySymbol,currencyId) in
                self.txtFldCurrency.text = "\(currencyName) \(currencySymbol)"
                self.objDescriptionBookNowVM.currencyTitle = currencyName
                self.objDescriptionBookNowVM.currency = currencyId
                self.objDescriptionBookNowVM.currencySymbol = currencySymbol
                
                KAppDelegate.bookPostDict.dictValue.updateValue(self.objDescriptionBookNowVM.currency, forKey: "Booking[currency]")
                
                KAppDelegate.bookPostDict.dictValue.updateValue(self.objDescriptionBookNowVM.currencyTitle, forKey: "Booking[currency_title]")
                
                KAppDelegate.bookPostDict.dictValue.updateValue(self.objDescriptionBookNowVM.currencySymbol, forKey: "Booking[currency_symbol]")
                
            }
            self.present(controller, animated: true, completion: nil)
            return false
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFldPrice  {
            if range.location >= 6  {
                return false
            }
        }
        return true
    }
}


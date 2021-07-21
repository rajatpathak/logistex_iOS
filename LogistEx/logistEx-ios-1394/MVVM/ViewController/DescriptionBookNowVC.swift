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
import IQKeyboardManagerSwift

class DescriptionBookNowVC: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var txtVwDescprition: IQTextView!
    @IBOutlet weak var btnFavouriteDriver: UIButton!
    @IBOutlet weak var clcVwSelectedImages: UICollectionView!
    @IBOutlet weak var txtFldSelectDate: UITextField!
    @IBOutlet weak var txtFldSelectTime: UITextField!
    @IBOutlet weak var vwAddImages: UIView!
    @IBOutlet weak var vwAddImgesHghtCnst: NSLayoutConstraint!
    @IBOutlet weak var txtFldCurrency: UITextField!
    @IBOutlet weak var txtFldPrice: UITextField!
    @IBOutlet weak var btnNagotiable: UIButton!
    @IBOutlet weak var lblWillingPay: UILabel!
    
    
    //MARK:- Varibale Declaration
    let objDescriptionBookNowVM = DescriptionBookNowVM()
    
    //MARK:- View Lifr Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clcVwSelectedImages.reloadData()
        objPassImageDelegate = self
    }
    
    @objc func selectDateTime(_ sender:UIDatePicker){
        if txtFldSelectDate.isSelected {
            txtFldSelectDate.text = sender.date.dateToString(format:"dd MMM yyyy")
            objDescriptionBookNowVM.selectedDate = sender.date.dateToString(format:"yyyy-MM-dd")
        } else if txtFldSelectTime.isSelected  {
            txtFldSelectTime.text = sender.date.dateToString(format:"HH:mm a")
            objDescriptionBookNowVM.selectedTime = sender.date.dateToString(format:"HH:mm:ss")
        }
    }
    
    //MARK:- IBACTIONS
    @IBAction func actionProceed(_ sender: UIButton) {
        if txtVwDescprition.text.isBlank {
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterDescprition.localized, state: .warning)
        } else  if txtFldCurrency.text!.isBlank{
            Proxy.shared.displayStatusAlert(message: AlertMessages.chooseCurrency.localized, state: .warning)
        } else if txtFldPrice.text!.isBlank{
            Proxy.shared.displayStatusAlert(message: AlertTitle.pleaseEnterAmount.localized, state: .warning)
        } else {
            KAppDelegate.bookPostDict.arrSelectedImage = objDescriptionBookNowVM.arrSelectedImage
            if KAppDelegate.bookPostDict.dictValue["Booking[type_id]"]! == "\(BookingType.bookNow.rawValue)" {
                KAppDelegate.bookPostDict.dictValue.updateValue("", forKey: "Booking[pickup_date]")
            } else if KAppDelegate.bookPostDict.dictValue["Booking[type_id]"]! == "\(BookingType.schedule.rawValue)" {
                if txtFldSelectDate.text!.isBlank {
                    Proxy.shared.displayStatusAlert(message: AlertMessages.selectDate.localized, state: .warning)
                    return
                } else  if txtFldSelectTime.text!.isBlank {
                    Proxy.shared.displayStatusAlert(message: AlertMessages.selectTime.localized, state: .warning)
                    return
                } else {
                    KAppDelegate.bookPostDict.dictValue.updateValue("\(objDescriptionBookNowVM.selectedDate) \(objDescriptionBookNowVM.selectedTime)", forKey: "Booking[pickup_date]")
                }
            }
            
            KAppDelegate.bookPostDict.dictValue.updateValue(btnFavouriteDriver.isSelected ? "\(IsFavouriteDriver.isFav.rawValue)" : "\(IsFavouriteDriver.notFav.rawValue)", forKey: "Booking[is_favorite]")
            KAppDelegate.bookPostDict.dictValue.updateValue(txtVwDescprition.text ?? "", forKey: "Booking[description]")
            KAppDelegate.bookPostDict.dictValue.updateValue("\(objDescriptionBookNowVM.isNagotiable)", forKey: "Booking[nagotiable]")
            let trimmedString = txtFldPrice.text!.trimmingCharacters(in: .whitespaces)
            KAppDelegate.bookPostDict.dictValue.updateValue(trimmedString, forKey: "Booking[amount]")
            objPassDataDelegate?.push(moveTo: "")
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func actionNagotiable(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        objDescriptionBookNowVM.isNagotiable = sender.isSelected ? AmountNagotiable.yes.rawValue : AmountNagotiable.no.rawValue
        
    }
    @IBAction func actionFavourite(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func actionDismiss(_ sender: UIButton) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
}


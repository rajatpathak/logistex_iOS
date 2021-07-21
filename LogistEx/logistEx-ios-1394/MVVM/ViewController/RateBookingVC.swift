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

class RateBookingVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblDeliveryDate: UILabel!
    @IBOutlet weak var btnDriverFav: UIButton!
    @IBOutlet weak var btnDriverBanned: UIButton!
    @IBOutlet weak var vwRateServices: FloatRatingView!
    @IBOutlet weak var vwRateQuality: FloatRatingView!
    @IBOutlet weak var vwRateDelivery: FloatRatingView!
    @IBOutlet weak var txtVwMessage: IQTextView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnMarkFavourite: UIButton!
    @IBOutlet weak var btnMarkBanned: UIButton!
    
    
    //MARK:- Variable declarations
    let objRateBookingVM = RateBookingVM()
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        showDetails()
    }
    
    func showDetails () {
        DispatchQueue.main.async {
            self.txtVwMessage.placeholder =  PassTitles.typeYourMessage.localized
            self.lblOrderNumber.text = String(self.objRateBookingVM.objBookingModel.id)
            let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
            if lang == ChooseLanguage.english.rawValue {
                self.lblDeliveryDate.text = self.objRateBookingVM.objBookingModel.deliveryTime.changeDateFormatOfStrDate(currentFormat: "yyyy-MM-dd HH:mm:ss", willingFormat: "MM-dd-yyyy, HH:mm:ss")
            } else {
                self.lblDeliveryDate.text = self.objRateBookingVM.objBookingModel.deliveryTime.changeDateFormatOfStrDate(currentFormat: "yyyy-MM-dd HH:mm:ss", willingFormat: "dd-MM-yyyy HH:mm:ss")
            }
            
            switch self.objRateBookingVM.objBookingModel.driverCurrentState {
            case .notSet, .none :
                self.btnDriverFav.isSelected = false
                self.btnDriverBanned.isSelected = false
            case .favourite:
                self.btnDriverFav.isSelected = true
                self.btnDriverBanned.isSelected = false
            case .banned:
                self.btnDriverBanned.isSelected = true
                self.btnDriverFav.isSelected = false
            }
            
            if self.objRateBookingVM.objBookingModel.isRated {
                self.vwRateServices.rating = Float(self.objRateBookingVM.objBookingModel.serviceRating)
                self.vwRateQuality.rating = Float(self.objRateBookingVM.objBookingModel.qualityRating)
                self.vwRateDelivery.rating = Float(self.objRateBookingVM.objBookingModel.deliveryRating)
                self.txtVwMessage.text = self.objRateBookingVM.objBookingModel.ratingComment
                self.txtVwMessage.isUserInteractionEnabled = false
                self.vwRateDelivery.isUserInteractionEnabled = false
                self.vwRateQuality.isUserInteractionEnabled = false
                self.vwRateServices.isUserInteractionEnabled = false
                self.btnMarkBanned.isUserInteractionEnabled = false
                self.btnMarkFavourite.isUserInteractionEnabled = false
                self.btnSubmit.isUserInteractionEnabled = false
            } else {
                self.txtVwMessage.isUserInteractionEnabled = true
                self.vwRateDelivery.isUserInteractionEnabled = true
                self.vwRateQuality.isUserInteractionEnabled = true
                self.vwRateServices.isUserInteractionEnabled = true
                self.btnMarkBanned.isUserInteractionEnabled = true
                self.btnMarkFavourite.isUserInteractionEnabled = true
                self.btnSubmit.isUserInteractionEnabled = true
            }
        }
    }
    
    //MARK:- Button Actions
    @IBAction func actionBack(_ sender: UIButton) {
        self.title == PassTitles.fromTrack ? rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC) : popToBack()
    }
    
    @IBAction func actionSubmit(_ sender: UIButton) {
        
        if vwRateServices.rating == 0 || vwRateQuality.rating == 0 || vwRateDelivery.rating == 0 {
            Proxy.shared.displayStatusAlert(message: AlertMessages.pleaseAddRating.localized, state: .error)
        } else {
            let param = [ "service_rating":"\(vwRateServices.rating)",
                "quality_rating":"\(vwRateQuality.rating)",
                "delivery_rating":"\(vwRateDelivery.rating)",
                "comment":txtVwMessage.text!  ]
            let postDict = NSMutableDictionary()
            postDict.setValue(param, forKey: "Rating")
            
            objRateBookingVM.addDriverRating(postParam: postDict as! Dictionary<String, AnyObject>){
                self.rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC)
            }
        }
    }
    
    @IBAction func actionDriverFav(_ sender: UIButton) {
        if btnDriverBanned.isSelected {
            Proxy.shared.displayStatusAlert(message: AlertMessages.unbannedToFavouriteDriver.localized, state: .error)
        } else {
            objRateBookingVM.togglFavBanDriver(requestType: sender.isSelected ? .notSet : .favourite) {
                sender.isSelected = !sender.isSelected
            }
        }
    }
    
    @IBAction func actionDriverBan(_ sender: UIButton) {
        if btnDriverFav.isSelected {
            Proxy.shared.displayStatusAlert(message: AlertMessages.unfavouriteTobanDriver.localized, state: .error)
        } else {
            objRateBookingVM.togglFavBanDriver(requestType: sender.isSelected ? .notSet : .banned) {
                sender.isSelected = !sender.isSelected
            }
        }
    }
}

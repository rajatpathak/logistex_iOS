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
import GoogleMaps
import GooglePlaces
import Lightbox

class DriverDetailsVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var lblPickUpLocation: UILabel!
    @IBOutlet weak var lblPickUpTime: UILabel!
    @IBOutlet weak var vwMapPickUp: GMSMapView!
    @IBOutlet weak var lblDropLocation: UILabel!
    @IBOutlet weak var lblDropTime: UILabel!
    @IBOutlet weak var vwMapDrop: GMSMapView!
    @IBOutlet weak var lblPaymentMethod: UILabel!
    @IBOutlet weak var vwServiceRating: FloatRatingView!
    @IBOutlet weak var vwQualityRating: FloatRatingView!
    @IBOutlet weak var vwDeliveryRating: FloatRatingView!
    @IBOutlet weak var lblRatingDesc: UILabel!
    @IBOutlet weak var lblRm: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var imgVwCust: RoundedImage!
    @IBOutlet weak var vwRatingHeightCnst: NSLayoutConstraint!
    @IBOutlet weak var vwRating: UIView!
    @IBOutlet weak var vwCustAvgRating: FloatRatingView!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var vwSignatureHeightCnst: NSLayoutConstraint!
    @IBOutlet weak var imgVwSignature: UIImageView!
    
    
    //MARK:- Object
    var objDriverDetailsVM = DriverDetailsVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        objDriverDetailsVM.hitBookingDetailApi(objDriverDetailsVM.bookingId) {
            self.showDetail()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.black)
    }
    
    
    //MARK:- IBActions
    @IBAction func actionQuery(_ sender: Any) {
        push(identifier: "ChatVC")
    }
    @IBAction func actionChat(_ sender: Any) {
        let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        controller.title = TitleValue.chatUser
        controller.objChatVM.toUserId = "\(objDriverDetailsVM.objDriverDetailModel.custId)"
        controller.objChatVM.toUserName = "\(objDriverDetailsVM.objDriverDetailModel.custName)"
        controller.objChatVM.bookingId = "\(objDriverDetailsVM.objDriverDetailModel.bookingId)"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func actionBack(_ sender: Any) {
        pop()
    }
    func showDetail() {
        markerPickup()
        markerDropup()
        let dict = objDriverDetailsVM.objDriverDetailModel
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        lblPickUpLocation.text = dict.pickupLocation
        lblDropLocation.text = dict.dropupLocation
        imgVwSignature.sd_setImage(with: URL(string: dict.signature), placeholderImage: #imageLiteral(resourceName: "ic_sign copy"))
        if lang == ChooseLanguage.english.rawValue {
            lblPickUpTime.text = "\(TitleValue.pickUp) \(dict.pickupDate.getStringFromDate(inputFormat: "yyyy-MMM-dd HH:mm:ss", outputFormat: "MM-dd-yyyy HH:mm:ss"))"
        } else {
            lblPickUpTime.text = "\(TitleValue.pickUpSpa) \(dict.pickupDate.getStringFromDate(inputFormat: "yyyy-MMM-dd HH:mm:ss", outputFormat: "dd-MM-yyyy HH:mm:ss"))"
        }
        let cashTitle = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.cashSpa : TitleValue.cash)"
        let cardTitle = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.cardSpa : TitleValue.card)"
        let bankTransferTitle = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.bankTransferTitlteSpa : TitleValue.bankTransferTitlte)"
        let paypalTitle = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.paypalTitleSpa : TitleValue.paypalTitle)"
        
        switch dict.paymentMethod {
        case PaymentMethod.cash.rawValue :
            lblPaymentMethod.text = cashTitle
        case PaymentMethod.stripe.rawValue :
            lblPaymentMethod.text = cardTitle
        case PaymentMethod.bankTransfer.rawValue :
            lblPaymentMethod.text = bankTransferTitle
        case PaymentMethod.paypal.rawValue :
            lblPaymentMethod.text = paypalTitle
        default:
            break
        }
        
        lblCustomerName.text = dict.custName
        imgVwCust.sd_setImage(with: URL(string: dict.custProfile), placeholderImage: #imageLiteral(resourceName: "ic_default_user"))
        lblRm.text = "\(dict.currencySymbol) \(dict.amount) \(dict.currency)"
        lblRatingDesc.text = dict.ratingComment
        vwCustAvgRating.rating = Float(dict.custAverageRating)
        vwQualityRating.rating = Float(dict.qualityRating)
        vwDeliveryRating.rating = Float(dict.deliveryRating)
        vwServiceRating.rating = Float(dict.serviceRating)
        vwRating.isHidden = dict.serviceRating == 0.0
        vwSignatureHeightCnst.constant = dict.bookingState == StateRequest.completed.rawValue ? 80 : 0
        vwRatingHeightCnst.constant = dict.serviceRating == 0.0 ? 0 : 185
        switch dict.bookingState {
        case StateRequest.active.rawValue:
            lblDropTime.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.dropSpa : TitleValue.drop) \(lang == ChooseLanguage.spanish.rawValue ? TitleValue.assignedSpa : TitleValue.assigned)"
            btnChat.isHidden = false
        case StateRequest.inProgress.rawValue:
            lblDropTime.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.dropSpa : TitleValue.drop) \(lang == ChooseLanguage.spanish.rawValue ? TitleValue.progressSpa : TitleValue.progress)"
            btnChat.isHidden = false
        case StateRequest.pickup.rawValue:
            lblDropTime.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.dropSpa : TitleValue.drop) \(lang == ChooseLanguage.spanish.rawValue ? TitleValue.pickedSpa : TitleValue.picked)"
            btnChat.isHidden = false
        case StateRequest.cancelled.rawValue:
            lblDropTime.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.dropSpa : TitleValue.drop) \(lang == ChooseLanguage.spanish.rawValue ? TitleValue.bookingCancelledSpa : TitleValue.bookingCancelled)"
            btnChat.isHidden = true
        case StateRequest.completed.rawValue:
            lblDropTime.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.dropSpa : TitleValue.drop) \(lang == ChooseLanguage.spanish.rawValue ? TitleValue.completedSpa : TitleValue.completed)"
            btnChat.isHidden = true
        case StateRequest.driverCancel.rawValue:
            lblDropTime.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.dropSpa : TitleValue.drop) \(lang == ChooseLanguage.spanish.rawValue ? TitleValue.bookingCancelledSpa : TitleValue.bookingCancelled)"
            btnChat.isHidden = true
        default:
            break
        }
    }
    @IBAction func actionPickUpLocation(_ sender: Any) {
        let dict = objDriverDetailsVM.objDriverDetailModel
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(dict.pickupLat),\(dict.pickupLong)&zoom=14&views=traffic&q=\(dict.pickupLat),\(dict.pickupLong)")!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=loc:\(dict.pickupLat),\(dict.pickupLong)&zoom=14&views=traffic&q=\(dict.pickupLat),\(dict.pickupLong)")!, options: [:], completionHandler: nil)
        }
    }
    @IBAction func actionDropLocation(_ sender: Any) {
        let dict = objDriverDetailsVM.objDriverDetailModel
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(dict.destLat),\(dict.destLong)&zoom=14&views=traffic&q=\(dict.destLat),\(dict.destLong)")!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=loc:\(dict.destLat),\(dict.destLong)&zoom=14&views=traffic&q=\(dict.destLat),\(dict.destLong)")!, options: [:], completionHandler: nil)
        }
    }
    func markerPickup () {
        let dict = objDriverDetailsVM.objDriverDetailModel
        if dict.pickupLat != "" && dict.pickupLong != "" {
            let sourceLocation = CLLocationCoordinate2D(latitude: Double(dict.pickupLat)! as CLLocationDegrees, longitude: Double(dict.pickupLong)! as CLLocationDegrees)
            vwMapPickUp.isBuildingsEnabled = true
            vwMapPickUp?.isMyLocationEnabled = false
            vwMapPickUp.setRegionMap(sourceLocation: sourceLocation)
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(dict.pickupLat)!, longitude: Double(dict.pickupLong)!))
            marker.icon = UIImage(named: "ic_marker")
            marker.map = vwMapPickUp
        }
    }
    func markerDropup () {
        let dict = objDriverDetailsVM.objDriverDetailModel
        if dict.destLat != "" && dict.destLong != "" {
            let sourceLocation = CLLocationCoordinate2D(latitude: Double(dict.destLat)! as CLLocationDegrees, longitude: Double(dict.destLong)! as CLLocationDegrees)
            vwMapDrop.isBuildingsEnabled = true
            vwMapDrop?.isMyLocationEnabled = false
            vwMapDrop.setRegionMap(sourceLocation: sourceLocation)
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(dict.destLat)!, longitude: Double(dict.destLong)!))
            marker.icon = UIImage(named: "ic_marker")
            marker.map = vwMapDrop
        }
    }
    @IBAction func actionOpenImage(_ sender: Any) {
        let dict = objDriverDetailsVM.objDriverDetailModel
        let file = dict.custProfile
        if file != "" {
            let images = [LightboxImage(imageURL: URL.init(string: file)!)]
            let controller = LightboxController(images: images)
            controller.pageDelegate = self
            controller.dismissalDelegate = self
            controller.dynamicBackground = true
            controller.modalPresentationStyle = .fullScreen
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
    }
    @IBAction func actionOpenSignature(_ sender: Any) {
        let dict = objDriverDetailsVM.objDriverDetailModel
        let file = dict.signature
        if file != "" {
            let images = [LightboxImage(imageURL: URL.init(string: file)!)]
            let controller = LightboxController(images: images)
            controller.pageDelegate = self
            controller.dismissalDelegate = self
            controller.dynamicBackground = true
            controller.modalPresentationStyle = .fullScreen
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
    }
}

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

class BookingDetailVC: UIViewController {
    
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
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var vwDriverAvgRating: FloatRatingView!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var vwRatingHeightCnst: NSLayoutConstraint!
    @IBOutlet weak var vwRating: UIView!
    @IBOutlet weak var lblTotalCharges: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblFinalAmount: UILabel!
    @IBOutlet weak var lblVehicleNo: UILabel!
    @IBOutlet weak var lblVehicleBrand: UILabel!
    @IBOutlet weak var lblVehicleColor: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    @IBOutlet weak var lblServiceType: UILabel!
    @IBOutlet weak var tblVwAdditionalServices: UITableView!
    @IBOutlet weak var vwAdditionalServices: UIView!
    @IBOutlet weak var cnstHeightVwAdditionalServices: NSLayoutConstraint!
    @IBOutlet weak var vwSignatureHeightCnst: NSLayoutConstraint!
    @IBOutlet weak var imgVwDriver: UIImageView!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var imgVwSignature: UIImageView!
    @IBOutlet weak var lblAdditionServiceCharges: UILabel!
    @IBOutlet weak var lblPrevioiusDriverName: UILabel!
    @IBOutlet weak var lblPrevioiusDriverVehicleNo: UILabel!
    @IBOutlet weak var lblPrevioiusDriverVehicleBrand: UILabel!
    @IBOutlet weak var lblPrevioiusDriverVehicleColor: UILabel!
    @IBOutlet weak var lblPrevioiusDriverContactNo: UILabel!
    @IBOutlet weak var lblPrevioiusDriverServiceType: UILabel!
    @IBOutlet weak var imgVwPreviousDriver: UIImageView!
    @IBOutlet weak var vwPreviousDriverDetails: UIView!
    @IBOutlet weak var vwPreviousDriverDetialHghtCnst: NSLayoutConstraint!
    
    //MARK:- Variables
    var objBookingDetailVM = BookingDetailVM()
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        objBookingDetailVM.getBookingDetail(objBookingDetailVM.detailId) {
            self.showDetail()
        }
    }
    //MARK:- IBACTIONS
    @IBAction func actionDrawer(_ sender: UIButton) {
        popToBack()
    }
    
    @IBAction func actionViewReceipt(_ sender: UIButton) {
        if objBookingDetailVM.objBookingDetailModel.stateId == BookingState.completed.rawValue {
            self.pushVC(selectedStoryboard: .main, identifier: .receiptVC, titleVal: "\(objBookingDetailVM.objBookingDetailModel.id)" )
        } else {
            Proxy.shared.displayStatusAlert(message: AlertMessages.noReceiptAvailable.localized, state: .info)
        }
    }
    
    
    func showDetail() {
        addMarkers()
        let dict = objBookingDetailVM.objBookingDetailModel
        lblPickUpLocation.text = dict.pickUpLocation
        lblDropLocation.text = dict.dropLocation
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        if lang == ChooseLanguage.english.rawValue {
            lblPickUpTime.text = AlertMessages.pickUp.localized + " \(dict.pickupDate.changeDateFormatOfStrDate(currentFormat: "yyyy-MM-dd HH:mm:ss", willingFormat: "MM-dd-yyyy HH:mm:ss"))"
        } else {
            lblPickUpTime.text = AlertMessages.pickUp.localized + " \(dict.pickupDate.changeDateFormatOfStrDate(currentFormat: "yyyy-MM-dd HH:mm:ss", willingFormat: "dd-MM-yyyy HH:mm:ss"))"
        }
        let cashTitle = "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.cashTitleSpa : PassTitles.cashTitle)"
        let cardTitle = "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.cardTitleSpa : PassTitles.cardTitle)"
        let bankTransferTitle = "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.bankTransferTitlteSpa : PassTitles.bankTransferTitlte)"
        let paypalTitle = "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.paypalTitleSpa : PassTitles.paypalTitle)"
        
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
        
        if dict.previousDriverId != 0 || dict.previousDriverName != "" {
            vwPreviousDriverDetails.isHidden = false
            vwPreviousDriverDetialHghtCnst.constant = 165
            lblPrevioiusDriverName.text = dict.previousDriverName
            imgVwPreviousDriver.sd_setImage(with: URL(string: dict.previousDriverProfile), placeholderImage: #imageLiteral(resourceName: "ic_drawer_pic"))
            lblPrevioiusDriverVehicleNo.text = AlertMessages.vehicleNumber.localized + " \(dict.previousDriverVehicleNo)"
            lblPrevioiusDriverVehicleBrand.text =  dict.previousDriverVehicleBrand
            lblPrevioiusDriverVehicleColor.text = AlertMessages.vehicleColor.localized + " \(dict.previousDriverVehicleColor)"
            lblPrevioiusDriverContactNo.text = AlertMessages.contactNumber.localized + " \(dict.previousDriverContact)"
            lblPrevioiusDriverServiceType.text = AlertMessages.serviceType.localized + " \(dict.previousDriverVehicleTypeTitle)"
        } else {
            vwPreviousDriverDetialHghtCnst.constant = 0
            vwPreviousDriverDetails.isHidden = true
        }

        lblDriverName.text = dict.driverName
        imgVwDriver.sd_setImage(with: URL(string: dict.driverProfile), placeholderImage: #imageLiteral(resourceName: "ic_drawer_pic"))
        vwDriverAvgRating.rating = Float(dict.averageRating)
        vwQualityRating.rating = Float(dict.qualityRating)
        vwDeliveryRating.rating = Float(dict.deliveryRating)
        vwServiceRating.rating = Float(dict.serviceRating)
        imgVwSignature.sd_setImage(with: URL(string: dict.signature), placeholderImage: #imageLiteral(resourceName: "ic_sign copy"))
        vwRating.isHidden = dict.serviceRating == 0.0
        lblRating.text = dict.ratingComment
        
        if dict.vehicleNo != "" {
            lblVehicleNo.text = AlertMessages.vehicleNumber.localized + " \(dict.vehicleNo)"
            lblVehicleBrand.text = dict.vehicleBrand
            lblVehicleColor.text = AlertMessages.vehicleColor.localized + " \(dict.vehicleColor)"
            lblContactNo.text = AlertMessages.contactNumber.localized + " \(dict.driverContact)"
            lblServiceType.text = AlertMessages.serviceType.localized + " \(dict.vehicleTypeTitle)"
        } else {
            lblVehicleNo.text = ""
            lblVehicleBrand.text = ""
            lblVehicleColor.text = ""
            lblContactNo.text =  AlertMessages.driverDetailsNotAvailable.localized
            lblServiceType.text =  ""
        }
        
        vwRatingHeightCnst.constant = dict.serviceRating == 0.0 ? 0 : 170
        switch dict.stateId {
        case BookingState.active.rawValue:
            lblDropTime.text = AlertMessages.drop.localized + " \(PassTitles.assigned.localized)"
            btnChat.isHidden = false
        case BookingState.inProgress.rawValue:
            lblDropTime.text = AlertMessages.drop.localized + " \(PassTitles.progress.localized)"
            btnChat.isHidden = false
        case BookingState.pickup.rawValue:
            lblDropTime.text = AlertMessages.drop.localized + " \(PassTitles.picked.localized)"
            btnChat.isHidden = false
        case BookingState.completed.rawValue:
            let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
            if lang == ChooseLanguage.english.rawValue {
                lblDropTime.text = AlertMessages.drop.localized + " \(dict.deliveryTime.changeDateFormatOfStrDate(currentFormat: "yyyy-MM-dd HH:mm:ss", willingFormat: "MM-dd-yyyy HH:mm:ss"))"
            } else {
                lblDropTime.text = AlertMessages.drop.localized + " \(dict.deliveryTime.changeDateFormatOfStrDate(currentFormat: "yyyy-MM-dd HH:mm:ss", willingFormat: "dd-MM-yyyy HH:mm:ss"))"
            }
           
            btnChat.isHidden = true
        case BookingState.cancelled.rawValue:
            lblDropTime.text = AlertMessages.drop.localized + " \(PassTitles.cancelled.localized)"
            btnChat.isHidden = true
        case BookingState.driverCancel.rawValue:
            lblDropTime.text = AlertMessages.drop.localized + " \(PassTitles.cancelDriver.localized)"
            btnChat.isHidden = true
        default:
            lblDropTime.text = AlertMessages.assigningDriverShortly.localized
        }
        
        if dict.arrAdditionalServiceModel.count > 0 {
            vwAdditionalServices.isHidden = false
            tblVwAdditionalServices.reloadData()
            cnstHeightVwAdditionalServices.constant = tblVwAdditionalServices.contentSize.height + 150
        } else {
            cnstHeightVwAdditionalServices.constant = 0
            vwAdditionalServices.isHidden = true
        }
        
        vwSignatureHeightCnst.constant = dict.stateId == BookingState.completed.rawValue ? 80 : 0
        lblTotalCharges.text = "\(dict.currencySymbol) \(dict.amount + dict.discountAmount) \(dict.currency)"
        lblDiscount.text = "\(dict.currencySymbol) \(dict.discountAmount) \(dict.currency)"
        lblFinalAmount.text = "\(dict.currencySymbol) \(dict.amount) \(dict.currency)"
        
        var additionalService = Double()
        
        for dict in dict.arrAdditionalServiceModel{
            additionalService = additionalService + Double(dict.objAdditionServiceModel!.amount)!
        }
        lblAdditionServiceCharges.text = "\(AlertMessages.amount.localized) \(dict.currency) \(additionalService)"
    }
    func addMarkers () {
        let dict = objBookingDetailVM.objBookingDetailModel
        if dict.pickupLat != "" && dict.pickupLong != "" {
            let sourceLocation = CLLocationCoordinate2D(latitude: Double(dict.pickupLat)! as CLLocationDegrees, longitude: Double(dict.pickupLong)! as CLLocationDegrees)
            vwMapPickUp.isBuildingsEnabled = true
            vwMapPickUp?.isMyLocationEnabled = false
            vwMapPickUp.setRegionMap(sourceLocation: sourceLocation)
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(dict.pickupLat)!, longitude: Double(dict.pickupLong)!))
            marker.icon = UIImage(named: "ic_red_small_loc")
            marker.map = vwMapPickUp
        }
        if dict.destLat != "" && dict.destLong != "" {
            let sourceLocation = CLLocationCoordinate2D(latitude: Double(dict.destLat)! as CLLocationDegrees, longitude: Double(dict.destLong)! as CLLocationDegrees)
            vwMapDrop.isBuildingsEnabled = true
            vwMapDrop?.isMyLocationEnabled = false
            vwMapDrop.setRegionMap(sourceLocation: sourceLocation)
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(dict.destLat)!, longitude: Double(dict.destLong)!))
            marker.icon = UIImage(named: "ic_red_small_loc")
            marker.map = vwMapDrop
        }
    }
    @IBAction func actionChat(_ sender: Any) {
        let objPushVC = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        objPushVC.objChatVM.toUserId = "\(objBookingDetailVM.objBookingDetailModel.driverId)"
        objPushVC.objChatVM.toUserName = "\(objBookingDetailVM.objBookingDetailModel.driverName)"
        objPushVC.objChatVM.bookingId = "\(objBookingDetailVM.objBookingDetailModel.id)"
        self.navigationController?.pushViewController(objPushVC, animated: true)
    }
    @IBAction func actionOpenImage(_ sender: Any) {
        let dict = objBookingDetailVM.objBookingDetailModel
        let file = dict.driverProfile
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
    @IBAction func actionOpenImagePreviousDriver(_ sender: Any) {
        let dict = objBookingDetailVM.objBookingDetailModel
        let file = dict.previousDriverProfile
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
    @IBAction func actionPickUpLocation(_ sender: Any) {
        let dict = objBookingDetailVM.objBookingDetailModel
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(dict.pickupLat),\(dict.pickupLong)&zoom=14&views=traffic&q=\(dict.pickupLat),\(dict.pickupLong)")!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=loc:\(dict.pickupLat),\(dict.pickupLong)&zoom=14&views=traffic&q=\(dict.pickupLat),\(dict.pickupLong)")!, options: [:], completionHandler: nil)
        }
    }
    @IBAction func actionDropLocation(_ sender: Any) {
        let dict = objBookingDetailVM.objBookingDetailModel
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(dict.destLat),\(dict.destLong)&zoom=14&views=traffic&q=\(dict.destLat),\(dict.destLong)")!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=loc:\(dict.destLat),\(dict.destLong)&zoom=14&views=traffic&q=\(dict.destLat),\(dict.destLong)")!, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func actionOpenSignature(_ sender: Any) {
        let dict = objBookingDetailVM.objBookingDetailModel
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

extension BookingDetailVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if objBookingDetailVM.objBookingDetailModel.arrAdditionalServiceModel.count == 0 {
            tableView.emptyState.show( TableState.noNotifications)
        } else {
            tableView.emptyState.hide()
        }
        
        return objBookingDetailVM.objBookingDetailModel.arrAdditionalServiceModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dictData = objBookingDetailVM.objBookingDetailModel.arrAdditionalServiceModel[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalServiceDetailTVC", for: indexPath) as! AdditionalServiceDetailTVC
        cell.lblAdditionalService.text = "\(indexPath.row+1). " + (dictData.objAdditionServiceModel?.title)!
        return cell
    }
}

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

class HomeVC: UIViewController, GMSMapViewDelegate ,PassLocationDelegate{
    
    //MARK:- IBOutlets
    @IBOutlet weak var lblDriverId: UILabel!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwMainHeightCnst: NSLayoutConstraint!
    @IBOutlet weak var lblOffline: UILabel!
    @IBOutlet weak var lblOnline: UILabel!
    @IBOutlet weak var vwMap: GMSMapView!
    @IBOutlet weak var btnProfileImg: UIButton!
    @IBOutlet weak var btnSwitch: UIButton!
    @IBOutlet weak var btnNavigate: UIButton!
    
    
    //MARK:- Object
    var objHomeVM = HomeVM()
    var objSplashVM = SplashVM()
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        delegateAcceptRequest = self
        delegateSignatureData = self
        objPassLocationDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(getNewRequestNotification), name: NSNotification.Name(rawValue: "NewRequest"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getNewChangeRequestNotification), name: NSNotification.Name(rawValue: "NewChangeRequest"), object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.black)
        LocationManagerClass.sharedLocationManager().startStandardUpdates()
        if objUserModel.objAccepRequestModel.bookingId == "" {
            objHomeVM.hitCurrentRequestApi { (isSuccess) in
                if isSuccess == true {
                    self.setupOrderDetailView {
                        self.objHomeVM.orderDetailVw.setUp(parentView: self.vwMain) {
                            self.showOrderDetailView()
                        }
                    }
                } else {
                    self.setDefaultLocation()
                }
            }
        }
        showUserDetail()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        setDefaultLocation()
    }
    @objc func getNewRequestNotification(_ notification: NSNotification) {
        objHomeVM.hitCurrentRequestApi { (isSuccess) in
            if isSuccess == true {
                self.setupOrderDetailView {
                    self.objHomeVM.orderDetailVw.setUp(parentView: self.vwMain) {
                        self.showOrderDetailView()
                    }
                }
            }
        }
    }
    @objc func getNewChangeRequestNotification(_ notification: NSNotification) {
        objSplashVM.hitCheckApi {
            self.showStartJourneyView()
        }
    }
    //MARK:- IBActions
    @IBAction func actionMenu(_ sender: Any) {
        KAppDelegate.sideMenuVC.openLeft()
    }
    @IBAction func actionNavigate(_ sender: Any) {
        Proxy.shared.openGoogleMap(currentLat: Proxy.shared.getLatitude(), currentLong: Proxy.shared.getLongitude(),destinationLat: objUserModel.objAccepRequestModel.destLat, destinationLong: objUserModel.objAccepRequestModel.destLong)
    }
    
    func setupOrderDetailView(_ completion:@escaping()-> Void) {
        if objHomeVM.orderDetailVw == nil {
            guard let orderDetailVw = OrderDetailView.loadNib() else {
                return
            }
            self.objHomeVM.orderDetailVw = orderDetailVw
        }
        self.objHomeVM.orderDetailVw.vwBg.showLoader()
        completion()
    }
    func setupJourneyDetailView(_ completion:@escaping()-> Void) {
        if objHomeVM.startJourneyVw == nil {
            guard let startJourneyVw = StartJourneyView.loadNib() else {
                return
            }
            self.objHomeVM.startJourneyVw = startJourneyVw
        }
        self.objHomeVM.startJourneyVw.vwOrderId.showLoader()
        self.objHomeVM.startJourneyVw.vwOrderDetail.showLoader()
        self.objHomeVM.startJourneyVw.vwInstruction.showLoader()
        completion()
    }
    func setupShowOnMapView(_ completion:@escaping()-> Void) {
        if objHomeVM.showOnMapVw == nil {
            guard let showOnMapVw = ShowOnMapView.loadNib() else {
                return
            }
            self.objHomeVM.showOnMapVw = showOnMapVw
        }
        self.objHomeVM.showOnMapVw.vwBg.showLoader()
        completion()
    }
    func setupInstructionsView(_ completion:@escaping()-> Void) {
        if objHomeVM.instructionsVw == nil {
            guard let instructionVw = InstructionsView.loadNib() else {
                return
            }
            self.objHomeVM.instructionsVw = instructionVw
        }
        self.objHomeVM.instructionsVw.vwOrderId.showLoader()
        self.objHomeVM.instructionsVw.vwOrderDetail.showLoader()
        self.objHomeVM.instructionsVw.vwInstruction.showLoader()
        completion()
    }
    func setupEndJourneyView(_ completion:@escaping()-> Void) {
        if objHomeVM.endJourneyVw == nil {
            guard let endJourneyVw = EndJourneyView.loadNib() else {
                return
            }
            self.objHomeVM.endJourneyVw = endJourneyVw
        }
        self.objHomeVM.endJourneyVw.vwBg.showLoader()
        completion()
    }
    func setupRatingView(_ completion:@escaping()-> Void) {
        if objHomeVM.ratingVw == nil {
            guard let ratingVw = RatingView.loadNib() else {
                return
            }
            self.objHomeVM.ratingVw = ratingVw
            let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
            objHomeVM.ratingVw.txtVwComment.placeholder = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.typeHereSpa : TitleValue.typeHere)"
        }
        self.objHomeVM.ratingVw.vwBg.showLoader()
        completion()
    }
    @IBAction func actionShowProfile(_ sender: Any) {
        push(identifier: "ProfileVC")
    }
    @IBAction func actionOnlineOffline(_ sender: UIButton) {
        if Proxy.shared.getLatitude() == "0.0" || Proxy.shared.getLongitude() == "0.0" {
            LocationManagerClass.sharedLocationManager().showAlert(title: AlertMessages.locationServiceOff, message: AlertMessages.turnOnLocationServiceFromSetting)
        } else {
            if objUserModel.contact == "" || objUserModel.contact == "<null>" {
                Proxy.shared.displayStatusAlert(AlertMessages.completeProfile.localized)
            } else {
                if btnSwitch!.currentImage == UIImage(named: "ic_offline") {
                    objHomeVM.hitUpdateStatusApi("\(DriverStatus.online.rawValue)") {
                        self.objHomeVM.hitCurrentRequestApi { (isSuccess) in
                            self.btnSwitch.isSelected = true
                            self.btnSwitch?.setImage(UIImage(named: "ic_online"), for: .normal)
                            self.lblOnline.isHidden = false
                            self.lblOffline.isHidden = true
                            if isSuccess == true {
                                self.setupOrderDetailView {
                                    self.objHomeVM.orderDetailVw.setUp(parentView: self.vwMain) {
                                        self.showOrderDetailView()
                                    }
                                }
                            }
                        }
                    }
                } else {
                    objHomeVM.hitUpdateStatusApi("\(DriverStatus.offline.rawValue)") {
                        self.btnSwitch.isSelected = false
                        self.btnSwitch?.setImage(UIImage(named: "ic_offline"), for: .normal)
                        self.lblOnline.isHidden = true
                        self.lblOffline.isHidden = false
                        self.objHomeVM.hitCurrentRequestApi { (isSuccess) in
                            if isSuccess == false {
                                self.setupOrderDetailView {
                                    self.objHomeVM.orderDetailVw.setUp(parentView: self.vwMain) {
                                        self.hideOrderDetailView()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func showOrderDetailView() {
        vwMain.isHidden = false
        vwMainHeightCnst.constant = 270
        let mapInsets = UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0)
        vwMap.padding = mapInsets
        UIView.animate(withDuration: 0.8, delay: 0.1, options: .curveEaseOut, animations: {
            self.objHomeVM.orderDetailVw.frame =  CGRect(x: 0, y: 0, width: Double(self.vwMain.frame.width), height: Double(self.vwMain.frame.height))
            self.vwMain.addSubview(self.objHomeVM.orderDetailVw)
            self.view.layoutIfNeeded()
        }, completion:{ finish in
            let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
            let dict = self.objHomeVM.objCurrentRequestModel
            self.objHomeVM.orderDetailVw.lblOrderId.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.orderIdSpa : TitleValue.orderId) \(dict.orderId)"
            self.objHomeVM.orderDetailVw.lblPickUpLocation.text = dict.pickupLocation
            self.objHomeVM.orderDetailVw.lblDropUpLocation.text = dict.dropupLocation
            let offeredPriceLanguageText = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.offeredAmountSpa : TitleValue.offeredAmount)"
            self.objHomeVM.orderDetailVw.lblStaticOfferedPrice.text = offeredPriceLanguageText
            self.objHomeVM.orderDetailVw.lblOfferAmount.text = "\(dict.currencySymbol) \(dict.orderAmount) \(dict.currency)"
            self.objHomeVM.orderDetailVw.vwBg.hideLoader()
        })
        
    }
    func hideOrderDetailView() {
        vwMain.isHidden = true
        vwMainHeightCnst.constant = 0
        let mapInsets = UIEdgeInsets(top: 0, left: 0.0, bottom: 10, right: 0.0)
        vwMap.padding = mapInsets
        self.objHomeVM.orderDetailVw.vwBg.hideLoader()
    }
    func showStartJourneyView() {
        btnNavigate.isHidden = true
        vwMain.isHidden = false
        objHomeVM.timer?.invalidate()
        if #available(iOS 13.0, *) {
            self.vwMainHeightCnst.constant = DeviceInfo.DeviceHeight - ((SceneDelegateInstance!.window?.safeAreaInsets.top)! + (SceneDelegateInstance!.window?.safeAreaInsets.bottom)! + 84)
        } else {
            self.vwMainHeightCnst.constant = DeviceInfo.DeviceHeight - ((KAppDelegate.window?.safeAreaInsets.top)! + (KAppDelegate.window?.safeAreaInsets.bottom)! + 84)
        }
        UIView.animate(withDuration: 0.8, delay: 0.1, options: .curveEaseOut, animations: {
            self.objHomeVM.startJourneyVw.frame =  CGRect(x: 0, y: 0, width: Double(self.vwMain.frame.width), height: Double(self.vwMain.frame.height))
            self.vwMain.addSubview(self.objHomeVM.startJourneyVw)
            self.view.layoutIfNeeded()
        }, completion:{ finish in
            let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
            let view = self.objHomeVM.startJourneyVw
            let dict = objUserModel.objAccepRequestModel
            
            let offeredPriceLanguageText = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.offeredAmountSpa : TitleValue.offeredAmount)"
            view?.lblStaticAmountOffered.text = offeredPriceLanguageText
            let changeAmountLanguageText = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.changeAmountSpa : TitleValue.changeAmount)"
            view?.lblStaticChangeAmount.text = changeAmountLanguageText
            view?.lblOrderId.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.orderIdSpa : TitleValue.orderId) \(dict.bookingId)"
            view?.lblAmountOffered.text = "\(dict.currencySymbol) \(dict.amount) \(dict.currency)"
            view?.txtFldCurrency.text = dict.currency
            view?.lblPickupLocation.text = dict.pickupLocation
            view?.lblDropupLocation.text = dict.dropupLocation
            view?.lblDesc.text = dict.desc
            view?.vwTimings.isHidden = dict.bookingType == "\(BookingType.bookNow.rawValue)"
            
            view?.lblPickUpDate.text = dict.pickupDate.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "dd MMM yyyy")
            if lang == ChooseLanguage.spanish.rawValue {
                view?.lblPickUpDate.text = dict.pickupDate.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "dd-MM-yyyy")
            } else {
                view?.lblPickUpDate.text = dict.pickupDate.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "MM-dd-yyyy")
            }
            view?.lblPickUpTime.text = dict.pickupDate.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "HH:mm:ss")
            view?.vwTimingHeightCnst.constant = dict.bookingType == "\(BookingType.bookNow.rawValue)" ? 0 : 53
            view?.colVwHeightCnst.constant = dict.arrFiles.count == 0 ? 0 : 80
            if lang == ChooseLanguage.spanish.rawValue {
                view?.btnApply.setTitle(TitleValue.applyChangesSpa, for: .normal)
                view?.btnDeclined.setTitle(TitleValue.declineSpa, for: .normal)
                view?.txtFldChangeAmount.placeholder = TitleValue.enterAmountTitleSpa
            } else {
                view?.btnApply.setTitle(TitleValue.applyChanges, for: .normal)
                view?.btnDeclined.setTitle(TitleValue.decline, for: .normal)
                view?.txtFldChangeAmount.placeholder = TitleValue.enterAmountTitle
            }
            if dict.isNagotiableAmount == AmountNagotiable.no.rawValue{
                view?.vwForNagotiableAmount.isHidden = true
                view?.vwNagotiableAmountHghtCnst.constant = 0
                view?.vwAmountOfferDetailsHghtCnst.constant = 75
            } else {
                view?.vwForNagotiableAmount.isHidden = false
                view?.vwNagotiableAmountHghtCnst.constant = 154
                view?.vwAmountOfferDetailsHghtCnst.constant = 220
            }
            
            switch dict.amountChangeRequestStatus {
            case ChangeAmountRequstState.none.rawValue:
                view?.txtFldChangeAmount.text = ""
            case ChangeAmountRequstState.send.rawValue:
                view?.txtFldChangeAmount.text = String(dict.finalAmount)
                view?.btnApply.isHidden = true
            case ChangeAmountRequstState.accept.rawValue , ChangeAmountRequstState.reject.rawValue :
                view?.txtFldChangeAmount.text =  String(dict.amount)
                view?.btnApply.isHidden = true
            default:
                break
            }
            
            switch dict.bookingState {
            case StateRequest.active.rawValue:
                self.showPickDetails()
                view?.btnJourney.setTitle(TitleValue.startJourney.localized, for: .normal)
            case StateRequest.inProgress.rawValue:
                view?.vwForNagotiableAmount.isHidden = true
                view?.vwNagotiableAmountHghtCnst.constant = 0
                view?.vwAmountOfferDetailsHghtCnst.constant = 75
                self.showPickDetails()
                view?.btnJourney.setTitle(TitleValue.makeOrderPickup.localized, for: .normal)
            case StateRequest.pickup.rawValue:
                view?.vwForNagotiableAmount.isHidden = true
                view?.vwNagotiableAmountHghtCnst.constant = 0
                view?.vwAmountOfferDetailsHghtCnst.constant = 75
                self.showDropDetails()
                view?.btnJourney.setTitle(TitleValue.makeOrderComplete.localized, for: .normal)
            default:
                break
            }
            view?.vwOrderId.hideLoader()
            view?.vwOrderDetail.hideLoader()
            view?.vwInstruction.hideLoader()
        })
    }
    func showOnMapView() {
        vwMain.isHidden = false
        let dict = objUserModel.objAccepRequestModel
        switch dict.bookingState {
        case StateRequest.active.rawValue:
            self.vwMainHeightCnst.constant = 250
        case StateRequest.inProgress.rawValue:
            self.vwMainHeightCnst.constant = 250
        case StateRequest.pickup.rawValue:
            self.vwMainHeightCnst.constant = 285
        default:
            break
        }
        UIView.animate(withDuration: 0.8, delay: 0.1, options: .curveEaseOut, animations: {
            self.objHomeVM.showOnMapVw.frame =  CGRect(x: 0, y: 0, width: Double(self.vwMain.frame.width), height: Double(self.vwMain.frame.height))
            self.vwMain.addSubview(self.objHomeVM.showOnMapVw)
            self.view.layoutIfNeeded()
        }, completion:{ finish in
            let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
            let view = self.objHomeVM.showOnMapVw
            let dict = objUserModel.objAccepRequestModel
            view?.lblOrderId.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.orderIdSpa : TitleValue.orderId) \(dict.bookingId)"
            view?.lblPickupLocation.text = dict.pickupLocation
            view?.lblDropLocation.text = dict.dropupLocation
            switch dict.bookingState {
            case StateRequest.active.rawValue:
                view?.vwMarkComplete.isHidden = true
                view?.vwCompleteHeightCnst.constant = 0
                self.startJourneyAnnotation()
            case StateRequest.inProgress.rawValue:
                view?.vwMarkComplete.isHidden = true
                view?.vwCompleteHeightCnst.constant = 0
                self.makeOrderLocationAnnotation()
            case StateRequest.pickup.rawValue:
                view?.vwMarkComplete.isHidden = false
                view?.vwCompleteHeightCnst.constant = 30
                self.makeCompleteOrderAnnotation()
            default:
                break
            }
            self.objHomeVM.showOnMapVw.vwBg.hideLoader()
            self.btnNavigate.isHidden = false
        })
    }
    func showInstructionsView() {
        vwMain.isHidden = false
        if #available(iOS 13.0, *) {
            self.vwMainHeightCnst.constant = DeviceInfo.DeviceHeight - ((SceneDelegateInstance!.window?.safeAreaInsets.top)! + (SceneDelegateInstance!.window?.safeAreaInsets.bottom)! + 84)
        } else {
            self.vwMainHeightCnst.constant = DeviceInfo.DeviceHeight - ((KAppDelegate.window?.safeAreaInsets.top)! + (KAppDelegate.window?.safeAreaInsets.bottom)! + 84)
        }
        UIView.animate(withDuration: 0.8, delay: 0.1, options: .curveEaseOut, animations: {
            self.objHomeVM.instructionsVw.frame =  CGRect(x: 0, y: 0, width: Double(self.vwMain.frame.width), height: Double(self.vwMain.frame.height))
            self.vwMain.addSubview(self.objHomeVM.instructionsVw)
            self.view.layoutIfNeeded()
        }, completion:{ finish in
            let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
            let view = self.objHomeVM.instructionsVw
            let dict = self.objHomeVM.objCurrentRequestModel
            view?.colVwInstructions.reloadData()
            view?.lblOrderId.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.orderIdSpa : TitleValue.orderId) \(dict.orderId)"
            view?.lblPickupLocation.text = dict.pickupLocation
            view?.lblDropupLocation.text = dict.dropupLocation
            view?.lblFloorNo.text = dict.pickupFloorNo != "" ? dict.pickupFloorNo : "N/A"
            view?.lblContactNo.text = dict.pickupContactNo != "" ? dict.pickupContactNo : "N/A"
            view?.lblBuildingBlock.text = dict.pickupBuildingBlock != "" ? dict.pickupBuildingBlock : "N/A"
            view?.lblRoomNo.text = dict.pickupRoomNo != "" ? dict.pickupRoomNo : "N/A"
            view?.lblContactName.text = dict.pickupContactName != "" ? dict.pickupContactName : "N/A"
            view?.lblInstructions.text = dict.desc != "" ? dict.desc : "N/A"
            view?.colVwHeightCnst.constant = dict.arrFiles.count == 0 ? 0 : 80
            view?.vwOrderId.hideLoader()
            view?.vwOrderDetail.hideLoader()
            view?.vwInstruction.hideLoader()
        })
    }
    func showEndJourneyView() {
        vwMain.isHidden = false
        self.vwMainHeightCnst.constant = 200
        UIView.animate(withDuration: 0.8, delay: 0.1, options: .curveEaseOut, animations: {
            self.objHomeVM.endJourneyVw.frame =  CGRect(x: 0, y: 0, width: Double(self.vwMain.frame.width), height: Double(self.vwMain.frame.height))
            self.vwMain.addSubview(self.objHomeVM.endJourneyVw)
            self.view.layoutIfNeeded()
        }, completion:{ finish in
            let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
            let view = self.objHomeVM.endJourneyVw
            let dict = objUserModel.objAccepRequestModel
            view?.lblOrderId.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.orderIdSpa : TitleValue.orderId) \(self.objHomeVM.orderId)"
            view?.lblRm.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.cashCollectSpa : TitleValue.cashCollect) \(dict.currencySymbol) \(dict.amount) \(dict.currency)"
            self.objHomeVM.endJourneyVw.vwBg.hideLoader()
        })
    }
    func showRatingView() {
        vwMain.isHidden = false
        if #available(iOS 13.0, *) {
            self.vwMainHeightCnst.constant = DeviceInfo.DeviceHeight - ((SceneDelegateInstance!.window?.safeAreaInsets.top)! + (SceneDelegateInstance!.window?.safeAreaInsets.bottom)! + 84)
        } else {
            self.vwMainHeightCnst.constant = DeviceInfo.DeviceHeight - ((KAppDelegate.window?.safeAreaInsets.top)! + (KAppDelegate.window?.safeAreaInsets.bottom)! + 84)
        }
        UIView.animate(withDuration: 0.8, delay: 0.1, options: .curveEaseOut, animations: {
            self.objHomeVM.ratingVw.frame =  CGRect(x: 0, y: 0, width: Double(self.vwMain.frame.width), height: Double(self.vwMain.frame.height))
            self.vwMain.addSubview(self.objHomeVM.ratingVw)
            self.view.layoutIfNeeded()
        }, completion:{ finish in
            let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
            let view = self.objHomeVM.ratingVw
            let dict = objUserModel.objAccepRequestModel
            view?.lblOrderNo.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.orderNoSpa : TitleValue.orderNo) \(self.objHomeVM.orderId)"
            view?.lblDeliveryTime.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.deliveryTimeSpa : TitleValue.deliveryTime) \(dict.deliveryTime)"
            view?.orderId = self.objHomeVM.orderId
            self.objHomeVM.ratingVw.vwBg.hideLoader()
        })
    }
    //MARK:- Map Methods
    func setDefaultLocation() {
        vwMap.clear()
        if Proxy.shared.getLatitude() != "" && Proxy.shared.getLongitude() != "" {
            let currentLat = Proxy.shared.getLatitude()
            let currentLong = Proxy.shared.getLongitude()
            let sourceLocation = CLLocationCoordinate2D(latitude: Double(currentLat)! as CLLocationDegrees, longitude: Double(currentLong)! as CLLocationDegrees)
            vwMap.delegate = self
            vwMap.isBuildingsEnabled = true
            vwMap?.isMyLocationEnabled = true
            vwMap.setRegionMap(sourceLocation: sourceLocation)
            vwMap.settings.myLocationButton = false
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(currentLat)!, longitude: Double(currentLong)!))
            marker.icon = #imageLiteral(resourceName: "ic_marker")
            marker.map = vwMap
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        vwMap.settings.myLocationButton = true
    }
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        setDefaultLocation()
        return true
    }
    
    func showUserDetail() {
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        let text = lang == ChooseLanguage.spanish.rawValue ? "Conductor ID:" : "Driver ID:"
        lblDriverId.text = "\(text) \(objUserModel.userId)"
        btnProfileImg.sd_setImage(with: URL(string: objUserModel.profile), for: .normal, placeholderImage: #imageLiteral(resourceName: "ic_default_user"))
        btnSwitch.setImage(objUserModel.workStatus == DriverStatus.online.rawValue || objUserModel.workStatus == DriverStatus.busy.rawValue ? UIImage(named: "ic_online") : UIImage(named: "ic_offline"), for: .normal)
        lblOnline.isHidden = objUserModel.workStatus == DriverStatus.offline.rawValue
        lblOffline.isHidden = objUserModel.workStatus == DriverStatus.online.rawValue || objUserModel.workStatus == DriverStatus.busy.rawValue
        if objUserModel.objAccepRequestModel.bookingId != "" {
            setupJourneyDetailView {
                self.objHomeVM.startJourneyVw.setUp(parentView: self.vwMain) {
                    if objUserModel.objAccepRequestModel.bookingType == "\(BookingType.scheduled.rawValue)" {
                        if Date().stringFromFormat("yyyy-MM-dd HH:mm:ss") > objUserModel.objAccepRequestModel.pickupDate {
                            self.showStartJourneyView()
                        }
                    } else {
                        self.showStartJourneyView()
                    }
                }
            }
        }
    }
    func startJourneyAnnotation() {
        vwMap.clear()
        let dict = objUserModel.objAccepRequestModel
        if dict.pickupLat != "" && dict.pickupLong != "" {
            let sourceLocation = CLLocationCoordinate2D(latitude: Double(dict.pickupLat)! as CLLocationDegrees, longitude: Double(dict.pickupLong)! as CLLocationDegrees)
            vwMap.isBuildingsEnabled = true
            vwMap?.isMyLocationEnabled = true
            vwMap.settings.myLocationButton = false
            vwMap.setRegionMap(sourceLocation: sourceLocation)
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(dict.pickupLat)!, longitude: Double(dict.pickupLong)!))
            marker.icon = #imageLiteral(resourceName: "ic_blk_loc_top")
            marker.title = TitleValue.pickupLocation.localized
            marker.appearAnimation = .pop
            marker.opacity = 0.85
            marker.isFlat = true
            marker.map = vwMap
            vwMap.selectedMarker = marker
        }
    }
    func makeOrderLocationAnnotation() {
        vwMap.clear()
        if Proxy.shared.getLatitude() != "" && Proxy.shared.getLongitude() != "" {
            let currentLat = Proxy.shared.getLatitude()
            let currentLong = Proxy.shared.getLongitude()
            let sourceLocation = CLLocationCoordinate2D(latitude: Double(currentLat)! as CLLocationDegrees, longitude: Double(currentLong)! as CLLocationDegrees)
            vwMap.delegate = self
            vwMap.isBuildingsEnabled = true
            vwMap?.isMyLocationEnabled = true
            vwMap.setRegionMap(sourceLocation: sourceLocation)
            vwMap.settings.myLocationButton = false
            let userMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(currentLat)!, longitude: Double(currentLong)!))
            // here add icon
            //            switch objUserModel.vehicleCat {
            //            case "\(VehicleCategory.motorCycle.rawValue)","\(VehicleCategory.motorCycleTrasnport.rawValue)":
            //                userMarker.icon = #imageLiteral(resourceName: "ic_bike")
            //            case "\(VehicleCategory.car.rawValue)","\(VehicleCategory.carTransport.rawValue)":
            //                userMarker.icon = #imageLiteral(resourceName: "ic_car")
            //            case "\(VehicleCategory.van.rawValue)":
            //                userMarker.icon = #imageLiteral(resourceName: "ic_van")
            //            case "\(VehicleCategory.truck.rawValue)":
            //                userMarker.icon = #imageLiteral(resourceName: "ic_truck")
            //            case "\(VehicleCategory.lorry.rawValue)":
            //                userMarker.icon = #imageLiteral(resourceName: "ic_lorry")
            //            case "\(VehicleCategory.suv.rawValue)":
            //                userMarker.icon = #imageLiteral(resourceName: "ic_car")
            //            case "\(VehicleCategory.miniBus.rawValue)","\(VehicleCategory.bus.rawValue)":
            //                userMarker.icon = #imageLiteral(resourceName: "ic_minibus")
            //            case "\(VehicleCategory.pickupTruck.rawValue)":
            //                userMarker.icon = #imageLiteral(resourceName: "ic_pickuptruck")
            //            case "\(VehicleCategory.vanTransport.rawValue)":
            //                userMarker.icon = #imageLiteral(resourceName: "ic_minitruck")
            //            case "\(VehicleCategory.miniTruck.rawValue)":
            //                userMarker.icon = #imageLiteral(resourceName: "ic_lorry")
            //            default:
            //                break
            //            }
            // userMarker.map = vwMap
            let dict = objUserModel.objAccepRequestModel
            if dict.pickupLat != "" && dict.pickupLong != "" {
                let destinationLoc = CLLocationCoordinate2D(latitude: Double(dict.pickupLat)!, longitude: Double(dict.pickupLong)!)
                let pickUpmarker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(dict.pickupLat)!, longitude: Double(dict.pickupLong)!))
                pickUpmarker.icon = #imageLiteral(resourceName: "ic_blk_loc_top")
                pickUpmarker.title = TitleValue.pickupLocation.localized
                pickUpmarker.appearAnimation = .pop
                pickUpmarker.opacity = 0.85
                pickUpmarker.isFlat = true
                pickUpmarker.map = vwMap
                vwMap.selectedMarker = pickUpmarker
                LocationManagerClass.sharedLocationManager().drawRouteOnMap(from: sourceLocation, to: destinationLoc, wayPointsArray: [], mapView: vwMap, polyLineColor: .black, completion: {(path,distance,time)   in
                    self.showDistanceTime(distance, time: time)
                    self.vwMap.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: path), withPadding: 130))
                    
                })
                self.objHomeVM.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.updateDriverRoute), userInfo: nil, repeats: true)
            }
        }
    }
    func makeCompleteOrderAnnotation() {
        vwMap.clear()
        if Proxy.shared.getLatitude() != "" && Proxy.shared.getLongitude() != "" {
            let currentLat = Proxy.shared.getLatitude()
            let currentLong = Proxy.shared.getLongitude()
            let sourceLocation = CLLocationCoordinate2D(latitude: Double(currentLat)! as CLLocationDegrees, longitude: Double(currentLong)! as CLLocationDegrees)
            self.vwMap.isBuildingsEnabled = true
            self.vwMap?.isMyLocationEnabled = true
            self.vwMap.settings.myLocationButton = false
            objHomeVM.driverMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(currentLat)!, longitude: Double(currentLong)!))
            //  let head = locationManager.location?.course ?? 0
            // objHomeVM.driverMarker.rotation = Proxy.shared.getCourse()
            //            switch objUserModel.vehicleCat {
            //
            //            case "\(VehicleCategory.motorCycle.rawValue)","\(VehicleCategory.motorCycleTrasnport.rawValue)":
            //                objHomeVM.driverMarker.icon = #imageLiteral(resourceName: "ic_bike")
            //            case "\(VehicleCategory.car.rawValue)","\(VehicleCategory.carTransport.rawValue)":
            //                objHomeVM.driverMarker.icon = #imageLiteral(resourceName: "ic_car")
            //            case "\(VehicleCategory.van.rawValue)":
            //                objHomeVM.driverMarker.icon = #imageLiteral(resourceName: "ic_van")
            //            case "\(VehicleCategory.truck.rawValue)":
            //                objHomeVM.driverMarker.icon = #imageLiteral(resourceName: "ic_truck")
            //            case "\(VehicleCategory.lorry.rawValue)":
            //                objHomeVM.driverMarker.icon = #imageLiteral(resourceName: "ic_lorry")
            //            case "\(VehicleCategory.suv.rawValue)":
            //                objHomeVM.driverMarker.icon = #imageLiteral(resourceName: "ic_car")
            //            case "\(VehicleCategory.miniBus.rawValue)","\(VehicleCategory.bus.rawValue)":
            //                objHomeVM.driverMarker.icon = #imageLiteral(resourceName: "ic_minibus")
            //            case "\(VehicleCategory.pickupTruck.rawValue)":
            //                objHomeVM.driverMarker.icon = #imageLiteral(resourceName: "ic_pickuptruck")
            //            case "\(VehicleCategory.vanTransport.rawValue)":
            //                objHomeVM.driverMarker.icon = #imageLiteral(resourceName: "ic_minitruck")
            //            case "\(VehicleCategory.miniTruck.rawValue)":
            //                objHomeVM.driverMarker.icon = #imageLiteral(resourceName: "ic_lorry")
            //            default:
            //                break
            //            }
            // objHomeVM.driverMarker.map = vwMap
            // objHomeVM.markerArray.add(objHomeVM.driverMarker)
            vwMap.setRegionMap(sourceLocation: sourceLocation)
            let dict = objUserModel.objAccepRequestModel
            if dict.destLat != "" && dict.destLong != ""  {
                let destinationLoc = CLLocationCoordinate2D(latitude: Double(dict.destLat)!, longitude: Double(dict.destLong)!)
                //let middleLoc = CLLocationCoordinate2D(latitude: Double(currentLat)!, longitude: Double(currentLong)!)
                
                let dropoffMarker = GMSMarker(position: destinationLoc)
                dropoffMarker.icon =  #imageLiteral(resourceName: "ic_blk_loc_top")
                dropoffMarker.title = TitleValue.dropLocation.localized
                dropoffMarker.map = self.vwMap
                vwMap.selectedMarker = dropoffMarker
                objHomeVM.markerArray.add(dropoffMarker)
                LocationManagerClass.sharedLocationManager().drawRouteOnMap(from: sourceLocation, to: destinationLoc, wayPointsArray: [], mapView: vwMap, polyLineColor: .black, completion: {(path,distance,time)   in
                    self.showDistanceTime(distance, time: time)
                    self.vwMap.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: path), withPadding: 130))
                    
                })
                self.objHomeVM.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.updateDriverRoute), userInfo: nil, repeats: true)
            }
        }
    }
    @objc func updateDriverRoute() {
        if Proxy.shared.getLatitude() != "" && Proxy.shared.getLongitude() != "" {
            let currentLat = Proxy.shared.getLatitude()
            let currentLong = Proxy.shared.getLongitude()
            let sourceLocation = CLLocationCoordinate2D(latitude: Double(currentLat)! as CLLocationDegrees, longitude: Double(currentLong)! as CLLocationDegrees)
            objHomeVM.driverCoordinate = sourceLocation
            //updateMarkerPosition()
        }
    }
    func updateMarkerPosition() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(3.0)
        // let value = CGAffineTransform(rotationAngle: CGFloat(M_PI * (Proxy.shared.getCourse()) / 180.0))
        // objHomeVM.driverMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        objHomeVM.driverMarker.rotation = objHomeVM.driverMarker.rotation - Proxy.shared.getCourse()
        //(Double.pi * (Proxy.shared.getCourse()) / 180.0)
        objHomeVM.driverMarker.position = objHomeVM.driverCoordinate
        CATransaction.commit()
        
        
    }
    func passCurrentHead() {
        updateMarkerPosition()
    }
    func passCurrentLoc() {
        vwMap.clear()
        objHomeVM.markerArray = []
        if Proxy.shared.getLatitude() != "" && Proxy.shared.getLongitude() != "" {
            let currentLat = Proxy.shared.getLatitude()
            let currentLong = Proxy.shared.getLongitude()
            let sourceLocation = CLLocationCoordinate2D(latitude: Double(currentLat)! as CLLocationDegrees, longitude: Double(currentLong)! as CLLocationDegrees)
            objHomeVM.driverMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(currentLat)!, longitude: Double(currentLong)!))
            //  let head = locationManager.location?.course ?? 0
            //objHomeVM.driverMarker.rotation = Proxy.shared.getCourse()
            //            switch objUserModel.vehicleCat {
            //
            //            case "\(VehicleCategory.motorCycle.rawValue)","\(VehicleCategory.motorCycleTrasnport.rawValue)":
            //                objHomeVM.driverMarker.icon = #imageLiteral(resourceName: "ic_bike")
            //            case "\(VehicleCategory.car.rawValue)","\(VehicleCategory.carTransport.rawValue)":
            //                objHomeVM.driverMarker.icon = #imageLiteral(resourceName: "ic_car")
            //            case "\(VehicleCategory.van.rawValue)":
            //                objHomeVM.driverMarker.icon = #imageLiteral(resourceName: "ic_van")
            //            case "\(VehicleCategory.truck.rawValue)":
            //                objHomeVM.driverMarker.icon = #imageLiteral(resourceName: "ic_truck")
            //            case "\(VehicleCategory.lorry.rawValue)":
            //                objHomeVM.driverMarker.icon = #imageLiteral(resourceName: "ic_lorry")
            //            case "\(VehicleCategory.suv.rawValue)":
            //                objHomeVM.driverMarker.icon = #imageLiteral(resourceName: "ic_car")
            //            case "\(VehicleCategory.miniBus.rawValue)","\(VehicleCategory.bus.rawValue)":
            //                objHomeVM.driverMarker.icon = #imageLiteral(resourceName: "ic_minibus")
            //            case "\(VehicleCategory.pickupTruck.rawValue)":
            //                objHomeVM.driverMarker.icon = #imageLiteral(resourceName: "ic_pickuptruck")
            //            case "\(VehicleCategory.vanTransport.rawValue)":
            //                objHomeVM.driverMarker.icon = #imageLiteral(resourceName: "ic_minitruck")
            //            case "\(VehicleCategory.miniTruck.rawValue)":
            //                objHomeVM.driverMarker.icon = #imageLiteral(resourceName: "ic_lorry")
            //            default:
            //                break
            //            }
            //            objHomeVM.driverMarker.map = vwMap
            //            objHomeVM.markerArray.add(objHomeVM.driverMarker)
            let dict = objUserModel.objAccepRequestModel
            if dict.destLat != "" && dict.destLong != ""  {
                let destinationLoc = CLLocationCoordinate2D(latitude: Double(dict.destLat)!, longitude: Double(dict.destLong)!)
                //let middleLoc = CLLocationCoordinate2D(latitude: Double(currentLat)!, longitude: Double(currentLong)!)
                // here comment
                //                let dropoffMarker = GMSMarker(position: destinationLoc)
                //                                       dropoffMarker.icon =  #imageLiteral(resourceName: "ic_blk_loc_top")
                //                                       dropoffMarker.title = TitleValue.dropLocation.localized
                //                                       dropoffMarker.map = self.vwMap
                //                                       vwMap.selectedMarker = dropoffMarker
                //                                       objHomeVM.markerArray.add(dropoffMarker)
                /// here comment
                
                // here add check
                if objUserModel.objAccepRequestModel.bookingType == "\(BookingType.scheduled.rawValue)" {
                    
                    if Date().stringFromFormat("yyyy-MM-dd HH:mm:ss") > objUserModel.objAccepRequestModel.pickupDate {
                        self.showStartJourneyView()
                        let dropoffMarker = GMSMarker(position: destinationLoc)
                        dropoffMarker.icon =  #imageLiteral(resourceName: "ic_blk_loc_top")
                        dropoffMarker.title = TitleValue.dropLocation.localized
                        dropoffMarker.map = self.vwMap
                        vwMap.selectedMarker = dropoffMarker
                        objHomeVM.markerArray.add(dropoffMarker)
                        
                        LocationManagerClass.sharedLocationManager().drawRouteOnMap(from: sourceLocation, to: destinationLoc, wayPointsArray: [], mapView: vwMap, polyLineColor: .black, completion: {(path,distance,time)   in
                        })
                    } else{
                        setDefaultLocation()
                    }
                } else {
                    let dropoffMarker = GMSMarker(position: destinationLoc)
                    dropoffMarker.icon =  #imageLiteral(resourceName: "ic_blk_loc_top")
                    dropoffMarker.title = TitleValue.dropLocation.localized
                    dropoffMarker.map = self.vwMap
                    vwMap.selectedMarker = dropoffMarker
                    objHomeVM.markerArray.add(dropoffMarker)
                    
                    LocationManagerClass.sharedLocationManager().drawRouteOnMap(from: sourceLocation, to: destinationLoc, wayPointsArray: [], mapView: vwMap, polyLineColor: .black, completion: {(path,distance,time)   in
                    })
                }
            }
        }
    }
    func showPickDetails() {
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        let view = self.objHomeVM.startJourneyVw
        let dict = objUserModel.objAccepRequestModel
        view?.colVwJourney.reloadData()
        view?.lblOrderId.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.orderIdSpa : TitleValue.orderId) \(dict.bookingId)"
        view?.lblPickupLocation.text = dict.pickupLocation
        view?.lblDropupLocation.text = dict.dropupLocation
        view?.lblFloorNo.text = dict.pickupFloorNo != "" ? dict.pickupFloorNo : "N/A"
        view?.lblContactNo.text = dict.pickupContactNo != "" ? dict.pickupContactNo : "N/A"
        view?.lblBuildingBlock.text = dict.pickupBuildingBlock != "" ? dict.pickupBuildingBlock : "N/A"
        view?.lblRoomNo.text = dict.pickupRoomNo != "" ? dict.pickupRoomNo : "N/A"
        view?.lblContactName.text = dict.pickupContactName != "" ? dict.pickupContactName : "N/A"
        view?.colVwHeightCnst.constant = dict.arrFiles.count == 0 ? 0 : 80
        view?.vwOrderId.hideLoader()
        view?.vwOrderDetail.hideLoader()
        view?.vwInstruction.hideLoader()
    }
    func showDropDetails() {
        let view = self.objHomeVM.startJourneyVw
        let dict = objUserModel.objAccepRequestModel
        view?.lblPickUpOrderDetail.text = TitleValue.dropOffDetail.localized
        view?.lblRoomNo.text = dict.dropRoomNo != "" ? dict.dropRoomNo : "N/A"
        view?.lblFloorNo.text = dict.dropFloorNo != "" ? dict.dropFloorNo : "N/A"
        view?.lblBuildingBlock.text = dict.dropBuildingBlock != "" ? dict.dropBuildingBlock : "N/A"
        view?.lblContactName.text = dict.dropContactName != "" ? dict.dropContactName : "N/A"
        view?.lblContactNo.text = dict.dropContactNo != "" ? dict.dropContactNo : "N/A"
    }
    func showDistanceTime(_ distance: Double, time: Double) {
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        let value = objHomeVM.showOnMapVw
        value?.lblDistance.isHidden = false
        value?.lblTime.isHidden = false
        value?.lblDistance.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.distanceSpa : TitleValue.distance) \(distance)KM"
        value?.lblTime.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.timeSpa : TitleValue.time) \(time)mins"
    }
}

extension GMSMapView {
    func setRegionMap(sourceLocation: CLLocationCoordinate2D, zoomLevel : Float = 12.0)  {
        let camera = GMSCameraPosition.camera(withLatitude: sourceLocation.latitude, longitude: sourceLocation.longitude, zoom: zoomLevel)
        self.camera = camera
    }
}

extension HomeVC: AcceptRequest {
    func setRoot() {
        setupJourneyDetailView {
            self.objHomeVM.startJourneyVw.setUp(parentView: self.vwMain) {
                if objUserModel.objAccepRequestModel.bookingType == "\(BookingType.scheduled.rawValue)" {
                    if Date().stringFromFormat("yyyy-MM-dd HH:mm:ss") > objUserModel.objAccepRequestModel.pickupDate {
                        self.showStartJourneyView()
                    }
                } else {
                    self.showStartJourneyView()
                }
            }
        }
    }
}

extension HomeVC: SignatureData {
    func endJourney(_ path: UIImage) {
        objHomeVM.orderId = objUserModel.objAccepRequestModel.bookingId
        objHomeVM.startJourneyVw.objStartJourneyVM.signaturePath = path
        objHomeVM.startJourneyVw.objStartJourneyVM.hitUpdateBookingApi(objUserModel.objAccepRequestModel.bookingId, state: "\(StateRequest.completed.rawValue)") {
            objUserModel.objAccepRequestModel.bookingId = ""
            self.setupEndJourneyView {
                self.objHomeVM.endJourneyVw.setUp(parentView: self.vwMain) {
                    self.showEndJourneyView()
                }
            }
        }
    }
}

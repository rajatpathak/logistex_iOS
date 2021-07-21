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

class GetNearByDriverVC: UIViewController {
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var vwLocation: GMSMapView!
    @IBOutlet weak var imgVwProfile: UIImageView!
    @IBOutlet weak var lblHeaderPickupLoc: UILabel!
    @IBOutlet weak var vwTrackOrder: UIView!
    @IBOutlet weak var imgVwVehicle: UIImageView!
    @IBOutlet weak var imgVwDriver: UIImageView!
    @IBOutlet weak var imgVwDrop: UIImageView!
    @IBOutlet weak var imgVwPickup: UIImageView!
    @IBOutlet weak var imgVwStart: UIImageView!
    @IBOutlet weak var lblDriverState: UILabel!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblVehicleNumber: UILabel!
    @IBOutlet weak var lblVehicleBrand: UILabel!
    @IBOutlet weak var lblVehicleColor: UILabel!
    @IBOutlet weak var vwStratLine: UIView!
    @IBOutlet weak var vwPickLine: UIView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var vwTimings: UIView!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var btnCancelRide: UIButton!
    @IBOutlet weak var btnNavigate: UIButton!
    
    //MARK:- Object
    var objGetNearByDriverVM = GetNearByDriverVM()
    var objBookingDetailVM = BookingDetailVM()
    var markerDriver = GMSMarker()
    var createdRoute = false
    var oldPolyLines = [GMSPolyline]()
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if self.title == PassTitles.accepted {
            let controller = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: IdentifiersVC.driverFound.rawValue) as! DriverFoundVC
            controller.objBookingDetailVM.detailId = objGetNearByDriverVM.bookingId
            if #available(iOS 13.0, *) {
                let sceneDelegate = UIApplication.shared.connectedScenes
                    .first!.delegate as! SceneDelegate
                sceneDelegate.window?.rootViewController?.present(controller, animated: true, completion: nil)
            } else {
                KAppDelegate.window?.rootViewController?.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getOrderDetailNotification), name: NSNotification.Name(rawValue: "TrackOrder"), object: nil)
        getBookingDetailApi()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.title = ""
        objGetNearByDriverVM.timer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func getOrderDetailNotification(_ notification: NSNotification) {
        let dict = notification.object as? NSDictionary
        let orderId = dict?["orderId"] as? Int
        objGetNearByDriverVM.type = dict?["typeId"] as? Int ?? 0
        objGetNearByDriverVM.bookingId = orderId ?? 0
        getBookingDetailApi()
    }
    //MARK:- Map Methods
    func setDefaultLocation() {
        vwLocation.clear()
        vwTimings.isHidden = true
        let bookingModel = objBookingDetailVM.objBookingDetailModel
        if bookingModel.pickupLat != "" && bookingModel.pickupLong != "" {
            let sourceLocation = CLLocationCoordinate2D(latitude: Double(bookingModel.pickupLat)! as CLLocationDegrees, longitude: Double(bookingModel.pickupLong)! as CLLocationDegrees)
            vwLocation.isBuildingsEnabled = true
            vwLocation?.isMyLocationEnabled = true
            vwLocation.setRegionMap(sourceLocation: sourceLocation)
            vwLocation.settings.myLocationButton = false
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(bookingModel.pickupLat)!, longitude: Double(bookingModel.pickupLong)!))
            marker.icon = #imageLiteral(resourceName: "ic_pickUp")
            marker.title = PassTitles.pickupLocation.localized
            marker.appearAnimation = .pop
            marker.opacity = 0.85
            marker.isFlat = true
            marker.map = vwLocation
            vwLocation.selectedMarker = marker
            LocationServiceProxy.shared.addressMethod(lat: Proxy.shared.getLatitude(), long: Proxy.shared.getLongitude()) { (addressvalue) in
                self.lblHeaderPickupLoc.text = addressvalue
            }
        }
    }
    @objc func updateStartDriverStatus() {
        let bookingModel = objBookingDetailVM.objBookingDetailModel
        objGetNearByDriverVM.getDriverLocationApi(bookingModel.id) { (dict) in
            let currentLat = dict.getValueInString(dict["current_lat"] as AnyObject)
            let currentLong = dict.getValueInString(dict["current_long"] as AnyObject)
            self.setStartLocation(lat: currentLat, long: currentLong)
        }
    }
    @objc func updatePickUpDriverStatus() {
        let bookingModel = objBookingDetailVM.objBookingDetailModel
        objGetNearByDriverVM.getDriverLocationApi(bookingModel.id) { (dict) in
            let currentLat = dict.getValueInString(dict["current_lat"] as AnyObject)
            let currentLong = dict.getValueInString(dict["current_long"] as AnyObject)
            self.setPickupLocation(lat: currentLat, long: currentLong)
        }
    }
    //MARK:- Map Methods
    func setPickupLocation(lat: String, long: String) {
        
        //        if createdRoute{
        //            print("Already created")
        //            if lat != "" && long != "" {
        //                let sourceLocation = CLLocationCoordinate2D(latitude: Double(lat)! as CLLocationDegrees, longitude: Double(long)! as CLLocationDegrees)
        //                markerDriver = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!))
        //
        //                self.updateMarkerPosition(sourceLocation)
        //            }
        //        }else{
        //  self.vwLocation.clear()
        vwTimings.isHidden = false
        if lat != "" && long != "" {
            let sourceLocation = CLLocationCoordinate2D(latitude: Double(lat)! as CLLocationDegrees, longitude: Double(long)! as CLLocationDegrees)
            let bookingModel = objBookingDetailVM.objBookingDetailModel
            if !self.createdRoute{
                vwLocation.isBuildingsEnabled = true
                vwLocation?.isMyLocationEnabled = true
                vwLocation.setRegionMap(sourceLocation: sourceLocation)
                vwLocation.settings.myLocationButton = false
                markerDriver = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!))
                // new
                if bookingModel.trackingIcon != "" {
                    let url  = NSURL(string :bookingModel.trackingIcon)!
                    let imageData   = NSData.init(contentsOf: url as URL)!
                    let str64 = imageData.base64EncodedData(options: .lineLength64Characters)
                    let data  = NSData(base64Encoded: str64 , options: .ignoreUnknownCharacters)!
                    let dataImage = UIImage(data: data as Data)
                    markerDriver.icon = dataImage
                    self.markerDriver.icon = self.image(dataImage!, scaledToSize: CGSize(width: 20, height: 55))
                } else {
                    markerDriver.icon = #imageLiteral(resourceName: "ic_taxi")
                }
                markerDriver.map = vwLocation
            }
            imgVwStart.isHighlighted = true
            imgVwPickup.isHighlighted = true
            vwStratLine.backgroundColor = Color.red
            lblDriverState.text = PassTitles.pickedUp.localized
            
            let dropLocation = CLLocationCoordinate2D(latitude: Double(bookingModel.destLat)! as CLLocationDegrees, longitude: Double(bookingModel.destLong)! as CLLocationDegrees)
            if !self.createdRoute{
                let dropMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(bookingModel.destLat)!, longitude: Double(bookingModel.destLong)!))
                dropMarker.icon = #imageLiteral(resourceName: "ic_dropOff")
                dropMarker.title = PassTitles.dropOffLocation.localized
                dropMarker.appearAnimation = .pop
                dropMarker.opacity = 0.85
                dropMarker.isFlat = true
                dropMarker.map = vwLocation
                vwLocation.selectedMarker = markerDriver
            }
            LocationServiceProxy.shared.addressMethod(lat: Proxy.shared.getLatitude(), long: Proxy.shared.getLongitude()) { (addressvalue) in
                self.lblHeaderPickupLoc.text = addressvalue
            }
            LocationServiceProxy.shared.drawRoute(sourceLoc: sourceLocation, destinationLoc: dropLocation) { (route,error) in
                if let error = error {
                    if error != ""{
                        Proxy.shared.displayStatusAlert(message: error, state: .error)
                        return
                    }
                }
                
                if let polylines = route?.polylines {
                    let path: GMSPath = GMSPath(fromEncodedPath: polylines as String)!
                    let routePolyline = GMSPolyline(path: path)
                    routePolyline.strokeWidth = 2.5
                    let strokeStyles = [GMSStrokeStyle.solidColor(.black), GMSStrokeStyle.solidColor(.clear)]
                    let strokeLengths = [NSNumber(value: 10), NSNumber(value: 10)]
                    
                    routePolyline.spans = GMSStyleSpans(path, strokeStyles, strokeLengths, .rhumb)
                    routePolyline.strokeColor = .black
                    if self.oldPolyLines.count > 0 {
                        for polyline in self.oldPolyLines {
                            polyline.map = nil
                        }
                    }
                    self.oldPolyLines.append(routePolyline)
                    routePolyline.map = self.vwLocation
                    let distanceKm = round((Double((route?.distance ?? 0))/1000)*0.621371)
                    let time = round((Double((route?.time ?? 0))/60)*0.621371)
                    self.lblTime.text = "\(PassTitles.time.localized) \(time)\(PassTitles.minute.localized)"
                    self.lblDistance.text = "\(PassTitles.distance.localized) \(distanceKm)KM"
                    if !self.createdRoute{
                        self.vwLocation.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: path), withPadding: 50))
                        self.createdRoute = true
                    }else{
                        
                        self.updateMarkerPosition(sourceLocation)
                    }
                }
            }
        }
    }
    //MARK:- Set Size of marker Icon
    fileprivate func image(_ originalImage:UIImage, scaledToSize:CGSize) -> UIImage {
        if originalImage.size.equalTo(scaledToSize) {
            return originalImage
        }
        UIGraphicsBeginImageContextWithOptions(scaledToSize, false, 0.0)
        originalImage.draw(in: CGRect(x: 0, y: 0, width: scaledToSize.width, height: scaledToSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    func updateMarkerPosition(_ driverCord: CLLocationCoordinate2D) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        markerDriver.position = driverCord
        CATransaction.commit()
    }
    //MARK:- Map Methods
    func setStartLocation(lat: String, long: String) {
        vwLocation.clear()
        vwTimings.isHidden = false
        if lat != "" && long != "" {
            let sourceLocation = CLLocationCoordinate2D(latitude: Double(lat)! as CLLocationDegrees, longitude: Double(long)! as CLLocationDegrees)
            vwLocation.isBuildingsEnabled = true
            vwLocation?.isMyLocationEnabled = true
            vwLocation.setRegionMap(sourceLocation: sourceLocation)
            vwLocation.settings.myLocationButton = false
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!))
            let bookingModel = objBookingDetailVM.objBookingDetailModel
            // new
            if bookingModel.trackingIcon != "" {
                let url  = NSURL(string :bookingModel.trackingIcon)!
                let imageData   = NSData.init(contentsOf: url as URL)!
                let str64 = imageData.base64EncodedData(options: .lineLength64Characters)
                let data  = NSData(base64Encoded: str64 , options: .ignoreUnknownCharacters)!
                let dataImage = UIImage(data: data as Data)
                marker.icon = dataImage
                marker.icon = self.image(dataImage!, scaledToSize: CGSize(width: 20, height: 55))
            } else {
                marker.icon = #imageLiteral(resourceName: "ic_01")
            }
            marker.map = vwLocation
            imgVwStart.isHighlighted = true
            lblDriverState.text = PassTitles.onWay.localized
            LocationServiceProxy.shared.addressMethod(lat: Proxy.shared.getLatitude(), long: Proxy.shared.getLongitude()) { (addressvalue) in
                self.lblHeaderPickupLoc.text = addressvalue
            }
            let dropLocation = CLLocationCoordinate2D(latitude: Double(bookingModel.destLat)! as CLLocationDegrees, longitude: Double(bookingModel.destLong)! as CLLocationDegrees)
            LocationServiceProxy.shared.drawRoute(sourceLoc: sourceLocation, destinationLoc: dropLocation) { (route,error) in
                if let error = error {
                    if error != ""{
                        Proxy.shared.displayStatusAlert(message: error, state: .error)
                        return
                    }
                }
                let distanceKm = round((Double((route?.distance ?? 0))/1000)*0.621371)
                let time = round((Double((route?.time ?? 0))/60)*0.621371)
                self.lblTime.text = "\(PassTitles.time.localized) \(time)\(PassTitles.minute.localized)"
                self.lblDistance.text = "\(PassTitles.distance.localized) \(distanceKm)KM"
            }
        }
    }
    //MARK:- IBActions
    @IBAction func actionCallDriver(_ sender: Any) {
        let bookingModel = objBookingDetailVM.objBookingDetailModel
        if let phoneCallURL = URL(string: "telprompt://\(bookingModel.driverContact)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    application.openURL(phoneCallURL as URL)
                }
            }
        }
    }
    
    @IBAction func actionChat(_ sender: Any) {
        let objPushVC = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        objPushVC.objChatVM.toUserId = "\(objBookingDetailVM.objBookingDetailModel.driverId)"
        objPushVC.objChatVM.toUserName = "\(objBookingDetailVM.objBookingDetailModel.driverName)"
        objPushVC.objChatVM.bookingId = "\(objBookingDetailVM.objBookingDetailModel.id)"
        self.navigationController?.pushViewController(objPushVC, animated: true)
    }
    @IBAction func actionCancelRide(_ sender: Any) {
        cancelBookingAlert()
    }
    func cancelBookingAlert() {
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        let value = "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.cancelBookingSpa : PassTitles.cancelBooking)"
        let controller = UIAlertController(title: AppInfo.appName, message: value, preferredStyle: .alert)
        let valueBtnYes = "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.yesSpa : PassTitles.yes)"
        
        let okAction = UIAlertAction(title: valueBtnYes, style: .default) { (action) in
            self.objGetNearByDriverVM.getCancelBookingApi("\(self.objBookingDetailVM.objBookingDetailModel.id)") {
                self.rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC)
            }
        }
        let cancelAction = UIAlertAction(title: AlertMessages.no.localized, style: .default, handler: nil)
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        controller.view.tintColor = Color.app
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func actionDrawer(_ sender: Any) {
        KAppDelegate.sideMenuVC.openLeft()
    }
    @IBAction func actionNavigate(_ sender: Any) {
        let bookingModel = objBookingDetailVM.objBookingDetailModel
        Proxy.shared.openGoogleMap(currentLat: Proxy.shared.getLatitude(), currentLong: Proxy.shared.getLongitude(),destinationLat: bookingModel.destLat, destinationLong: bookingModel.destLong)
    }
    func setDriverDetail() {
        objGetNearByDriverVM.timer?.invalidate()
        let bookingModel = objBookingDetailVM.objBookingDetailModel
        imgVwProfile.sd_setImage(with: URL(string: objUserModel.profileImage), placeholderImage: #imageLiteral(resourceName: "ic_drawer_pic"))
        imgVwDriver.sd_setImage(with: URL(string: bookingModel.driverProfile), placeholderImage: #imageLiteral(resourceName: "ic_drawer_pic"))
        lblDriverName.text = "\(bookingModel.driverName)"
        lblVehicleNumber.text = "\(AlertMessages.vehicleNumber.localized) \(bookingModel.vehicleNo)"
        lblVehicleBrand.text =  bookingModel.vehicleBrand
        lblVehicleColor.text = AlertMessages.vehicleColor.localized + " \(bookingModel.vehicleColor)"
        imgVwVehicle.sd_setImage(with: URL(string: bookingModel.vehicleImgFile), placeholderImage: #imageLiteral(resourceName: "ic_01"))
        switch objBookingDetailVM.objBookingDetailModel.stateId {
        case BookingState.pickup.rawValue:
            btnCancelRide.isHidden = true
        default:
            btnCancelRide.isHidden = false
        }
        btnNavigate.isHidden = true
        switch objGetNearByDriverVM.type {
        case BookingState.active.rawValue:
            setDefaultLocation()
        case BookingState.inProgress.rawValue:
            btnNavigate.isHidden = false
            objGetNearByDriverVM.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateStartDriverStatus), userInfo: nil, repeats: true)
        case BookingState.pickup.rawValue:
            btnNavigate.isHidden = false
            objGetNearByDriverVM.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updatePickUpDriverStatus), userInfo: nil, repeats: true)
        case BookingState.completed.rawValue:
            DispatchQueue.main.async {
                let objController = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: "RateBookingVC") as! RateBookingVC
                objController.objRateBookingVM.objBookingModel = bookingModel
                objController.title = PassTitles.fromTrack
                self.navigationController?.pushViewController(objController, animated: true)
            }
        default:
            break
        }
    }
    
    func getBookingDetailApi() {
        objBookingDetailVM.getBookingDetail(objGetNearByDriverVM.bookingId) {
            DispatchQueue.main.async {
                self.setDriverDetail()
            }
        }
    }
}

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
import MapKit
import GoogleMaps

class SelectVehicleTypeVC: UIViewController {
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var imgVwProfile: UIImageView!
    @IBOutlet weak var lblHeaderPickupLoc: UILabel!
    @IBOutlet weak var clcVwNearByVehicles: UICollectionView!
    @IBOutlet weak var vwMapShowEndPoints: GMSMapView!
    @IBOutlet weak var btnBookNow: UIButton!
    @IBOutlet weak var cnstHeightBtnBookNow: NSLayoutConstraint!
    @IBOutlet weak var imgVwSelectedVehicle: UIImageView!
    @IBOutlet weak var cnstHeightVwAdditional: NSLayoutConstraint!
    @IBOutlet weak var vwAdditionalDetails: UIView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblTotalCharges: UILabel!
    @IBOutlet weak var lblAdditionalServices: UILabel!
    @IBOutlet weak var cnstHeightClcVw: NSLayoutConstraint!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var cnstWidthBackBtn: NSLayoutConstraint!
    
    //MARK:- Variable
    let objSelectVehicleTypeVM = SelectVehicleTypeVM()
    
    //MARK:- Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    //MARK:- Functoni set Data
    func setData(){
        imgVwProfile.sd_setImage(with: URL(string: objUserModel.profileImage), placeholderImage: #imageLiteral(resourceName: "ic_drawer_pic"))
        lblHeaderPickupLoc.text = KAppDelegate.bookPostDict.dictValue["Booking[pickup_location]"]!
        setDefaultLocation()
        cnstHeightVwAdditional.constant = 0
        vwAdditionalDetails.isHidden = true
        cnstHeightBtnBookNow.constant = 0
        cnstWidthBackBtn.constant = 0
        btnBack.isHidden = true
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        btnBookNow.setTitle("\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.confirmBookingSpa : PassTitles.confirmBooking)", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        objSelectVehicleTypeVM.arrNearbyVehicleModel = []
        objSelectVehicleTypeVM.getNearbyCars{
            self.clcVwNearByVehicles.reloadData()
        }
    }
    
    func setDefaultLocation() {
        //MARK:- PickUP Location & marker setup
        let pickUpLong =  Double(KAppDelegate.bookPostDict.dictValue["Booking[pickup_longitude]"]!) ?? 76.7179
        let pickUpLat =  Double(KAppDelegate.bookPostDict.dictValue["Booking[pickup_latitude]"]!) ?? 76.7179
        let pickUpLoc = CLLocationCoordinate2D(latitude: pickUpLat, longitude: pickUpLong )
        
        self.objSelectVehicleTypeVM.dropOffMarker = LocationServiceProxy.shared.showAnnotationOnMapReturnMarker(cordinates: pickUpLoc, mapView: self.vwMapShowEndPoints, markerIcon: UIImage(named: "ic_pickUp")!, address: "")
        
        //MARK:- DropOff Location & marker setup
        let dropOffLong = Double(KAppDelegate.bookPostDict.dictValue["Booking[destination_longitude]"]!) ?? 76.7179
        let dropOffLat = Double(KAppDelegate.bookPostDict.dictValue["Booking[destination_latitude]"]!) ?? 30.7046
        let dropOffLoc = CLLocationCoordinate2D(latitude: dropOffLat, longitude: dropOffLong)
        
        LocationServiceProxy.shared.showAnnotationOnMap(cordinates: dropOffLoc, mapView: self.vwMapShowEndPoints, markerIcon: UIImage(named: "ic_dropOff")!, address: "")
        self.drawRoute(sourceLocation: pickUpLoc, destinationLoation: dropOffLoc, strokeColor: .black , calculateDistance: true)
    }
    
    func drawRoute(sourceLocation: CLLocationCoordinate2D, destinationLoation: CLLocationCoordinate2D, strokeColor:UIColor, calculateDistance: Bool) {
        LocationServiceProxy.shared.drawRoute(sourceLoc: sourceLocation, destinationLoc: destinationLoation) { (route, error) in
            if let error = error {
                if error != ""{
                    Proxy.shared.displayStatusAlert(message: error, state: .error)
                    return
                }
            }
            
            if let polylines = route?.polylines {
                let path: GMSPath = GMSPath(fromEncodedPath: polylines as String)!
                let routePolyline = GMSPolyline(path: path)
                // routePolyline.geodesic = true
                routePolyline.strokeWidth = 2.5
                let strokeStyles = [GMSStrokeStyle.solidColor(strokeColor), GMSStrokeStyle.solidColor(.clear)]
                let strokeLengths = [NSNumber(value: 10), NSNumber(value: 10)]
                
                routePolyline.spans = GMSStyleSpans(path, strokeStyles, strokeLengths, .rhumb)
                routePolyline.strokeColor = strokeColor
                routePolyline.map = self.vwMapShowEndPoints
                
                if calculateDistance {
                    let distanceKm = round((Double((route?.distance)!)/1000)*0.621371)
                    // self.lblKm.text = "\(distanceKm) KM"
                }
                self.vwMapShowEndPoints.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: path), withPadding: 50))
            }
        }
    }
    
    
    //MARK:- IBACTIONS
    @IBAction func actionBack(_ sender: UIButton) {
        btnBack.isHidden = true
        cnstWidthBackBtn.constant = 0
        cnstHeightClcVw.constant = 0
        clcVwNearByVehicles.isHidden = false
    }
    
    @IBAction func actionDrawer(_ sender: UIButton) {
        KAppDelegate.bookPostDict.dictValue.updateValue("", forKey: "Booking[destination_location]")
        KAppDelegate.bookPostDict.dictValue.updateValue("", forKey: "Booking[destination_latitude]")
        KAppDelegate.bookPostDict.dictValue.updateValue("", forKey: "Booking[destination_longitude]")
        self.rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC)
    }
    
    @IBAction func actionBookNow(_ sender: UIButton) {
        KAppDelegate.bookPostDict.dictValue.updateValue("\(self.objSelectVehicleTypeVM.arrNearbyVehicleModel[self.objSelectVehicleTypeVM.selectedIndex].distance)", forKey: "Booking[distance]")
        
//        if (lblAdditionalServices.text?.contains("\(objUserModel.currency) 0.0"))! {
//            KAppDelegate.bookPostDict.dictValue.updateValue("\(KAppDelegate.bookPostDict.dictValue["Booking[amount]"] ?? "")", forKey: "Booking[amount]")
//        }
        cnstHeightClcVw.constant = 0
        clcVwNearByVehicles.isHidden = true
        
        // btnBack.isHidden = false
        //cnstWidthBackBtn.constant = 80
        btnBack.isHidden = true
        cnstWidthBackBtn.constant = 0
        
        //if sender.isSelected {
        let objPushVC = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
        objPushVC.distance = objSelectVehicleTypeVM.distance.roundValuesUpto2Points(uptoPoints: 3) + " \(PassTitles.miles.localized)"
        self.navigationController?.pushViewController(objPushVC, animated: true)
        //}
        //sender.isSelected = true
    }
    
    @IBAction func actionAdditionalServices(_ sender: UIButton) {
        
        objAdditionalServicesDelegate = self
        if  self.objSelectVehicleTypeVM.selectedType != self.objSelectVehicleTypeVM.arrNearbyVehicleModel[self.objSelectVehicleTypeVM.selectedIndex].typeId {
            objSelectVehicleTypeVM.objAdditionalServicesVM.getAdditonalServicesList(typeId: "\(objSelectVehicleTypeVM.arrNearbyVehicleModel[objSelectVehicleTypeVM.selectedIndex].typeId)") {
                
                //TO CHECK FOR NEXT COMPILITATION
                self.objSelectVehicleTypeVM.selectedType = self.objSelectVehicleTypeVM.arrNearbyVehicleModel[self.objSelectVehicleTypeVM.selectedIndex].typeId
                
                let objAdditionalServicesVC = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: IdentifiersVC.additionalServicesVC.rawValue) as! AdditionalServicesVC
                objAdditionalServicesVC.objAdditionalServicesVM.arrAdditionalServicesModel = self.objSelectVehicleTypeVM.objAdditionalServicesVM.arrAdditionalServicesModel
                self.present(objAdditionalServicesVC, animated: true, completion: nil)
            }
        } else {
            self.objSelectVehicleTypeVM.selectedType = self.objSelectVehicleTypeVM.arrNearbyVehicleModel[self.objSelectVehicleTypeVM.selectedIndex].typeId
            
            let objAdditionalServicesVC = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: IdentifiersVC.additionalServicesVC.rawValue) as! AdditionalServicesVC
            objAdditionalServicesVC.objAdditionalServicesVM.arrAdditionalServicesModel = self.objSelectVehicleTypeVM.objAdditionalServicesVM.arrAdditionalServicesModel
            self.present(objAdditionalServicesVC, animated: true, completion: nil)
        }
    }
}

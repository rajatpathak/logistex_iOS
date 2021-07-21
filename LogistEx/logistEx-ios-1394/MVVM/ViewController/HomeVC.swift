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
import GooglePlacesSearchController
import Lightbox

class HomeVC: UIViewController {
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var vwLocation: GMSMapView!
    @IBOutlet weak var imgVwProfile: UIImageView!
    @IBOutlet weak var lblHeaderPickupLoc: UILabel!
    @IBOutlet weak var lblDropLoc: UILabel!
    @IBOutlet weak var lblPickupLoc: UILabel!
    @IBOutlet weak var btnDrop: UIButton!
    @IBOutlet weak var btnPickUp: UIButton!
    
    //MARK:- Variables
    var objHomeVM = HomeVM()
    
    lazy var placesSearchController: GooglePlacesSearchController = {
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        
        let controller = GooglePlacesSearchController(delegate: self, apiKey: ApiKey.googleMapsPlacesApi, placeType: .all,searchBarPlaceholder: PassTitles.enterAddress.localized
            // Optional: coordinate: CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423),
            // Optional: radius: 10,
            // Optional: strictBounds: true,
            // Optional: searchBarPlaceholder: "Start typing..."(
        )
        let cancelBtnTitle = "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.cancelBtnSpa : PassTitles.cancelBtn)"
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = cancelBtnTitle
        
        //Optional: controller.searchBar.isTranslucent = false
        //Optional: controller.searchBar.barStyle = .black
        //Optional: controller.searchBar.tintColor = .white)
        //Optional: controller.searchBar.barTintColor = .black
        return controller
        
    }()
    
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        objPassDataDelegate = self
        objSearchDriverDelegate = self
        objTrackOrderDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(getBookigNotification), name: NSNotification.Name(rawValue: "GetAddress"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.white)
        
        LocationManagerClass.sharedLocationManager().startStandardUpdates()
        imgVwProfile.sd_setImage(with: URL(string: objUserModel.profileImage), placeholderImage: #imageLiteral(resourceName: "ic_drawer_pic"))
        
        if KAppDelegate.bookPostDict.dictValue["Booking[pickup_location]"] != "" {
            setDefaultLocation()
            lblHeaderPickupLoc.text = KAppDelegate.bookPostDict.dictValue["Booking[pickup_location]"] == "" ? PassTitles.pickUpAt.localized : KAppDelegate.bookPostDict.dictValue["Booking[pickup_location]"]
            lblPickupLoc.text = KAppDelegate.bookPostDict.dictValue["Booking[pickup_location]"] == "" ? PassTitles.pickUpAt.localized :  KAppDelegate.bookPostDict.dictValue["Booking[pickup_location]"]
            lblDropLoc.text = (KAppDelegate.bookPostDict.dictValue["Booking[destination_location]"] == "") ? PassTitles.dropAt.localized : KAppDelegate.bookPostDict.dictValue["Booking[destination_location]"]
        } else {
            lblDropLoc.text = (KAppDelegate.bookPostDict.dictValue["Booking[destination_location]"] == "") ? PassTitles.dropAt.localized : KAppDelegate.bookPostDict.dictValue["Booking[destination_location]"]
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.setDefaultLocation()
            }
        }
    }
    
    //MARK:- IBACTIONS
    @objc func getBookigNotification(_ notification: NSNotification) {
        setDefaultLocation()
    }
    @IBAction func actionDrop (_ sender: UIButton) {
        if Proxy.shared.getLatitude() == "0.0" || Proxy.shared.getLongitude() == "0.0" {
            LocationManagerClass.sharedLocationManager().showAlert(title: AlertMessages.locationServiceOff, message: AlertMessages.turnOnLocationServiceFromSetting)
        } else {
            objSearchDriverDelegate = self
            btnDrop.isSelected  = true
            btnPickUp.isSelected = false
            
            present(placesSearchController, animated: true, completion: nil)
            
        }
    }
    
    
    @IBAction func actionPickup (_ sender: UIButton) {
        if Proxy.shared.getLatitude() == "0.0" || Proxy.shared.getLongitude() == "0.0" {
            LocationManagerClass.sharedLocationManager().showAlert(title: AlertMessages.locationServiceOff, message: AlertMessages.turnOnLocationServiceFromSetting)
        } else {
            objSearchDriverDelegate = self
            btnDrop.isSelected  = false
            btnPickUp.isSelected = true
            present(placesSearchController, animated: true, completion: nil)
        }
    }
    
    @IBAction func actionOpenImage(_ sender: Any) {
        if Proxy.shared.accessTokenNil() == "" {
            rootWithoutDrawer(selectedStoryboard: .main, identifier: .loginVC)
        } else {
            pushVC(selectedStoryboard: .main, identifier: IdentifiersVC.myProfileVC, titleVal: PassTitles.fromHome)
        }
    }
    @IBAction func actionDrawer(_ sender: UIButton) {
        KAppDelegate.sideMenuVC.openLeft()
    }
    
    @IBAction func actionBookingType(_ sender: UIButton) {
        if Proxy.shared.getLatitude() == "0.0" || Proxy.shared.getLongitude() == "0.0" {
            LocationManagerClass.sharedLocationManager().showAlert(title: AlertMessages.locationServiceOff, message: AlertMessages.turnOnLocationServiceFromSetting)
        } else {
            if lblPickupLoc.text! == PassTitles.pickUpAt.localized {
                Proxy.shared.displayStatusAlert(message: AlertMessages.selectPickup.localized, state: .warning)
            } else if lblDropLoc.text! == PassTitles.dropAt.localized {
                Proxy.shared.displayStatusAlert(message: AlertMessages.selectDestination.localized, state: .warning)
            } else {
                presentVC(selectedStoryboard: .main, identifier: .bookTypeVC)
            }
        }
    }
    
    //MARK:- Map Methods
    func setDefaultLocation() {
        vwLocation.clear()
        if Proxy.shared.getLatitude() != "" && Proxy.shared.getLongitude() != "" {
            let currentLat = Proxy.shared.getLatitude()
            let currentLong = Proxy.shared.getLongitude()
            let sourceLocation = CLLocationCoordinate2D(latitude: Double(currentLat)! as CLLocationDegrees, longitude: Double(currentLong)! as CLLocationDegrees)
            vwLocation.delegate = self
            vwLocation.isBuildingsEnabled = true
            vwLocation?.isMyLocationEnabled = true
            vwLocation.setRegionMap(sourceLocation: sourceLocation)
            vwLocation.settings.myLocationButton = false
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(currentLat)!, longitude: Double(currentLong)!))
            // marker.icon = #imageLiteral(resourceName: "ic_red_small_loc")
            marker.map = vwLocation
            if  KAppDelegate.bookPostDict.dictValue["Booking[pickup_location]"] != "" {
                
            } else {
                //DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                LocationServiceProxy.shared.addressMethod(lat: currentLat, long: currentLong) { (addressvalue) in
                    self.lblHeaderPickupLoc.text = addressvalue
                    self.lblPickupLoc.text = addressvalue
                    KAppDelegate.bookPostDict.dictValue.updateValue(addressvalue, forKey: "Booking[pickup_location]")
                    KAppDelegate.bookPostDict.dictValue.updateValue(Proxy.shared.getLatitude(), forKey: "Booking[pickup_latitude]")
                    KAppDelegate.bookPostDict.dictValue.updateValue(Proxy.shared.getLongitude(), forKey: "Booking[pickup_longitude]")
                }
                //}
            }
        }
    }
}

extension HomeVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        vwLocation.settings.myLocationButton = true
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        setDefaultLocation()
        return true
    }
}

extension HomeVC: PassDataDelegate, SearchDriverDelegate, TrackOrderDelegate {
    func push(orderId: Int, type: Int, title: String) {
        
        if title == PassTitles.schedule{
            self.rootWithDrawer(selectedStoryboard: .main, identifier: .myBookingsVC)
            Proxy.shared.displayStatusAlert(message: "Driver accepted your schedule booking", state: .success)

//            let objPushVC = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: IdentifiersVC.driverFound.rawValue) as! DriverFoundVC
//            objPushVC.objBookingDetailVM.detailId = orderId
//            if #available(iOS 13.0, *) {
//                let sceneDelegate = UIApplication.shared.connectedScenes
//                    .first!.delegate as! SceneDelegate
//                sceneDelegate.window?.rootViewController?.present(objPushVC, animated: true, completion: nil)
//            } else {
//                KAppDelegate.window?.rootViewController?.present(objPushVC, animated: true, completion: nil)
//            }
            
        }else{
            let objPushVC = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: IdentifiersVC.nearByDriver.rawValue) as! GetNearByDriverVC
            objPushVC.objGetNearByDriverVM.bookingId = orderId
            objPushVC.objGetNearByDriverVM.type = type
            objPushVC.title = title
            self.navigationController?.pushViewController(objPushVC, animated: true)
        }
    }
    
    func setData(orderId: String) {
        let controller = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: IdentifiersVC.cancelbookingVC.rawValue) as! CancelbookingVC
        controller.title = orderId
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
    
    func push(moveTo: String) {
        if moveTo == "login" {
            pushVC(selectedStoryboard: .main, identifier: .loginVC)
        } else if moveTo == "notify" {
            presentVC(selectedStoryboard: .main, identifier: .notifyVC)
        } else if moveTo == "refreshMapData" {
            //will be used in future
            
            // lblHeaderPickupLoc.text = KAppDelegate.bookPostDict.dictValue["Booking[pickup_location]"] == "" ? PassTitles.pickUpAt.localized : KAppDelegate.bookPostDict.dictValue["Booking[pickup_location]"]
            // lblPickupLoc.text = KAppDelegate.bookPostDict.dictValue["Booking[pickup_location]"] == "" ? PassTitles.pickUpAt.localized :  KAppDelegate.bookPostDict.dictValue["Booking[pickup_location]"]
            
            lblDropLoc.text = (KAppDelegate.bookPostDict.dictValue["Booking[destination_location]"] == "") ? PassTitles.dropAt.localized : KAppDelegate.bookPostDict.dictValue["Booking[destination_location]"]
            
        }  else {
            pushVC(selectedStoryboard: .main, identifier: .selectVehicleTypeVC)
        }
    }
}

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

class AddressDetailVC: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var vwMapAdddressDetail: GMSMapView!
    @IBOutlet weak var lblSelectedAddress: UILabel!
    @IBOutlet weak var btnSetLocation: UIButton!
    @IBOutlet weak var txtFldRoom: UITextField!
    @IBOutlet weak var txtFldFloor: UITextField!
    @IBOutlet weak var txtFldBuildingBlock: UITextField!
    @IBOutlet weak var txtFldContactName: UITextField!
    @IBOutlet weak var txtFldContactPhone: UITextField!
    
    //MARK:- Variable
    let objAddressDetailVM = AddressDetailVM()
    
    //MARK:- GooglePlacesSearchController Declaration
    lazy var placesSearchController: GooglePlacesSearchController = {
        let controller = GooglePlacesSearchController(delegate: self, apiKey: ApiKey.googleMapsPlacesApi, placeType: .all)
        return controller
    }()
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if self.title == PassTitles.dropOff {
            btnSetLocation.setTitle(PassTitles.setDropOffLoc.localized, for: .normal)
        } else {
            btnSetLocation.setTitle(PassTitles.setPickUpLoc.localized, for: .normal)
        }
        UITextField.connectAllTxtFieldFields(txtfields: [txtFldRoom,txtFldFloor,txtFldBuildingBlock,txtFldContactName,txtFldContactPhone])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setDefaultLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Proxy.shared.hideActivityIndicator()
    }
    
    //MARK:- IBACTIONS
    @IBAction func actionDismiss(_ sender: Any) {
        self.dismissController()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        dismissController()
    }
    @IBAction func actionChange(_ sender: Any) {
        
        present(placesSearchController, animated: true, completion: nil)
        
    }
    
    @IBAction func actionSetLocation(_ sender: Any) {
        
        defer {
            print(KAppDelegate.bookPostDict)
            dismissController()
            objPassDataDelegate?.push(moveTo: "refreshMapData")
        }

        if btnSetLocation.currentTitle == PassTitles.setDropOffLoc.localized {
            KAppDelegate.bookPostDict.dictValue.updateValue(txtFldFloor.text ?? "", forKey: "Booking[floor]")
            KAppDelegate.bookPostDict.dictValue.updateValue(txtFldRoom.text ?? "", forKey: "Booking[room_no]")
            KAppDelegate.bookPostDict.dictValue.updateValue(txtFldBuildingBlock.text ?? "", forKey: "Booking[building_block]")
            KAppDelegate.bookPostDict.dictValue.updateValue(txtFldContactName.text ?? "", forKey: "Booking[contact_name]")
            KAppDelegate.bookPostDict.dictValue.updateValue(txtFldContactPhone.text ?? "", forKey: "Booking[contact_number]")
        } else {
            KAppDelegate.bookPostDict.dictValue.updateValue(txtFldFloor.text ?? "", forKey: "Booking[pickup_floor]")
            KAppDelegate.bookPostDict.dictValue.updateValue(txtFldRoom.text ?? "", forKey: "Booking[pickup_room]")
            KAppDelegate.bookPostDict.dictValue.updateValue(txtFldBuildingBlock.text ?? "", forKey: "Booking[pickup_block]")
            KAppDelegate.bookPostDict.dictValue.updateValue(txtFldContactName.text ?? "", forKey: "Booking[pickup_contact_name]")
            KAppDelegate.bookPostDict.dictValue.updateValue(txtFldContactPhone.text ?? "", forKey: "Booking[pickup_contact_number]")
        }
    }
    
    //MARK:- Map Methods
    func setDefaultLocation() {
        vwMapAdddressDetail.clear()
        var currentLat = ""
        var currentLong = ""
        
        if self.title == PassTitles.dropOff {
            currentLat =  KAppDelegate.bookPostDict.dictValue["Booking[destination_latitude]"]!
            currentLong = KAppDelegate.bookPostDict.dictValue["Booking[destination_longitude]"]!
            lblSelectedAddress.text = KAppDelegate.bookPostDict.dictValue["Booking[destination_location]"]!
        } else {
            currentLat = KAppDelegate.bookPostDict.dictValue["Booking[pickup_latitude]"]!
            currentLong = KAppDelegate.bookPostDict.dictValue["Booking[pickup_longitude]"]!
            lblSelectedAddress.text = KAppDelegate.bookPostDict.dictValue["Booking[pickup_location]"]!
        }
        
        let sourceLocation = CLLocationCoordinate2D(latitude: Double(currentLat)!, longitude: Double(currentLong)!)
        vwMapAdddressDetail.delegate = self
        vwMapAdddressDetail.isBuildingsEnabled = true
        vwMapAdddressDetail?.isMyLocationEnabled = false
        vwMapAdddressDetail.settings.myLocationButton = false
        vwMapAdddressDetail.setRegionMap(sourceLocation: sourceLocation)
    }
}

extension AddressDetailVC: GMSMapViewDelegate {
    
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        self.title = ""
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        vwMapAdddressDetail.settings.myLocationButton = true
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        setCurrnentLocation()
        return true
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
    }
    
    //MARK:- Camera change Position this methods will call every time
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        if self.title == "" {
            LocationServiceProxy.shared.addressMethod(lat: "\(position.target.latitude)",  long: "\(position.target.longitude)") { addressValue in
                self.lblSelectedAddress.text = addressValue
            }
            
            if btnSetLocation.currentTitle == PassTitles.setDropOffLoc.localized {
                KAppDelegate.bookPostDict.dictValue.updateValue(self.lblSelectedAddress.text!, forKey: "Booking[destination_location]")
                KAppDelegate.bookPostDict.dictValue.updateValue("\(position.target.latitude)", forKey: "Booking[destination_latitude]")
                KAppDelegate.bookPostDict.dictValue.updateValue("\(position.target.longitude)", forKey: "Booking[destination_longitude]")
            } else {
                KAppDelegate.bookPostDict.dictValue.updateValue(self.lblSelectedAddress.text!, forKey: "Booking[pickup_location]")
                KAppDelegate.bookPostDict.dictValue.updateValue("\(position.target.latitude)", forKey: "Booking[pickup_latitude]")
                KAppDelegate.bookPostDict.dictValue.updateValue("\(position.target.longitude)", forKey: "Booking[pickup_longitude]")
            }
        }
    }
    
    //MARK:- Map Methods
    func setCurrnentLocation() {
        
        vwMapAdddressDetail.clear()
        if Proxy.shared.getLatitude() != "" && Proxy.shared.getLongitude() != "" {
            let currentLat = Proxy.shared.getLatitude()
            let currentLong = Proxy.shared.getLongitude()
            let sourceLocation = CLLocationCoordinate2D(latitude: Double(currentLat)! as CLLocationDegrees, longitude: Double(currentLong)! as CLLocationDegrees)
            vwMapAdddressDetail.delegate = self
            vwMapAdddressDetail.isBuildingsEnabled = true
            vwMapAdddressDetail?.isMyLocationEnabled = true
            vwMapAdddressDetail.setRegionMap(sourceLocation: sourceLocation)
            vwMapAdddressDetail.settings.myLocationButton = false
        }
    }
}

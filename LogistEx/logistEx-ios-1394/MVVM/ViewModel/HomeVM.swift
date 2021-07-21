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
import GooglePlaces
import GoogleMaps
import GooglePlacesSearchController
import Lightbox

class HomeVM: NSObject{
    
}

extension GMSMapView {
    func setRegionMap(sourceLocation: CLLocationCoordinate2D, zoomLevel : Float = AppInfo.zoomLevel)  {
        let camera = GMSCameraPosition.camera(withLatitude: sourceLocation.latitude, longitude: sourceLocation.longitude, zoom: zoomLevel)
        self.camera = camera
    }
}

extension HomeVC: GooglePlacesAutocompleteViewControllerDelegate {
    
    func viewController(didAutocompleteWith place: PlaceDetails) {
        Proxy.shared.showActivityIndicator()
        if btnDrop.isSelected {
            lblDropLoc.text = place.formattedAddress
            
            KAppDelegate.bookPostDict.dictValue.updateValue(place.formattedAddress, forKey: "Booking[destination_location]")
            KAppDelegate.bookPostDict.dictValue.updateValue("\(place.coordinate!.latitude)", forKey: "Booking[destination_latitude]")
            KAppDelegate.bookPostDict.dictValue.updateValue("\(place.coordinate!.longitude)", forKey: "Booking[destination_longitude]")
        } else {
            lblPickupLoc.text = place.formattedAddress
            lblHeaderPickupLoc.text = place.formattedAddress
            KAppDelegate.bookPostDict.dictValue.updateValue(place.formattedAddress, forKey: "Booking[pickup_location]")
            KAppDelegate.bookPostDict.dictValue.updateValue("\(place.coordinate!.latitude)", forKey: "Booking[pickup_latitude]")
            KAppDelegate.bookPostDict.dictValue.updateValue("\(place.coordinate!.longitude)", forKey: "Booking[pickup_longitude]")
            
        }
        placesSearchController.isActive = false
        presentVC(selectedStoryboard: .main, identifier: .addressDetailVC, titleVal: btnDrop.isSelected ? PassTitles.dropOff : PassTitles.pickUP)
    }
}
extension HomeVC: LightboxControllerPageDelegate, LightboxControllerDismissalDelegate  {
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        debugPrint(page)
    }
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
    }
}

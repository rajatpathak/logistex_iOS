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
import GooglePlacesSearchController

class AddressDetailVM: NSObject {
    
    var cameFrom = String()
    
}

extension AddressDetailVC : GooglePlacesAutocompleteViewControllerDelegate {
    
    func viewController(didAutocompleteWith place: PlaceDetails) {
        if btnSetLocation.currentTitle == PassTitles.setDropOffLoc.localized {
            KAppDelegate.bookPostDict.dictValue.updateValue(place.formattedAddress, forKey: "Booking[destination_location]")
            KAppDelegate.bookPostDict.dictValue.updateValue("\(place.coordinate!.latitude)", forKey: "Booking[destination_latitude]")
            KAppDelegate.bookPostDict.dictValue.updateValue("\(place.coordinate!.longitude)", forKey: "Booking[destination_longitude]")
        } else {
            KAppDelegate.bookPostDict.dictValue.updateValue(place.formattedAddress, forKey: "Booking[pickup_location]")
            KAppDelegate.bookPostDict.dictValue.updateValue("\(place.coordinate!.latitude)", forKey: "Booking[pickup_latitude]")
            KAppDelegate.bookPostDict.dictValue.updateValue("\(place.coordinate!.longitude)", forKey: "Booking[pickup_longitude]")
        }
        
        let sourceLocation = CLLocationCoordinate2D(latitude: place.coordinate!.latitude, longitude: place.coordinate!.longitude)
        vwMapAdddressDetail.delegate = self
        vwMapAdddressDetail.isBuildingsEnabled = true
        vwMapAdddressDetail?.isMyLocationEnabled = false
        vwMapAdddressDetail.settings.myLocationButton = false
        vwMapAdddressDetail.setRegionMap(sourceLocation: sourceLocation)
        lblSelectedAddress.text = place.formattedAddress
        placesSearchController.isActive = false
    }
}
extension AddressDetailVC: UITextFieldDelegate {

func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
{
    if textField == txtFldContactPhone  {
        if range.location >= 16  {
            return false
        }
    }
    return true
}
}

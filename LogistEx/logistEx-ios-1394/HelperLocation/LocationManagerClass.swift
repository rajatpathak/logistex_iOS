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
import CoreMotion
import CoreLocation
import Alamofire

var locationUpdates = Bool()

var locationShareInstance = LocationManagerClass()

class LocationManagerClass: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Class Variables
    var locationManager = CLLocationManager()
    
    class func sharedLocationManager() -> LocationManagerClass {
        locationShareInstance = LocationManagerClass()
        return locationShareInstance
    }
    var timer = Timer()
    
    func startStandardUpdates() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation
        locationManager.distanceFilter = 10
        locationManager.pausesLocationUpdatesAutomatically = false
        if (Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationUpdates = true
        locationManager.startUpdatingLocation()
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates  = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        UserDefaults.standard.set("\(location.coordinate.latitude)", forKey: "lat")
        UserDefaults.standard.set("\(location.coordinate.longitude)", forKey: "long")
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                var addressString = String()
                if placemark.subLocality != nil {
                    addressString = addressString + placemark.subLocality! + ", "
                }
                if placemark.thoroughfare != nil {
                    addressString = addressString + placemark.thoroughfare! + ", "
                }
                if placemark.locality != nil {
                    addressString = addressString + placemark.locality! + ", "
                }
                if placemark.country != nil {
                    addressString = addressString + placemark.country! + ", "
                }
                if placemark.postalCode != nil {
                    addressString = addressString + placemark.postalCode! + " "
                }
                print(addressString)
                
            }
        }
        
        UserDefaults.standard.synchronize()
    }
    
    func stopStandardUpdate(){
        DispatchQueue.main.async  {
            self.timer.invalidate()
        }
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = false
        }
        locationUpdates = false
        locationManager.stopUpdatingLocation()
    }
    
    //MARK:- WHEN DENIED
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied {
            UserDefaults.standard.set("\(0.0)", forKey: "lat")
            UserDefaults.standard.set("\(0.0)", forKey: "long")
            self.generateAlertToNotifyUser()
        }
    }
    
    func generateAlertToNotifyUser() {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            showAlert(title: AlertTitle.locationProblem, message: AlertMessages.canNotDetermineYourLocation)
        }
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
            showAlert(title: AlertMessages.locationServiceOff, message: AlertMessages.turnOnLocationServiceFromSetting)
        }
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            startStandardUpdates()
        }
    }
    
    //MARK:- Show Alert of Location Problem
    func showAlert(title: String, message:String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let callFunction = UIAlertAction(title: AlertTitle.setting, style: UIAlertAction.Style.default, handler:
        { action in
            let url:URL = URL(string: UIApplication.openSettingsURLString)!
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (success) in })
            } else {
                guard UIApplication.shared.openURL(url) else {
                    Proxy.shared.displayStatusAlert(message: AlertMessages.reviewYourNetworkConnection, state: .error)
                    return
                }
            }
        })
        let dismiss = UIAlertAction(title: AlertTitle.cancel, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(callFunction)
        alert.addAction(dismiss)
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
            sceneDelegate.window!.rootViewController?.present(alert, animated: true, completion: nil)
        } else {
            KAppDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}


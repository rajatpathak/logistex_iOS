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
import GoogleMaps
import GooglePlaces
import Alamofire
protocol PassLocationDelegate {
    func passCurrentLoc()
    func passCurrentHead()
    
}
var objPassLocationDelegate:PassLocationDelegate?

var locationShareInstance:LocationManagerClass = LocationManagerClass()

class LocationManagerClass: NSObject, CLLocationManagerDelegate , UIAlertViewDelegate {
    // MARK: - Class Variables
    
    var locationManager = CLLocationManager()
    var timer = Timer()
    
    class func sharedLocationManager() -> LocationManagerClass {
        locationShareInstance = LocationManagerClass()
        return locationShareInstance
    }
    
    func startStandardUpdates() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType    = .automotiveNavigation
        locationManager.distanceFilter  = 100
        // meters
        locationManager.pausesLocationUpdatesAutomatically = false
        
        if (Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates  = false
        } else {
            // Fallback on earlier versions
        }
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(LocationManagerClass.updateDriverStatusFake), userInfo: nil, repeats: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        UserDefaults.standard.set("\(location.coordinate.latitude)", forKey: "lat")
        UserDefaults.standard.set("\(location.coordinate.longitude)", forKey: "long")
        
        fetchCityAndCountry(from: location) { (area, error)  in
            guard let city = area, error == nil else { return }
            
            UserDefaults.standard.set(area, forKey: "address")
        }
        
        UserDefaults.standard.synchronize()
        if objUserModel.objAccepRequestModel.bookingId != "" {
            objPassLocationDelegate?.passCurrentLoc()
        }
        updateDriverStatus()
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let heading = newHeading.trueHeading
        UserDefaults.standard.set(heading, forKey: "head")
        UserDefaults.standard.synchronize()
        objPassLocationDelegate?.passCurrentHead()
    }
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city:String?,_ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            
            let val = placemarks?.first!.subAdministrativeArea
            let subLocality = placemarks?.first!.subLocality
            let locality = placemarks?.first!.locality
            let country = placemarks?.first!.country
            let finalAddress: String =   "\(val ?? "") \(subLocality ?? "") \(locality ?? "") \(country ?? "")"
            completion(finalAddress, error)
        }
    }
    
    func stopStandardUpdate(){
        DispatchQueue.main.async {
            self.timer.invalidate()
        }
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = false
        } else {
            // Fallback on earlier versions
        }
        locationManager.stopUpdatingLocation()
    }
    @objc func updateDriverStatusFake() {
        
    }
    //MARK:- Update Driver Location
    @objc func updateDriverStatus() {
        let driverLat = UserDefaults.standard.object(forKey: "lat") as? String ?? ""
        let driverLong = UserDefaults.standard.object(forKey: "long") as? String ?? ""
        let authCode = Proxy.shared.accessTokenNil()
        if authCode != "" {
            if NetworkReachabilityManager()!.isReachable {
                let param = [
                    "User[latitude]": driverLat,
                    "User[longitude]": driverLong
                ]
                request("\(Apis.serverUrl)\(Apis.updateLocation)?access-token=\(Proxy.shared.accessTokenNil())", method: .post, parameters: param as Parameters, encoding: URLEncoding.httpBody,headers:["Authorization": "Bearer \(Proxy.shared.accessTokenNil())","User-Agent":"\(AppInfo.userAgent)"])
                    .responseJSON { response in
                        do {
                            if (response.response?.statusCode == 200) {
                                if (response.result.value as? NSDictionary) != nil {
                                    let json = response.result.value as! NSDictionary
                                    
                                }
                            }
                        }
                    }
            } else {
                Proxy.shared.openSettingApp()
            }
        }
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
            showAlert(title: AlertMessages.locationProblem, message: AlertMessages.canNotDetermineYourLocation)
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
        let callFunction = UIAlertAction(title: AlertMessages.setting, style: UIAlertAction.Style.default, handler:
                                            { action in
                                                let url:URL = URL(string: UIApplication.openSettingsURLString)!
                                                if #available(iOS 10, *) {
                                                    UIApplication.shared.open(url, options: [:], completionHandler: {
                                                                                (success) in })
                                                } else {
                                                    guard UIApplication.shared.openURL(url) else {
                                                        Proxy.shared.displayStatusAlert(AlertMessages.reviewNetworkConn)
                                                        return
                                                    }
                                                }
                                            })
        let dismiss = UIAlertAction(title: AlertMessages.cancel, style: UIAlertAction.Style.cancel, handler: nil)
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
    //MARK:- Draw Polyline On Map
    func drawRouteOnMap(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D,wayPointsArray:[CLLocationCoordinate2D],mapView: GMSMapView, polyLineColor: UIColor, completion:@escaping(_ path:GMSPath, _ distance: Double, _ time: Double) -> Void){
        self.drawRoute(from, to, wayPointArray: wayPointsArray, mapVw: mapView) { (polylines, error, distance,time)   in
            if let error = error {
                Proxy.shared.displayStatusAlert(error)
                return
            }
            
            if let polylines = polylines {
                let path: GMSPath = GMSPath(fromEncodedPath: polylines as String)!
                let routePolyline = GMSPolyline(path: path)
                routePolyline.strokeWidth = 3.0
                routePolyline.strokeColor = polyLineColor
                routePolyline.map = mapView
                let distanceKm = round((Double(distance!)/1000)*0.621371)
                let time = round((Double(time!)/60)*0.621371)
                completion(path,distanceKm,time)
                return
            }
        }
    }
    //MARK:- Route Draw API
    func drawRoute(_ sourceLoc : CLLocationCoordinate2D, _ destinationLoc : CLLocationCoordinate2D, wayPointArray : [CLLocationCoordinate2D] = [CLLocationCoordinate2D](),mapVw:GMSMapView, completion: @escaping (_ polylines : String? , _ error : String?, _  distance: Int?, _ time: Int?) -> Void) {
        var routeUrl = String()
        if wayPointArray.count != 0{
            let waypoints = wayPointArray.map{"\($0.latitude),\($0.longitude)"}.joined(separator: "|")
            routeUrl = "\(Apis.googleAddress)directions/json?origin=\(sourceLoc.latitude),\(sourceLoc.longitude)&destination=\(destinationLoc.latitude),\(destinationLoc.longitude)&waypoints=optimize:true|\(waypoints)&sensor=false\(Keys.googleKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        } else {
            routeUrl = "\(Apis.googleAddress)directions/json?origin=\(sourceLoc.latitude),\(sourceLoc.longitude)&destination=\(destinationLoc.latitude),\(destinationLoc.longitude)&key=\(Keys.googleKey)"
        }
        if NetworkReachabilityManager()!.isReachable {
            request(routeUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
                .responseJSON { response in
                    if(response.response?.statusCode == 200) {
                        var getResults = NSArray()
                        var JSONDIC = NSMutableDictionary()
                        JSONDIC = (response.result.value as? NSDictionary)?.mutableCopy() as! NSMutableDictionary
                        getResults = (JSONDIC["routes"]! as? NSArray)!
                        var polylines = String()
                        guard let route = getResults[0] as? [String: Any] else {
                            return
                        }
                        
                        guard let legs = route["legs"] as? [Any] else {
                            return
                        }
                        
                        guard let leg = legs[0] as? [String: Any] else {
                            return
                        }
                        
                        guard let steps = leg["steps"] as? [Any] else {
                            return
                        }
                        for item in steps {
                            
                            guard let step = item as? [String: Any] else {
                                return
                            }
                            
                            guard let polyline = step["polyline"] as? [String: Any] else {
                                return
                            }
                            
                            guard let polyLineString = polyline["points"] as? String else {
                                return
                            }
                            
                            //Call this method to draw path on map
                            DispatchQueue.main.async {
                                //  self.drawPath(from: polyLineString)
                                //MARK:- Draw Path line
                                let path = GMSPath(fromEncodedPath: polyLineString)
                                let polyline = GMSPolyline(path: path)
                                polyline.strokeWidth = 3.0
                                polyline.map = mapVw // Google MapView
                                
                            }
                            
                        }
                        var getRouteDict = NSDictionary()
                        if getResults.count > 0  {
                            getRouteDict = getResults.lastObject as! NSDictionary
                            //  let polylines = (getRouteDict.value(forKey: "overview_polyline") as! NSDictionary).value(forKey: "points") as! String
                            var distance = Int()
                            var time  = Int()
                            if let legsArr = getRouteDict["legs"] as? NSArray {
                                for index in 0..<legsArr.count {
                                    let legDic = legsArr[index] as! NSDictionary
                                    if let distVal = legDic.value(forKeyPath: "distance.value") as? Int {
                                        distance += distVal
                                    }
                                    if let timeVal = legDic.value(forKeyPath: "duration.value") as? Int {
                                        time += timeVal
                                    }
                                }
                            }
                            completion(polylines, nil, distance, time)
                        }
                    } else {
                        WebServiceProxy.shared.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                    }
                }
        } else {
            Proxy.shared.openSettingApp()
        }
    }
}


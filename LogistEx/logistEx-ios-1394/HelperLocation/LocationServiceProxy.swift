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

import Foundation
import Alamofire
import GoogleMaps
import GooglePlaces

class LocationServiceProxy {
    static var shared: LocationServiceProxy {
        return LocationServiceProxy()
    }
    fileprivate init(){}
    
    //MARK:- Latitude Method
    func getLatitude() -> String {
        if UserDefaults.standard.object(forKey: "lat") != nil {
            let currentLat =  UserDefaults.standard.object(forKey: "lat") as! String
            return currentLat
        }
        return ""
    }
    //MARK:- Longitude Method
    func getLongitude() -> String {
        if UserDefaults.standard.object(forKey: "long") != nil {
            let currentLong =  UserDefaults.standard.object(forKey: "long") as! String
            return currentLong
        }
        return ""
    }
    
    //MARK:- Get Location Coordinate Method
    func getLocationCoordinate2D(latitudeStr: String, longitudeStr:String) -> CLLocationCoordinate2D {
        var pointCoordinate = CLLocationCoordinate2D()
        pointCoordinate =  CLLocationCoordinate2DMake((latitudeStr as NSString).doubleValue, (longitudeStr as NSString).doubleValue)
        return  pointCoordinate
    }
    
    func getCoordinateLocation(latitudeStr: String, longitudeStr:String) -> CLLocation {
        var pointCoordinate = CLLocation()
        pointCoordinate = CLLocation(latitude: (latitudeStr as NSString).doubleValue, longitude: (longitudeStr as NSString).doubleValue)
        return  pointCoordinate
    }
    
    //MARK:- Show Annotation On Map Method
    func showAnnotationOnMap(cordinates:CLLocationCoordinate2D, mapView: GMSMapView, markerIcon:UIImage, address: String) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: cordinates.latitude, longitude: cordinates.longitude)
        marker.icon = markerIcon
        //marker.title = address
        marker.snippet  = address
        marker.map = mapView
        
    }
    
    func showAnnotationOnMapReturnMarker(cordinates:CLLocationCoordinate2D, mapView: GMSMapView, markerIcon:UIImage, address: String)-> GMSMarker{
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: cordinates.latitude, longitude: cordinates.longitude)
        marker.icon = markerIcon
        //marker.title = address
        marker.snippet  = address
        marker.map = mapView
        return marker
    }
    
    //MARK:- Map Methods
    func getCurrentAddress(iconMarker: UIImage, mapView: GMSMapView,completion:@escaping(_ address:String) -> Void) {
        mapView.clear()
        var currentAddress = String()
        if getLatitude() != "" && getLongitude() != "" {
            let sourceLocation = getLocationCoordinate2D(latitudeStr: getLatitude(), longitudeStr: getLongitude())
            mapView.setRegionMap(sourceLocation: sourceLocation, zoomLevel: 15.0)
            let geocoder = GMSGeocoder()
            self.showAnnotationOnMap(cordinates: sourceLocation, mapView: mapView, markerIcon: iconMarker, address: "")
            geocoder.reverseGeocodeCoordinate(sourceLocation) { response, error in
                if let address = response?.firstResult() {
                    if address.thoroughfare != nil &&  address.locality != nil  {
                        currentAddress = "\(address.thoroughfare!) \(address.locality!)"
                    } else if address.lines != nil  {
                        currentAddress = (address.lines?.joined(separator: " "))!
                    }
                    completion(currentAddress)
                }
            }
        } else {
            //  Proxy.shared.hideActivityIndicator()
            //  Proxy.shared.openLocationSettingApp()
        }
    }
 
    //MARK:- Address Methods
    func  addressMethod(lat:String ,long:String , _ completion:@escaping(_ address:String) -> Void) {
        var currentAddress = String()
        let sourceLocation = getLocationCoordinate2D(latitudeStr: lat, longitudeStr: long)
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(sourceLocation) { response, error in
            if let address = response?.firstResult() {
                if address.thoroughfare != nil &&  address.locality != nil  {
                    currentAddress = "\(address.thoroughfare!) \(address.locality!)"
                } else if address.lines != nil  {
                    currentAddress = (address.lines?.joined(separator: " "))!
                }
                completion(currentAddress)
            }
        }
    }
    
    //MARK:- Route Draw API

      func drawRoute(sourceLoc : CLLocationCoordinate2D, destinationLoc : CLLocationCoordinate2D, _ wayPointArray : [CLLocationCoordinate2D] = [CLLocationCoordinate2D](), completion: @escaping ( _ route : (polylines : String?, distance: Int?, time: Int?)? , _ error : String? ) -> Void) {
          
          var routeUrl = String()
          if wayPointArray.count != 0 {
              let waypoints = wayPointArray.map{"\($0.latitude),\($0.longitude)"}.joined(separator: "|")
              routeUrl = "\(Apis.googleAddress)directions/json?origin=\(sourceLoc.latitude),\(sourceLoc.longitude)&destination=\(destinationLoc.latitude),\(destinationLoc.longitude)&waypoints=optimize:true|\(waypoints)&sensor=false&key=\(ApiKey.googleMapsPlacesApi)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
          }else{
            routeUrl = "\(Apis.googleAddress)directions/json?origin=\(sourceLoc.latitude),\(sourceLoc.longitude)&destination=\(destinationLoc.latitude),\(destinationLoc.longitude)&key=\(ApiKey.googleMapsPlacesApi)"
          }
          if NetworkReachabilityManager()!.isReachable {
            AF.request(routeUrl,
                      method: .get, parameters: nil,
                      encoding: JSONEncoding.default,
                      headers: nil ).responseJSON { response in
                        
                      if(response.response?.statusCode == 200) {
                        let dictJson = response.value as? NSDictionary
                          let getResults = dictJson!["routes"] as? NSArray
                          var getRouteDict = NSDictionary()
                          if getResults!.count > 0  {
                              getRouteDict = getResults?.lastObject as! NSDictionary
                              let polylines = (getRouteDict.value(forKey: "overview_polyline") as! NSDictionary).value(forKey: "points") as! String
                              completion(nil, "")
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
                              completion((polylines, max(distance, 1000), max(time, 60)), nil)
                          }

                      } else {
                          WebServiceProxy.shared.statusHandler(response.response, data: response.data, error: response.error as NSError?)
                  }
              }
          } else {
              Proxy.shared.openSettingApp()
          }
      }
}

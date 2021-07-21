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

class HomeVM: NSObject {
    
    //MARK:- Variables
    var orderDetailVw: OrderDetailView!
    var startJourneyVw: StartJourneyView!
    var showOnMapVw: ShowOnMapView!
    var instructionsVw: InstructionsView!
    var endJourneyVw: EndJourneyView!
    var ratingVw: RatingView!
    var objCurrentRequestModel = CurrentRequestModel()
    var markerArray = NSMutableArray()
    var timer: Timer?
    var driverMarker = GMSMarker()
    var driverCoordinate = CLLocationCoordinate2D()
    var orderId = String()
    
    //MARK:- Hit Update Status Api
    func hitUpdateStatusApi(_ status: String, completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.updateStatus)?status=\(status)", showIndicator: true) { (response) in
            if response.success {
                if let resultDict = response.data?["result"] as? NSDictionary {
                    objUserModel.workStatus = Proxy.shared.isValueInt(resultDict["work_status"] as Any)
                }
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
    
    //MARK:- Hit Current Request Api
    func hitCurrentRequestApi(_ completion:@escaping(_ isSuccess: Bool) -> Void) {
        WebServiceProxy.shared.getData(Apis.requestList, showIndicator: true) { (response) in
            if response.success {
                if let requestDict = response.data?["request"] as? NSDictionary {
                    self.objCurrentRequestModel = CurrentRequestModel()
                    self.objCurrentRequestModel.handleData(requestDict)
                }
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}

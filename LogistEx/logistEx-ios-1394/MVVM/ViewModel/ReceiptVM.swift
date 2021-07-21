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
import Alamofire

class ReceiptVM: NSObject {
    
    var bookingId = String()
    
    //MARK:- ViewReceipt Api
    func getViewReceiptApi(id: String, success: @escaping()-> Void) {
        
        if NetworkReachabilityManager()!.isReachable {
            Proxy.shared.showActivityIndicator()
            AF.request("https://app.logist-ex.com/invoice?id=\(id)",
                method: .get, parameters: nil,
                encoding: JSONEncoding.default,
                headers:[   "Authorization": "Bearer \(Proxy.shared.accessTokenNil())",
                    "User-Agent":"\(AppInfo.userAgent)"] ).responseJSON { response in
                        
                        Proxy.shared.hideActivityIndicator()
                        
                        if response.data != nil && response.error == nil {
                            
                            debugPrint("RESPONSE",response.value!)
                            debugPrint("JSON-RESPONSE", NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)!)
                            
                            let dict  = response.value as? [String:AnyObject]
                            
                            if response.response?.statusCode == 200 {
                                success()
                            } else if response.response?.statusCode == 400 {
                                Proxy.shared.displayStatusAlert(message: dict!["error"] as? String ?? AlertTitle.error, state: .error)
                            } else {
                                WebServiceProxy.shared.statusHandler(response.response, data: response.data, error: response.error as NSError?)
                            }
                        } else {
                            WebServiceProxy.shared.statusHandler(response.response, data: response.data, error: response.error as NSError?)
                        }
            }
        } else {
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.openSettingApp()
        }
    }
}

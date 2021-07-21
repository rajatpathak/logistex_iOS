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

class SplashVM: NSObject {
    
    //MARK:- Hit Check Api
    func hitCheckApi(_ completion:@escaping() -> Void) {
        let param = [
            "DeviceDetail[device_token]" : Proxy.shared.deviceToken(),
            "DeviceDetail[device_type]" : DeviceInfo.deviceType,
            "DeviceDetail[device_name]" : DeviceInfo.deviceName] as [String:AnyObject]
        WebServiceProxy.shared.postData(Apis.check, params: param, showIndicator: true) { (response) in
            if response.success {
                if let auth = response.data!["access-token"] as? String {
                    UserDefaults.standard.set(auth, forKey: "access_token")
                    UserDefaults.standard.synchronize()
                }
                if let userDetailDict = response.data!["detail"] as? NSDictionary {
                    objUserModel.saveData(userDetailDict)
                }
                completion()
            } 
        }
    }
}

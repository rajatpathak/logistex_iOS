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
class SplashVM: NSObject{
    
    //MARK:- USER CHECK API
    func getUserCheckApi(completion: @escaping()-> Void){
        let param = [
            "DeviceDetail[device_token]": "\(Proxy.shared.deviceToken())",
            "DeviceDetail[device_type]": DeviceInfo.deviceType,
            "DeviceDetail[device_name]": DeviceInfo.deviceName ] as [String: AnyObject]
        
        
        WebServiceProxy.shared.postData(urlStr: Apis.isUserSessionValid, params: param, showIndicator: false) { (response) in
            if let userDetailDict = response?.data!["detail"] as? Dictionary<String, AnyObject>{
                objUserModel.setData(dictData: userDetailDict)
                completion()
            }
        }
    }
}

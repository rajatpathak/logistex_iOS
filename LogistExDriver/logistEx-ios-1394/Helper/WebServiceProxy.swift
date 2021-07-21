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
import UIKit

class WebServiceProxy {
    static var shared: WebServiceProxy {
        return WebServiceProxy()
    }
    fileprivate init(){}
    
    //MARK:- post Api Method
    func postData(_ urlStr: String, params: Dictionary<String, AnyObject>? = nil, showIndicator: Bool, completion: @escaping (ApiResponse) -> Void) {
        
        if NetworkReachabilityManager()!.isReachable {
            debugPrint("urlStr:-\(Apis.serverUrl)\(urlStr)")
            debugPrint("accessToken:- \(Proxy.shared.accessTokenNil())")
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
            request("\(Apis.serverUrl)\(urlStr)", method: .post, parameters: params!, encoding: URLEncoding.httpBody, headers:["Authorization": "Bearer \(Proxy.shared.accessTokenNil())","User-Agent":"\(AppInfo.userAgent)\(Locale.preferredLanguage)"])
                .responseJSON { response in
                    
                    DispatchQueue.main.async {
                        Proxy.shared.hideActivityIndicator()
                    }
                    var res : ApiResponse?
                    if response.data != nil && response.result.error == nil {
                        debugPrint("RESPONSE",response.result.value!)
                        if response.response?.statusCode == 200 {
                            if let JSON = response.result.value as? NSDictionary {
                                if let dateCheck = JSON["datecheck"] as? String {
                                    if !Proxy.shared.expiryDateCheckMethod(expiryDate: dateCheck) {
                                        return
                                    }
                                }
                                if JSON["status"] as? Int == 200 {
                                    res = ApiResponse(data: JSON, success: true, message: JSON["message"] as? String ?? "Success")
                                }else{
                                    if  ((JSON["error"] as? String) != nil) {
                                        res = ApiResponse(data: JSON, success: false, message: JSON["error"] as? String ?? "Error")
                                    }
                                    else {
                                        res = ApiResponse(data: JSON, success: false, message: JSON["message"] as? String ?? "Error")
                                    }
                                }
                                
                            } else {
                                res = ApiResponse(data: nil, success: false, message:  "Error")
                                
                            }
                        } else {
                            res = ApiResponse(data: nil, success: false, message: "Error")
                            self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                        }
                    } else {
                        res = ApiResponse(data: nil, success: false, message: "Error: Unable to encode JSON Response")
                    }
                    completion(res!)
            }
        } else {
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.openSettingApp()
        }
    }
    
    //MARK:- get Api Method
    func getData(_ urlStr: String, showIndicator: Bool, completion: @escaping (ApiResponse) -> Void)  {
        
        debugPrint("Url:-\(Apis.serverUrl)\(urlStr)")
        debugPrint("accessToken:- \(Proxy.shared.accessTokenNil())")
        if NetworkReachabilityManager()!.isReachable {
            
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
            debugPrint(Proxy.shared.accessTokenNil())
            
            request("\(Apis.serverUrl)\(urlStr)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers:["Authorization": "Bearer \(Proxy.shared.accessTokenNil())","User-Agent":"\(AppInfo.userAgent)\(Locale.preferredLanguage)"])
                .responseJSON { response in
                    debugPrint(response)
                    DispatchQueue.main.async {
                        Proxy.shared.hideActivityIndicator()
                    }
                    let res : ApiResponse?
                    if response.data != nil && response.result.error == nil {
                        debugPrint("RESPONSE",response.result.value!)
                        if response.response?.statusCode == 200 {
                            if let JSON = response.result.value as? NSDictionary {
                                if let dateCheck = JSON["datecheck"] as? String {
                                    if !Proxy.shared.expiryDateCheckMethod(expiryDate: dateCheck) {
                                        return
                                    }
                                }
                                if JSON["status"] as? Int == 200 {
                                    res = ApiResponse(data: JSON, success: true, message: JSON["message"] as? String ?? "Success")
                                } else {
                                    
                                    if  ((JSON["error"] as? String) != nil) {
                                        res = ApiResponse(data: nil, success: false, message: JSON["error"] as? String ?? "Error")
                                    }
                                    else {
                                        res = ApiResponse(data: JSON, success: false, message: JSON["message"] as? String ?? "Error")
                                    }
                                }
                                
                            } else {
                                
                                res = ApiResponse(data: nil, success: false, message:  "Error")
                            }
                        } else {
                            
                            res = ApiResponse(data: nil, success: false, message: "Page not found")
                            self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                            
                        }
                    } else {
                        if let JSON = response.result.value as? NSDictionary {
                            debugPrint("RESPONSE",JSON)
                            
                            res = ApiResponse(data: nil, success: false, message:  "Error")
                            
                        } else {
                            res = ApiResponse(data: nil, success: false, message:  "Error")
                        }
                    }
                    completion(res!)
            }
        } else {
            DispatchQueue.main.async {
                Proxy.shared.hideActivityIndicator()
            }
            Proxy.shared.openSettingApp()
        }
    }
    
    //MARKK:- API Interaction
    func deleteData(_ urlStr: String, params: Dictionary<String, AnyObject>? = nil, showIndicator: Bool, completion: @escaping (_ response: NSDictionary, _ isSuccess: Bool , _ message: String) -> Void) {
        
        debugPrint("urlStr:-\(urlStr)")
        debugPrint("accessToken:- \(Proxy.shared.accessTokenNil())")
        if NetworkReachabilityManager()!.isReachable {
            
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
            
            request(Apis.serverUrl+urlStr, method: .delete, parameters: params, encoding: JSONEncoding.default, headers:["Authorization": "Bearer \(Proxy.shared.accessTokenNil())","User-Agent":"\(AppInfo.userAgent)\(Locale.preferredLanguage)","accept":"application/json"])
                .responseJSON { response in
                    debugPrint(response)
                    debugPrint(Apis.serverUrl+urlStr)
                    DispatchQueue.main.async {
                        Proxy.shared.hideActivityIndicator()
                    }
                    if response.data != nil && response.result.error == nil {
                        if response.response?.statusCode == 200 {
                            if let JSON = response.result.value as? NSDictionary {
                                completion( JSON, true, "")
                                
                            } else {
                                self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                            }
                        } else {
                            self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                        }
                    } else {
                        self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                    }
                    
            }
        } else {
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.openSettingApp()
        }
    }
    
    //MARK:- upload image Api Method
    func uploadImage(apiName: String, paramsDictionary: Dictionary<String, AnyObject>? = nil, imageDictionary: [String: UIImage], showIndicator: Bool, completion: @escaping (ApiResponse) -> Void)  {
        
        if NetworkReachabilityManager()!.isReachable {
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    if paramsDictionary != nil {
                        for (key, val) in paramsDictionary! {
                            multipartFormData.append(val.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                        }
                    }
                    
                    for (key, val) in imageDictionary {
                        let timeStamp = Date().timeIntervalSince1970 * 1000
                        let fileName = "image\(timeStamp).png"
                        
                        guard let imageData = val.jpegData(compressionQuality: 0.75) else { return }
                        multipartFormData.append(imageData, withName: key, fileName: fileName , mimeType: "image/png")
                    }
                    
            },
                to: "\(Apis.serverUrl)\(apiName)",
                method:.post,
                headers:["Authorization": "Bearer \(Proxy.shared.accessTokenNil())","User-Agent":"\(AppInfo.userAgent)\(Locale.preferredLanguage)"],
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.validate()
                        upload.responseJSON { response in
                            guard response.result.isSuccess else {
                                Proxy.shared.hideActivityIndicator()
                                self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                                Proxy.shared.displayStatusAlert(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)! as String)
                                return
                            }
                            Proxy.shared.hideActivityIndicator()
                            let res : ApiResponse?
                            if let responseJSON = response.result.value as? NSDictionary{
                                if let dateCheck = responseJSON["datecheck"] as? String {
                                    if !Proxy.shared.expiryDateCheckMethod(expiryDate: dateCheck) {
                                        return
                                    }
                                }
                                if responseJSON["status"] as? Int == 200 {
                                    res = ApiResponse(data: responseJSON, success: true, message: responseJSON["message"] as? String ?? "Success")
                                } else {
                                    res = ApiResponse(data: nil, success: false, message: responseJSON["error"] as? String ?? "Error")
                                }
                                completion(res!)
                            }
                        }
                        
                    case .failure(let errorcoding):
                        debugPrint(errorcoding)
                        Proxy.shared.hideActivityIndicator()
                        break
                    }
            }
            )
            
        } else {
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.openSettingApp()
        }
    }
    
    
    //MARK:- upload PDF Api Method
    func uploadPDF(apiName: String, paramsDictionary: Dictionary<String, AnyObject>? = nil, pdfDictionary: [String: Data], imagesDictionary: [String: Data]? = nil, showIndicator: Bool, completion: @escaping (ApiResponse) -> Void)  {
        
        if NetworkReachabilityManager()!.isReachable {
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    if paramsDictionary != nil {
                        for (key, val) in paramsDictionary! {
                            multipartFormData.append(val.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                        }
                    }
                    if pdfDictionary != nil {
                        for (key, val) in pdfDictionary {
                            let timeStamp = Date().timeIntervalSince1970 * 1000
                            let fileName = "pdf_\(timeStamp).pdf"
                            
                            multipartFormData.append(val, withName: key, fileName: fileName , mimeType: "application/pdf")
                        }
                    }
                    if imagesDictionary != nil {
                        for (key, val) in imagesDictionary! {
                            let timeStamp = Date().timeIntervalSince1970 * 1000
                            let fileName = "image\(timeStamp).png"
                            
                            multipartFormData.append(val, withName: key, fileName: fileName , mimeType: "image/png")
                        }
                    }
            },
                to: "\(Apis.serverUrl)\(apiName)",
                method:.post,
                headers:["Authorization": "Bearer \(Proxy.shared.accessTokenNil())","User-Agent":"\(AppInfo.userAgent)\(Locale.preferredLanguage)"],
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.validate()
                        upload.responseJSON { response in
                            guard response.result.isSuccess else {
                                Proxy.shared.hideActivityIndicator()
                                self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                                Proxy.shared.displayStatusAlert(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)! as String)
                                return
                            }
                            Proxy.shared.hideActivityIndicator()
                            let res : ApiResponse?
                            if let responseJSON = response.result.value as? NSDictionary{
                                if let dateCheck = responseJSON["datecheck"] as? String {
                                    if !Proxy.shared.expiryDateCheckMethod(expiryDate: dateCheck) {
                                        return
                                    }
                                }
                                if responseJSON["status"] as? Int == 200 {
                                    res = ApiResponse(data: responseJSON, success: true, message: responseJSON["message"] as? String ?? "Success")
                                } else {
                                    res = ApiResponse(data: nil, success: false, message: responseJSON["error"] as? String ?? "Error")
                                }
                                completion(res!)
                            }
                        }
                        
                    case .failure(let errorcoding):
                        debugPrint(errorcoding)
                        Proxy.shared.hideActivityIndicator()
                        break
                    }
            }
            )
            
        } else {
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.openSettingApp()
        }
    }
    //MARK:-uploadAudioVideo
    func uploadAudioVideo(_ parameters:[String:AnyObject],parametersImage:[String:Data],addImageUrl:String,type:String, showIndicator: Bool, completion: @escaping (ApiResponse) -> Void)  {
        
        if NetworkReachabilityManager()!.isReachable {
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    for (key, val) in parameters {
                        multipartFormData.append(val.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                    
                    for (key, val) in parametersImage {
                        let timeStamp = Date().timeIntervalSince1970 * 1000
                        let fileName = "\(timeStamp).\(type)"
                        
                        
                        //                        guard let imageData = UIImageJPEGRepresentation(val, 0.5)
                        //                            else {
                        //                                return
                        //                        }
                        multipartFormData.append(val, withName: key, fileName: fileName , mimeType: type)
                    }
                    
            },
                to: "\(Apis.serverUrl)\(addImageUrl)",
                method:.post,
                headers:["Authorization": "Bearer \(Proxy.shared.accessTokenNil())","User-Agent":"\(AppInfo.userAgent)\(Locale.preferredLanguage)"],
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.validate()
                        upload.responseJSON { response in
                            guard response.result.isSuccess else {
                                Proxy.shared.hideActivityIndicator()
                                self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                                Proxy.shared.displayStatusAlert(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)! as String)
                                
                                return
                            }
                            Proxy.shared.hideActivityIndicator()
                            let res : ApiResponse?
                            if let responseJSON = response.result.value as? NSDictionary{
                                //completion( JSON, true, "")
                                if let dateCheck = responseJSON["datecheck"] as? String {
                                    if !Proxy.shared.expiryDateCheckMethod(expiryDate: dateCheck) {
                                        return
                                    }
                                }
                                if responseJSON["status"] as? Int == 200 {
                                    res = ApiResponse(data: responseJSON, success: true, message:responseJSON["message"] as? String ?? "Success")
                                }else{
                                    res = ApiResponse(data: nil, success: false, message: responseJSON["error"] as? String ?? "Error")
                                }
                                completion(res!)
                            }
                        }
                        
                    case .failure(let errorcoding):
                        debugPrint(errorcoding)
                        Proxy.shared.hideActivityIndicator()
                        break
                    }
            }
            )
            
        } else {
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.openSettingApp()
        }
    }
    
    // MARK: - Error Handling
    
    func statusHandler(_ response:HTTPURLResponse? , data:Data?, error:NSError?) {
        if let code = response?.statusCode {
            switch code {
            case 400:
                Proxy.shared.displayStatusAlert(AlertMessages.urlError)
            case 401 , 403:
                UserDefaults.standard.set("", forKey: "access-token")
                objUserModel = UserModel()
                UserDefaults.standard.synchronize()
                if #available(iOS 13.0, *) {
                    let sceneDelegate = UIApplication.shared.connectedScenes
                        .first!.delegate as! SceneDelegate
                    sceneDelegate.window!.rootViewController?.root(identifier: "LoginVC")
                } else {
                    KAppDelegate.window?.rootViewController?.root(identifier: "LoginVC")
                }
            case 404:
                Proxy.shared.displayStatusAlert(AlertMessages.urlNotExist)
            case 500:
                let myHTMLString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                Proxy.shared.displayStatusAlert(myHTMLString as String)
            case 408:
                Proxy.shared.displayStatusAlert(AlertMessages.serverError)
            default:
                let myHTMLString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                Proxy.shared.displayStatusAlert(myHTMLString as String)
            }
        } else {
            let myHTMLString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            Proxy.shared.displayStatusAlert(myHTMLString as String)
        }
        
        if let errorCode = error?.code {
            switch errorCode {
            default:
                Proxy.shared.displayStatusAlert(AlertMessages.serverError)
                break
            }
        }
    }
    
}
//po print(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue))

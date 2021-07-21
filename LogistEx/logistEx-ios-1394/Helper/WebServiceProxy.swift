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

import Alamofire
import Foundation

class WebServiceProxy {
    
    static var shared: WebServiceProxy {
        return WebServiceProxy()
    }
    fileprivate init(){ }
    
    
    //MARK:- Post & Get Api Interaction
    func postData(urlStr: String, params: Dictionary<String, AnyObject>? = nil, showIndicator: Bool = true, completion: @escaping (ApiResponse?) -> Void) {
        
        if NetworkReachabilityManager()!.isReachable {
            
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
            
            AF.request("\(Apis.serverUrl)\(urlStr)",
                method: .post,
                parameters: params!,
                encoding: URLEncoding.httpBody,
                headers:[   "Authorization": "Bearer \(Proxy.shared.accessTokenNil())",
                    "User-Agent":"\(AppInfo.userAgent)\(Locale.preferredLanguage)"]).responseJSON { response in
                        
                        debugPrint("Url,\(Apis.serverUrl)\(urlStr), Acces-Token, \(Proxy.shared.accessTokenNil())")
                        debugPrint("PostParam", "\(params!)")
                        
                        Proxy.shared.hideActivityIndicator()
                        
                        if response.data != nil && response.error == nil {
                            debugPrint("RESPONSE",response.value!)
                            let dict  = response.value as? [String:AnyObject]
                          
                            
                            if response.response?.statusCode == 200 {
                                let res : ApiResponse?
                                res = ApiResponse(success: true, jsonData: response.data!, data: dict, message: dict!["success"] as? String ?? dict!["message"] as? String ??  dict!["error"] as? String ?? AlertTitle.success)
                                completion(res!)
                            } else if response.response?.statusCode == 400 {
                                Proxy.shared.displayStatusAlert(message: dict!["error"] as? String ?? AlertTitle.error, state: .error)
                            } else {
                                self.statusHandler(response.response, data: response.data, error: response.error as NSError?)
                            }
                        } else {
                            self.statusHandler(response.response, data: response.data, error: response.error as NSError?)
                        }
                        
            }
        } else {
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.openSettingApp()
        }
    }
    
    func getData(urlStr: String, showIndicator: Bool = true, completion: @escaping (ApiResponse?) -> Void)  {
        
        if NetworkReachabilityManager()!.isReachable {
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
            
            AF.request("\(Apis.serverUrl)\(urlStr)",
                method: .get, parameters: nil,
                encoding: JSONEncoding.default,
                headers:[   "Authorization": "Bearer \(Proxy.shared.accessTokenNil())",
                    "User-Agent":"\(AppInfo.userAgent)\(Locale.preferredLanguage)"] ).responseJSON { response in
                        
                        debugPrint("Url,\(Apis.serverUrl)\(urlStr), Acces-Token, \(Proxy.shared.accessTokenNil())")
                        Proxy.shared.hideActivityIndicator()
                        
                        
                        if response.data != nil && response.error == nil {
                            
                            debugPrint("RESPONSE",response.value!)
                            
                            let dict  = response.value as? [String:AnyObject]
                            
                            if response.response?.statusCode == 200 {
                                let res : ApiResponse?
                                res = ApiResponse(success: true, jsonData: response.data!, data: dict, message: dict!["message"] as? String ?? dict!["success"] as? String ?? AlertTitle.success)
                                completion(res!)
                            } else if response.response?.statusCode == 400 {
                                Proxy.shared.displayStatusAlert(message: dict!["error"] as? String ?? AlertTitle.error, state: .error)
                            } else {
                                self.statusHandler(response.response, data: response.data, error: response.error as NSError?)
                            }
                        } else {
                            self.statusHandler(response.response, data: response.data, error: response.error as NSError?)
                        }
            }
        } else {
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.openSettingApp()
        }
    }
    
    func uploadImage(_ parameters:[String:AnyObject],
                     parametersImage:[String:UIImage],
                     addImageUrl:String,
                     showIndicator: Bool,
                     completion:@escaping (_ completed: NSDictionary) -> Void){
        
           if NetworkReachabilityManager()!.isReachable {
               if showIndicator {
                   Proxy.shared.showActivityIndicator()
               }
               
               AF.upload(multipartFormData: { multipartFormData in
                   for (key, val) in parameters {
                       multipartFormData.append(val.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                   }
                   
                   
                   for (key, val) in parametersImage {
                       let timeStamp = Date().timeIntervalSince1970 * 1000
                       let fileName = "image\(timeStamp).png"
                       guard let imageData = val.jpegData(compressionQuality: 0.5)
                           else {
                               return
                       }
                       multipartFormData.append(imageData, withName: key, fileName: fileName , mimeType: "image/png")
                   }
               },
                to: "\(Apis.serverUrl)\(addImageUrl)",
                method: .post ,
                headers: [ "Authorization": "Bearer \(Proxy.shared.accessTokenNil())",  "User-Agent":"\(AppInfo.userAgent)\(Locale.preferredLanguage)"]).response { response in
                       
                       DispatchQueue.main.async {
                           Proxy.shared.hideActivityIndicator()
                       }
                       
                       switch response.result {
                           
                       case .success(let json):                         
                           let anyResult = try? JSONSerialization.jsonObject(with: json!, options: [])

                           if let res = anyResult as? NSDictionary {
                               debugPrint(res)
                               completion(res)
                               
                           }else{
                            Proxy.shared.displayStatusAlert(message:"Error: Unable to encode JSON Response", state: .error)
                               completion([:])
                           }
                       case .failure(let error):
                           print(error)
                           self.statusHandler(response.response, data: response.data, error: error as NSError?)
                       }
               }
           } else {
               Proxy.shared.hideActivityIndicator()
               Proxy.shared.openSettingApp()
           }
       }
    
       
    // MARK: - Server Sent Status Code Handler
    func statusHandler(_ response:HTTPURLResponse?, data:Data?, error:NSError?) {
        if let code = response?.statusCode {
            if code == 401 ||  code == 403 {
                UserDefaults.standard.set("", forKey: "access_token")
                UserDefaults.standard.synchronize()
                if #available(iOS 13.0, *) {
                    let sceneDelegate = UIApplication.shared.connectedScenes
                        .first!.delegate as! SceneDelegate
                    sceneDelegate.window!.rootViewController?.rootWithoutDrawer(selectedStoryboard: .main, identifier: .loginVC)
                } else {
                    KAppDelegate.window?.rootViewController?.rootWithoutDrawer(selectedStoryboard: .main, identifier: .loginVC)
                }
                objUserModel = UserModel()
            } else{
                let myHTMLString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                Proxy.shared.displayStatusAlert(message:myHTMLString as String, state: .error)
            }
        } else {
            if data != nil {
                let myHTMLString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                Proxy.shared.displayStatusAlert(message:myHTMLString as! String, state: .error)
            }
        }
    }
}


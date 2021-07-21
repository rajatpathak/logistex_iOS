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

class ChatVM: NSObject {
    
    //MARK:- Variables
    var currentPage = Int()
    var totalPage = Int()
    var arrMessageModel = [MessageModel]()
    var timer: Timer?
    var toUserId = String()
    var toUserName = String()
    var bookingId = String()
    
    //MARK:- Get Messages Api
    func getMessagesApi(_ id : String, url: String, param: [String:AnyObject], completion:@escaping() -> Void) {
        WebServiceProxy.shared.postData("\(url)?page=\(currentPage)&id=\(id)", params: param, showIndicator: true) { (response) in
            if response.success {
                if self.currentPage == 0 {
                    self.arrMessageModel = []
                }
                
                if let paginationDict  = response.data!["_meta"] as? NSDictionary {
                    if let pageCountVal = paginationDict["pageCount"] as? Int{
                        self.totalPage = pageCountVal
                    }
                }
                
                if let listArray = response.data!["list"] as? [NSDictionary] {
                    for dict in listArray {
                        let objChatModel = MessageModel()
                        objChatModel.handleData(dict)
                        self.arrMessageModel.append(objChatModel)
                    }
                }
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.data?["message"] as? String ?? "")
            }
        }
    }
    //MARK:- Message Send Api
    func messageSendApi(_ url: String, param: [String:AnyObject], completion:@escaping() -> Void) {
        WebServiceProxy.shared.postData(url, params: param , showIndicator: true, completion: { (response)  in
            if response.success {
                if let dataDict = response.data!["data"] as? NSDictionary {
                    let objChatModel = MessageModel()
                    objChatModel.handleData(dataDict)
                    self.arrMessageModel.append(objChatModel)
                }
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.data?["message"] as? String ?? "")
            }
        })
    }
    //MARK:- Get New Api
    func getReceiveMessageApi(_ url: String, param: [String:AnyObject],completion:@escaping() -> Void) {
        WebServiceProxy.shared.postData(url, params: param, showIndicator: false) { (response) in
            if response.success {
                if let listArr = response.data!["list"] as? [NSDictionary] {
                    for dict in listArr {
                        let objChatModel = MessageModel()
                        objChatModel.handleData(dict)
                        self.arrMessageModel.append(objChatModel)
                    }
                }
                completion()
            }
        }
    }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return objChatVM.arrMessageModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict = objChatVM.arrMessageModel[indexPath.row]
        if objUserModel.userId == dict.fromUserId {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTVC") as! SenderTVC
            cell.lblDate.text = dict.createdOn
            cell.lblMsg.text = dict.message
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTVC") as! ReceiverTVC
            cell.lblDate.text = dict.createdOn
            cell.lblMsg.text = dict.message
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        tableView.estimatedRowHeight = 80
        return UITableView.automaticDimension
    }
}

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
    func getMessagesApi(_ id : Int, completion:@escaping() -> Void) {
        let param = ["Booking[id]": bookingId,"Chatmessage[user_id]": toUserId] as [String:AnyObject]
        WebServiceProxy.shared.postData(urlStr: "\(Apis.getMessages)?page=\(currentPage)&id=\(id)", params: param, showIndicator: true) { (response) in
            if self.currentPage == 0 {
                self.arrMessageModel = []
            }
            
            if let paginationDict  = response?.data!["_meta"] as? Dictionary<String, AnyObject> {
                if let pageCountVal = paginationDict["pageCount"] as? Int{
                    self.totalPage = pageCountVal
                }
            }
            
            if let listArray = response?.data!["list"] as? [Dictionary<String, AnyObject>] {
                for dict in listArray {
                    let objChatModel = MessageModel()
                    objChatModel.handleData(dict)
                    self.arrMessageModel.append(objChatModel)
                }
            }
            completion()
        }
    }
    //MARK:- Message Send Api
    func messageSendApi(_ message: String, completion:@escaping() -> Void) {
        let param = [
            "Chatmessage[message]": message,
            "Chatmessage[to_user_id]": toUserId,
            "Chatmessage[to_user_name]": toUserName,
            "Chatmessage[booking_id]": bookingId
            ] as [String:AnyObject]
        WebServiceProxy.shared.postData(urlStr: Apis.sendMessage, params: param , showIndicator: true, completion: { (response)  in
            if let dataDict = response?.data!["data"] as? Dictionary<String, AnyObject> {
                let objChatModel = MessageModel()
                objChatModel.handleData(dataDict)
                self.arrMessageModel.append(objChatModel)
            }
            completion()
        })
    }
    //MARK:- Get New Api
    func getReceiveMessageApi(_ completion:@escaping() -> Void) {
        let param = ["Booking[id]": bookingId,"Chatmessage[user_id]": toUserId] as [String:AnyObject]
        WebServiceProxy.shared.postData(urlStr: Apis.receiveMessage, params: param, showIndicator: false) { (response) in
            if let listArr = response?.data!["list"] as? [Dictionary<String, AnyObject>] {
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

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return objChatVM.arrMessageModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict = objChatVM.arrMessageModel[indexPath.row]
        if objUserModel.id == dict.fromUserId {
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

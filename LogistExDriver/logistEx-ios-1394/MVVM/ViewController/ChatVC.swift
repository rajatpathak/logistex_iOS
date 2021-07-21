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
import IQKeyboardManagerSwift

class ChatVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tblVwChat: UITableView!
    @IBOutlet weak var vwBottomCnst: NSLayoutConstraint!
    @IBOutlet weak var txtVwMsg: IQTextView!
    @IBOutlet weak var lblTItle: UILabel!
    
    //MARK:- Object
    var objChatVM = ChatVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        lblTItle.text = self.title == TitleValue.chatUser ? objChatVM.toUserName : lang == ChooseLanguage.spanish.rawValue ? TitleValue.chatAdminSpa : TitleValue.chatAdmin
         txtVwMsg.placeholder = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.typeHereSpa : TitleValue.typeHere)"
        
        let param = self.title == TitleValue.chatUser ? ["Booking[id]": objChatVM.bookingId,"Chatmessage[user_id]": objChatVM.toUserId] as [String:AnyObject] : [:]
        objChatVM.getMessagesApi(objUserModel.userId, url: self.title == TitleValue.chatUser ? Apis.getUserMessages : Apis.getMessages, param: param) {
            self.tblVwChat.reloadData()
            self.scrollToBottomInitial()
            self.objChatVM.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.receiveMessage), userInfo: nil, repeats: true)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(getNewMessageNotification), name: NSNotification.Name(rawValue: "NewMessage"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        self.startKeyboardObserver()
    }
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        self.objChatVM.timer?.invalidate()
        self.stopKeyboardObserver()
    }
    @objc func getNewMessageNotification(_ notification: NSNotification) {
        let dict = notification.object as? NSDictionary
        let bookingId = dict?["orderId"] as? String
        let fromId = dict?["fromId"] as? String
        let userId = dict?["userId"] as? String
        let fromName = dict?["fromName"] as? String
        lblTItle.text = fromName
        objChatVM.toUserName = fromName ?? ""
        objUserModel.userId = fromId ?? ""
        objChatVM.toUserId = userId ?? ""
        let param = ["Booking[id]": bookingId,"Chatmessage[user_id]": objChatVM.toUserId] as [String:AnyObject]
        objChatVM.getMessagesApi(objChatVM.toUserId, url: self.title == TitleValue.chatUser ? Apis.getUserMessages : Apis.getMessages, param: param) {
            self.tblVwChat.reloadData()
            self.scrollToBottomInitial()
            self.objChatVM.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.receiveMessage), userInfo: nil, repeats: true)
        }
    }
    func startKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    func stopKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //MARK:- IBActions
    @IBAction func actionBack(_ sender: Any) {
        pop()
    }
    @IBAction func actionSend(_ sender: Any) {
        var messageText = String()
        if txtVwMsg.text == ""  {
            view.endEditing(true)
            Proxy.shared.displayStatusAlert(AlertMessages.enterMessage.localized)
        } else {
            messageText = txtVwMsg.text
        }
        if messageText.count == 0 {
            return
        }
        var param = NSDictionary()
        if self.title == TitleValue.chatUser {
            param = [
                "Chatmessage[message]": messageText,
                "Chatmessage[to_user_id]": objChatVM.toUserId,
                "Chatmessage[to_user_name]": objChatVM.toUserName,
                "Chatmessage[booking_id]": objChatVM.bookingId
                ] as NSDictionary
        } else {
            param = [
                "Chatmessage[message]": messageText,
                ]  as NSDictionary
        }
        txtVwMsg.text = ""
        objChatVM.messageSendApi(self.title == TitleValue.chatUser ? Apis.sendUserMessage : Apis.sendMessage, param: param as! [String : AnyObject]) {
            self.tblVwChat.reloadData()
        }
    }
    @objc func keyboardWillShow(_ notification: Notification)  {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            vwBottomCnst.constant = keyboardSize.height
            self.perform(#selector(self.scrollToBottomInitial), with: nil, afterDelay: 0.1)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        vwBottomCnst.constant = 0
        if txtVwMsg.text != nil {
            self.txtVwMsg.resignFirstResponder()
        }
    }
    //MARK:- Custom method
    @objc func receiveMessage() {
        let param = self.title == TitleValue.chatUser ? ["Booking[id]": objChatVM.bookingId,"Chatmessage[user_id]": objChatVM.toUserId] as [String:AnyObject] : [:]
        
        objChatVM.getReceiveMessageApi(self.title == TitleValue.chatUser ? Apis.receiveUserMessage : Apis.receiveMessage, param: param) {
            self.tblVwChat.reloadData()
            self.scrollToBottomInitial()
        }
    }    //MARK:- Function To Scroll To Bottom
    @objc func scrollToBottomInitial() {
        DispatchQueue.main.async {
            let oldCount: Int = self.objChatVM.arrMessageModel.count
            if oldCount != 0 {
                let lastRowNumber: Int = self.tblVwChat.numberOfRows(inSection: 0) - 1
                if lastRowNumber > 0 {
                    let ip: IndexPath = IndexPath(row: lastRowNumber, section: 0)
                    self.tblVwChat.scrollToRow(at: ip, at: .bottom, animated: false)
                }
            }
        }
    }
}

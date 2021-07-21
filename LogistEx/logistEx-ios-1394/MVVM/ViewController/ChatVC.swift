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
        lblTItle.text = objChatVM.toUserName
        objChatVM.getMessagesApi(objUserModel.id) {
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
    func startKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    func stopKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func getNewMessageNotification(_ notification: NSNotification) {
        let dict = notification.object as? NSDictionary
        let bookingId = dict?["orderId"] as? Int
        let fromId = dict?["fromId"] as? Int
        let userId = dict?["userId"] as? Int
        let fromName = dict?["fromName"] as? String
        lblTItle.text = fromName
        objUserModel.id = fromId ?? 0
        objChatVM.toUserName = fromName ?? ""
        objChatVM.toUserId = "\(userId ?? 0)"
        objChatVM.bookingId = "\(bookingId ?? 0)"
        objChatVM.getMessagesApi(objUserModel.id) {
            self.tblVwChat.reloadData()
            self.scrollToBottomInitial()
            self.objChatVM.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.receiveMessage), userInfo: nil, repeats: true)
        }
    }
    //MARK:- IBActions
    @IBAction func actionBack(_ sender: Any) {
        popToBack()
    }
    @IBAction func actionSend(_ sender: Any) {
        var messageText = String()
        if txtVwMsg.text == ""  {
            view.endEditing(true)
            Proxy.shared.displayStatusAlert(message: AlertMessages.enterMessage.localized, state: .warning)
        } else {
            messageText = txtVwMsg.text
        }
        if messageText.count == 0 {
            return
        }
        
        txtVwMsg.text = ""
        objChatVM.messageSendApi(messageText) {
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
        objChatVM.getReceiveMessageApi() {
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

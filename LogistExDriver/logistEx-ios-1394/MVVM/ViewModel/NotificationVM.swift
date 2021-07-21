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
import EmptyStateKit

class NotificationVM: NSObject {
    
    //MARK:- Variables
    var currentPage = Int()
    var totalPage = Int()
    var arrNotification = [NotificationModel]()
    
    //MARK:- Hit Notification List Api
    func hitNotificationListApi(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.notificationList)?currentPage=\(currentPage)", showIndicator: true) { (response) in
            if response.success {
                if self.currentPage == 0 {
                    self.arrNotification = []
                }
                if let dictMeta = response.data?["_meta"] as? NSDictionary {
                    self.totalPage  = dictMeta["pageCount"] as! Int
                }
                if let listArr = response.data?["list"] as? [NSDictionary] {
                    for dict in listArr {
                        let objNotificationModel = NotificationModel()
                        objNotificationModel.handleData(dict)
                        self.arrNotification.append(objNotificationModel)
                    }
                }
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
}

extension NotificationVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objNotificationVM.arrNotification.count == 0 {
            tableView.emptyState.show(TableState.noNotifications)
        } else {
            tableView.emptyState.hide()
        }
        return objNotificationVM.arrNotification.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = objNotificationVM.arrNotification[indexPath.row]
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVC") as! NotificationTVC
        cell.lblTitle.text = dict.title
        cell.lblOrderNo.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.orderNoSpa : TitleValue.orderNo) \(dict.bookingId)"
        if lang == ChooseLanguage.english.rawValue {
            cell.lblDate.text = dict.createdOn.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "MM-dd-yyyy HH:mm:ss")
        } else {
            cell.lblDate.text = dict.createdOn.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "dd-MM-yyyy HH:mm:ss")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 125
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == objNotificationVM.arrNotification.count-1 {
            if objNotificationVM.totalPage > objNotificationVM.currentPage+1 {
                objNotificationVM.currentPage += 1
                objNotificationVM.hitNotificationListApi {
                    DispatchQueue.main.async {
                        self.tblVwNotification.reloadData()
                    }
                }
            }
        }
    }
}

extension NotificationVC: EmptyStateDelegate {
    
    func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
        notificationList()
    }
}

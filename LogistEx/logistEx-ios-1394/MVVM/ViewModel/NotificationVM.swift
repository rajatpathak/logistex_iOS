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
    var arrNotificationModel = [NotificationModel]()
    var currentPage = Int()
    var totalPage = Int()
    
    //MARK:- Get Notification List
    func getNotificationList(completion: @escaping()-> Void){
        WebServiceProxy.shared.getData(urlStr: "\(Apis.notificationList)?page=\(currentPage)", showIndicator: true) { (response) in
            
            if self.currentPage == 0{
                self.arrNotificationModel.removeAll()
            }
            if let paginationDict = response?.data!["_meta"] as? Dictionary<String, AnyObject>{
                self.totalPage = paginationDict["pageCount"] as? Int ?? 0
            }
            if let arrList = response?.data!["list"] as? [Dictionary<String, AnyObject>]{
                for dict in arrList{
                    let objNotificationModel = NotificationModel()
                    objNotificationModel.setNotificationList(dictData: dict)
                    self.arrNotificationModel.append(objNotificationModel)
                }
                
            }
            completion()
        }
    }
}
extension NotificationVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objNotificationVM.arrNotificationModel.count == 0 {
            tableView.emptyState.show(TableState.noNotifications)
        } else {
            tableView.emptyState.hide()
        }
        
        return objNotificationVM.arrNotificationModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVC") as! NotificationTVC
        let dictData = objNotificationVM.arrNotificationModel[indexPath.row]
        cell.lblOrderNo.text = "\(PassTitles.orderNo.localized) \(dictData.modelId)"
        cell.lblOrderStatus.text = dictData.desc
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        if lang == ChooseLanguage.english.rawValue {
            cell.lblDate.text = " \(dictData.createdOn.changeDateFormatOfStrDate(currentFormat: "yyyy-MM-dd HH:mm:ss", willingFormat: "MM-dd-yyyy HH:mm:ss"))"
        } else {
            cell.lblDate.text = " \(dictData.createdOn.changeDateFormatOfStrDate(currentFormat: "yyyy-MM-dd HH:mm:ss", willingFormat: "dd-MM-yyyy HH:mm:ss"))"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == objNotificationVM.arrNotificationModel.count-1{
            if objNotificationVM.currentPage+1 < objNotificationVM.totalPage  {
                objNotificationVM.currentPage += 1
                objNotificationVM.getNotificationList {
                    self.tblVwNotificationList.reloadData()
                }
            }
        }
    }
}
extension NotificationVC: EmptyStateDelegate {
    
    func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
        objNotificationVM.arrNotificationModel = []
        objNotificationVM.getNotificationList {
            self.tblVwNotificationList.reloadData()
        }
    }
}

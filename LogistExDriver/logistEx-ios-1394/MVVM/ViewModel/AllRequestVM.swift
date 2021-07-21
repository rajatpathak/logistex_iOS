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

protocol AcceptRequest {
    func setRoot()
}
var delegateAcceptRequest: AcceptRequest?
class AllRequestVM: NSObject {
    
    //MARK:- Variables
    var currentPage = Int()
    var totalPage = Int()
    var arrAllRequest = [AllRequestModel]()
    var filterType = String()
    var sortingType = String()
    var objOrderDetailVM = OrderDetailVM()
    
    //MARK:- Hit All Request List Api
    func hitAllRequestListApi(filter: String, sort: String, completion:@escaping() -> Void) {
        
        WebServiceProxy.shared.getData("\(Apis.requestAllList)?page=\(currentPage)&filter=\(filter)&sort=\(sort)", showIndicator: true) { (response) in
            if response.success {
                if self.currentPage == 0 {
                    self.arrAllRequest = []
                }
                if let dictMeta = response.data?["_meta"] as? NSDictionary {
                    self.totalPage  = dictMeta["pageCount"] as! Int
                }
                if let listArr = response.data?["list"] as? [NSDictionary] {
                    for dict in listArr {
                        let objRequestListModel = AllRequestModel()
                        objRequestListModel.handleData(dict)
                        self.arrAllRequest.append(objRequestListModel)
                    }
                }
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
}

extension AllRequestVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objAllRequestVM.arrAllRequest.count == 0 {
            tableView.emptyState.show(TableState.noSearch)
        } else {
            tableView.emptyState.hide()
        }
        return objAllRequestVM.arrAllRequest.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = objAllRequestVM.arrAllRequest[indexPath.row]
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllRequestTVC") as! AllRequestTVC
        cell.lblOrderId.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.orderIdSpa : TitleValue.orderId) \(dict.orderId)"
        cell.lblPickUpLocation.text = dict.pickupLocation
        cell.lblDropUpLocation.text = dict.dropupLocation
        if lang == ChooseLanguage.spanish.rawValue {
            cell.lblDateTime.text = "\(dict.pickupDate.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "dd-MM-yyyy HH:mm:ss"))"
        } else {
            cell.lblDateTime.text = "\(dict.pickupDate.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "MM-dd-yyyy HH:mm:ss"))"
        }
        cell.btnRm.setTitle("\(dict.currency) \(dict.amount)", for: .normal)
        cell.btnAccept.tag = indexPath.row
        cell.btnAccept.addTarget(self, action: #selector(actionAcceptRequest(_ :)), for: .touchUpInside)
        cell.btnPass.tag = indexPath.row
        cell.btnPass.addTarget(self, action: #selector(actionRejectRequest(_ :)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 290
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == objAllRequestVM.arrAllRequest.count-1 {
            if objAllRequestVM.totalPage > objAllRequestVM.currentPage+1 {
                objAllRequestVM.currentPage += 1
                objAllRequestVM.hitAllRequestListApi(filter: objAllRequestVM.filterType, sort: objAllRequestVM.sortingType) {
                    DispatchQueue.main.async {
                        self.tblVwAllRequest.reloadData()
                    }
                }
            }
        }
    }
    @objc func actionAcceptRequest(_ sender: UIButton) {
        acceptAlert(sender)
    }
    @objc func actionRejectRequest(_ sender: UIButton) {
        let dict = objAllRequestVM.arrAllRequest[sender.tag]
        objAllRequestVM.objOrderDetailVM.hitRejectRequestApi("\(dict.orderId)") {
            self.objAllRequestVM.arrAllRequest.remove(at: sender.tag)
            self.tblVwAllRequest.reloadData()
        }
    }
    func acceptAlert(_ sender: UIButton) {
        let dict = objAllRequestVM.arrAllRequest[sender.tag]
        let controller = UIAlertController(title: AppInfo.appName, message: AlertMessages.accept.localized, preferredStyle: .alert)
        let okAction = UIAlertAction(title: AlertMessages.ok, style: .default) { (action) in
            if dict.bookingType == "\(BookingType.bookNow.rawValue)" {
                self.objAllRequestVM.objOrderDetailVM.hitAcceptRequestApi("\(dict.orderId)") {
                    self.rootWithDrawer(identifier: "HomeVC")
                    delegateAcceptRequest?.setRoot()
                }
            } else {
                self.objAllRequestVM.objOrderDetailVM.hitAcceptScheduledRequestApi("\(dict.orderId)") {
                      self.rootWithDrawer(identifier: "HomeVC")
                     // delegateAcceptRequest?.setRoot()
                }
            }
        }
       
        let cancelAction = UIAlertAction(title: AlertMessages.cancel.localized, style: .default, handler: nil)
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        controller.view.tintColor = Color.app
        self.present(controller, animated: true, completion: nil)
    }
}
extension AllRequestVC: EmptyStateDelegate {
    
    func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
        filteringData()
    }
}

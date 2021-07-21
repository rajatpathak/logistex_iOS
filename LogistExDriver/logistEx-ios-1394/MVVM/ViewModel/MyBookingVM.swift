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

class MyBookingVM: NSObject {
    //MARK:- Variables
    var selectedVal = Int()
    var currentPage = Int()
    var totalPage = Int()
    var arrBokkingHistory = [DriverDetailModel]()
    var type = DeliveryState.completed.rawValue
    var objBookingModel = DriverDetailModel()
    var notificationType = String()
    
    //MARK:- Hit Booking History Api
    func hitBookingHistoryApi(_ type: String,completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.bookingHistory)?type=\(type)&page=\(currentPage)", showIndicator: true) { (response) in
            if response.success {
                if self.currentPage == 0 {
                    self.arrBokkingHistory = []
                }
                if let dictMeta = response.data?["_meta"] as? NSDictionary {
                    self.totalPage  = dictMeta["pageCount"] as! Int
                }
                if let listArr = response.data?["list"] as? [NSDictionary] {
                    for dict in listArr {
                        self.objBookingModel = DriverDetailModel()
                        self.objBookingModel.handleData(dict)
                        self.arrBokkingHistory.append(self.objBookingModel)
                    }
                }
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
    //MARK:- Hit Cancel Booking By Driver Api
    func hitCancelBookingDriverApi(_ bookingId: String,completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.cancelBookingDriver)?id=\(bookingId)", showIndicator: true) { (response) in
            if response.success {
                objUserModel.objAccepRequestModel.bookingId = ""
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
}

extension MyBookingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objMyBookingVM.arrBokkingHistory.count == 0 {
            tableView.emptyState.show(TableState.noSearch)
        } else {
            tableView.emptyState.hide()
        }
        return objMyBookingVM.arrBokkingHistory.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = objMyBookingVM.arrBokkingHistory[indexPath.row]
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        let cell = tableView.dequeueReusableCell(withIdentifier: "PastBookingTVC") as! PastBookingTVC
        cell.lblOrderNo.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.orderNoSpa : TitleValue.orderNo) \(dict.bookingId)"
        cell.lblOrderPrice.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.orderPriceSpa : TitleValue.orderPrice) \(dict.currencySymbol) \(dict.amount) \(dict.currency)"
        cell.btnRate.setTitle(dict.comment != "" ? lang == ChooseLanguage.spanish.rawValue ? TitleValue.alreadyRateSpa : TitleValue.alreadyRate : lang == ChooseLanguage.spanish.rawValue ? TitleValue.rateUserSpa : TitleValue.rateUser, for: .normal)
        switch dict.bookingState {
        case StateRequest.active.rawValue:
            if lang == ChooseLanguage.spanish.rawValue {
                cell.lblPickupTime.text = "\(TitleValue.pickUpTimeSpa) \(dict.pickupDate.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "dd-MM-yyyy HH:mm:ss"))"
            } else {
                cell.lblPickupTime.text = "\(TitleValue.pickUpTime) \(dict.pickupDate.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "MM-dd-yyyy HH:mm:ss"))"
            }
            
            cell.lblDeliveryStatus.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.pickUpTimeSpa : TitleValue.deliveryStatus) \(lang == ChooseLanguage.spanish.rawValue ? TitleValue.assignedSpa : TitleValue.assigned)"
            cell.btnRate.isHidden = true
            cell.vwCancel.isHidden = false
        case StateRequest.inProgress.rawValue:
            if lang == ChooseLanguage.spanish.rawValue {
                cell.lblPickupTime.text = "\(TitleValue.pickUpTimeSpa) \(dict.pickupDate.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "dd-MM-yyyy HH:mm:ss"))"
            } else {
                cell.lblPickupTime.text = "\(TitleValue.pickUpTime) \(dict.pickupDate.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "MM-dd-yyyy HH:mm:ss"))"
            }
            cell.lblDeliveryStatus.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.pickUpTimeSpa : TitleValue.deliveryStatus) \(TitleValue.progress)"
            cell.btnRate.isHidden = true
            cell.vwCancel.isHidden = false
        case StateRequest.pickup.rawValue:
            if lang == ChooseLanguage.spanish.rawValue {
                cell.lblPickupTime.text = "\(TitleValue.pickUpTimeSpa) \(dict.pickupDate.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "dd-MM-yyyy HH:mm:ss"))"
            } else {
                cell.lblPickupTime.text = "\(TitleValue.pickUpTime) \(dict.pickupDate.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "MM-dd-yyyy HH:mm:ss"))"
            }
            cell.lblDeliveryStatus.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.pickUpTimeSpa : TitleValue.deliveryStatus) \(lang == ChooseLanguage.spanish.rawValue ? TitleValue.pickedSpa : TitleValue.picked)"
            cell.btnRate.isHidden = true
            cell.vwCancel.isHidden = true
        case StateRequest.cancelled.rawValue:
            if lang == ChooseLanguage.spanish.rawValue {
                cell.lblPickupTime.text = "\(TitleValue.pickUpTimeSpa) \(dict.pickupDate.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "dd-MM-yyyy HH:mm:ss"))"
            } else {
                cell.lblPickupTime.text = "\(TitleValue.pickUpTime) \(dict.pickupDate.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "MM-dd-yyyy HH:mm:ss"))"
            }
            cell.lblDeliveryStatus.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.pickUpTimeSpa : TitleValue.deliveryStatus) \(lang == ChooseLanguage.spanish.rawValue ? TitleValue.bookingCancelledSpa : TitleValue.bookingCancelled)"
            cell.btnRate.isHidden = true
            cell.vwCancel.isHidden = true
        case StateRequest.completed.rawValue:
            if lang == ChooseLanguage.spanish.rawValue {
                cell.lblPickupTime.text = "\(TitleValue.deliveryTimeSpa) \(dict.deliveryTime.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "dd-MM-yyyy HH:mm:ss"))"
            } else {
                cell.lblPickupTime.text = "\(TitleValue.deliveryTime) \(dict.deliveryTime.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "MM-dd-yyyy HH:mm:ss"))"
            }
            
            cell.lblDeliveryStatus.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.pickUpTimeSpa : TitleValue.deliveryStatus) \(lang == ChooseLanguage.spanish.rawValue ? TitleValue.completedSpa : TitleValue.completed)"
            cell.btnRate.isHidden = false
            cell.vwCancel.isHidden = true
        case StateRequest.driverCancel.rawValue:
            if lang == ChooseLanguage.spanish.rawValue {
                cell.lblPickupTime.text = "\(TitleValue.deliveryTimeSpa) \(dict.deliveryTime.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "dd-MM-yyyy HH:mm:ss"))"
            } else {
                cell.lblPickupTime.text = "\(TitleValue.deliveryTime) \(dict.deliveryTime.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "MM-dd-yyyy HH:mm:ss"))"
            }
            cell.lblDeliveryStatus.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.deliveryStatusSpa : TitleValue.deliveryStatus) \(lang == ChooseLanguage.spanish.rawValue ? TitleValue.bookingCancelledSpa : TitleValue.bookingCancelled)"
            cell.btnRate.isHidden = true
            cell.vwCancel.isHidden = true
        default:
            break
        }
        let text = lang == ChooseLanguage.spanish.rawValue ? TitleValue.cancelCapsFirstLetterSpa : TitleValue.cancelCapsFirstLetter
        cell.btnRate.tag = indexPath.row
        cell.btnCancel.tag = indexPath.row
        cell.btnCancel.setTitle(text, for: .normal)
        cell.btnRate.addTarget(self, action: #selector(actionViewRating(_ :)), for: .touchUpInside)
        cell.btnCancel.addTarget(self, action: #selector(actionCancel(_ :)), for: .touchUpInside)
        cell.btnViewDetails.tag = indexPath.row
        cell.btnViewDetails.addTarget(self, action: #selector(actionViewDetail(_ :)), for: .touchUpInside)
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if objMyBookingVM.type == DeliveryState.accepted.rawValue {
            self.rootWithDrawer(identifier: "HomeVC")
            delegateAcceptRequest?.setRoot()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(155)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == objMyBookingVM.arrBokkingHistory.count-1 {
            if objMyBookingVM.totalPage > objMyBookingVM.currentPage+1 {
                objMyBookingVM.currentPage += 1
                objMyBookingVM.hitBookingHistoryApi("\(objMyBookingVM.type)") {
                    DispatchQueue.main.async {
                        self.tblVwBooking.reloadData()
                    }
                }
            }
        }
    }
    @objc func actionViewDetail(_ sender: UIButton) {
        let dict = objMyBookingVM.arrBokkingHistory[sender.tag]
        let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "DriverDetailsVC") as! DriverDetailsVC
        controller.objDriverDetailsVM.bookingId = dict.bookingId
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @objc func actionViewRating(_ sender: UIButton) {
        let dict = objMyBookingVM.arrBokkingHistory[sender.tag]
        let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "RatingVC") as! RatingVC
        controller.objDriverDetailModel = dict
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @objc func actionCancel(_ sender: UIButton) {
        cancelBookingAlert(sender)
    }
    func cancelBookingAlert(_ sender: UIButton) {
        let dict = objMyBookingVM.arrBokkingHistory[sender.tag]
        let controller = UIAlertController(title: AppInfo.appName, message: AlertMessages.cancelBooking.localized, preferredStyle: .alert)
        let okAction = UIAlertAction(title: AlertMessages.ok, style: .default) { (action) in
            self.objMyBookingVM.hitCancelBookingDriverApi(dict.bookingId) {
                self.objMyBookingVM.arrBokkingHistory.remove(at: sender.tag)
                self.tblVwBooking.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: AlertMessages.cancel.localized, style: .default, handler: nil)
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        controller.view.tintColor = Color.app
        self.present(controller, animated: true, completion: nil)
    }
}

extension MyBookingVC: EmptyStateDelegate {
    
    func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
        myBookingData()
    }
}

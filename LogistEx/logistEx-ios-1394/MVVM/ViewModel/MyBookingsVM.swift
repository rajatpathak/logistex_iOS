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

class MyBookingsVM: NSObject {
    
    //MARK:- Variables
    var arrBookingModel = [BookingModel]()
    var currentPage = Int()
    var totalPage = Int()
    var filterId = String()
    var paypalWebUrl = String()
    
    //MARK:- Get Booking List Api
    func getBookingListApi(_ filterId: String, completion:@escaping()-> Void){
        WebServiceProxy.shared.getData(urlStr: "\(Apis.bookingList)?page=\(currentPage)&type=\(filterId)", showIndicator: true) { (response) in
            
            if self.currentPage == 0 {
                self.arrBookingModel.removeAll()
            }
            if let paginationDict = response?.data?["_meta"] as? Dictionary<String, AnyObject>{
                self.totalPage = paginationDict["pageCount"] as? Int ?? 0
            }
            if let arrBookingList = response?.data?["list"] as? [Dictionary<String, AnyObject>]{
                for dict in arrBookingList{
                    let objBookingModel = BookingModel()
                    objBookingModel.setBookingDetail(dictData: dict)
                    self.arrBookingModel.append(objBookingModel)
                }
            }
            completion()
        }
    }
    //MARK:- Hit get Paypal Url
    func hitGetPaypalUrlApi(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData(urlStr: "\(Apis.getPaypalUrl)", showIndicator: false) { (response) in
            self.paypalWebUrl = response?.data!["paypal_url"] as? String ?? ""
            completion()
        }
    }
    //MARK:- Hit Payment Api
    func hitPaymentApi(bookingId : Int , completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData(urlStr: "\(Apis.payment)?booking_id=\(bookingId)", showIndicator: true) { (response) in
            self.paypalWebUrl = response?.data!["paypal_url"] as? String ?? ""
            completion()
        }
    }
}

extension MyBookingsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objMyBookingsVM.arrBookingModel.count == 0 {
            DispatchQueue.main.async {
                tableView.emptyState.show(TableState.noNotifications)
            }
        } else {
            DispatchQueue.main.async {
                tableView.emptyState.hide()
            }
        }
        
        return objMyBookingsVM.arrBookingModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingsTVC") as! MyBookingsTVC
        let bookingDict = objMyBookingsVM.arrBookingModel[indexPath.row]
        cell.lblOrderId.text = PassTitles.oderId.localized + " - \(bookingDict.id)"
        cell.lblPickUp.text = bookingDict.pickUpLocation
        cell.lblDrop.text = bookingDict.dropLocation
        cell.lblRm.text =  bookingDict.currencySymbol + " \(bookingDict.amount) \(bookingDict.currency)"
        cell.vwStateAssigningHghtConst.constant = 35
        switch bookingDict.stateId {
        case BookingState.active.rawValue:
            if bookingDict.paymentStatus == 0 {
                cell.lblStateAssigning.text = "\(PassTitles.assigned.localized) \n(\(AlertMessages.paymentPending.localized))"
                cell.vwStateAssigningHghtConst.constant = 55
            } else {
                cell.lblStateAssigning.text = PassTitles.assigned.localized
                cell.vwStateAssigningHghtConst.constant = 35
            }
            showHideCancellButton(cell: cell, isHide: false)
            cell.lblPackagedeliveredDate.text = ""
            cell.btnGiveRating.isHidden = true
        case BookingState.deleted.rawValue:
            cell.lblStateAssigning.text = AlertMessages.bookingDeleted.localized
            showHideCancellButton(cell: cell, isHide: true)
            cell.lblPackagedeliveredDate.text = ""
            cell.btnGiveRating.isHidden = true
        case BookingState.pending.rawValue :
            if bookingDict.paymentStatus == 0 {
                cell.lblStateAssigning.text = AlertMessages.paymentPending.localized
            } else {
                cell.lblStateAssigning.text = AlertMessages.assigningDriverShortly.localized
            }
            showHideCancellButton(cell: cell, isHide: false)
            cell.lblPackagedeliveredDate.text = ""
            cell.btnGiveRating.isHidden = true
        case BookingState.cancelled.rawValue :
            cell.lblStateAssigning.text = AlertMessages.bookingCancelled.localized
            showHideCancellButton(cell: cell, isHide: true)
            cell.lblPackagedeliveredDate.text = ""
            cell.btnGiveRating.isHidden = true
        case BookingState.inProgress.rawValue:
            cell.lblStateAssigning.text = PassTitles.progress.localized
            showHideCancellButton(cell: cell, isHide: false)
            cell.lblPackagedeliveredDate.text = ""
            cell.btnGiveRating.isHidden = true
        case BookingState.pickup.rawValue:
            cell.lblStateAssigning.text = PassTitles.picked.localized
            showHideCancellButton(cell: cell, isHide: true)
            cell.lblPackagedeliveredDate.text = ""
            cell.btnGiveRating.isHidden = true
        case BookingState.completed.rawValue:
            showHideCancellButton(cell: cell, isHide: true)
            cell.lblStateAssigning.text = PassTitles.bookingCompleted.localized
            let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
            if lang == ChooseLanguage.english.rawValue {
                cell.lblPackagedeliveredDate.text = " \(bookingDict.deliveryTime.changeDateFormatOfStrDate(currentFormat: "yyyy-MM-dd HH:mm:ss", willingFormat: "MM-dd-yyyy HH:mm:ss"))"
            } else {
                cell.lblPackagedeliveredDate.text = " \(bookingDict.deliveryTime.changeDateFormatOfStrDate(currentFormat: "yyyy-MM-dd HH:mm:ss", willingFormat: "dd-MM-yyyy HH:mm:ss"))"
            }
            
            cell.btnGiveRating.setTitle(bookingDict.isRated ? AlertMessages.alreadyRated.localized : AlertMessages.giveRating.localized , for: .normal)
            cell.btnGiveRating.tag = indexPath.row
            cell.btnGiveRating.addTarget(self, action: #selector(moveToRating(_ :)), for: .touchUpInside)
        case BookingState.driverCancel.rawValue:
            showHideCancellButton(cell: cell, isHide: true)
            cell.btnGiveRating.isHidden = true
            cell.lblStateAssigning.text = PassTitles.cancelDriver.localized
        default:
            break
        }
        cell.btnChangeRequest.isHidden = bookingDict.isChangeAmountRequest == 1 ? false : true
        cell.btnCancelBooking.tag = indexPath.row
        cell.btnCancelBooking.addTarget(self, action: #selector(cancelBooking(_ :)), for: .touchUpInside)
        cell.btnChangeRequest.tag = indexPath.row
        cell.btnChangeRequest.addTarget(self, action: #selector(actionChangeRequest), for: .touchUpInside)
        cell.btnVwDetail.tag = indexPath.row
        cell.btnVwDetail.addTarget(self, action: #selector(viewDetails(_ :)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookingDict = objMyBookingsVM.arrBookingModel[indexPath.row]
        switch bookingDict.stateId {
        case BookingState.pending.rawValue:
            if bookingDict.paymentMethod == PaymentMethod.paypal.rawValue && bookingDict.paymentStatus == 0 {
                objMyBookingsVM.hitGetPaypalUrlApi {
                    // new paypal api
                    if self.objMyBookingsVM.paypalWebUrl != ""{
                        let controller  = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: "PaymentWebViewVC") as! PaymentWebViewVC
                        controller.objPaymentWebViewVM.complition = {
                            title in
                            if title != ""{
                                self.rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC)
                            }
                        }
                        controller.objPaymentWebViewVM.bookingId = bookingDict.id
                        controller.objPaymentWebViewVM.paypalWebUrl = self.objMyBookingsVM.paypalWebUrl
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
            }
            
        case BookingState.active.rawValue:
            if bookingDict.changeRequestAmount != 1 && bookingDict.isNagotiable == 1 && bookingDict.paymentMethod == PaymentMethod.paypal.rawValue && bookingDict.paymentStatus == 0 {
                // payment api hit
                objMyBookingsVM.hitPaymentApi(bookingId: bookingDict.id){
                    if self.objMyBookingsVM.paypalWebUrl != ""{
                        let controller  = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: "PaymentWebViewVC") as! PaymentWebViewVC
                        let url = URL(string: self.objMyBookingsVM.paypalWebUrl)
                        let lastPath = url?.lastPathComponent as? String ?? "0"
                        controller.objPaymentWebViewVM.complition = {
                            title in
                            if title != ""{
                                self.rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC)
                            }
                        }
                        controller.objPaymentWebViewVM.bookingId = Int(lastPath)!
                        controller.objPaymentWebViewVM.paypalWebUrl = self.objMyBookingsVM.paypalWebUrl
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
            } else if  bookingDict.changeRequestAmount != 1 && bookingDict.isNagotiable == 1 && bookingDict.paymentMethod == PaymentMethod.bankTransfer.rawValue && bookingDict.paymentStatus == 0 {
                KAppDelegate.objVariableSaveModel.requestId = bookingDict.id
                KAppDelegate.objVariableSaveModel.currencyTitle = bookingDict.currency
                KAppDelegate.objVariableSaveModel.currencySymbol = bookingDict.currencySymbol
                KAppDelegate.objVariableSaveModel.amount = bookingDict.amount
                KAppDelegate.objVariableSaveModel.isChangeRequest = AlertMessages.no
                self.pushVC(selectedStoryboard: .main, identifier: .bankList)
            } else {
                let objPushVC = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: IdentifiersVC.nearByDriver.rawValue) as! GetNearByDriverVC
                objPushVC.objGetNearByDriverVM.bookingId = bookingDict.id
                objPushVC.objGetNearByDriverVM.type = bookingDict.stateId
                self.navigationController?.pushViewController(objPushVC, animated: true)
            }
            
        default:
            let objPushVC = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: IdentifiersVC.nearByDriver.rawValue) as! GetNearByDriverVC
            objPushVC.objGetNearByDriverVM.bookingId = bookingDict.id
            objPushVC.objGetNearByDriverVM.type = bookingDict.stateId
            self.navigationController?.pushViewController(objPushVC, animated: true)
        }
    }
    
    @objc func moveToRating(_ sender:UIButton) {
        let objPushVC = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: IdentifiersVC.rateBookingVC.rawValue) as? RateBookingVC
        objPushVC?.objRateBookingVM.objBookingModel = objMyBookingsVM.arrBookingModel[sender.tag]
        self.navigationController?.pushViewController(objPushVC!, animated: true)
    }
    
    @objc func cancelBooking(_ sender:UIButton) {
        cancelBookingAlert(sender)
    }
    @objc func actionChangeRequest(_ sender:UIButton) {
        let bookingDict = objMyBookingsVM.arrBookingModel[sender.tag]
        let changeAmountVCObj  = self.storyboard!.instantiateViewController(withIdentifier: "BookingChangePriceRequestVC") as! BookingChangePriceRequestVC
        changeAmountVCObj.objBookingChangePriceRequestVM.bookingModel = bookingDict
        self.navigationController?.pushViewController(changeAmountVCObj, animated: true)
    }
    
    private func showHideCancellButton(cell: MyBookingsTVC, isHide: Bool){
        DispatchQueue.main.async {
            cell.cnstHeightCancelVw.constant = isHide ? 0 : 35
            cell.vwCancelBooking.isHidden = isHide
            cell.btnCancelBooking.isHidden = isHide
        }
    }
    
    
    @objc func  viewDetails(_ sender:UIButton) {
        let bookingDict = objMyBookingsVM.arrBookingModel[sender.tag]
        let objPushVC = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: IdentifiersVC.bookingDetailVC.rawValue) as? BookingDetailVC
        objPushVC?.objBookingDetailVM.detailId = bookingDict.id
        self.navigationController?.pushViewController(objPushVC!, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == objMyBookingsVM.arrBookingModel.count-1 {
            if objMyBookingsVM.currentPage+1 < objMyBookingsVM.totalPage{
                objMyBookingsVM.currentPage += 1
                objMyBookingsVM.getBookingListApi(objMyBookingsVM.filterId) {
                    DispatchQueue.main.async {
                        self.tblVwBookingList.reloadData()
                    }
                }
            }
        }
    }
    func cancelBookingAlert(_ sender: UIButton) {
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        let value = "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.cancelBookingSpa : PassTitles.cancelBooking)"
        
        let controller = UIAlertController(title: AppInfo.appName, message: value, preferredStyle: .alert)
        let valueBtnYes = "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.yesSpa : PassTitles.yes)"
        
        let okAction = UIAlertAction(title: valueBtnYes, style: .default) { (action) in
            CancelbookingVM().getCancelBookingApi( "\(self.objMyBookingsVM.arrBookingModel[sender.tag].id)") {
                self.objMyBookingsVM.arrBookingModel[sender.tag].stateId = BookingState.cancelled.rawValue
                self.tblVwBookingList.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: AlertMessages.no.localized, style: .default, handler: nil)
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        controller.view.tintColor = Color.app
        self.present(controller, animated: true, completion: nil)
    }
}

extension MyBookingsVC: FilterDelegateProtocol{
    func sendFilterData(id: Int, title: String) {
        objMyBookingsVM.filterId = "\(id)"
        objMyBookingsVM.currentPage = 0
        objMyBookingsVM.getBookingListApi(objMyBookingsVM.filterId) {
            DispatchQueue.main.async {
                self.tblVwBookingList.reloadData()
            }
        }
    }
}
extension MyBookingsVC: EmptyStateDelegate {
    
    func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
        myBookingData()
    }
}

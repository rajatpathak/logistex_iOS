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

class MyEarningVM: NSObject {
    
    //MARK:- Variables
    var currentPage = Int()
    var totalPage = Int()
    var arrEarning = [EarningModel]()
    var date = String()
    var totalAmount = Double()
    var currencyId = String()
    var currencyName = String()
    
    //MARK:- Get Earning Api
    func getEarningApi(_ date : String, id: String, completion:@escaping() -> Void) {
        let param = ["Booking[currency]": id] as [String:AnyObject]
        WebServiceProxy.shared.postData("\(Apis.earning)?page=\(currentPage)&date=\(date)", params: param, showIndicator: true) { (response) in
            if response.success {
                if self.currentPage == 0 {
                    self.arrEarning = []
                }
                
                if let paginationDict  = response.data!["_meta"] as? NSDictionary {
                    if let pageCountVal = paginationDict["pageCount"] as? Int{
                        self.totalPage = pageCountVal
                    }
                }
                self.totalAmount = Proxy.shared.isValueDouble(response.data!["total"] as Any)
                if let listArray = response.data!["list"] as? [NSDictionary] {
                    for dict in listArray {
                        let objEarningModel = EarningModel()
                        objEarningModel.handleData(dict)
                        self.arrEarning.append(objEarningModel)
                    }
                }
                completion()
            }
            else {
                Proxy.shared.displayStatusAlert(response.data?["message"] as? String ?? "")
            }
        }
    }
}

extension MyEarningsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return objEarningVM.arrEarning.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let earningDict = objEarningVM.arrEarning[indexPath.row]
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyEarningsTVC") as! MyEarningsTVC
        cell.lblRm.text = "\(earningDict.currency) \(earningDict.amount)"
        cell.lblOrderNo.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.orderNoSpa : TitleValue.orderNo) \(earningDict.orderId)"
        cell.lblDropupLocation.text = earningDict.dropupLocation
        cell.lblPickupLocation.text = earningDict.pickupLocation
        if lang == ChooseLanguage.english.rawValue {
            cell.lblDate.text = earningDict.createdOn.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "MM-dd-yyyy HH:mm:ss")
        } else {
            cell.lblDate.text = earningDict.createdOn.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "dd-MM-yyyy HH:mm:ss")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        tableView.estimatedRowHeight = 220
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == objEarningVM.arrEarning.count-1 {
            if objEarningVM.totalPage > objEarningVM.currentPage+1 {
                objEarningVM.currentPage += 1
                objEarningVM.getEarningApi(objEarningVM.date, id: objEarningVM.currencyId) {
                    DispatchQueue.main.async {
                        self.tblVwEarning.reloadData()
                    }
                }
            }
        }
    }
}
extension MyEarningsVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtFldCurrency {
            let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "SelectCountryPopUpVC") as! SelectCountryPopUpVC
            controller.objSelectCountryPopUpVM.objCountryData = { (name,currencyId,currencyName) in
                let currencyVal = "\(name)(\(currencyName))"
                self.txtFldCurrency.text = currencyVal
                self.objEarningVM.currencyName = currencyName
                self.objEarningVM.currencyId = currencyId
            }
            self.present(controller, animated: true, completion: nil)
            return false
        }
        return true
    }
}

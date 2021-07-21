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

class SelectVehiclePopupVM: NSObject {
    
    //MARK: Variables
    var objVehicleCategory: VehicleId?
    var currentPage = Int()
    var totalPage = Int()
    var arrReasonList = [ReasonListModel]()
    var arrCategoryListModel = [VehicleCategoryListModel]()
    
    //MARK:- Hit Reason List Api
    func hitReasonListApi(_ type: Int, completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.reasonList)?page=\(currentPage)&type=\(type)", showIndicator: true) { (response) in
            if response.success {
                if self.currentPage == 0 {
                    self.arrReasonList = []
                }
                if let dictMeta = response.data?["_meta"] as? NSDictionary {
                    self.totalPage  = dictMeta["pageCount"] as! Int
                }
                if let listArr = response.data?["list"] as? [NSDictionary] {
                    for dict in listArr {
                        let objReasonListModel = ReasonListModel()
                        objReasonListModel.handleData(dict)
                        self.arrReasonList.append(objReasonListModel)
                    }
                }
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
    //MARK:- Hit Vehicle Cateogry List Api
    func hitVehicleCateogryListApi(_ type: Int, completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.vehicleCategoryList)?page=\(currentPage)&type=\(type)", showIndicator: true) { (response) in
            if response.success {
                if self.currentPage == 0 {
                    self.arrCategoryListModel = []
                }
                if let dictMeta = response.data?["_meta"] as? NSDictionary {
                    self.totalPage  = dictMeta["pageCount"] as! Int
                }
                if let listArr = response.data?["list"] as? [NSDictionary] {
                    for dict in listArr {
                        let objVehicleCategoryListModel = VehicleCategoryListModel()
                        objVehicleCategoryListModel.handleData(dict)
                        self.arrCategoryListModel.append(objVehicleCategoryListModel)
                    }
                }
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
}

extension SelectVehiclePopupVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.title == TitleValue.chooseReason ? objSelectVehiclePopupVM.arrReasonList.count : objSelectVehiclePopupVM.arrCategoryListModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleCategoryTVC") as! VehicleCategoryTVC
        cell.lblTitle.text = self.title == TitleValue.chooseReason ? objSelectVehiclePopupVM.arrReasonList[indexPath.row].title : objSelectVehiclePopupVM.arrCategoryListModel[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let block = objSelectVehiclePopupVM.objVehicleCategory else {return}
        dismiss()
        if self.title == TitleValue.chooseReason {
            let dict = objSelectVehiclePopupVM.arrReasonList[indexPath.row]
            block(dict.id, dict.title)
        } else {
            let dict = objSelectVehiclePopupVM.arrCategoryListModel[indexPath.row]
            block(dict.id, dict.title)
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == objSelectVehiclePopupVM.arrReasonList.count-1 {
            if objSelectVehiclePopupVM.totalPage > objSelectVehiclePopupVM.currentPage+1 {
                objSelectVehiclePopupVM.currentPage += 1
                objSelectVehiclePopupVM.hitReasonListApi(ContactType.driver.rawValue) {
                    DispatchQueue.main.async {
                        self.tblVwVehicle.reloadData()
                    }
                }
            }
        }
    }
}


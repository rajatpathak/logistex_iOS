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

class SelectVehicleTypePopupVM: NSObject {
    
    //MARK: Variables
    var currentPage = Int()
    var totalPage = Int()
    var arrVechicleTypeListModel = [VechicleTypeListModel]()
    var isApiHit = String()
    var complition : completionHandler?
    typealias completionHandler = (String,String) -> Void
    
    //MARK:- Hit Vehicle Type List Api
    func hitVehicleTypeListApi(finalUrl : String,completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(finalUrl)?page=\(currentPage)", showIndicator: true) { (response) in
            if response.success {
                if self.currentPage == 0 {
                    self.arrVechicleTypeListModel = []
                }
                if let dictMeta = response.data?["_meta"] as? NSDictionary {
                    self.totalPage  = dictMeta["pageCount"] as! Int
                }
                if let listArr = response.data?["list"] as? [NSDictionary] {
                    for dict in listArr {
                        let objVechicleTypeListModel = VechicleTypeListModel()
                        objVechicleTypeListModel.handleData(dict)
                        self.arrVechicleTypeListModel.append(objVechicleTypeListModel)
                    }
                }
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
}


extension SelectVehicleTypePopupVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objSelectVehicleTypePopupVM.arrVechicleTypeListModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleCategoryTVC") as! VehicleCategoryTVC
        cell.lblTitle.text = objSelectVehicleTypePopupVM.arrVechicleTypeListModel[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = objSelectVehicleTypePopupVM.arrVechicleTypeListModel[indexPath.row]
        guard let finalComp = objSelectVehicleTypePopupVM.complition else {
            return
        }
        finalComp("\(dict.id)", dict.title)
        dismiss()
    }
}




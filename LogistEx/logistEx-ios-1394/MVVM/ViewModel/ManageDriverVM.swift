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

class ManageDriverVM: NSObject {
    
    //MARK:- Variables
    var arrManageDriver = [ManageDriverModel]()
    var currentPage = Int()
    var totalPage = Int()
    var type = ManageDriver.fav.rawValue
    
    //MARK:- Driver List Api
    func getDriverListApi(_ type: String, completion: @escaping()-> Void){
        WebServiceProxy.shared.getData(urlStr: "\(Apis.driverList)?type=\(type)&page=\(currentPage)", showIndicator: true) { (response) in
            if self.currentPage == 0{
                self.arrManageDriver.removeAll()
            }
            if let paginationDict = response?.data!["_meta"] as? Dictionary<String, AnyObject>{
                self.totalPage = paginationDict["pageCount"] as? Int ?? 0
            }
            if let arrList = response?.data!["list"] as? [Dictionary<String, AnyObject>]{
                for dict in arrList{
                    let objDriverModel = ManageDriverModel()
                    objDriverModel.handleData(dict: dict)
                    self.arrManageDriver.append(objDriverModel)
                }
            }
            completion()
        }
    }
    //MARK:- Driver Unfavourite Api
    func getDriverUnfavouriteApi(_ id: String, type: String, completion: @escaping()-> Void){
        WebServiceProxy.shared.getData(urlStr: "\(Apis.driverUnfav)?id=\(id)&type=\(type)", showIndicator: true) { (response) in
            completion()
        }
    }
}
extension ManageDriverVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objManageDriverVM.arrManageDriver.count == 0 {
            tableView.emptyState.show(TableState.noBox)
        } else {
            tableView.emptyState.hide()
        }
        return objManageDriverVM.arrManageDriver.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageDriverTVC") as! ManageDriverTVC
        let driverDict = objManageDriverVM.arrManageDriver[indexPath.row]
        cell.lblDriverName.text = driverDict.driverName
        cell.lblVehicleNo.text = "Vehicle Number:- \(driverDict.vehicleNo)"
        cell.imgVwDriver.sd_setImage(with: URL(string: driverDict.driverProfile), placeholderImage: #imageLiteral(resourceName: "ic_drawer_pic"))
        cell.btnUnfav.tag = indexPath.row
        cell.btnUnfav.addTarget(self, action: #selector(actionUnfav(_ :)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == objManageDriverVM.arrManageDriver.count-1{
            if objManageDriverVM.currentPage+1 < objManageDriverVM.totalPage  {
                objManageDriverVM.currentPage += 1
                objManageDriverVM.getDriverListApi("\(objManageDriverVM.type)") {
                    DispatchQueue.main.async {
                        self.tblVwDriver.reloadData()
                    }
                }
            }
        }
    }
    @objc func actionUnfav(_ sender: UIButton) {
        let driverDict = objManageDriverVM.arrManageDriver[sender.tag]
        objManageDriverVM.getDriverUnfavouriteApi("\(driverDict.id)", type: "0") {
            sender.isSelected = false
            self.objManageDriverVM.arrManageDriver.remove(at: sender.tag)
            self.tblVwDriver.reloadData()
        }
    }
}

extension ManageDriverVC: EmptyStateDelegate {
    
    func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
         actionStatus(btnFavorite)
    }
}

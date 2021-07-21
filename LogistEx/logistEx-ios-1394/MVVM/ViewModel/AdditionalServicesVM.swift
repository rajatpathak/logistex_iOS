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

class AdditionalServicesVM: NSObject {
    
    var currentpage = 0
    var totalpage = 0
    var arrAdditionalServicesModel = [AdditionalServicesModel]()
    
    func getAdditonalServicesList(typeId:String, success:@escaping()->()) {
        
        WebServiceProxy.shared.getData(urlStr: "\(Apis.serviceList)?type=\(typeId)&page=\(currentpage)", showIndicator: true) { response in
            
            if self.currentpage == 0{
                self.arrAdditionalServicesModel.removeAll()
            }
            
            if let paginationDict = response?.data!["_meta"] as? Dictionary<String, AnyObject>{
                self.totalpage = paginationDict["pageCount"] as? Int ?? 0
            }
            
            if let arrList = response?.data!["list"] as? [Dictionary<String, AnyObject>]{
                for dict in arrList{
                    self.arrAdditionalServicesModel.append(AdditionalServicesModel.init(fromDictionary: dict))
                }                
            }
            success()
        }
    }
}


extension AdditionalServicesVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objAdditionalServicesVM.arrAdditionalServicesModel.count == 0 {
            tableView.emptyState.show(TableState.noFavorites)
        } else {
            tableView.emptyState.hide()
        }
        return objAdditionalServicesVM.arrAdditionalServicesModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalServicesTVC", for: indexPath) as! AdditionalServicesTVC
        let dictData = objAdditionalServicesVM.arrAdditionalServicesModel[indexPath.row]
        cell.lblTitle.text =  dictData.title
        cell.lblPrice.text =  "\(objUserModel.currency) \(dictData.amount)"
        cell.btnCheckbox.isSelected = dictData.isSelected
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        objAdditionalServicesVM.arrAdditionalServicesModel[indexPath.row].isSelected = !objAdditionalServicesVM.arrAdditionalServicesModel[indexPath.row].isSelected
        tblVwAdditionalServiceList.reloadData()
    }
}


extension AdditionalServicesVC: EmptyStateDelegate {
    
    func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
        tblVwAdditionalServiceList.reloadData()
    }
}

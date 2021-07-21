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

class SelectReasonVM: NSObject{
    
    //MARK:- Variables
    var categoryId = Int()
    var currentPage = Int()
    var arrCategory = [CategoryModel]()
    
    //MARK:- Get Reason List Api
    func getReasonList(_ type: Int, completion: @escaping()-> Void){
        WebServiceProxy.shared.getData(urlStr: "\(Apis.selectReason)?id=\(categoryId)&type=\(type)&page=\(currentPage)", showIndicator: true) { (response) in
            if let arrCategoryList = response?.data!["list"] as? [Dictionary<String, AnyObject>]{
                for dict in arrCategoryList {
                    let objCategoryModel = CategoryModel()
                    objCategoryModel.setCategoryData(dictData: dict)
                    self.arrCategory.append(objCategoryModel)
                }
            }
            completion()
        }
        
    }
}
extension SelectReasonVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objSelectReasonVM.arrCategory.count == 0 {
            tableView.emptyState.show( TableState.noNotifications)
        } else {
            tableView.emptyState.hide()
        }
        
        return objSelectReasonVM.arrCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectReasonTVC") as! SelectReasonTVC
        cell.lblCategory.text = objSelectReasonVM.arrCategory[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictData = objSelectReasonVM.arrCategory[indexPath.row]
        objCategoryDelegateProtocol.sendCategoryData(id: dictData.id, title: dictData.title)
        dismissController()
    }
}



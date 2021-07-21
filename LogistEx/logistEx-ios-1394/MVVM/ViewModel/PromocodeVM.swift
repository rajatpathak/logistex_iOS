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

class PromocodeVM: NSObject {
    
    //MARK:- Variables
    var arrPromocodeModel = [PromocodeModel]()
    var currentPage = Int()
    var totalPage = Int()
    
    //MARK:- Get PromoCodeList
    
    func getPromoCodeList(completion: @escaping()-> Void) {
        WebServiceProxy.shared.getData(urlStr: "\(Apis.promoCodeList)?page=\(currentPage)", showIndicator: true) { (response) in
            
            if self.currentPage == 0{
                self.arrPromocodeModel.removeAll()
            }
            
            if let paginationDict = response?.data!["_meta"] as? Dictionary<String, AnyObject>{
                self.totalPage = paginationDict["pageCount"] as? Int ?? 0
            }
            
            if let arrList = response?.data!["list"] as? [Dictionary<String, AnyObject>]{
                for dict in arrList{
                    self.arrPromocodeModel.append(PromocodeModel(fromDictionary: dict))
                }
            }
            completion()
        }
    }
    
    func getApplyPromoCode(code: String, completion: @escaping(_ objPromocodeModel: PromocodeModel)-> Void) {
        
        WebServiceProxy.shared.getData(urlStr: "\(Apis.applyPromoCode)?code=\(code)", showIndicator: true) { response in
            if let dictData = response?.data!["details"] as? Dictionary<String, AnyObject> {
                 completion(PromocodeModel(fromDictionary: dictData))
            }
        }
    }
}

extension PromocodeVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if objPromocodeVM.arrPromocodeModel.count == 0 {
            tableView.emptyState.show(TableState.noPromoCode)
        } else {
            tableView.emptyState.hide()
        }
        return objPromocodeVM.arrPromocodeModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromocodeTVC") as! PromocodeTVC
        let dictData = objPromocodeVM.arrPromocodeModel[indexPath.row]
        cell.lblTitle.text = dictData.title
        cell.lblDescprition.text = dictData.descriptionField.removeHTMLTag()
        cell.lblExpirationdate.text = dictData.expireOn
        cell.btnApply.tag = indexPath.row
        cell.btnApply.addTarget(self, action: #selector(applyPromoCode), for: .touchUpInside)
        return cell
    }
    
    @objc func applyPromoCode(_ sender: UIButton) {
        objPromocodeVM.getApplyPromoCode(code: objPromocodeVM.arrPromocodeModel[sender.tag].title) { objPromocodeModel in
            self.popToBack()
            objPromoModelDelegate?.setData(dictData: objPromocodeModel)
        }
    }
}

extension PromocodeVC: EmptyStateDelegate {
    
    func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
        promoCode()
    }
}

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

class BankListVM: NSObject {
    
    //MARK: Variables
    var currentPage = Int()
    var totalPage = Int()
    var arrBankListModel = [BankListModel]()
 
    //MARK:- Hit Bank List List Api
    func hitBankListApi(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData(urlStr: "\(Apis.adminBankList)?page=\(currentPage)", showIndicator: true) { (response) in
            
            if self.currentPage == 0 {
                self.arrBankListModel = []
            }
            if let dictMeta = response?.data?["_meta"] as? NSDictionary {
                self.totalPage  = dictMeta["pageCount"] as! Int
            }
            if let listArr = response?.data?["list"] as? [NSDictionary] {
                for dict in listArr {
                    let objBankListModel = BankListModel()
                    objBankListModel.handleData(dict)
                    self.arrBankListModel.append(objBankListModel)
                }
            }
            completion()
        }
    }
}

extension BankListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  objBankListVM.arrBankListModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BankListTVC") as! BankListTVC
        let dict = objBankListVM.arrBankListModel[indexPath.row]
        cell.lblName.text = dict.bankName
        cell.imgVwBank.sd_setImage(with: URL(string: dict.logoFile), placeholderImage: #imageLiteral(resourceName: "ic_login_logo"))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = objBankListVM.arrBankListModel[indexPath.row]
        let objController = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: "BankDetailVC") as! BankDetailVC
        objController.objBankDetailsVM.bankId = dict.id
        self.navigationController?.pushViewController(objController, animated: true)

    }
}


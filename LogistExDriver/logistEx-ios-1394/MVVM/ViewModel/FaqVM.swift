
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

class FaqVM: NSObject {
    
    //MARK:- Variables
    var selectedSection = -1
    var currentPage = Int()
    var totalPage = Int()
    var arrFaqModel = [FaqModel]()
    
    //MARK:- Hit Faq Api
    func hitFaqApi(_ type: String, completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.faq)?page=\(currentPage)&type=\(type)", showIndicator: true) { (response) in
            if response.success {
                if self.currentPage == 0 {
                    self.arrFaqModel = []
                }
                if let dictMeta = response.data?["_meta"] as? NSDictionary {
                    self.totalPage  = dictMeta["pageCount"] as! Int
                }
                if let listArr = response.data?["list"] as? [NSDictionary] {
                    for dict in listArr {
                        let objFaqModel = FaqModel()
                        objFaqModel.handleData(dict)
                        self.arrFaqModel.append(objFaqModel)
                    }
                }
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
}

extension FaqVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objFaqVM.arrFaqModel.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objFaqVM.selectedSection == section {
            return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FaqTVC") as! FaqTVC
        cell.lblTitle.text = objFaqVM.arrFaqModel[indexPath.section].answer
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "FaqHeaderTVC") as! FaqHeaderTVC
        headerCell.btnHeader.tag = section
        headerCell.lblTitle.text = objFaqVM.arrFaqModel[section].question
        if objFaqVM.selectedSection == section {
            headerCell.lblTitle.textColor = UIColor(displayP3Red: 0/255, green: 1, blue: 1, alpha: 1)
            headerCell.imgVwDropDown.isHighlighted = true
        } else {
            headerCell.lblTitle.textColor = .black
            headerCell.imgVwDropDown.isHighlighted = false
        }
        return headerCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tblVwFaq.estimatedRowHeight = 85
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == objFaqVM.arrFaqModel.count-1 {
            if objFaqVM.totalPage > objFaqVM.currentPage+1 {
                objFaqVM.currentPage += 1
                objFaqVM.hitFaqApi("\(TypePage.termDriver.rawValue)") {
                    DispatchQueue.main.async {
                        self.tblVwFaq.reloadData()
                    }
                }
            }
        }
    }
}

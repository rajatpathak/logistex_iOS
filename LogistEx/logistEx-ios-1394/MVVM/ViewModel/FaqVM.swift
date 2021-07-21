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
class FaqVM: NSObject{
    
    //MARK:- Variables
    var arrFaqModel = [FaqModel]()
    
      //MARK:- Faq List Api
    func getFaqsList(completion: @escaping()-> Void){
        WebServiceProxy.shared.getData(urlStr: "\(Apis.faqList)?type=\(PageType.userType.rawValue)", showIndicator: true) { (response) in
            if let arrFaq = response?.data!["list"] as? [Dictionary<String, AnyObject>]{
                for dict in arrFaq{
                    let objFaqModel = FaqModel()
                    objFaqModel.setFaqData(dictData: dict)
                    self.arrFaqModel.append(objFaqModel)
                }
            }
            completion()
        }
    }
}
extension FaqVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objFaqVM.arrFaqModel.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSection == section {
            return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FaqTVC") as! FaqTVC
        let dictFaq = objFaqVM.arrFaqModel[indexPath.section]
        cell.lblTitle.text = dictFaq.answer
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "FaqHeaderTVC") as! FaqHeaderTVC
        headerCell.btnHeader.tag = section
        headerCell.lblTitle.text =  objFaqVM.arrFaqModel[section].question
        if selectedSection == section {
            headerCell.lblTitle.textColor = UIColor(displayP3Red: 0/255, green: 1, blue: 1, alpha: 1)
            headerCell.vwBg.layer.borderColor = UIColor(displayP3Red: 0/255, green: 1, blue: 1, alpha: 1).cgColor
        } else {
            headerCell.lblTitle.textColor = .black
            headerCell.vwBg.layer.borderColor = UIColor.black.cgColor
        }
        return headerCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

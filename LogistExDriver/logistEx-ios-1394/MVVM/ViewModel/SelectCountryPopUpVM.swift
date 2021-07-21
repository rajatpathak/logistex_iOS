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

class SelectCountryPopUpVM: NSObject {
    
    //MARK: Variables
    var currentPage = Int()
    var totalPage = Int()
    var arrCountryList = [CountryListModel]()
    var objCountryData : CountryData?
    var title = String()
    
    //MARK:- Hit Country List Api
    func hitCountryListApi(_ title: String, completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.countryList)?page=\(currentPage)&title=\(title)", showIndicator: true) { (response) in
            if response.success {
                if self.currentPage == 0 {
                    self.arrCountryList = []
                }
                if let dictMeta = response.data?["_meta"] as? NSDictionary {
                    self.totalPage  = dictMeta["pageCount"] as! Int
                }
                if let listArr = response.data?["list"] as? [NSDictionary] {
                    for dict in listArr {
                        let objCountryListModel = CountryListModel()
                        objCountryListModel.handleData(dict)
                        self.arrCountryList.append(objCountryListModel)
                    }
                }
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
}

extension SelectCountryPopUpVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objSelectCountryPopUpVM.arrCountryList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = objSelectCountryPopUpVM.arrCountryList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCountryTVC") as! SelectCountryTVC
        cell.lblTitle.text = dict.countryName
        cell.lblCurrency.text = dict.currency
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let block = objSelectCountryPopUpVM.objCountryData else {return}
        dismiss()
        let dict = objSelectCountryPopUpVM.arrCountryList[indexPath.row]
        block(dict.countryName, "\(dict.id)", dict.currency)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == objSelectCountryPopUpVM.arrCountryList.count-1 {
            if objSelectCountryPopUpVM.totalPage > objSelectCountryPopUpVM.currentPage+1 {
                objSelectCountryPopUpVM.currentPage += 1
                objSelectCountryPopUpVM.hitCountryListApi(objSelectCountryPopUpVM.title) {
                    DispatchQueue.main.async {
                        self.tblVwCountry.reloadData()
                    }
                }
            }
        }
    }
}

extension SelectCountryPopUpVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = txtFldSearch?.text as NSString? ?? ""
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        objSelectCountryPopUpVM.title = txtAfterUpdate
        objSelectCountryPopUpVM.currentPage = 0
        objSelectCountryPopUpVM.hitCountryListApi(objSelectCountryPopUpVM.title) {
            DispatchQueue.main.async {
                self.tblVwCountry.reloadData()
            }
        }
        return true
    }
}

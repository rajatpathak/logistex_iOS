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
class FilterVM: NSObject {
    
    //MARK:- Variables
    var arrFilter = [(title: PassTitles.allOrders.localized, value : FilterType.allOrders.rawValue ),
                     (title: PassTitles.assigning.localized, value : FilterType.pending.rawValue ),
                     (title: PassTitles.driverAssigned.localized, value : FilterType.active.rawValue ),
                     (title: PassTitles.onGoing.localized, value : FilterType.inProgress.rawValue),
                     (title: PassTitles.completed.localized, value : FilterType.completed.rawValue ),
                     (title: PassTitles.cancelled.localized, value : FilterType.cancelled.rawValue )]
}
extension FilterVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objFilterVM.arrFilter.count == 0 {
            tableView.emptyState.show( TableState.noNotifications)
        } else {
            tableView.emptyState.hide()
        }
        
        return objFilterVM.arrFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTVC") as! FilterTVC
        cell.lblTitle.text = objFilterVM.arrFilter[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = objFilterVM.arrFilter[indexPath.row]
        if indexPath.row == 5 {
           // let value = dict.value.c
            objFilterDelegateProtocol.sendFilterData(id: dict.value, title: dict.title)
        } else {
           objFilterDelegateProtocol.sendFilterData(id: dict.value, title: dict.title)
        }
        self.dismissController()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

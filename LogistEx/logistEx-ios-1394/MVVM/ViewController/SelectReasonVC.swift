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

class SelectReasonVC: UIViewController {

    //MARK:- IBOUTLETS
    @IBOutlet weak var tblVwReasonList: UITableView!
    
    //MARK:- VARIABLES
    var objSelectReasonVM = SelectReasonVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objSelectReasonVM.getReasonList(ContactType.cust.rawValue) {
            self.tblVwReasonList.reloadData()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         dismissController()
    }
}

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

class BankListVC: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var tblVwBankList: UITableView!
    
    //MARK:- Variables
    var objBankListVM = BankListVM()
    
    //MARK:- Life cyecle method
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        objBankListVM.arrBankListModel = []
        objBankListVM.hitBankListApi {
            self.tblVwBankList.reloadData()
        }
    }
    //MARK:- Button actions
    @IBAction func actionBack(_ sender: UIButton) {
        popToBack()
    }
    
}

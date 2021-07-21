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

class AdditionalServicesVC: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var tblVwAdditionalServiceList: UITableView!
    
    //MARK:- Variable Declarations
    let objAdditionalServicesVM = AdditionalServicesVM()
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVwAdditionalServiceList.reloadData()
        tblVwAdditionalServiceList.emptyState.delegate = self
    }
    
    //MARK:- Button Actions
    @IBAction func actionCross(_ sender: UIButton) {
        self.dismissController()
    }
    
    @IBAction func actionSave(_ sender: UIButton) {
        objAdditionalServicesDelegate?.setData(arrList: objAdditionalServicesVM.arrAdditionalServicesModel)
        self.dismissController()
    }
}

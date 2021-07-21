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

class BookTypeVC: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var collVwTypleList: UICollectionView!
    
    //MARK:- Variable
    var objBookTypeVM = BookTypeVM()
    
    //MARK:- ViewLifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
         self.setTitles()
        objBookTypeVM.arrVehilcleListModel = []
        objBookTypeVM.hitVehicleTypeListApi {
            self.collVwTypleList.reloadData()
        }
    }
    //MARK:- IBACTIONS
    @IBAction func actionDismiss(_ sender: UIButton) {
        dismissController()
    }
}

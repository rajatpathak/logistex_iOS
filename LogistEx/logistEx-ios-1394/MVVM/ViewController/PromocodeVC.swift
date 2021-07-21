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

class PromocodeVC: UIViewController {
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var tblVwPromoCodeList: UITableView!
    
    //MARK:- Variable declarations
    let objPromocodeVM = PromocodeVM()
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        promoCode()
        tblVwPromoCodeList.emptyState.delegate = self
    }
    
     
    //MARK:- IBACTIONS
    @IBAction func actionBack(_ sender: UIButton) {
         popToBack()
    }
    
    func promoCode() {
        objPromocodeVM.arrPromocodeModel = []
        objPromocodeVM.getPromoCodeList {
            self.tblVwPromoCodeList.reloadData()
        }
    }
}

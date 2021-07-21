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
typealias CountryData = (String,String,String) -> ()

class SelectCountryPopUpVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var txtFldSearch: UITextField!
    @IBOutlet weak var tblVwCountry: UITableView!
    
    //MARK:- Object
    var objSelectCountryPopUpVM = SelectCountryPopUpVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        objSelectCountryPopUpVM.hitCountryListApi(objSelectCountryPopUpVM.title) {
            self.tblVwCountry.reloadData()
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionCross(_ sender: Any) {
        dismissController()
    }
}

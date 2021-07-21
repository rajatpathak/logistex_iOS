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

class FaqVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tblVwFaq: UITableView!
    
    //MARK:- Variables
    var selectedSection = -1
    var objFaqVM = FaqVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        objFaqVM.getFaqsList {
            self.tblVwFaq.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
           Proxy.shared.statusBarColor(scrrenColor: AlertMessages.white)
       }
    //MARK:- IBActions
    @IBAction func actionBack(_ sender: Any) {
        KAppDelegate.sideMenuVC.openLeft()
    }
    @IBAction func actionHeader(_ sender: UIButton) {
        if selectedSection == sender.tag {
            selectedSection = -1
        } else {
            selectedSection = sender.tag
        }
        tblVwFaq.reloadData()
    }
}



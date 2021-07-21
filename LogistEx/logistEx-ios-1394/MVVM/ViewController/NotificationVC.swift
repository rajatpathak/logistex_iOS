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
class NotificationVC: UIViewController {
    
    //MARK:- VARIABLE
    var objNotificationVM = NotificationVM()
    @IBOutlet weak var tblVwNotificationList: UITableView!
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVwNotificationList.emptyState.delegate = self
        objNotificationVM.arrNotificationModel = []
        objNotificationVM.getNotificationList {
            self.tblVwNotificationList.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
           Proxy.shared.statusBarColor(scrrenColor: AlertMessages.white)
       }
    
    //MARK:- IBACTIONS
    @IBAction func actionDrawer(_ sender: UIButton) {
        KAppDelegate.sideMenuVC.openLeft()
    }
}

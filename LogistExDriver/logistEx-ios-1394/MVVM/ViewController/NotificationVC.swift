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
    
    //MARK:- IBOutlets
    @IBOutlet weak var tblVwNotification: UITableView!
    
    //MARK:- Object
    var objNotificationVM = NotificationVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationList()
        tblVwNotification.emptyState.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.black)
    }
    //MARK:- IBActions
    @IBAction func actionMenu(_ sender: Any) {
        KAppDelegate.sideMenuVC.openLeft()
    }
    func notificationList() {
        objNotificationVM.currentPage = 0
        objNotificationVM.hitNotificationListApi {
            self.tblVwNotification.reloadData()
        }
    }
}

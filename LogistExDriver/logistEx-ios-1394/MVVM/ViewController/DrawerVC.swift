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
import SDWebImage

class DrawerVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tblVwDrawer: UITableView!
    @IBOutlet weak var imgVwUser: RoundedImage!
    @IBOutlet weak var lblName: UILabel!
    
    //MARK:- Object
    var objDrawerVM = DrawerVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.black)
        lblName.text = objUserModel.fullName
        imgVwUser.sd_setImage(with: URL(string: objUserModel.profile), placeholderImage: #imageLiteral(resourceName: "ic_default_user"))
        tblVwDrawer.reloadData()
    }
    @IBAction func actionOpenProfile(_ sender: Any) {
        if let visibleNavC = KAppDelegate.sideMenuVC.mainViewController as? UINavigationController {
            objDrawerVM.myCurrentVC = visibleNavC.visibleViewController!
        } else if let viewC = KAppDelegate.sideMenuVC.mainViewController {
            objDrawerVM.myCurrentVC = viewC
        }
        KAppDelegate.sideMenuVC.closeLeft()
        objDrawerVM.myCurrentVC.push(identifier: "ProfileVC")
    }
}

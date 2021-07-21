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
class DrawerVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tblVwDrawer: UITableView!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    //MARK:- Variables
    var objDrawerVM = DrawerVM()
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.black)
        lblName.text = (Proxy.shared.accessTokenNil() != "" ? objUserModel.fullname : "Guest User")
        imgVwUser.sd_setImage(with: URL(string: objUserModel.profileImage), placeholderImage: #imageLiteral(resourceName: "ic_drawer_pic"))
        tblVwDrawer.reloadData()
    }
    //MARK:- IBACTIONS
    @IBAction func actionTitleName(_ sender: UIButton) {
        
        var myCurrentVC = UIViewController()
        if let visibleNavC = KAppDelegate.sideMenuVC.mainViewController as? UINavigationController {
            myCurrentVC = visibleNavC.visibleViewController!
        } else if let viewC = KAppDelegate.sideMenuVC.mainViewController {
            myCurrentVC = viewC
        }
        KAppDelegate.sideMenuVC.closeLeft()
        if Proxy.shared.accessTokenNil() == "" {
            rootWithoutDrawer(selectedStoryboard: .main, identifier: .loginVC)
        } else {
            myCurrentVC.pushVC(selectedStoryboard: .main, identifier: .myProfileVC)
        }
    }
}

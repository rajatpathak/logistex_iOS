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
class ManageDriverVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var btnBanned: UIButton!
    @IBOutlet weak var tblVwDriver: UITableView!
    
    //MARK:- Object
    var objManageDriverVM = ManageDriverVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        actionStatus(btnFavorite)
    }
    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.white)
    }
    
    //MARK:- IBActions
    @IBAction func actionStatus(_ sender: UIButton) {
        animateSegments(segment: 0, sender: sender)
        sender.setTitleColor(.white, for: .normal)
        switch sender {
        case btnFavorite:
            btnBanned.setTitleColor(.lightGray, for: .normal)
            objManageDriverVM.type = ManageDriver.fav.rawValue
        case btnBanned:
            btnFavorite.setTitleColor(.lightGray, for: .normal)
            objManageDriverVM.type = ManageDriver.banned.rawValue
        default:
            break
        }
        objManageDriverVM.getDriverListApi("\(objManageDriverVM.type)") {
            self.tblVwDriver.reloadData()
        }
    }
    func animateSegments(segment: Int, sender: UIButton) {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        let originX = sender.frame.origin.x
                        self.vwBackground.frame.origin = CGPoint(x: originX, y: self.vwBackground.frame.origin.y)
                        self.view.layoutIfNeeded()
                        
        }, completion: nil)
    }
    @IBAction func actionDrawer(_ sender: UIButton) {
        KAppDelegate.sideMenuVC.openLeft()
    }
}

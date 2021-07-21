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
class BookNowVC: UIViewController {
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var imgVwProfile: UIImageView!
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgVwProfile.sd_setImage(with: URL(string: objUserModel.profileImage), placeholderImage: #imageLiteral(resourceName: "ic_drawer_pic"))
    }
    //MARK:- IBACTIONS
    @IBAction func actionBookNow(_ sender: UIButton) {
        pushVC(selectedStoryboard: .main, identifier: .confirmBookingVC)
    }
    @IBAction func actionDrawer(_ sender: UIButton) {
        KAppDelegate.sideMenuVC.openLeft()
    }
}

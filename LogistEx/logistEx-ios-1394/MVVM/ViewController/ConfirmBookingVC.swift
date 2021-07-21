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
class ConfirmBookingVC: UIViewController {
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var imgVwProfile: UIImageView!
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK:- IBACTIONS
    @IBAction func actionConfirmBooking(_ sender: UIButton) {
        pushVC(selectedStoryboard: .main, identifier: .paymentVC)
    }
    @IBAction func actionBack(_ sender: UIButton) {
        KAppDelegate.sideMenuVC.openLeft()
    }
}

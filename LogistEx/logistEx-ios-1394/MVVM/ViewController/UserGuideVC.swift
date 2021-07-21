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
class UserGuideVC: UIViewController {
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var txtVwUserGuide: UITextView!
    //MARK:- VARIABLES
    var objPageTypeVM = PageTypeVM()
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objPageTypeVM.getPagesApi(PageType.userGuide.rawValue) {
            self.txtVwUserGuide.attributedText = self.objPageTypeVM.desc.htmlToAttributedString
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

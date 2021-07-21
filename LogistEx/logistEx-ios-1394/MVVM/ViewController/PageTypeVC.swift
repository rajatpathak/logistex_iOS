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
class PageTypeVC: UIViewController {
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtVwDesc: UITextView!
    
    //MARK:- Variable Declaration
    let objPageTypeVM = PageTypeVM()
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:- Back button image added
        if objPageTypeVM.cameFrom == PassTitles.termsAndCondition {
            btnBack.setImage(UIImage(named: "ic_arw_blk"), for: .normal)
        } else {
            btnBack.setImage(UIImage(named: "ic_drawer"), for: .normal)
        }
        txtVwDesc.text = self.title
        switch self.title {
        case PassTitles.aboutUs.localized :
            lblTitle.text = PassTitles.about.localized
            objPageTypeVM.type = PageType.aboutUs.rawValue
        case PassTitles.termsAndCondition.localized :
            lblTitle.text = PassTitles.term.localized
            objPageTypeVM.type = PageType.termsAndCondition.rawValue
        case PassTitles.privacyPolicy.localized :
            lblTitle.text = PassTitles.privacy.localized
            objPageTypeVM.type = PageType.privacyPolicy.rawValue
        default:
            break
        }
        
        objPageTypeVM.getPagesApi(objPageTypeVM.type) {
            self.txtVwDesc.attributedText = self.objPageTypeVM.desc.htmlToAttributedString
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.white)
    }
    
    //MARK:- IBACTIONS
    @IBAction func actionDrawer(_ sender: UIButton) {
        if objPageTypeVM.cameFrom == PassTitles.termsAndCondition {
            self.popToBack()
        } else {
            KAppDelegate.sideMenuVC.openLeft()
        }
    }
}

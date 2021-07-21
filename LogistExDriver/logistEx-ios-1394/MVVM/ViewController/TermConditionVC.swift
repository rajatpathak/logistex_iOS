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

class TermConditionVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var txtVwTerms: UITextView!
    @IBOutlet weak var btnMenu: UIButton!
    
    //MARK: Object
    var objAboutUsVM = AboutUsVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        btnMenu.setImage(self.title == TitleValue.termsCondition ? UIImage(named: "ic_arw_blk") : UIImage(named: "ic_drawer"), for: .normal)
        objAboutUsVM.hitGetPagesApi("\(TypePage.termDriver.rawValue)") { 
            self.txtVwTerms.attributedText = self.objAboutUsVM.desc.htmlToAttributedString
            self.txtVwTerms.font = UIFont(name: Font.avenirMedium, size: 17)
            self.txtVwTerms.textColor = .lightGray
            self.txtVwTerms.textAlignment = .justified
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.white)
    }
    //MARK:- IBActions
    @IBAction func actionMenu(_ sender: Any) {
        self.title == TitleValue.termsCondition ? pop() : KAppDelegate.sideMenuVC.openLeft()
    }
}

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

class AboutUsVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var txtVwAboutUs: UITextView!
    
    //MARK:- Object
    var objAboutUsVM = AboutUsVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        objAboutUsVM.hitGetPagesApi("\(TypePage.about.rawValue)") {
            self.txtVwAboutUs.attributedText = self.objAboutUsVM.desc.htmlToAttributedString
            self.txtVwAboutUs.font = UIFont(name: Font.avenirMedium, size: 17)
            self.txtVwAboutUs.textColor = .lightGray
            self.txtVwAboutUs.textAlignment = .justified
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.white)
    }
    
    //MARK:- IBActions
    @IBAction func actionBack(_ sender: Any) {
        KAppDelegate.sideMenuVC.openLeft()
    }
}

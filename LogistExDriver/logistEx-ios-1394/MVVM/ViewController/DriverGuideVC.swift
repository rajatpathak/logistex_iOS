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

class DriverGuideVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var txtVwDetail: UITextView!
    
    //MARK: Object
    var objAboutUsVM = AboutUsVM()
    
    //MARK:- Variables
    var type = String()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        
        switch self.title {
        case TitleValue.driverGuide:
            type = "\(TypePage.driverGuide.rawValue)"
            lblHeaderTitle.text = lang == ChooseLanguage.spanish.rawValue ? TitleValue.driverGuideSpa : TitleValue.driverGuide
        case TitleValue.privacy:
            type = "\(TypePage.privacy.rawValue)"
            lblHeaderTitle.text = lang == ChooseLanguage.spanish.rawValue ? TitleValue.privacySpa : TitleValue.privacy
        default:
            break
        }
        objAboutUsVM.hitGetPagesApi(type) {
            self.txtVwDetail.attributedText = self.objAboutUsVM.desc.htmlToAttributedString
            self.txtVwDetail.font = UIFont(name: Font.avenirMedium, size: 17)
            self.txtVwDetail.textColor = .lightGray
            self.txtVwDetail.textAlignment = .justified
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.black)
    }
    //MARK:- IBActions
    @IBAction func actionBack(_ sender: Any) {
        KAppDelegate.sideMenuVC.openLeft()
    }
}

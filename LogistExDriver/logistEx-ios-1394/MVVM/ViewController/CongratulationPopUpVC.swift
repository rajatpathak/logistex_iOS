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

class CongratulationPopUpVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        
          if lang == ChooseLanguage.spanish.rawValue{
            lblTitle.text = "\(TitleValue.orderCompletedSpa) \n \(TitleValue.cashCollectedSpa)\(objUserModel.objAccepRequestModel.currency) \(objUserModel.objAccepRequestModel.amount)"
          } else {
              lblTitle.text = "\(TitleValue.orderCompleted) \n \(TitleValue.cashCollected) \(objUserModel.objAccepRequestModel.currency) \(objUserModel.objAccepRequestModel.amount)"
          }
    }
    
    //MARK:- IBActions
    @IBAction func actionGotIt(_ sender: Any) {
        rootWithDrawer(identifier: "HomeVC")
    }
}

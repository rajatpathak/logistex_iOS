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
import IQKeyboardManagerSwift

class OrderDetailView: UIView {
    
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var btnAllRequest: UIButton!
    @IBOutlet weak var lblPickUpLocation: UILabel!
    @IBOutlet weak var lblDropUpLocation: UILabel!
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var btnInstructions: UIButton!
    @IBOutlet weak var lblStaticOfferedPrice: UILabel!
    @IBOutlet weak var lblOfferAmount: UILabel!
    
    //MARK:- Object
    var objParent = HomeVC()
    var objOrderDetailVM = OrderDetailVM()
    
    class func loadNib() -> OrderDetailView? {
        if let customView = Bundle.main.loadNibNamed("OrderDetailView", owner: self, options: nil)?.first as? OrderDetailView {
            return customView
        }
        return nil
    }
    
    func setUp(parentView: UIView, completion:@escaping()->Void) {
        guard let objParentController = parentView.viewContainingController() as? HomeVC else {
            return
        }
        objParent = objParentController
        completion()
    }
    @IBAction func actionAllRequest(_ sender: Any) {
        objParent.push(identifier: "AllRequestVC")
    }
    @IBAction func actionAccept(_ sender: Any) {
        acceptAlert()
    }
    @IBAction func actionPass(_ sender: Any) {
    objOrderDetailVM.hitRejectRequestApi("\(self.objParent.objHomeVM.objCurrentRequestModel.orderId)") {
            self.objParent.rootWithDrawer(identifier: "HomeVC")
        }
    }
    @IBAction func actionInstructions(_ sender: Any) {
        objParent.setupInstructionsView {
            self.objParent.objHomeVM.instructionsVw.setUp(parentView: self.objParent.vwMain) {
                self.objParent.showInstructionsView()
            }
        }
    }
    func acceptAlert() {
        DispatchQueue.main.async {
            let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
                 let controller = UIAlertController(title: AppInfo.appName, message: AlertMessages.accept.localized, preferredStyle: .alert)
                 
                 let valueBtnOk = "\(lang == ChooseLanguage.spanish.rawValue ? AlertMessages.okSpa : AlertMessages.ok)"

                 let okAction = UIAlertAction(title: valueBtnOk, style: .default) { (action) in
                     self.objOrderDetailVM.hitAcceptRequestApi("\(self.objParent.objHomeVM.objCurrentRequestModel.orderId)") {
                         self.objParent.setupJourneyDetailView {
                             self.objParent.objHomeVM.startJourneyVw.setUp(parentView: self.objParent.vwMain) {
                                 self.objParent.showStartJourneyView()
                             }
                         }
                     }
                 }
                 let cancelAction = UIAlertAction(title: AlertMessages.cancel.localized, style: .default, handler: nil)
                 controller.addAction(okAction)
                 controller.addAction(cancelAction)
                 controller.view.tintColor = Color.app
                 self.objParent.present(controller, animated: true, completion: nil)
        }
    }
}

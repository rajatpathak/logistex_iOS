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

class ShowOnMapView: UIView {
    
    //MARK:- IBOutlets
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDropLocation: UILabel!
    @IBOutlet weak var btnMarkComplete: RoundedButton!
    @IBOutlet weak var vwMarkComplete: UIView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var vwCompleteHeightCnst: NSLayoutConstraint!
    @IBOutlet weak var btnCancelRide: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    //MARK:- Object
    var objParent = HomeVC()
    
    class func loadNib() -> ShowOnMapView? {
        if let customView = Bundle.main.loadNibNamed("ShowOnMapView", owner: self, options: nil)?.first as? ShowOnMapView {
            return customView
        }
        return nil
    }
    
    func setUp(parentView: UIView, completion:@escaping()->Void) {
        guard let objParentController = parentView.viewContainingController() as? HomeVC else {
            return
        }
        switch objUserModel.objAccepRequestModel.bookingState {
        case StateRequest.pickup.rawValue:
            btnCancelRide.isHidden = true
        default:
             btnCancelRide.isHidden = false
        }
        objParent = objParentController
        completion()
    }
    
    //MARK:- IBActions
    @IBAction func actionGoBack(_ sender: Any) {
        
        objParent.showStartJourneyView()
    }
    
    
    @IBAction func actionChat(_ sender: UIButton) {
        let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        controller.title = TitleValue.chatUser
        controller.objChatVM.toUserId = "\(objUserModel.objAccepRequestModel.custId)"
        controller.objChatVM.toUserName = "\(objUserModel.objAccepRequestModel.custName)"
        controller.objChatVM.bookingId = "\(objUserModel.objAccepRequestModel.bookingId)"
        self.objParent.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func actionCancelRide(_ sender: UIButton) {
        declinedAlert()
        
    }
    @IBAction func actionMarkComplete(_ sender: Any) {
        objParent.present(identifier: "CustomerSignatureVC")
    }
    //MARK:- Hit Reject Request Alert

    func declinedAlert() {
           DispatchQueue.main.async {
               let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
               let controller = UIAlertController(title: AppInfo.appName, message: AlertMessages.declinedRequestConfirmation.localized, preferredStyle: .alert)
               
               let valueBtnYes = "\(lang == ChooseLanguage.spanish.rawValue ? AlertMessages.yesSpa : AlertMessages.yes)"
               
               let okAction = UIAlertAction(title: valueBtnYes, style: .default) { (action) in
                self.hitRejectRequestApi(objUserModel.objAccepRequestModel.bookingId) {
                    self.objParent.rootWithDrawer(identifier: "HomeVC")
                    objUserModel.objAccepRequestModel = AccepRequestModel()
                   }
               }
               let cancelAction = UIAlertAction(title: AlertMessages.no.localized, style: .default, handler: nil)
               controller.addAction(okAction)
               controller.addAction(cancelAction)
               controller.view.tintColor = Color.app
               self.objParent.present(controller, animated: true, completion: nil)
           }
       }
    //MARK:- Hit Reject Request Api
    func hitRejectRequestApi(_ id: String, completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.declinedRequest)?id=\(id)", showIndicator: true) { (response) in
            if response.success {
                completion()
            } else {
                Proxy.shared.displayStatusAlert(response.message ?? "")
            }
        }
    }
    
}

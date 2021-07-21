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
class CancelbookingVC: UIViewController{
    
    //MARK:- IBOutlets
    @IBOutlet weak var animateView: UILabel!
    
    //MARK:- Object
    var objCancelbookingVM = CancelbookingVM()
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        animateView.setUpAnimation()
        objCancelbookingVM.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        NotificationCenter.default.addObserver(self, selector: #selector(getOrderDetailNotification), name: NSNotification.Name(rawValue: "DismissController"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        objCancelbookingVM.timer.invalidate()
    }
    @objc func getOrderDetailNotification(_ notification: NSNotification) {
        let dict = notification.object as? NSDictionary
        let orderId = dict?["orderId"] as? Int ?? 0
        let typeId = dict?["typeId"] as? Int ?? 0
        let actionType = dict?["actionType"] as? String ?? ""

         self.dismissController()
        if actionType != NotificationAction.acceptScheduledRequest{
              objTrackOrderDelegate?.push(orderId: orderId, type: typeId, title: PassTitles.accepted)
        }else{
            objTrackOrderDelegate?.push(orderId: orderId, type: typeId, title: PassTitles.schedule)

            
        }
     
    }
    @objc func timerAction() {
        if objCancelbookingVM.counter != 0 {
            objCancelbookingVM.counter -= 1
        } else {
            objCancelbookingVM.timer.invalidate()
            animateView.stopAnimation()
            self.dismissController()
            objPassDataDelegate?.push(moveTo: "notify")
        }
    }
    //MARK:- IBACTIONS
    @IBAction func actionCancelBooking(_ sender: UIButton) {
        cancelBookingAlert()
    }
    
    func cancelBookingAlert() {
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        let value = "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.cancelBookingSpa : PassTitles.cancelBooking)"
        let controller = UIAlertController(title: AppInfo.appName, message: value, preferredStyle: .alert)
        let valueBtnYes = "\(lang == ChooseLanguage.spanish.rawValue ? PassTitles.yesSpa : PassTitles.yes)"

        let okAction = UIAlertAction(title: valueBtnYes, style: .default) { (action) in
            self.objCancelbookingVM.getCancelBookingApi(self.title!) {
                self.dismissController()
                self.rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC)
            }
        }
        let cancelAction = UIAlertAction(title: AlertMessages.no.localized, style: .default, handler: nil)
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        controller.view.tintColor = Color.app
        self.present(controller, animated: true, completion: nil)
    }
}

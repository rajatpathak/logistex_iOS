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
import EmptyStateKit

class MyBookingVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tblVwBooking: UITableView!
    @IBOutlet weak var btnUpComingBooking: RoundedButton!
    @IBOutlet weak var btnPastBooking: RoundedButton!
    
    //MARK:- Object
    var objMyBookingVM = MyBookingVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getBookigNotification), name: NSNotification.Name(rawValue: "MyBooking"), object: nil)
        tblVwBooking.emptyState.delegate = self
        self.title == TitleValue.rate ? actionBookings(btnPastBooking) : actionBookings(btnUpComingBooking)
    }
    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.white)
    }
    
    @objc func getBookigNotification(_ notification: NSNotification) {
        let dict = notification.object as? NSDictionary
        let typeId = dict?["typeId"] as? String
        objMyBookingVM.notificationType = typeId ?? ""
        DispatchQueue.main.async {
            self.actionBookings(self.btnPastBooking)
        }
    }
    //MARK:- IBActions
    @IBAction func actionBookings(_ sender: UIButton) {
        btnPastBooking.backgroundColor = Color.fadeGray
        btnUpComingBooking.backgroundColor = Color.fadeGray
        btnPastBooking.setTitleColor(.black, for: .normal)
        btnUpComingBooking.setTitleColor(.black, for: .normal)
        sender.backgroundColor = Color.lightRed
        sender.setTitleColor(.white, for: .normal)
        objMyBookingVM.selectedVal = sender.tag
        switch sender {
        case btnUpComingBooking:
            objMyBookingVM.type = DeliveryState.accepted.rawValue
        default:
            objMyBookingVM.type = DeliveryState.completed.rawValue
        }
        myBookingData()
    }
    @IBAction func actionMenu(_ sender: Any) {
        KAppDelegate.sideMenuVC.openLeft()
    }
    func myBookingData() {
        objMyBookingVM.currentPage = 0
        objMyBookingVM.hitBookingHistoryApi("\(objMyBookingVM.type)") {
            if self.title == TitleValue.rate || self.objMyBookingVM.notificationType == "12" {
                objUserModel.objAccepRequestModel.bookingId = ""
            }
            self.tblVwBooking.reloadData()
        }
    }
}

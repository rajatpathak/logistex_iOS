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

class MyBookingsVC: UIViewController {
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var tblVwBookingList: UITableView!
    
    //MARK:- VARIABLES
    var objMyBookingsVM = MyBookingsVM()
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVwBookingList.emptyState.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.white)
        NotificationCenter.default.addObserver(self, selector: #selector(getBookigNotification), name: NSNotification.Name(rawValue: "MyBooking"), object: nil)
        myBookingData()
    }
    @objc func getBookigNotification(_ notification: NSNotification) {
        myBookingData()
    }
    //MARK:- IBACTIONS
    @IBAction func actionFilter(_ sender: UIButton) {
        objFilterDelegateProtocol = self
        presentVC(selectedStoryboard: .main, identifier: .filterVC)
    }
    @IBAction func actionDrawer(_ sender: UIButton) {
        KAppDelegate.sideMenuVC.openLeft()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Here write down you logic to dismiss controller
    }
    func myBookingData() {
        objMyBookingsVM.currentPage = 0
        objMyBookingsVM.getBookingListApi(objMyBookingsVM.filterId) {
            DispatchQueue.main.async {
                self.tblVwBookingList.reloadData()
            }
        }
    }
}

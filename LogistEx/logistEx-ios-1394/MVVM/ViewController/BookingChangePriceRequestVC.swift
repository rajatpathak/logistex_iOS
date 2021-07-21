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

class BookingChangePriceRequestVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblDrop: UILabel!
    @IBOutlet weak var lblPickUp: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblChangedAmount: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblStaticBookingAmount: UILabel!
    @IBOutlet weak var lblStaticRequestAmount: UILabel!

    //MARK:- VARIABLES
    var objBookingChangePriceRequestVM = BookingChangePriceRequestVM()
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        showDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.white)
    }
    //MARK:- IBACTIONS
    @IBAction func actionBack(_ sender: UIButton) {
        popToBack()
    }
    @IBAction func actionAcceptReject(_ sender: UIButton) {
        if sender.tag == 0 {
            acceptRequestAlert()
        } else {
            rejectRequestAlert()
        }
    }
}

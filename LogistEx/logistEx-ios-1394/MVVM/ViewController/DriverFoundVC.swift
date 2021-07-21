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

class DriverFoundVC: UIViewController {
    
    //MARK:- IBOUtlets
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblRegistrationNo: UILabel!
    
    //MARK:- Variables
    var objBookingDetailVM = BookingDetailVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        objBookingDetailVM.getBookingDetail(objBookingDetailVM.detailId) {
            let dict = self.objBookingDetailVM.objBookingDetailModel
            self.lblDriverName.text = dict.driverName
            self.lblRegistrationNo.text = dict.vehicleNo
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionGotIt(_ sender: Any) {
        dismissController()
    }
}

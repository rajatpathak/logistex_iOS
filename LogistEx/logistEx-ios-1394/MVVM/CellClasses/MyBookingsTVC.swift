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
class MyBookingsTVC: UITableViewCell {
    
   //MARK:- Outlets
    @IBOutlet weak var lblRm: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblStateAssigning: UILabel!
    @IBOutlet weak var btnVwDetail: UIButton!
    @IBOutlet weak var lblStateBooking: UILabel!
    @IBOutlet weak var lblDrop: UILabel!
    @IBOutlet weak var lblPickUp: UILabel!
    @IBOutlet weak var vwCancelBooking: UIView!
    @IBOutlet weak var btnCancelBooking: UIButton!
    @IBOutlet weak var btnGiveRating: UIButton!
    @IBOutlet weak var cnstHeightCancelVw: NSLayoutConstraint!
    @IBOutlet weak var lblPackagedeliveredDate: UILabel!
    @IBOutlet weak var btnChangeRequest: UIButton!
    @IBOutlet weak var vwStateAssigningHghtConst: NSLayoutConstraint!
    
}

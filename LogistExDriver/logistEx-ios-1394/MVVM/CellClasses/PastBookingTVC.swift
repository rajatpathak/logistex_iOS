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

class PastBookingTVC: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var lblPickupTime: UILabel!
    @IBOutlet weak var lblDeliveryStatus: UILabel!
    @IBOutlet weak var lblOrderPrice: UILabel!
    @IBOutlet weak var btnViewDetails: RoundedButton!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var btnRate: RoundedButton!
    @IBOutlet weak var vwCancel: RoundedView!
    @IBOutlet weak var btnCancel: UIButton!
}
class UpComingBookingTVC: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var btnViewDetails: RoundedButton!
    @IBOutlet weak var lblPickupTime: UILabel!
}

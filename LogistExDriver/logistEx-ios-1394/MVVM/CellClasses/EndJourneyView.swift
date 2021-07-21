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

class EndJourneyView: UIView {
    //MARK:- IBOutlets
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblRm: UILabel!
    @IBOutlet weak var vwBg: UIView!
    
    //MARK:- Object
    var objParent = HomeVC()
    var objStartJourneyVM = StartJourneyVM()
    
    class func loadNib() -> EndJourneyView? {
        if let customView = Bundle.main.loadNibNamed("EndJourneyView", owner: self, options: nil)?.first as? EndJourneyView {
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
    
    @IBAction func actionGotIt(_ sender: Any) {
        objParent.setupRatingView {
            self.objParent.showRatingView()
        }
    }
}

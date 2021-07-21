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

class RatingView: UIView {
    //MARK:- IBOutlets
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblDeliveryTime: UILabel!
    @IBOutlet weak var vwRating: FloatRatingView!
    @IBOutlet weak var txtVwComment: IQTextView!
    @IBOutlet weak var vwBg: UIView!
    
    //MARK:- Object
    var objParent = HomeVC()
    var objRatingVM = RatingVM()
    var orderId = String()

    
    class func loadNib() -> RatingView? {
        if let customView = Bundle.main.loadNibNamed("RatingView", owner: self, options: nil)?.first as? RatingView {
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
    
    @IBAction func actionSubmit(_ sender: Any) {
        let request = AddRating(comment: txtVwComment.text, rating: vwRating.rating, userId: "\(objUserModel.objAccepRequestModel.custId)", bookingId: "\(orderId)")
        objRatingVM.addRatingApi(request) {
            if #available(iOS 13.0, *) {
                let sceneDelegate = UIApplication.shared.connectedScenes
                    .first!.delegate as! SceneDelegate
                sceneDelegate.window!.rootViewController?.rootWithDrawer(identifier: "HomeVC")
            } else {
                KAppDelegate.window?.rootViewController?.rootWithDrawer(identifier: "HomeVC")
            }
        }
    }
}

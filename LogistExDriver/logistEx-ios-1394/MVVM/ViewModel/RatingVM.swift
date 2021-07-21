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

class RatingVM: NSObject {
    
    //MARK:- Message Send Api
    func addRatingApi(_ request: AddRating, completion:@escaping() -> Void) {
        if validData(request){
            let param = ["Rating[rating]": request.rating ?? 0,
                         "Rating[comment]": request.comment ?? "",
                         "Rating[to_user]": request.userId ?? "",
                         "Rating[booking_id]": request.bookingId ?? ""] as [String:AnyObject]
            
            WebServiceProxy.shared.postData(Apis.addRating, params: param , showIndicator: true, completion: { (response)  in
                if response.success {
                    completion()
                } else {
                    Proxy.shared.displayStatusAlert(response.data?["message"] as? String ?? "")
                }
            })
        }
    }
    //MARK:-  Check Data Validation
    func validData(_ request: AddRating) -> Bool {
        if request.rating == 0 || request.rating == 0.0 {
            Proxy.shared.displayStatusAlert(AlertMessages.addRating.localized)
        } else if (request.comment?.isBlank)!{
            Proxy.shared.displayStatusAlert(AlertMessages.addComment.localized)
        } else {
            return true
        }
        return false
    }
}

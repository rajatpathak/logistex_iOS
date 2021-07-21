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

class RatingVC: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblDeliveryTime: UILabel!
    @IBOutlet weak var vwRating: FloatRatingView!
    @IBOutlet weak var txtVwComment: IQTextView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    //MARK:- Variables
    var objDriverDetailModel = DriverDetailModel()
    
    //MARK:- Object
    var objRatingVM = RatingVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        lblOrderNo.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.orderNoSpa : TitleValue.orderNo) \(objDriverDetailModel.bookingId)"
        if lang == ChooseLanguage.spanish.rawValue {
            lblDeliveryTime.text = "\(TitleValue.deliveryTimeSpa) \(objDriverDetailModel.deliveryTime.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "dd-MM-yyyy HH:mm:ss"))"
        } else {
          lblDeliveryTime.text = "\(TitleValue.deliveryTime) \(objDriverDetailModel.deliveryTime.getStringFromDate(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "MM-dd-yyyy HH:mm:ss"))"
        }

        vwRating.rating = Float(objDriverDetailModel.userRating)
        txtVwComment.text = objDriverDetailModel.comment
        vwRating.isUserInteractionEnabled = objDriverDetailModel.userRating == 0.0
        txtVwComment.isUserInteractionEnabled = objDriverDetailModel.comment == ""
        btnSubmit.isUserInteractionEnabled = objDriverDetailModel.comment == ""
        txtVwComment.placeholder = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.typeHereSpa : TitleValue.typeHere)"
            

    }
    override func viewWillAppear(_ animated: Bool) {
           Proxy.shared.statusBarColor(scrrenColor: AlertMessages.black)
    }
    @IBAction func actionSubmit(_ sender: Any) {
        let request = AddRating(comment: txtVwComment.text, rating: vwRating?.rating, userId: "\(objDriverDetailModel.custId)", bookingId: objDriverDetailModel.bookingId)
        objRatingVM.addRatingApi(request) {
            self.rootWithDrawer(identifier: "HomeVC")
        }
    }
    @IBAction func actionBack(_ sender: Any) {
        pop()
    }
}

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

class MyEarningsVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var lblRm: UILabel!
    @IBOutlet weak var btnOpenCalendar: RoundedButton!
    @IBOutlet weak var tblVwEarning: UITableView!
    @IBOutlet weak var lblRideCount: UILabel!
    @IBOutlet weak var txtFldCurrency: UITextField!
    
    //MARK: Object
    var objEarningVM = MyEarningVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        btnOpenCalendar.setTitle(objEarningVM.date.getCurrentDate(), for: .normal)
        txtFldCurrency.text = "\(objUserModel.driverCountry) (\(objUserModel.currency))"
        objEarningVM.currencyId = objUserModel.currencyId
        objEarningVM.getEarningApi(objEarningVM.date.getCurrentDate(), id: objEarningVM.currencyId) {
            let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
            self.lblRm.text = "\(self.objEarningVM.totalAmount) \(objUserModel.currency)"
            self.lblRideCount.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.totalRidesSpa : TitleValue.totalRides) \(self.objEarningVM.arrEarning.count)"
            self.tblVwEarning.reloadData()
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionMenu(_ sender: Any) {
        KAppDelegate.sideMenuVC.openLeft()
    }
    @IBAction func actionFilter(_ sender: Any) {
    }
    @IBAction func actionCalendar(_ sender: UIButton) {
        let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
        controller.dateStr = objEarningVM.date
        controller.title = TitleValue.earning
        controller.objPassDate = { (date) in
            self.btnOpenCalendar.setTitle(date, for: .normal)
            self.objEarningVM.date = date
            self.objEarningVM.getEarningApi(self.objEarningVM.date, id: self.objEarningVM.currencyId) {
                let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
                self.lblRm.text = "\(self.objEarningVM.totalAmount) \(self.objEarningVM.currencyName)"
                self.lblRideCount.text = "\(lang == ChooseLanguage.spanish.rawValue ? TitleValue.totalRidesSpa : TitleValue.totalRides) \(self.objEarningVM.arrEarning.count)"
                self.tblVwEarning.reloadData()
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
}

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
typealias VehicleId = (Int,String) -> ()

class SelectVehiclePopupVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tblVwVehicle: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblVwHeightCnst: NSLayoutConstraint!
    
    //MARK:- Object
    var objSelectVehiclePopupVM = SelectVehiclePopupVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        switch self.title {
        case TitleValue.chooseReason:
            let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
            lblTitle.text = lang == ChooseLanguage.spanish.rawValue ? TitleValue.chooseReasonSpa : TitleValue.chooseReason
            
            objSelectVehiclePopupVM.hitReasonListApi(ContactType.driver.rawValue) {
                self.tblVwVehicle.reloadData()
                if self.objSelectVehiclePopupVM.arrReasonList.count > 8 {
                    self.tblVwHeightCnst.constant = 450
                } else {
                    self.tblVwHeightCnst.constant = CGFloat(self.objSelectVehiclePopupVM.arrReasonList.count*50+50)
                }
            }
        case "\(VehicleType.transport.rawValue)" :
            objSelectVehiclePopupVM.hitVehicleCateogryListApi(VehicleType.transport.rawValue){
                self.tblVwVehicle.reloadData()
            }
        case "\(VehicleType.taxi.rawValue)":
              objSelectVehiclePopupVM.hitVehicleCateogryListApi(VehicleType.taxi.rawValue) {
                self.tblVwVehicle.reloadData()
            }
        default:
            break
        }
    }
    
    
    //MARK:- IBActions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
    @IBAction func actionCross(_ sender: Any) {
        dismiss()
    }
}

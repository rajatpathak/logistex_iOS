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

class SelectVehicleTypePopupVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tblVwVehicle: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblVwHeightCnst: NSLayoutConstraint!
    
    // MARK:- Variables
    var objSelectVehicleTypePopupVM = SelectVehicleTypePopupVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = objSelectVehicleTypePopupVM.isApiHit
        switch objSelectVehicleTypePopupVM.isApiHit {
        case TitleValue.vehicleTypeList:
            objSelectVehicleTypePopupVM.arrVechicleTypeListModel = []
            objSelectVehicleTypePopupVM.hitVehicleTypeListApi(finalUrl: Apis.vehicleTypeList) {
                self.tblVwVehicle.reloadData()
            }
        case TitleValue.vehicleBrand:
            objSelectVehicleTypePopupVM.arrVechicleTypeListModel = []
            objSelectVehicleTypePopupVM.hitVehicleTypeListApi(finalUrl: Apis.vehicleBrandList) {
                self.tblVwVehicle.reloadData()
            }
        case TitleValue.vehicleColor:
            objSelectVehicleTypePopupVM.arrVechicleTypeListModel = []
            objSelectVehicleTypePopupVM.hitVehicleTypeListApi(finalUrl: Apis.vehicleColorList) {
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

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
typealias TypeId = (String,String) ->()

class FilterVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var btnLater: RoundedButton!
    @IBOutlet weak var btnToday: RoundedButton!
    @IBOutlet weak var btnNow: RoundedButton!
    @IBOutlet weak var btnAll: RoundedButton!
    @IBOutlet weak var btnDistance: RoundedButton!
    @IBOutlet weak var btnTime: RoundedButton!
    
    //MARK:- Variables
    var sortType = String()
    var filterType = String()
    var objTypeData: TypeId?
    var isFilter = false
   
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDetail()
    }
    
    //MARK:- IBActions
    @IBAction func actionSortBy(_ sender: UIButton) {
        btnTime.backgroundColor = .white
        btnDistance.backgroundColor = .white
        sender.backgroundColor = Color.fadeGray
        switch sender {
        case btnTime:
            sortType = "\(SortType.time.rawValue)"
        case btnDistance:
            sortType = "\(SortType.distance.rawValue)"
        default:
            break
        }
        guard let block = objTypeData else {return}
        UserDefaults.standard.setValue(sortType, forKey: "Sort")
        UserDefaults.standard.synchronize()
        dismiss()
        block(sortType, UserDefaults.standard.object(forKey: "Filter") as? String ?? "")
    }
    @IBAction func actionFilterBy(_ sender: UIButton) {
        btnNow.backgroundColor = .white
        btnAll.backgroundColor = .white
        btnLater.backgroundColor = .white
        btnToday.backgroundColor = .white
        sender.backgroundColor = Color.fadeGray
        switch sender {
        case btnNow:
            filterType = "\(FilterType.now.rawValue)"
        case btnToday:
            filterType = "\(FilterType.today.rawValue)"
        case btnLater:
            filterType = "\(FilterType.later.rawValue)"
        case btnAll:
            filterType = ""
        default:
            break
        }
        if !isFilter {
        guard let block = objTypeData else {return}
        UserDefaults.standard.setValue(filterType, forKey: "Filter")
        UserDefaults.standard.synchronize()
        dismiss()
        block(sortType, filterType)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
    func setDetail() {
        let sortVal = UserDefaults.standard.object(forKey: "Sort") as? String ?? ""
        let filterVal = UserDefaults.standard.object(forKey: "Filter") as? String ?? ""
        isFilter = true
        switch sortVal {
        case "1":
            actionSortBy(btnDistance)
        case "2":
            actionSortBy(btnTime)
        default:
            break
        }
        switch filterVal {
        case "1":
            actionFilterBy(btnNow)
        case "2":
            actionFilterBy(btnToday)
        case "3":
            actionFilterBy(btnLater)
        case "":
            actionFilterBy(btnAll)
        default:
            break
        }
        isFilter = false
    }
}

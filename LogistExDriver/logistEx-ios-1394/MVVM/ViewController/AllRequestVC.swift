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

class AllRequestVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tblVwAllRequest: UITableView!
    @IBOutlet weak var lblDriverID: UILabel!
    @IBOutlet weak var btnProfileImg: UIButton!
    
    //MARK:- Object
    var objAllRequestVM = AllRequestVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showUserDetail()
        filteringData()
        tblVwAllRequest.emptyState.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        Proxy.shared.statusBarColor(scrrenColor: AlertMessages.black)
    }
    //MARK:- IBActions
    @IBAction func actionMenu(_ sender: Any) {
        KAppDelegate.sideMenuVC.openLeft()
    }
    @IBAction func actionShowProfile(_ sender: Any) {
        push(identifier: "ProfileVC")
    }
    @IBAction func actionFilter(_ sender: Any) {
        let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        controller.objTypeData = { (sort,filter) in
            self.objAllRequestVM.sortingType = sort
            self.objAllRequestVM.filterType = filter
            self.filteringData()
        }
        self.present(controller, animated: true, completion: nil)
    }
    func showUserDetail() {
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        let text = lang == ChooseLanguage.spanish.rawValue ? "Conductor ID:" : "Driver ID:"
        lblDriverID.text = "\(text) \(objUserModel.userId)"
        btnProfileImg.sd_setImage(with: URL(string: objUserModel.profile), for: .normal, placeholderImage: #imageLiteral(resourceName: "ic_default_user"))
    }
    func filteringData() {
        self.objAllRequestVM.currentPage = 0
        self.objAllRequestVM.hitAllRequestListApi(filter: self.objAllRequestVM.filterType, sort: self.objAllRequestVM.sortingType) {
            self.tblVwAllRequest.reloadData()
        }
    }
}

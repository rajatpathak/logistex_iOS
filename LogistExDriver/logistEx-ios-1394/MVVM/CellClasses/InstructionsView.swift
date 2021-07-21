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
import Lightbox

class InstructionsView: UIView {
    //MARK:- IBOutlets
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblFloorNo: UILabel!
    @IBOutlet weak var lblBuildingBlock: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var lblRoomNo: UILabel!
    @IBOutlet weak var lblDropupLocation: UILabel!
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var colVwInstructions: UICollectionView!
    @IBOutlet weak var vwOrderId: UIView!
    @IBOutlet weak var vwOrderDetail: UIView!
    @IBOutlet weak var vwInstruction: UIView!
    @IBOutlet weak var lblInstructions: UILabel!
    @IBOutlet weak var btnGoBack: UIButton!
    @IBOutlet weak var colVwHeightCnst: NSLayoutConstraint!
    
    //MARK:- Object
    var objParent = HomeVC()
    
    class func loadNib() -> InstructionsView? {
        if let customView = Bundle.main.loadNibNamed("InstructionsView", owner: self, options: nil)?.first as? InstructionsView {
            return customView
        }
        return nil
    }
    
    func setUp(parentView: UIView, completion:@escaping()->Void) {
        guard let objParentController = parentView.viewContainingController() as? HomeVC else {
            return
        }
        objParent = objParentController
        Proxy.shared.registerCollViewNib(colVwInstructions, identifierCell: "StartJourneyCVC")
        completion()
    }
    @IBAction func actionGoBack(_ sender: Any) {
        objParent.showOrderDetailView()
    }
}

extension InstructionsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objParent.objHomeVM.objCurrentRequestModel.arrFiles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dict = objParent.objHomeVM.objCurrentRequestModel.arrFiles[indexPath.row] as? [String : Any]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StartJourneyCVC", for: indexPath) as! StartJourneyCVC
        cell.imgVwInstructions.sd_setImage(with: URL(string: dict?["file"] as! String) , placeholderImage: #imageLiteral(resourceName: "ic_default_user"))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = objParent.objHomeVM.objCurrentRequestModel.arrFiles[indexPath.row] as? [String : Any]
        let file = dict?["file"] as? String ?? ""
        if file != "" {
            let images = [LightboxImage(imageURL: URL.init(string: file)!)]
            let controller = LightboxController(images: images)
            controller.pageDelegate = self
            controller.dismissalDelegate = self
            controller.dynamicBackground = true
            controller.modalPresentationStyle = .fullScreen
            objParent.navigationController?.present(controller, animated: true, completion: nil)
        }
    }
}
extension InstructionsView: LightboxControllerPageDelegate, LightboxControllerDismissalDelegate  {
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        print(page)
    }
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
    }
}

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
import SDWebImage
import Lightbox

class StartJourneyView: UIView,UITextFieldDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblFloorNo: UILabel!
    @IBOutlet weak var lblBuildingBlock: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var lblRoomNo: UILabel!
    @IBOutlet weak var lblDropupLocation: UILabel!
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var colVwJourney: UICollectionView!
    @IBOutlet weak var vwOrderId: UIView!
    @IBOutlet weak var vwOrderDetail: UIView!
    @IBOutlet weak var vwInstruction: UIView!
    @IBOutlet weak var btnJourney: UIButton!
    @IBOutlet weak var lblPickUpOrderDetail: UILabel!
    @IBOutlet weak var vwTimings: UIView!
    @IBOutlet weak var lblPickUpDate: UILabel!
    @IBOutlet weak var lblPickUpTime: UILabel!
    @IBOutlet weak var vwTimingHeightCnst: NSLayoutConstraint!
    @IBOutlet weak var colVwHeightCnst: NSLayoutConstraint!
    @IBOutlet weak var lblStaticAmountOffered: UILabel!
    @IBOutlet weak var lblStaticChangeAmount: UILabel!
    @IBOutlet weak var btnDeclined: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var lblAmountOffered: UILabel!
    @IBOutlet weak var txtFldCurrency: UITextField!
    @IBOutlet weak var txtFldChangeAmount: UITextField!
    @IBOutlet weak var vwForNagotiableAmount: UIView!
    @IBOutlet weak var vwNagotiableAmountHghtCnst: NSLayoutConstraint!
    @IBOutlet weak var vwAmountOfferDetailsHghtCnst: NSLayoutConstraint!
    @IBOutlet weak var btnReschudleTrip: UIButton!
    //MARK:- Object
    var objParent = HomeVC()
    var objStartJourneyVM = StartJourneyVM()
    var objSplashVM = SplashVM()
    
    class func loadNib() -> StartJourneyView? {
        if let customView = Bundle.main.loadNibNamed("StartJourneyView", owner: self, options: nil)?.first as? StartJourneyView {
            return customView
        }
        return nil
    }
    
    func setUp(parentView: UIView, completion:@escaping()->Void) {
        guard let objParentController = parentView.viewContainingController() as? HomeVC else {
            return
        }
        objParent = objParentController
        txtFldChangeAmount.delegate = self
        switch objUserModel.objAccepRequestModel.bookingState {
        case StateRequest.inProgress.rawValue,StateRequest.pickup.rawValue :
            if objUserModel.objAccepRequestModel.isReschudled == 1 {
                btnReschudleTrip.isHidden = true
            } else {
                btnReschudleTrip.isHidden = false
            }
            
        default:
            btnReschudleTrip.isHidden = true
        }
        Proxy.shared.registerCollViewNib(colVwJourney, identifierCell: "StartJourneyCVC")
        completion()
    }
    
    //MARK:- IBActions
    @IBAction func actionDetails(_ sender: Any) {
        let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "DriverDetailsVC") as! DriverDetailsVC
        controller.objDriverDetailsVM.bookingId = objUserModel.objAccepRequestModel.bookingId
        self.objParent.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func actionViewOnMap(_ sender: Any) {
        objParent.setupShowOnMapView {
            self.objParent.objHomeVM.showOnMapVw.setUp(parentView: self.objParent.vwMain) {
                self.objParent.showOnMapView()
            }
        }
    }
    @IBAction func actionReschduledTrip(_ sender: Any) {
        reschudledAlert()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFldChangeAmount  {
            if range.location >= 9  {
                return false
            }
        }
        return true
    }
    
    @IBAction func actionApplyChanges(_ sender: UIButton) {
        if txtFldChangeAmount.text!.isBlank{
            Proxy.shared.displayStatusAlert(AlertMessages.enterAmount.localized)
        } else {
            alertApplyAmountChange()
        }
    }
    @IBAction func actionDeclined(_ sender: UIButton) {
        declinedAlert()
    }
    
    @IBAction func actionChat(_ sender: UIButton) {
        let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        controller.title = TitleValue.chatUser
        controller.objChatVM.toUserId = "\(objUserModel.objAccepRequestModel.custId)"
        controller.objChatVM.toUserName = "\(objUserModel.objAccepRequestModel.custName)"
        controller.objChatVM.bookingId = "\(objUserModel.objAccepRequestModel.bookingId)"
        self.objParent.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func actionStartJourney(_ sender: Any) {
        
        switch objUserModel.objAccepRequestModel.bookingState {
        
        case StateRequest.active.rawValue:
            if objUserModel.objAccepRequestModel.isNagotiableAmount == 1 && objUserModel.objAccepRequestModel.paymentStatus == 0 &&  objUserModel.objAccepRequestModel.paymentMethod == PaymentMethod.bankTransfer.rawValue || objUserModel.objAccepRequestModel.paymentMethod == PaymentMethod.paypal.rawValue {
                
                if objUserModel.objAccepRequestModel.amountChangeRequestStatus == ChangeAmountRequstState.send.rawValue {
                    Proxy.shared.displayStatusAlert(AlertMessages.canNotStartJourney.localized)
                } else if objUserModel.objAccepRequestModel.paymentStatus == 0  {
                    alertAmountNotificationSendToUser()
                } else {
                    objStartJourneyVM.hitUpdateBookingApi(objUserModel.objAccepRequestModel.bookingId, state: "\(StateRequest.inProgress.rawValue)") {
                        if objUserModel.objAccepRequestModel.isReschudled == 1 {
                            self.btnReschudleTrip.isHidden = true
                        } else {
                            self.btnReschudleTrip.isHidden = false
                        }
                        self.btnJourney.setTitle(TitleValue.makeOrderPickup.localized, for: .normal)
                        self.vwForNagotiableAmount.isHidden = true
                        self.vwNagotiableAmountHghtCnst.constant = 0
                        self.vwAmountOfferDetailsHghtCnst.constant = 75
                    }
                }
            } else {
                objStartJourneyVM.hitUpdateBookingApi(objUserModel.objAccepRequestModel.bookingId, state: "\(StateRequest.inProgress.rawValue)") {
                    if objUserModel.objAccepRequestModel.isReschudled == 1 {
                        self.btnReschudleTrip.isHidden = true
                    } else {
                        self.btnReschudleTrip.isHidden = false
                    }
                    self.btnJourney.setTitle(TitleValue.makeOrderPickup.localized, for: .normal)
                    self.vwForNagotiableAmount.isHidden = true
                    self.vwNagotiableAmountHghtCnst.constant = 0
                    self.vwAmountOfferDetailsHghtCnst.constant = 75
                }
            }
            
        case StateRequest.inProgress.rawValue:
            objStartJourneyVM.hitUpdateBookingApi(objUserModel.objAccepRequestModel.bookingId, state: "\(StateRequest.pickup.rawValue)") {
                self.objParent.showDropDetails()
                self.btnJourney.setTitle(TitleValue.makeOrderComplete.localized , for:.normal)
                self.vwForNagotiableAmount.isHidden = true
                self.vwNagotiableAmountHghtCnst.constant = 0
                self.vwAmountOfferDetailsHghtCnst.constant = 75
            }
        case StateRequest.pickup.rawValue:
            if objUserModel.objAccepRequestModel.isReschudled == 1 {
                btnReschudleTrip.isHidden = true
            } else {
                btnReschudleTrip.isHidden = false
            }
            self.vwForNagotiableAmount.isHidden = true
            self.vwNagotiableAmountHghtCnst.constant = 0
            self.vwAmountOfferDetailsHghtCnst.constant = 75
            objParent.present(identifier: "CustomerSignatureVC")
        default:
            break
        }
    }
}


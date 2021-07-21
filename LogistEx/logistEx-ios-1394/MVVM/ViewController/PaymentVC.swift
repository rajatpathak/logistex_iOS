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

class PaymentVC: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var lblPickUpLoc: UILabel!
    @IBOutlet weak var lblDropOffLoc: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblValueAmount: UILabel!
    @IBOutlet weak var lblFinalAmount: UILabel!
    @IBOutlet weak var btnRemovePromoCode: UIButton!
    @IBOutlet weak var btnPromoCode: UIButton!
    
    //MARK:-  Variable declarations
    let objPaymentVM = PaymentVM()
    var distance = String()
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPickUpLoc.text = KAppDelegate.bookPostDict.dictValue["Booking[pickup_location]"]!
        lblDropOffLoc.text = KAppDelegate.bookPostDict.dictValue["Booking[destination_location]"]!
        lblDistance.text = distance
        let currencyTitle = "\(KAppDelegate.bookPostDict.dictValue["Booking[currency_title]"] ?? "")"
        let currencySymbol = "\(KAppDelegate.bookPostDict.dictValue["Booking[currency_symbol]"] ?? "")"
        lblValueAmount.text =
            "\(currencySymbol) \(KAppDelegate.bookPostDict.dictValue["Booking[amount]"]!) \(currencyTitle)"
        lblFinalAmount.text = "\(currencySymbol) \(KAppDelegate.bookPostDict.dictValue["Booking[amount]"]!) \(currencyTitle)"
        btnRemovePromoCode.isHidden = true
    }
    
    //MARK:- IBACTIONS
    @IBAction func actionPromoCode(_ sender: UIButton) {
        objPromoModelDelegate = self
        pushVC(selectedStoryboard: .main, identifier: .promocodeVC)
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        popToBack()
    }
    
    
    @IBAction func actionCash(_ sender: UIButton) {
        objPaymentVM.paymentMode = PaymentMethod.cash.rawValue
        KAppDelegate.bookPostDict.dictValue.updateValue("\(objPaymentVM.paymentMode)", forKey: "Booking[payment_method]")
        objPaymentVM.hitBookingApi { (orderId) in
            KAppDelegate.bookPostDict = BookNowDict()
            objSearchDriverDelegate?.setData(orderId: "\(orderId)")
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: HomeVC.self) {
                    _ =  self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }        
    }
    @IBAction func actionPappal(_ sender: UIButton) {
        objPaymentVM.paymentMode = PaymentMethod.paypal.rawValue
        KAppDelegate.bookPostDict.dictValue.updateValue("\(objPaymentVM.paymentMode)", forKey: "Booking[payment_method]")
        let isNagotialbeCase  = KAppDelegate.bookPostDict.dictValue["Booking[nagotiable]"]
        if isNagotialbeCase == "\(AmountNagotiable.no.rawValue)" {
            objPaymentVM.hitBookingApi { (orderId) in
                if self.objPaymentVM.paypalUrl != ""{
                    let url = URL(string: self.objPaymentVM.paypalUrl)
                    let lastPath = url?.lastPathComponent as? String ?? "0"
                    let controller  = StoryBoardType.main.storyBoard.instantiateViewController(withIdentifier: "PaymentWebViewVC") as! PaymentWebViewVC
                    controller.objPaymentWebViewVM.complition = {
                        title in
                        if title != "" {
                            KAppDelegate.bookPostDict = BookNowDict()
                            objSearchDriverDelegate?.setData(orderId: "\(orderId)")
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: HomeVC.self) {
                                    _ =  self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        }
                       
                    }
                    controller.objPaymentWebViewVM.bookingId = Int(lastPath)!
                    controller.objPaymentWebViewVM.paypalWebUrl = self.objPaymentVM.paypalUrl
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        } else {
            objPaymentVM.hitBookingApi { (orderId) in
                KAppDelegate.bookPostDict = BookNowDict()
                objSearchDriverDelegate?.setData(orderId: "\(orderId)")
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: HomeVC.self) {
                        _ =  self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        }
    }
    @IBAction func actionBankTransfer(_ sender: UIButton) {
        objPaymentVM.paymentMode = PaymentMethod.bankTransfer.rawValue
        KAppDelegate.bookPostDict.dictValue.updateValue("\(objPaymentVM.paymentMode)", forKey: "Booking[payment_method]")
        
        let isNagotialbeCase  = KAppDelegate.bookPostDict.dictValue["Booking[nagotiable]"]
        if isNagotialbeCase == "\(AmountNagotiable.no.rawValue)" {
            KAppDelegate.objVariableSaveModel.requestId = 0
            self.pushVC(selectedStoryboard: .main, identifier: .bankList)
        } else {
            objPaymentVM.hitBookingApi { (orderId) in
                KAppDelegate.bookPostDict = BookNowDict()
                objSearchDriverDelegate?.setData(orderId: "\(orderId)")
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: HomeVC.self) {
                        _ =  self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        }
    }
    @IBAction func actionOnline(_ sender: UIButton) {
        objPaymentVM.paymentMode = PaymentMethod.stripe.rawValue
        KAppDelegate.bookPostDict.dictValue.updateValue("\(objPaymentVM.paymentMode)", forKey: "Booking[payment_method]")
        self.pushVC(selectedStoryboard: .main, identifier: .addCard)
    }
    
    @IBAction func actionRemovePromoCode(_ sender: UIButton) {
        btnRemovePromoCode.isHidden = true
        btnPromoCode.setTitle(PassTitles.selectPromoCode, for: .normal)
        let currencyTitle = "\(KAppDelegate.bookPostDict.dictValue["Booking[currency_title]"] ?? "")"
        lblValueAmount.text = "\(currencyTitle) \(KAppDelegate.bookPostDict.dictValue["Booking[amount]"]!)"
        lblFinalAmount.text = "\(currencyTitle) \(KAppDelegate.bookPostDict.dictValue["Booking[amount]"]!)"
        KAppDelegate.bookPostDict.dictValue.updateValue("", forKey: "Booking[promo_code]")
        KAppDelegate.bookPostDict.dictValue.updateValue("", forKey: "Booking[discount_amount]")
    }
}

extension PaymentVC: PromoModelDelegate {
    
    func setData(dictData: PromocodeModel) {
        
        btnRemovePromoCode.isHidden = false
        btnPromoCode.setTitle("  \(dictData.title)", for: .normal)
        let rideCostWithoutDiscount = KAppDelegate.bookPostDict.dictValue["Booking[amount]"]!
        let discountValueInPercentage = dictData.amount
        let dicountedValue = Double(rideCostWithoutDiscount)! * Double(discountValueInPercentage)! / 100
        let currencyTitle = "\(KAppDelegate.bookPostDict.dictValue["Booking[currency_title]"] ?? "")"
        lblFinalAmount.text = " \(currencyTitle) \(Double(KAppDelegate.bookPostDict.dictValue["Booking[amount]"]!)! - dicountedValue)"
        KAppDelegate.bookPostDict.dictValue.updateValue(dictData.title, forKey: "Booking[promo_code]")
        KAppDelegate.bookPostDict.dictValue.updateValue("\(dicountedValue)".roundValuesUpto2Points(uptoPoints: 2), forKey: "Booking[discount_amount]")
    }
}

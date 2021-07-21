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
import SwiftSignatureView

protocol SignatureData {
    func endJourney(_ path: UIImage)
}
var delegateSignatureData: SignatureData?

class CustomerSignatureVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var vwSignature: SwiftSignatureView!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        vwSignature.delegate = self
    }
    
    //MARK:- IBActions
    @IBAction func actionCross(_ sender: Any) {
        dismiss()
    }
    @IBAction func actionClear(_ sender: Any) {
        self.vwSignature.clear()
    }
    @IBAction func actionDone(_ sender: Any) {
        if vwSignature.signature == nil {
            Proxy.shared.displayStatusAlert(AlertMessages.custSignature.localized)
        } else {
            dismiss()
            delegateSignatureData?.endJourney(vwSignature.getCroppedSignature()!)
        }
    }
}

extension CustomerSignatureVC: SwiftSignatureViewDelegate{
    func swiftSignatureViewDidTapInside(_ view: SwiftSignatureView) {
    }
    
    func swiftSignatureViewDidPanInside(_ view: SwiftSignatureView, _ pan: UIPanGestureRecognizer) {
    }
}

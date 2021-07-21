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
import WebKit

class ReceiptVC: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var webVwReceipt: WKWebView!
    
    //MARK:- VARIABLES
    var objReceiptVM = ReceiptVM()
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:- Setting Booking id to id variable set up in self.titlte value
        objReceiptVM.bookingId = self.title ?? "0"
        webVwReceipt.uiDelegate = self
        webVwReceipt.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let url = URL(string: "https://app.logist-ex.com/invoice?id=\(objReceiptVM.bookingId)&acces-token=\(Proxy.shared.accessTokenNil())")
        DispatchQueue.main.async {
            self.webVwReceipt.load(URLRequest(url: url!))
        }
    }
    
    
    //MARK:- IBActions
    @IBAction func actionBack(_ sender: Any) {
        self.popToBack()
    }
}

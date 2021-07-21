/**
 *
 *@copyright : OZVID Technologies Pvt Ltd. < www.ozvid.com >
 *@author     : Shiv Charan Panjeta < shiv@ozvid.com >
 *
 * All Rights Reserved.
 * Proprietary and confidential :  All information contained herein is, and remains
 * the property of OZVID Technologies Pvt Ltd. and its partners.
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 */

import UIKit
import WebKit

class PaymentWebViewVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var paymentWebVw: WKWebView!
    //MARK:- Variables
    var objPaymentWebViewVM = PaymentWebViewVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        objPaymentWebViewVM.pageLoad = false
        let url = URL(string: objPaymentWebViewVM.paypalWebUrl)!
        paymentWebVw.navigationDelegate = self
        Proxy.shared.showActivityIndicator()
        paymentWebVw.uiDelegate = self
        paymentWebVw.allowsBackForwardNavigationGestures = true
        paymentWebVw.load(URLRequest(url: url))
    }
    
    //MARK:- IBActions
    @IBAction func actionBack(_ sender: Any) {
        KAppDelegate.bookPostDict = BookNowDict()
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeVC.self) {
                _ =  self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
}

extension PaymentWebViewVC: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Proxy.shared.hideActivityIndicator()
    }
   
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url {
            let stringResult = url.absoluteString.contains("/request/success/")
            if stringResult == true{
                self.objPaymentWebViewVM.responseUrl = url.absoluteString
                let url = URL(string: self.objPaymentWebViewVM.responseUrl)
                let lastPath = url?.lastPathComponent as? String ?? "0"
                self.objPaymentWebViewVM.pageLoad = true
                objPaymentWebViewVM.addConnectAcountApi(requestId: Int(lastPath)!, finalUrl: Apis.requestSuccess) {
                    guard let finalComp = self.objPaymentWebViewVM.complition else {
                        return
                    }
                    finalComp("Success")
                    self.popToBack()
                    Proxy.shared.displayStatusAlert(message: AlertMessages.paymentDoneSuccess.localized, state: .success)
                }
            }
            
            let bookingResultStr = url.absoluteString.contains("booking/success/")
            if bookingResultStr == true{
                
                self.objPaymentWebViewVM.responseUrl = url.absoluteString
                let url = URL(string: self.objPaymentWebViewVM.responseUrl)
                let lastPath = url?.lastPathComponent as? String ?? "0"
                self.objPaymentWebViewVM.pageLoad = true
                objPaymentWebViewVM.addConnectAcountApi(requestId: Int(lastPath)!, finalUrl: Apis.paypalSuccess) {
                    guard let finalComp = self.objPaymentWebViewVM.complition else {
                        return
                    }
                    finalComp("Success")
                    self.popToBack()
                    Proxy.shared.displayStatusAlert(message: AlertMessages.paymentDoneSuccess.localized, state: .success)
                }
            }
           
        }
        decisionHandler(.allow)
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}

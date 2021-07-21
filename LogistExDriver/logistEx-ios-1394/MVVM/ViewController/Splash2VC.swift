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

class Splash2VC: UIViewController {
    
    //MARK:- Object
    var objSplashVM = SplashVM()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sleep(2)
        if Proxy.shared.accessTokenNil() != "" {
            objSplashVM.hitCheckApi {
                self.rootWithDrawer(identifier: "HomeVC")
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()+1.3) {
                self.root(identifier: "PageControlVC")
            }
        }
    }
}

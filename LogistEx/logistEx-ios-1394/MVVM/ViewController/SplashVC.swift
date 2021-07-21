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
class SplashVC: UIViewController {
    
    //MARK:- VARIABLES
    let objSplashVM = SplashVM()
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()){
            if Proxy.shared.accessTokenNil() != "" {
                self.objSplashVM.getUserCheckApi {
                    self.rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC)
                }
            } else {
                 self.rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC)
            }
    }
    }
}


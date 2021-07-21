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



class DrawerVM: NSObject {
    //MARK:- Variables
    var selectedIndex = 0
    var arrDrawerDataWithoutLoginUser = [
        
        (title: Proxy.shared.accessTokenNil() == "" ? PassTitles.login.localized : PassTitles.logOut.localized,menuImage:UIImage(named:"ic_login"), value : IdentifiersVC.loginVC),
        
        (title: PassTitles.home.localized,menuImage:UIImage(named:"ic_home"), value : IdentifiersVC.homeVC),
        (title: PassTitles.myBookings.localized,menuImage:UIImage(named:"ic_bookings"), value : IdentifiersVC.myBookingsVC),
        (title: PassTitles.manageDriver.localized,menuImage:UIImage(named:"ic_driver"), value : IdentifiersVC.manageDriveVC),
        (title: PassTitles.notification.localized,menuImage:UIImage(named:"ic_noti"), value : IdentifiersVC.notificationVC),
        (title: PassTitles.aboutUs.localized,menuImage:UIImage(named:"ic_about"), value : IdentifiersVC.pageTypeVC),
        (title: PassTitles.contactUs.localized,menuImage:UIImage(named:"ic_contact"), value : IdentifiersVC.contactUsVC),
        (title: PassTitles.userGuide.localized,menuImage:UIImage(named:"ic_user_guide"), value : IdentifiersVC.userGuideVC),
        (title: PassTitles.faq.localized,menuImage:UIImage(named:"ic_faq"), value : IdentifiersVC.faqVC),
        (title: PassTitles.privacyPolicy.localized,menuImage:UIImage(named:"ic_privacy_ploicy"), value : IdentifiersVC.pageTypeVC),
        (title: PassTitles.termsAndCondition.localized,menuImage:UIImage(named:"ic_terms"), value : IdentifiersVC.pageTypeVC),
    ]
    
    var arrDrawerData = [
        (title: PassTitles.home.localized,menuImage:UIImage(named:"ic_home"), value : IdentifiersVC.homeVC),
        (title: PassTitles.myBookings.localized,menuImage:UIImage(named:"ic_bookings"), value : IdentifiersVC.myBookingsVC),
        (title: PassTitles.manageDriver.localized,menuImage:UIImage(named:"ic_driver"), value : IdentifiersVC.manageDriveVC),
        (title: PassTitles.notification.localized,menuImage:UIImage(named:"ic_noti"), value : IdentifiersVC.notificationVC),
        (title: PassTitles.aboutUs.localized,menuImage:UIImage(named:"ic_about"), value : IdentifiersVC.pageTypeVC),
        (title: PassTitles.contactUs.localized,menuImage:UIImage(named:"ic_contact"), value : IdentifiersVC.contactUsVC),
        (title: PassTitles.userGuide.localized,menuImage:UIImage(named:"ic_user_guide"), value : IdentifiersVC.userGuideVC),
        (title: PassTitles.faq.localized,menuImage:UIImage(named:"ic_faq"), value : IdentifiersVC.faqVC),
        (title: PassTitles.privacyPolicy.localized,menuImage:UIImage(named:"ic_privacy_ploicy"), value : IdentifiersVC.pageTypeVC),
        (title: PassTitles.termsAndCondition.localized,menuImage:UIImage(named:"ic_terms"), value : IdentifiersVC.pageTypeVC),
        (title: Proxy.shared.accessTokenNil() == "" ? PassTitles.login.localized : PassTitles.logOut.localized,menuImage:UIImage(named:"ic_login"), value : IdentifiersVC.loginVC)
    ]
}
extension DrawerVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Proxy.shared.accessTokenNil() == "" {
            return objDrawerVM.arrDrawerDataWithoutLoginUser.count
        } else {
            return objDrawerVM.arrDrawerData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerTVC") as! DrawerTVC
        if Proxy.shared.accessTokenNil() == "" {
            cell.lblTitle.text = objDrawerVM.arrDrawerDataWithoutLoginUser[indexPath.row].title
            cell.imgVwTitle.image = objDrawerVM.arrDrawerDataWithoutLoginUser[indexPath.row].menuImage
        } else {
            cell.lblTitle.text = objDrawerVM.arrDrawerData[indexPath.row].title
            cell.imgVwTitle.image = objDrawerVM.arrDrawerData[indexPath.row].menuImage
        }
        cell.imgVwDottedLine.isHidden = indexPath.row == 11
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        objDrawerVM.selectedIndex = indexPath.row
        
        var myCurrentVC = UIViewController()
        if let visibleNavC = KAppDelegate.sideMenuVC.mainViewController as? UINavigationController {
            myCurrentVC = visibleNavC.visibleViewController!
        } else if let viewC = KAppDelegate.sideMenuVC.mainViewController {
            myCurrentVC = viewC
        }
        KAppDelegate.sideMenuVC.closeLeft()
        if Proxy.shared.accessTokenNil() == "" {
            if indexPath.row == 1 {
                KAppDelegate.bookPostDict = BookNowDict()
                self.rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC)
            } else if indexPath.row == 0 {
                if Proxy.shared.accessTokenNil() == "" {
                    myCurrentVC.pushVC(selectedStoryboard: .main, identifier: .loginVC)
                } else {
                    Proxy.shared.hitlogoutApi {
                        KAppDelegate.bookPostDict = BookNowDict()
                        UserDefaults.standard.set("", forKey: "access_token")
                        UserDefaults.standard.synchronize()
                        FacebookClass.sharedInstance().logoutFromFacebook()
                        GmailLogin.sharedInstance().logoutGmail()
                        objUserModel = UserModel()
                        self.root(selectedStoryboard: .main, identifier: .splashVC)
                    }
                }
            } else {
                myCurrentVC.pushVC(selectedStoryboard: .main, identifier: objDrawerVM.arrDrawerData[indexPath.row].value, titleVal: objDrawerVM.arrDrawerData[indexPath.row].title)
            }
        } else {
            if indexPath.row == 0 {
                KAppDelegate.bookPostDict = BookNowDict()
                self.rootWithDrawer(selectedStoryboard: .main, identifier: .homeVC)
            } else if indexPath.row == 10 {
                if Proxy.shared.accessTokenNil() == "" {
                    myCurrentVC.pushVC(selectedStoryboard: .main, identifier: .loginVC)
                } else {
                    Proxy.shared.hitlogoutApi {
                        KAppDelegate.bookPostDict = BookNowDict()
                        UserDefaults.standard.set("", forKey: "access_token")
                        UserDefaults.standard.synchronize()
                        FacebookClass.sharedInstance().logoutFromFacebook()
                        GmailLogin.sharedInstance().logoutGmail()
                        objUserModel = UserModel()
                        self.root(selectedStoryboard: .main, identifier: .splashVC)
                    }
                }
            } else {
                myCurrentVC.pushVC(selectedStoryboard: .main, identifier: objDrawerVM.arrDrawerData[indexPath.row].value, titleVal: objDrawerVM.arrDrawerData[indexPath.row].title)
            }
        }
        
    }
}


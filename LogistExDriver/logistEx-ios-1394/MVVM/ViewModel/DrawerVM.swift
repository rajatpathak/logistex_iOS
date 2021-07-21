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
    var arrDrawer =
        [("Home", #imageLiteral(resourceName: "ic_home"),""),
         ("My Bookings",#imageLiteral(resourceName: "ic_bookings"),"MyBookingVC"),
         ("All Request",#imageLiteral(resourceName: "ic_login"),"AllRequestVC"),
         ("Notifications",#imageLiteral(resourceName: "ic_noti"),"NotificationVC"),
         ("My Earnings", #imageLiteral(resourceName: "ic_request"),"MyEarningsVC"),
         ("About Us",#imageLiteral(resourceName: "ic_about"),"AboutUsVC"),
         ("Contact Us",#imageLiteral(resourceName: "ic_contact"),"ContactUsVC"),
         ("Driver Guide",#imageLiteral(resourceName: "ic_user_guide"),"DriverGuideVC"),
         ("FAQs",#imageLiteral(resourceName: "ic_faq_menu"),"FaqVC"),
         ("Privacy Policy",#imageLiteral(resourceName: "ic_privacy_ploicy"),"DriverGuideVC"),
         ("Terms and Conditions",#imageLiteral(resourceName: "ic_terms"),"TermConditionVC"),
         ("Logout",#imageLiteral(resourceName: "ic_logout"),"")]
    var arrSpanishDrawer =
        [("Home", #imageLiteral(resourceName: "ic_home"),""),
         ("Mis Reservas",#imageLiteral(resourceName: "ic_bookings"),"MyBookingVC"),
         ("Todas las Solicitudes",#imageLiteral(resourceName: "ic_login"),"AllRequestVC"),
         ("Notificaciones",#imageLiteral(resourceName: "ic_noti"),"NotificationVC"),
         ("Mis Ganancias", #imageLiteral(resourceName: "ic_request"),"MyEarningsVC"),
         ("Acerca de",#imageLiteral(resourceName: "ic_about"),"AboutUsVC"),
         ("Contáctanos",#imageLiteral(resourceName: "ic_contact"),"ContactUsVC"),
         ("Guía de conductor",#imageLiteral(resourceName: "ic_user_guide"),"DriverGuideVC"),
         ("Preguntas frecuentes",#imageLiteral(resourceName: "ic_faq_menu"),"FaqVC"),
         ("Políticas de privacidad",#imageLiteral(resourceName: "ic_privacy_ploicy"),"DriverGuideVC"),
         ("Términos y condiciones",#imageLiteral(resourceName: "ic_terms"),"TermConditionVC"),
         ("Salir",#imageLiteral(resourceName: "ic_logout"),"")]
    var myCurrentVC = UIViewController()
}

extension DrawerVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objDrawerVM.arrDrawer.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        let dict = lang == ChooseLanguage.spanish.rawValue ? objDrawerVM.arrSpanishDrawer[indexPath.row] : objDrawerVM.arrDrawer[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerTVC") as! DrawerTVC
        cell.lblTitle.text = dict.0
        cell.imgVwDrawer.image = dict.1
        cell.imgVwDottedLine.isHidden = indexPath.row == 11
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        let dict = lang == ChooseLanguage.spanish.rawValue ? objDrawerVM.arrSpanishDrawer[indexPath.row] : objDrawerVM.arrDrawer[indexPath.row]
        if let visibleNavC = KAppDelegate.sideMenuVC.mainViewController as? UINavigationController {
            objDrawerVM.myCurrentVC = visibleNavC.visibleViewController!
            
        } else if let viewC = KAppDelegate.sideMenuVC.mainViewController {
            objDrawerVM.myCurrentVC = viewC
        }
        if objDrawerVM.myCurrentVC.navigationController?.viewControllers.count ?? 0 > 3 {
            objDrawerVM.myCurrentVC.navigationController?.viewControllers.remove(at: 0)
        }
        KAppDelegate.sideMenuVC.closeLeft()
        switch indexPath.row {
        case 0:
            rootWithDrawer(identifier: "HomeVC")
        case 1,2,3,4,5,6,8,10:
            objDrawerVM.myCurrentVC.push(identifier: dict.2)
        case 7:
            objDrawerVM.myCurrentVC.push(identifier: "DriverGuideVC", titleStr: TitleValue.driverGuide)
        case 9:
            objDrawerVM.myCurrentVC.push(identifier: "DriverGuideVC", titleStr: TitleValue.privacy)
        case 11:
            logoutAlert()
        default:
            break
        }
    }
    func logoutAlert() {
        let lang = UserDefaults.standard.value(forKey: "Language" ) as? String
        let controller = UIAlertController(title: AppInfo.appName, message: AlertMessages.logout.localized, preferredStyle: .alert)
        
        let valueBtnYes = "\(lang == ChooseLanguage.spanish.rawValue ? AlertMessages.yesSpa : AlertMessages.yes)"
        
        let okAction = UIAlertAction(title: valueBtnYes, style: .default) { (action) in
            Proxy.shared.logout {
                self.root(identifier: "LoginVC")
                objUserModel = UserModel()
                UserDefaults.standard.set("", forKey: "access_token")
                UserDefaults.standard.synchronize()
                FacebookClass.sharedInstance().logoutFromFacebook()
                GmailLogin.sharedInstance().logoutGmail()
                Proxy.shared.displayStatusAlert(AlertMessages.logoutSuccess.localized)
            }
        }
        let cancelAction = UIAlertAction(title: AlertMessages.no.localized, style: .default, handler: nil)
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        controller.view.tintColor = Color.app
        self.present(controller, animated: true, completion: nil)
    }
}

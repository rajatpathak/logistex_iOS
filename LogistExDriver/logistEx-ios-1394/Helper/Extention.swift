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


extension UIViewController {
    func push(identifier: String, titleStr: String = "") {
        let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: identifier)
        controller.title = titleStr
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func popToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func present(identifier: String, titleStr: String = "") {
        let controller = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: identifier)
        controller.title = titleStr
        self.present(controller, animated: true, completion: nil)
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func root(identifier: String) {
        let controller  = StoryBoard.mainStoryboard.instantiateViewController(withIdentifier: identifier)
        self.view.window?.rootViewController    = controller
    }
    
    func rootWithDrawer(identifier: String) -> Void {
        
        let mainViewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:identifier)
        let sideViewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrawerVC")
        let sideNav = sideViewController
        let mainNav: UINavigationController = UINavigationController(rootViewController: mainViewController)
        let slideMenuController = SlideMenuController.init(mainViewController: mainNav, leftMenuViewController: sideNav)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController as? SlideMenuControllerDelegate
        mainNav.isNavigationBarHidden = true
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                let window:UIWindow =  sd.window!
                KAppDelegate.sideMenuVC = slideMenuController
                window.rootViewController = slideMenuController
                window.makeKeyAndVisible()
            }
        } else {
            KAppDelegate.sideMenuVC = slideMenuController
            self.view.window?.rootViewController = slideMenuController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    func showAlertControllerWithStyle(
        alertStyle style: UIAlertController.Style = .alert,
        title: String = "",
        message: String = "",
        customActions: [String],
        cancelTitle: String = AlertMessages.no,
        needOK: Bool = false,
        
        completion block: @escaping(_ selectedAction: Int) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,  message: message, preferredStyle: style)
            for action in customActions {
                let newAlertAction  = UIAlertAction(title: action, style: .default, handler:{ action in
                    if let title = action.title,
                        var actionIndex = customActions.firstIndex(of: title) {
                        actionIndex = needOK ? actionIndex + 1 : actionIndex
                        block(actionIndex)
                    }
                })
                alert.addAction(newAlertAction)
            }
            if needOK {
                let cancelAction = UIAlertAction(title: cancelTitle, style: .destructive, handler:{ (action: UIAlertAction!) in
                    block(0)
                })
                alert.addAction(cancelAction)
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return (navigation.visibleViewController?.topMostViewController())!
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}

extension UITextField {
    
    class func connectAllTxtFieldFields(txtfields:[UITextField]) -> Void {
        guard let last = txtfields.last else {
            return
        }
        for i in 0 ..< txtfields.count - 1 {
            txtfields[i].returnKeyType = .next
            txtfields[i].addTarget(txtfields[i+1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
            
        }
        last.returnKeyType = .done
        last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
        
    }
    var isBlank : Bool {
        return (self.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
    }
    var trimmedValue : String {
        return (self.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
    }
}

extension String {
    
    //MARK:-  validation for name
    var isValidName : Bool {
        let emailRegEx = "^[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]+$"
        let range = self.range(of: emailRegEx, options:.regularExpression)
        return range != nil ? true : false
    }
    //MARK:- Check Valid Email Method
    var isValidEmail : Bool  {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return (self.range(of: emailRegEx, options:.regularExpression) != nil)
    }
    var isBlank : Bool {
        return (self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }
    
    //MARK:- Convert html string into String
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    // MARK: Get string from date
    func getStringFromDate(inputFormat:String,outputFormat:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = inputFormat
        guard let inputtime = formatter.date(from: self) else { return "" }
        formatter.dateFormat = outputFormat
        let outputTime = formatter.string(from: inputtime)
        return outputTime
    }
    // MARK: Get date from string
    func getDateFromStr() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from:self) else { return Date()}
        return date
    }
    // MARK: Get string from date
    func getCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        return result
    }
    var hexColor: UIColor {
        
        let hexString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

extension Date{
    func stringFromFormat(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.calendar = Calendar.autoupdatingCurrent
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

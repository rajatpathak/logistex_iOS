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

//MARK:- UIViewController
extension UIViewController {
    
    func popToBack(isAnimate:Bool = true) {
        DispatchQueue.main.async {
            self.navigationController?.viewControllers.removeLast()
            self.navigationController?.popViewController(animated: isAnimate)
        }
    }
    
    func popToRoot(isAnimate:Bool = true) {
        DispatchQueue.main.async {
            self.navigationController?.viewControllers.removeAll()
            self.navigationController?.popToRootViewController(animated: isAnimate)
        }
    }
    
    func dismissController(isAnimate:Bool = true) {
        DispatchQueue.main.async {
            self.dismiss(animated: isAnimate, completion: nil)
        }
    }
    
    func root(selectedStoryboard: StoryBoardType, identifier: IdentifiersVC ) {
        DispatchQueue.main.async {
            self.navigationController?.viewControllers.removeAll()
            let controller =  selectedStoryboard.storyBoard.instantiateViewController(withIdentifier: identifier.rawValue )
            self.view.window?.rootViewController = controller
        }
    }
    
    func pushVC(selectedStoryboard: StoryBoardType, identifier: IdentifiersVC, titleVal: String = "", isAnimate:Bool = true) {
        DispatchQueue.main.async {
            let objPushVC = selectedStoryboard.storyBoard.instantiateViewController(withIdentifier: identifier.rawValue)
            objPushVC.title = titleVal
            self.navigationController?.pushViewController(objPushVC, animated: isAnimate)
        }
    }
    
    //MARK:- Present method
    func presentVC(selectedStoryboard: StoryBoardType, identifier: IdentifiersVC, titleVal:String="") {
        DispatchQueue.main.async {
            let controller = selectedStoryboard.storyBoard.instantiateViewController(withIdentifier: identifier.rawValue)
            controller.title = titleVal
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK:- Alert
    func showAlert(title: String = "", message: String = "", completion block: @escaping(_ isSuccess: Bool) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: AlertMessages.yes, style: .default, handler:{ (action: UIAlertAction!) in
                block(true)
            })
            
            let cancelAction = UIAlertAction(title:  AlertMessages.no, style: .destructive, handler:{ (action: UIAlertAction!) in
                block(false)
                
            })
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    func rootWithDrawer(selectedStoryboard: StoryBoardType, identifier: IdentifiersVC, titleVal: String = "", isAnimate:Bool = true)   {
        DispatchQueue.main.async {
            let mainVC =  selectedStoryboard.storyBoard.instantiateViewController(withIdentifier: identifier.rawValue)
            let sideVC =  selectedStoryboard.storyBoard.instantiateViewController(withIdentifier: "DrawerVC")
            let slideMenuController = SlideMenuController.init(mainViewController: mainVC, leftMenuViewController: sideVC) 
            slideMenuController.automaticallyAdjustsScrollViewInsets = true
            slideMenuController.delegate = mainVC as? SlideMenuControllerDelegate
            
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
    }
    
    func rootWithoutDrawer(selectedStoryboard: StoryBoardType, identifier: IdentifiersVC, titleVal: String = "", isAnimate:Bool = true){
        let blankController = selectedStoryboard.storyBoard.instantiateViewController(withIdentifier: identifier.rawValue)
        blankController.title  = titleVal
        var homeNavController:UINavigationController = UINavigationController()
        homeNavController = UINavigationController.init(rootViewController: blankController)
        homeNavController.isNavigationBarHidden = true
        if #available(iOS 13.0, *)  {
            let scene = UIApplication.shared.connectedScenes.first
            if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                let window:UIWindow =  sd.window!
                window.rootViewController = homeNavController
                window.makeKeyAndVisible()
            }
        } else {
            KAppDelegate.window?.rootViewController = homeNavController
            KAppDelegate.window?.makeKeyAndVisible()
        }
    }
    // Custom method for creating action sheet or alert with multiple actions
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

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y:
            locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        switch(vc){
        case is UINavigationController:
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!)
        case is UITabBarController:
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
        default:
            if let presentedViewController = vc.presentedViewController {
                if let presentedViewController2 = presentedViewController.presentedViewController {
                    return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController2)
                } else {
                    return vc
                }
            } else {
                return vc
            }
        }
    }
}

extension UIView {
    func setUpAnimation() {
        let lineSize = self.frame.size.width / 9
        let x = (self.bounds.size.width - self.frame.size.width) / 2
        let y = (self.bounds.size.height - self.frame.size.height) / 2
        let duration: CFTimeInterval = 0.9
        let beginTime = CACurrentMediaTime()
        let beginTimes = [0.5, 0.25, 0, 0.25, 0.5]
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.11, 0.49, 0.38, 0.78)
        
        // Animation
        let animation = CAKeyframeAnimation(keyPath: "transform.scale.y")
        
        animation.keyTimes = [0, 0.8, 0.9]
        animation.timingFunctions = [timingFunction, timingFunction]
        animation.beginTime = beginTime
        animation.values = [1, 0.3, 1]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        // Draw lines
        for i in 0 ..< 5 {
            let line = layerWith(size: CGSize(width: lineSize, height: self.frame.size.height), color: Color.app)
            let frame = CGRect(x: x + lineSize * 2 * CGFloat(i),
                               y: y,
                               width: lineSize,
                               height: self.frame.size.height)
            
            animation.beginTime = beginTime + beginTimes[i]
            line.frame = frame
            line.add(animation, forKey: "animation")
            self.layer.addSublayer(line)
        }
    }
    func layerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        var path: UIBezierPath = UIBezierPath()
        path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height),
                            cornerRadius: size.width / 2)
        layer.fillColor = color.cgColor
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        return layer
    }
    func stopAnimation() {
        guard let sublayers = self.layer.sublayers else {
            return
        }
        for layer in sublayers {
            layer.removeAllAnimations()
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

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
import Foundation
import AVFoundation

protocol PassImageDelegate {
    func passSelectedImgCrop(selectImage: UIImage)
}

var galleryCameraImageObj:PassImageDelegate?

class GalleryCameraImage: NSObject,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- variable Decleration
    var imagePicker = UIImagePickerController()
    var imageTapped = Int()
    var clickImage = UIImage()
    var controller = UIViewController()
    
    //MARK:- Choose Image Method
    func customActionSheet(_ deleteEnable:Bool) {
        
        let myActionSheet = UIAlertController()
        let deleteAction = UIAlertAction(title: AlertMessages.deletePhoto, style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        let galleryAction = UIAlertAction(title: AlertMessages.choosePhoto, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGallary()
        })
        let cameraAction = UIAlertAction(title: AlertMessages.takePhoto, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.checkCameraPermission()
        })
        
        let cancelAction = UIAlertAction(title: AlertMessages.cancel, style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        if deleteEnable{
            myActionSheet.addAction(deleteAction)
        }
        myActionSheet.addAction(galleryAction)
        myActionSheet.addAction(cameraAction)
        myActionSheet.addAction(cancelAction)
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                let window:UIWindow =  sd.window!
                window.rootViewController?.present(myActionSheet, animated: true, completion: nil)
                window.makeKeyAndVisible()
            }
        } else {
            KAppDelegate.window?.rootViewController?.present(myActionSheet, animated: true, completion: nil)
        }
    }
    
    //MARK:- Open Image Camera
    func checkCameraPermission() {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            DispatchQueue.main.async {
                self.openCamera()
            }
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    DispatchQueue.main.async {
                        self.openCamera()
                    }
                }
            })
        }
    }
    func openCamera(){
        DispatchQueue.main.async {
            if(UIImagePickerController .isSourceTypeAvailable(.camera)) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.delegate = self
                self.imagePicker.allowsEditing = false
                if #available(iOS 13.0, *) {
                    let scene = UIApplication.shared.connectedScenes.first
                    if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                        let window:UIWindow =  sd.window!
                        window.rootViewController?.present(self.imagePicker, animated: true, completion: nil)
                        window.makeKeyAndVisible()
                    }
                } else {
                    KAppDelegate.window?.rootViewController?.present(self.imagePicker, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: AlertMessages.alert, message: AlertMessages.cameraNotSupport, preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: AlertMessages.ok, style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okAction)
                if #available(iOS 13.0, *) {
                    let scene = UIApplication.shared.connectedScenes.first
                    if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                        let window:UIWindow =  sd.window!
                        window.rootViewController?.present(alert, animated: true, completion: nil)
                        window.makeKeyAndVisible()
                    }
                } else {
                     KAppDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK:- Open Image Gallery
    func openGallary() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
      //imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.sourceType = .photoLibrary
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                let window:UIWindow =  sd.window!
                window.rootViewController?.present(imagePicker, animated: true, completion: nil)
                window.makeKeyAndVisible()
            }
        } else {
             KAppDelegate.window?.rootViewController?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                let window:UIWindow =  sd.window!
                window.rootViewController?.dismiss(animated: true, completion: nil)
                window.makeKeyAndVisible()
            }
        } else {
            KAppDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            if (picker.sourceType == .camera) || (picker.sourceType == .photoLibrary) ||  (picker.sourceType == .savedPhotosAlbum) {
                let objImagePick: UIImage = (info[.originalImage] as! UIImage)
                self.setSelectedimage(objImagePick)
            }
        }
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                let window:UIWindow =  sd.window!
                window.rootViewController?.dismiss(animated: true, completion: nil)
                window.makeKeyAndVisible()
            }
        } else {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK:- Selectedimage
    func setSelectedimage(_ image: UIImage) {
        clickImage = image
        galleryCameraImageObj?.passSelectedImgCrop(selectImage: clickImage)
    }
}

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
import AVFoundation
import CropViewController


protocol PassImageDelegate {
    func getSelectedImage(selectImage: UIImage)
}

var objPassImageDelegate:PassImageDelegate?

class GalleryCameraImage: NSObject,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK:- variable Decleration
    var imageTapped = Int()
    var clickImage = UIImage()
    var delegate:PassImageDelegate?
    var currentController = UIViewController()
    //METHOD TO ASK FOR PERMISSION    
    func customActionSheet(removeProfile: Bool,controller: UIViewController) {
        currentController = controller
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            self.callCamera(removeProfile: removeProfile)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    self.callCamera(removeProfile: removeProfile )
                } else {
                    self.presentCameraSettings()
                }
            })
        }
    }
    
    func presentCameraSettings() {
        let alertController = UIAlertController(title: AlertMessages.cameraTitle,
                                                message:AlertMessages.cameraGallery, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AlertMessages.cancel, style: .default))
        alertController.addAction(UIAlertAction(title: AlertMessages.settings, style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        })
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView =  currentController.view
                popoverController.sourceRect = CGRect(x: currentController.view.bounds.midX, y: currentController.view.bounds.midY, width: 0, height: 0)
            }
            currentController.present(alertController, animated: true, completion: nil)
            
        } else{
            currentController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func callCamera(removeProfile:Bool) {
        DispatchQueue.main.async {
            
            
            let myActionSheet = UIAlertController()
            let deleteAction = UIAlertAction(title:AlertMessages.deletePhoto, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.deleteProfileApi {
                    self.currentController.dismiss(animated: true, completion: nil)
                }
            })
            
            let galleryAction = UIAlertAction(title: AlertMessages.galery, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.openGallary()
            })
            let cmaeraAction = UIAlertAction(title: AlertMessages.camera, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.openCamera()
            })
            let cancelAction = UIAlertAction(title:AlertMessages.cancel, style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
            })
            if removeProfile {
                myActionSheet.addAction(deleteAction)
            }
            myActionSheet.addAction(galleryAction)
            myActionSheet.addAction(cmaeraAction)
            myActionSheet.addAction(cancelAction)
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
                if let popoverController = myActionSheet.popoverPresentationController {
                    popoverController.sourceView =  KAppDelegate.window?.rootViewController?.view
                    popoverController.sourceRect = CGRect(x: self.currentController.view.bounds.midX, y:  self.currentController.view.bounds.midY, width: 0, height: 0)
                }
                self.currentController.present(myActionSheet, animated: true, completion: nil)
            } else {
                self.currentController.present(myActionSheet, animated: true, completion: nil)
            }
        }
    }
    
    //MARK:- Open Image Camera
    func openCamera() {
        DispatchQueue.main.async {
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                self.currentController.present(imagePicker, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: AlertMessages.alert, message: AlertMessages.cameraNotSupported, preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: AlertMessages.ok, style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okAction)
                self.currentController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK:- Open Image Gallery
    func openGallary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        currentController.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        DispatchQueue.main.async {
            if(picker.sourceType == .camera) {
                let objImagePick: UIImage = (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
                self.setSelectedimage(objImagePick)
            } else {
                let objImagePick: UIImage = (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
                self.setSelectedimage(objImagePick)
            }
        }
        picker.dismiss(animated: true, completion: nil) 
    }
    
    //MARK:- Selectedimage
    func setSelectedimage(_ image: UIImage) {
        clickImage = image
        let cropViewController = TOCropViewController(image: clickImage)
        cropViewController.delegate = self
        currentController.present(cropViewController, animated: true, completion: nil)
    }
    //MARK:- DeleteProfile Api Method
    func deleteProfileApi(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData(urlStr: "", showIndicator: true) { (response) in
            completion()
            
        }
    }
}

extension GalleryCameraImage :TOCropViewControllerDelegate {
    //MARK:-CropViewController Delegate
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        objPassImageDelegate?.getSelectedImage(selectImage: image)
        currentController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentController.dismiss(animated: true, completion: nil)
    }
}

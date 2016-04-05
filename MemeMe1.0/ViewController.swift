//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Hoff Henry Pereira da Silva on 21/08/15.
//  Copyright (c) 2015 Hoff Silva. All rights reserved.
//

import UIKit
import Social


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var top: UITextField!
    @IBOutlet weak var bottom: UITextField!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.redColor(),
        NSForegroundColorAttributeName: UIColor.yellowColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -1.9
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        top.hidden = true
        shareButton.enabled = false
        top.delegate = self
        bottom.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotificationsWillShow()
        subscribeToKeyboardNotificationsWillHide()
        checkCamera()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotificationsWillShow()
        unsubscribeToKeyboardNotificationsWillHide()
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func pickAnImage(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePickerView.image = image
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        showTextfield(false)
        shareButton.enabled = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func showTextfield(ativar: Bool){
        
        top.defaultTextAttributes = memeTextAttributes
        top.hidden = ativar
        top.text = "TOP"
        top.textAlignment = NSTextAlignment.Center
        
        bottom.hidden = ativar
        bottom.text = "BOTTOM"
        bottom.defaultTextAttributes = memeTextAttributes
        bottom.textAlignment = NSTextAlignment.Center
        
    }
    
    func checkCamera(){
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotificationsWillShow() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotificationsWillShow() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotificationsWillHide() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func subscribeToKeyboardNotificationsWillHide() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func generateMemedImage() -> UIImage {
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
        
    }
    
    
    func save() {
        var meme = Meme( text: "\(top.text) \(bottom.text)", image:
            imagePickerView.image!, memedImage: generateMemedImage())
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func shareImage(sender: AnyObject) {
        
        var memedImageWillShare = [generateMemedImage()]
        
        presentViewController(UIActivityViewController(activityItems: memedImageWillShare, applicationActivities: nil), animated: true, completion: nil)
        
    }
    
}


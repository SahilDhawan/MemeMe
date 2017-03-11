//
//  ViewController.swift
//  MemeMe
//
//  Created by Sahil Dhawan on 24/02/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.isEnabled = false
        //delegate
        topTextField.delegate = self
        bottomTextField.delegate = self
        //Specifying the height of status View
        statusView.translatesAutoresizingMaskIntoConstraints = false
        let heightContraint = UIApplication.shared.statusBarFrame.height
        statusView.heightAnchor.constraint(equalToConstant: heightContraint).isActive = true
        
        
        //disabling camera button
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        
        let memeTextAttributes : [String: Any] = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white ,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -5.0]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .center
    }
    @IBAction func imagePickerPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        shareButton.isEnabled = true
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
        shareButton.isEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    //MARK: AdjustingViewAccordingToKeyboard
    func subscribeToKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    func keyboardWillHide(_ notification:Notification)
    {
        self.view.frame.origin.y += getKeyboardHeight(notification)
    }
    func keyboardWillShow(_ notification:Notification)
    {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    func unsubscribeToKeyboardNotifications()
    {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let height = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return height.cgRectValue.height
    }
    @IBAction func shareButtonPressed(_ sender: Any) {
        let meme = Meme.init(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imageView.image, memedImage: generateMemedImage())
        let controller = UIActivityViewController.init(activityItems: [meme.memedImage], applicationActivities:nil)
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.topTextField.text = "TOP"
        self.bottomTextField.text = "BOTTOM"
        self.imageView.image = nil
    }
}
extension ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let key = UIImagePickerControllerOriginalImage
        if let pickedImage = info[key] as? UIImage
        {
            self.imageView.image = pickedImage
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func generateMemedImage()->UIImage
    {
        self.navigationBar.isHidden = true
        self.toolbar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage!  = UIGraphicsGetImageFromCurrentImageContext()
        self.navigationBar.isHidden = false
        self.toolbar.isHidden = false
        return memedImage
    }
}
extension ViewController:UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
struct Meme
{
    var topText : String!
    var bottomText : String!
    var image : UIImage!
    var memedImage : UIImage!
}

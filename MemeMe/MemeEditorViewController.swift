//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Sahil Dhawan on 24/02/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {
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
        
        configure(topTextField, "TOP", memeTextAttributes)
        configure(bottomTextField,"BOTTOM",memeTextAttributes)
    }
    @IBAction func imagePickerPressed(_ sender: Any) {
        present(imagePickerGenerator(.photoLibrary), animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        present(imagePickerGenerator(.camera), animated: true, completion: nil)
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
        if bottomTextField.isFirstResponder
        {
            self.view.frame.origin.y = 0
        }
    }
    func keyboardWillShow(_ notification:Notification)
    {
        if bottomTextField.isFirstResponder
        {
            self.view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
        
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
    @IBAction func shareButtonPressed(_ sender: Any) {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController.init(activityItems: [memedImage], applicationActivities:nil)
        controller.completionWithItemsHandler = {
            (_, successful, _, _) in
            if successful{
                self.save(memedImage)
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.topTextField.text = "TOP"
        self.bottomTextField.text = "BOTTOM"
        self.imageView.image = nil
    }
    func configure(_ textField : UITextField, _ text : String , _ attributes : [String:Any])
    {
        textField.text = text
        textField.defaultTextAttributes = attributes
        textField.textAlignment = .center
    }
    func imagePickerGenerator(_ sourceType : UIImagePickerControllerSourceType)-> UIImagePickerController
    {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        shareButton.isEnabled = true
        return imagePicker
    }
    func save(_ memedImage:UIImage)
    {
        let meme = Meme.init(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imageView.image, memedImage: memedImage)
    }
}
extension MemeEditorViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate
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
    
}
extension MemeEditorViewController:UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM"
        {
            textField.text = ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

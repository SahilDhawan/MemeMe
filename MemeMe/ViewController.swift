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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
       func showError(msg:String)
    {
        let activity = UIAlertController.init(title: "Project", message: msg, preferredStyle: .actionSheet)
        let action = UIAlertAction.init(title: "Dismiss", style: .destructive, handler: nil)
        activity.addAction(action)
        self.present(activity, animated: true, completion: nil)
    }
    
    
    @IBAction func imagePickerPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
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
//        showError(msg: "key of the image is   \(key)")
        if let pickedImage = info[key] as? UIImage
        {
//            showError(msg: "picked Image with key  \(key)")
            self.imageView.image = pickedImage
            self.dismiss(animated: true, completion: nil)
        }
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

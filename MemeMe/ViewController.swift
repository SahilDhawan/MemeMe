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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topTextField.delegate = self
        bottomTextField.delegate = self
    }
    
       func showError(msg:String)
    {
        let activity = UIAlertController.init(title: "Project", message: msg, preferredStyle: .actionSheet)
        let action = UIAlertAction.init(title: "Dismiss", style: .destructive, handler: nil)
        activity.addAction(action)
        self.present(activity, animated: true, completion: nil)
    }
}
extension ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let key = UIImagePickerControllerOriginalImage
        showError(msg: "key of the image is   \(key)")
        if let pickedImage = info[key] as? UIImage
        {
            showError(msg: "picked Image with key  \(key)")
            self.imageView.image = pickedImage
            self.dismiss(animated: true, completion: nil)
        }

        
    }
    @IBAction func cameraPressed(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
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

//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Sahil Dhawan on 17/03/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var memedImage : UIImage! = nil
    override func viewDidLoad()
    {
        super.viewDidLoad()
       imageView.image = memedImage
        imageView.contentMode = UIViewContentMode.scaleAspectFit
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

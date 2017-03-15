
//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Sahil Dhawan on 14/03/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController{
    
    var memes = [Meme]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        self.tableView.reloadData()
    }
    @IBAction func plusButtonPressed(_ sender: Any) {
        let memeController = (storyboard?.instantiateViewController(withIdentifier: "MemeEditor"))! as UIViewController
        self.navigationController?.pushViewController(memeController, animated: true)
    }
    
}
extension MemeTableViewController : UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let memeCell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell")
        let meme = memes[indexPath.row]
        memeCell?.imageView?.image = meme.memedImage
        memeCell?.textLabel?.text = meme.topText + " " + meme.bottomText
        return memeCell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
}
extension MemeTableViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]
        let memeController = storyboard?.instantiateViewController(withIdentifier: "MemeEditor") as! MemeEditorViewController
        memeController.imageView.image = meme.image
        memeController.bottomTextField.text = meme.bottomText
        memeController.topTextField.text = meme.topText
        self.navigationController?.pushViewController(memeController, animated: true)
    }
}

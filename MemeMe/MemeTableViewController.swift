
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
        memeCell?.textLabel?.text = meme.topText + " - " + meme.bottomText
        memeCell?.imageView?.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        memeCell?.imageView?.image = meme.memedImage
        memeCell?.layer.borderColor = UIColor.black.cgColor
        memeCell?.layer.borderWidth = 2.0
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
        memeController.meme = meme
        self.navigationController?.pushViewController(memeController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}

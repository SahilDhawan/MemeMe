//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Sahil Dhawan on 14/03/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController {
    var memes  = [Meme]()
    @IBOutlet weak var collectionView: UICollectionView!
    func showAlert(_ msg:String)
    {
        let controller = UIAlertController.init(title: "Meme", message:msg , preferredStyle: .alert)
        let action = UIAlertAction.init(title: "DIsmiss", style: .destructive, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        collectionView.reloadData()
    }
    @IBAction func plusButtonPressed(_ sender: Any) {
        let memeController = (storyboard?.instantiateViewController(withIdentifier: "MemeEditor"))! as UIViewController
        self.navigationController?.pushViewController(memeController, animated: true)
    }
}
//MARK: UICollectionViewDelegate
extension MemeCollectionViewController:UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]
        let memeController = storyboard?.instantiateViewController(withIdentifier: "MemeEditor") as! MemeEditorViewController
        showAlert(meme.topText)
        showAlert("\(indexPath.row)")
        memeController.imageView.image = meme.image
        memeController.bottomTextField.text = meme.bottomText
        memeController.topTextField.text = meme.topText
        self.navigationController?.pushViewController(memeController, animated: true)
    }
}
//MARK: UICollectionViewDataSouce
extension MemeCollectionViewController:UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let memeCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as! MemeCollectionViewCell
        showAlert("\(indexPath.row)")
        let meme = memes[indexPath.row]
        memeCollectionCell.label.text = meme.topText + " " + meme.bottomText
        memeCollectionCell.imageView.image = meme.memedImage
        return memeCollectionCell
    }
}

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
    @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        collectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        var dimension : CGFloat
        super.viewWillTransition(to: size, with: coordinator)
        let space:CGFloat = 10.0
        dimension = (collectionView.frame.width - space)/2
        collectionFlowLayout.minimumLineSpacing = space
        collectionFlowLayout.minimumInteritemSpacing = space
        if (UIApplication.shared.statusBarOrientation == .landscapeLeft) || (UIApplication.shared.statusBarOrientation == .landscapeRight)
        {
            dimension = (collectionView.frame.width-3*space)/4
        }
        collectionFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
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
        memeController.meme = meme
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
        let meme = memes[indexPath.row]
        memeCollectionCell.label.text = meme.topText + " - " + meme.bottomText
        memeCollectionCell.imageView.image = meme.memedImage
        memeCollectionCell.layer.borderColor = UIColor.black.cgColor
        memeCollectionCell.layer.borderWidth = 2.0
        return memeCollectionCell
    }
}

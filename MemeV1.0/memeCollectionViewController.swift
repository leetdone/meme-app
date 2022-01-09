//
//  memeCollectionViewController.swift
//  MemeV1.0
//
//  Created by lindong on 1/5/22.
//

import Foundation
import UIKit

class memeCollectionViewController: UICollectionViewController{
    
    @IBOutlet weak var flowLayout:UICollectionViewFlowLayout!
    
    var memes: [Meme]!{
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //manage layout even if rotation happens
        let space: CGFloat = 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: 123, height: 150)//vertical, horizontal different type
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionViewCell", for: indexPath) as! memeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "memeDetailViewController") as! memeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
}

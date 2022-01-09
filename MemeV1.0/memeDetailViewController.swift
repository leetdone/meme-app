//
//  memeDetailViewController.swift
//  MemeV1.0
//
//  Created by lindong on 1/7/22.
//

import Foundation
import UIKit
class memeDetailViewController: UIViewController{
    
    var meme: Meme!
    
    @IBOutlet weak var detailView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailView.image = meme.memedImage
    }
}

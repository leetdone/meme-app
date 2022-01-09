//
//  memeTableViewController.swift
//  MemeV1.0
//
//  Created by lindong on 1/5/22.
//

import Foundation
import UIKit


class memeTableViewController: UITableViewController{
        //get list containing memes
        var memes: [Meme]!{
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    //show image and text in the tablecell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memetableViewCell",for: indexPath) as! memetableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.tableCellImage?.image = meme.memedImage
        cell.tableCellText?.text = "\(meme.topText)\t\(meme.buttonText)"
        return cell
    }
    
    //when a cell is selected, go to detail page
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "memeDetailViewController") as! memeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}

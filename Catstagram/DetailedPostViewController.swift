//
//  DetailedPostViewController.swift
//  Catstagram
//
//  Created by Olga Andreeva on 6/29/17.
//  Copyright © 2017 Olga Andreeva. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DetailedPostViewController: UIViewController {
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var detailedImageView: PFImageView!
    var post: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let post = post {
            let author = post["author"] as! PFUser
            let imageObject = post["media"] as! PFFile
            let caption = post["caption"] as! String
            let date = post.createdAt!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            let dateString = dateFormatter.string(from:date as Date)
            timestampLabel.text = dateString
            captionLabel.text = caption
            usernameLabel.text = author.username
            detailedImageView.file = imageObject
            detailedImageView.loadInBackground()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

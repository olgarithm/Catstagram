//
//  HomeScreenViewController.swift
//  Catstagram
//
//  Created by Olga Andreeva on 6/27/17.
//  Copyright © 2017 Olga Andreeva. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MBProgressHUD

class HomeScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var returnedPosts: [PFObject] = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshControlAction(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.separatorStyle = .none
        refreshPage()
    }

    func refreshPage() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        getPosts()
        tableView.setContentOffset(CGPoint.zero, animated: true)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        getPosts()
    }
    
    @IBAction func didLogOut(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            print("You're logged out!")
            self.performSegue(withIdentifier: "logOutSegue", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return returnedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let postData = returnedPosts[indexPath.row]
        
        let author = postData["author"] as! PFUser
        let imageObject = postData["media"] as! PFFile
        let caption = postData["caption"] as! String
        let date = postData.createdAt!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let dateString = dateFormatter.string(from:date as Date)
        
        cell.postImage.file = imageObject
        cell.postImage.loadInBackground()
        cell.usernameLabel.text = author.username
        cell.captionLabel.text = caption
        cell.timestampLabel.text = dateString
        cell.profileImage.file = author["profilePicture"] as! PFFile
        cell.profileImage.loadInBackground()
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width / 2;
        cell.profileImage.clipsToBounds = true;
    
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshPage()
    }
    
    func getPosts() {
        let query = PFQuery(className: "Post")
        query.limit = 20
        query.addDescendingOrder("createdAt")
        query.includeKey("author")
        
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                self.returnedPosts = posts
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DetailedView") {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                let postData = returnedPosts[indexPath.row]
                let detailViewController = segue.destination as! DetailedPostViewController
                detailViewController.post = postData
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}

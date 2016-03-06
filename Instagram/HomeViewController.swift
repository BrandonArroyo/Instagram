//
//  HomeViewController.swift
//  Instagram
//
//  Created by Brandon Arroyo on 3/5/16.
//  Copyright © 2016 Brandon Arroyo. All rights reserved.
//

import UIKit
import Parse
import JGProgressHUD

class HomeViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [Post]?
    var postsAsPFObjects: [PFObject]?
    var HUD: JGProgressHUD = JGProgressHUD(style: JGProgressHUDStyle.Dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        makeQuery()
        
    }
    func refreshControlAction(refreshControl: UIRefreshControl) {
        makeQuery(refreshControl.endRefreshing())
    }
    func makeQuery(completion: Void) {
        // construct PFQuery
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        HUD.textLabel.text = "Loading..."
        HUD.showInView(self.view)
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {
                // do something with the data fetched
                self.postsAsPFObjects = media
                self.posts = Post.PostsWithArray(media)
                self.collectionView.reloadData()
            } else {
                // handle error
                print("error thingy")
            }
            completion
            self.HUD.dismiss()
        }
    }

    
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts != nil ? posts!.count : 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PostCollectionViewCell", forIndexPath: indexPath) as! PostCollectionViewCell
        
        cell.post = posts![indexPath.item]
//        cell.prof.tag = indexPath.item
        // we have to query for the image data
        
        
        // get post
        HUD.showInView(self.view)
        let mediaFile = postsAsPFObjects![indexPath.item]["media"] as! PFFile
        mediaFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            if imageData != nil {
                let image = UIImage(data:imageData!)
                cell.postImageView.image = image
                cell.post!.media = image
                
                self.posts![indexPath.item].media = image
            
            }
            self.HUD.dismiss()
        }
        let user = postsAsPFObjects![indexPath.item]["author"] as! PFUser
        if user.objectForKey("profile_photo") != nil {
            let profileMedia = user["profile_photo"]
            HUD.showInView(self.view)
            profileMedia.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if imageData != nil {
                    let image = UIImage(data:imageData!)
                    cell.profileImageViewButton.setImage(image, forState: .Normal)
                    cell.post!.authorImage = image
                    self.posts![indexPath.item].authorImage = image
                    print("this thing is happening")
                }
                self.HUD.dismiss()
            }
        }
        else {
            let image = UIImage(named: "default_profile")
//            cell.profileImageViewButton.setImage(image, forState: .Normal)
            cell.post!.authorImage = image
            self.posts![indexPath.item].authorImage = image
        }
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Brandon Arroyo on 3/5/16.
//  Copyright © 2016 Brandon Arroyo. All rights reserved.
//

import UIKit
import Parse
import ALCameraViewController
import JGProgressHUD

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [Post]?
    var postsAsPFObjects: [PFObject]?
    var HUD: JGProgressHUD = JGProgressHUD(style: JGProgressHUDStyle.Dark)
    var user: PFUser?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user == nil {
            user = PFUser.currentUser()
        }
        else if user?.objectId != PFUser.currentUser()?.objectId {
            logoutButton.alpha = 0
            profileImageButton.userInteractionEnabled = false
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
        
//        profileImageButton.imageView?.layer.cornerRadius = 34
      
        
        if user!.objectForKey("profile_photo") != nil {
            let profileMedia = user!["profile_photo"]
            self.HUD.textLabel.text = "Loading..."
            self.HUD.showInView(self.view)
            profileMedia.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if imageData != nil {
                    let image = UIImage(data:imageData!)
                    print(image)
                    // set profile image for view
                    self.profileImageButton.setImage(image, forState: .Normal)
                    print("this thing is happening")
                }
                self.HUD.dismiss()
            }
        }
        else {
            let image = UIImage(named: "default_profile")
            self.profileImageButton.setImage(image, forState: .Normal)
        }
        
        makeQuery()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    func makeQuery() {
        // construct PFQuery
        let query = PFQuery(className: "Post")
        query.whereKey("author", equalTo: user!)
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        self.HUD.textLabel.text = "Loading..."
        self.HUD.showInView(self.view)
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {
                // do something with the data fetched
                self.postsAsPFObjects = media
                self.posts = Post.PostsWithArray(media)
//                self.collectionView.reloadData()
            } else {
                // handle error
                print("error thingy")
            }
            self.HUD.dismiss()
        }
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts != nil ? posts!.count : 0
    }
    
    
    
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PostCollectionViewCell", forIndexPath: indexPath) as! PostCollectionViewCell
        cell.isProfileCell = true
        cell.post = posts![indexPath.item]
        // we have to query for the image data
        
        // get post
        let mediaFile = postsAsPFObjects![indexPath.item]["media"] as! PFFile
        self.HUD.textLabel.text = "Loading..."
        self.HUD.showInView(self.view)
        mediaFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            if imageData != nil {
                let image = UIImage(data:imageData!)
                cell.postImageView.image = image
                cell.post!.media = image
                self.posts![indexPath.item].media = image
                print("this thing is happening")
            }
            self.HUD.dismiss()
        }
        
        return cell
    }

    
    @IBAction func onLogout(sender: AnyObject) {
        PFUser.logOut()
        NSNotificationCenter.defaultCenter().postNotificationName("userDidLogoutNotification", object: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
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

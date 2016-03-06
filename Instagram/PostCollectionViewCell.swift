//
//  PostCollectionViewCell.swift
//  Instagram
//
//  Created by Brandon Arroyo on 3/5/16.
//  Copyright © 2016 Brandon Arroyo. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var profileImageViewButton: UIButton!
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var isProfileCell = false
    
    var post: Post? {
        didSet {
           
            timeLabel.text = Post.convertDateToString((post?.createdAt)!)
            if !isProfileCell {
//                self.sendSubviewToBack(profileImageViewButton)
                usernameLabel.text = post?.author?.username!
//                profileImageViewButton.layer.cornerRadius = 12
//                profileImageViewButton.clipsToBounds = true
                captionLabel.text = post?.caption!
            }
        }
    }
}

//
//  ImageViewController.swift
//  Instagram
//
//  Created by Brandon Arroyo on 3/5/16.
//  Copyright © 2016 Brandon Arroyo. All rights reserved.
//

import UIKit
import JGProgressHUD
import ALCameraViewController

class ImageViewController: UIViewController {
    var preview: UIImage!
    var HUD = JGProgressHUD(style: .Dark)
    
    @IBOutlet weak var CaptionTextField: UITextField!
    
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var photoPreview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        CaptionTextField.alpha = 0
        sendButton.alpha = 0
        
        
        
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
  
    @IBAction func TakePicture(sender: AnyObject) {

        self.takePhoto()
        
    }
    
    @IBAction func sendPost(sender: AnyObject) {
        if preview != nil {
            self.HUD.textLabel.text = "Posting..."
            self.HUD.showInView(self.view)
            Post.postUserImage(preview, withCaption: CaptionTextField.text ?? "") { (flag: Bool, error: NSError?) -> Void in
                if error == nil {
                    print("Image Posted Successfully!")
                    self.CaptionTextField.alpha = 0
                    self.sendButton.alpha = 0
                    self.photoPreview.alpha = 0
                    self.takePhotoButton.alpha = 1
                    
                }
                else {
                    print("error occurred \(error?.localizedDescription)")
                }
                self.HUD.dismiss()
            }
        }
        else {
            let alertController = UIAlertController(title: "Whoops", message: "Please choose an image before posting.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Alright.", style: UIAlertActionStyle.Cancel, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
            
           
            
        }

        
    }
    func takePhoto(){
        let croppingEnabled = true
        let cameraViewController = ALCameraViewController(croppingEnabled: croppingEnabled) { image in
            // Do something with your image here.
            // If cropping is enabled this image will be the cropped version
            
            
            if image != nil {
                // save to imageview
                let newSize = CGSize(width: 320, height: 320)
                self.preview = Post.resize(image!, newSize: newSize)
                self.photoPreview.image = self.preview
            }
            self.dismissViewControllerAnimated(true, completion: nil)
            self.takePhotoButton.alpha = 0
            self.sendButton.alpha = 1
            self.CaptionTextField.alpha = 1
            self.photoPreview.alpha = 1
            
            
            var myTextField = UITextField(frame:CGRectMake(0, 0, 200, 30))
            
            self.CaptionTextField.attributedPlaceholder = NSAttributedString(string:"Type Caption here...",
                attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            
        }
        presentViewController(cameraViewController, animated: true, completion: nil)
        

        
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

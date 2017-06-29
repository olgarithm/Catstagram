//
//  PhotoMapViewController.swift
//  Catstagram
//
//  Created by Olga Andreeva on 6/27/17.
//  Copyright © 2017 Olga Andreeva. All rights reserved.
//

import UIKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var choosenImage: UIImageView!
    var choosenCameraType = ""
    var postCaption = ""
    @IBOutlet weak var placeholderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captionTextView.delegate = self
        placeholderLabel.text = "Write a caption..."
        placeholderLabel.sizeToFit()
        captionTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (captionTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !captionTextView.text.isEmpty
        captionTextView.layer.cornerRadius = 5.0
        let cameraType = choosenCameraType
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if cameraType == "takePicture" {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                print("Camera is available 📸")
                vc.sourceType = .camera
            } else {
                print("Camera 🚫 available so we will use photo library instead")
                vc.sourceType = .photoLibrary
            }
        } else {
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    
    @IBAction func didPressUpload(_ sender: Any) {
            postCaption = captionTextView.text ?? ""
        Post.postUserImage(image: choosenImage.image, withCaption: postCaption) { (bool: Bool, error: Error?) in
            print("Post complete")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        choosenImage.image = resize(image: editedImage, newSize: CGSize(width: 640, height: 640))
        dismiss(animated: true, completion: nil)
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
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

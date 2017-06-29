//
//  SelectionViewController.swift
//  Catstagram
//
//  Created by Olga Andreeva on 6/28/17.
//  Copyright © 2017 Olga Andreeva. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {

    var typeOfCamera = ""
    
    @IBAction func didPressPhotoLibrary(_ sender: Any) {
        typeOfCamera = "photoLibrary"
    }
    
    @IBAction func didPressTakePicture(_ sender: Any) {
        typeOfCamera = "takePicture"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue:
        UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToPhotoMap" {
            let destinationViewController = segue.destination as! PhotoMapViewController
            destinationViewController.choosenCameraType = self.typeOfCamera
        }
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

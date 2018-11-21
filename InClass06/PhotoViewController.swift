//
//  PhotoViewController.swift
//  InClass06
//
//  Created by Pranalee Jadhav on 11/14/18.
//  Copyright © 2018 Pranalee Jadhav. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class PhotoViewController: UIViewController {

    var imageDetails:(String,String)!
    @IBOutlet weak var imgView: UIImageView!
    let storageRef = Storage.storage().reference().child("images").child(Auth.auth().currentUser!.uid)
    let databaseRef = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        .child("images")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var rightBtn: UIButton!
        rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 25))
        rightBtn.setImage(UIImage(named: "trash.png"), for: UIControlState.normal)
        rightBtn.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
        rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        rightBtn.tintColor = .blue
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        
        imgView.sd_setImage(with: URL(string:imageDetails.1), placeholderImage: UIImage(named: "loading.png"))
        
    }

    @IBAction func deleteImage(sender: UIButton) {
        //building an alert
        let alertController = UIAlertController(title: "Photo Delete", message: "Do you want to delete the photo?", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
            self.databaseRef.child(self.imageDetails.0).removeValue{_,_ in
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
       
        
        //adding action
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //presenting dialog
        present(alertController, animated: true, completion: nil)
    }
    

}

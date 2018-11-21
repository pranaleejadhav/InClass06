//
//  PhotosViewController.swift
//  InClass06
//
//  Created by Pranalee Jadhav on 11/14/18.
//  Copyright © 2018 Pranalee Jadhav. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import Photos
import SVProgressHUD
import SDWebImage

class photoCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImg: UIImageView!
    
}

extension UIView {
    
    func findCollectionView() -> UICollectionView? {
        if let collectionView = self as? UICollectionView {
            return collectionView
        } else {
            return superview?.findCollectionView()
        }
    }
    
    func findCollectionViewCell() -> UICollectionViewCell? {
        if let cell = self as? UICollectionViewCell {
            return cell
        } else {
            return superview?.findCollectionViewCell()
        }
    }
    
    func findCollectionViewIndexPath() -> IndexPath? {
        guard let cell = findCollectionViewCell(), let collectionView = cell.findCollectionView() else { return nil }
        
        return collectionView.indexPath(for: cell)
    }
    
}

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    let imagePicker = UIImagePickerController()
    var cellArr = [(String, String)]()
    var database: Database!
    // Create a root reference
    let storageRef = Storage.storage().reference().child("images").child(Auth.auth().currentUser!.uid)
    var databaseRef = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        .child("images")
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "User Photos"
        
        var backBtn: UIButton!
        backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 25))
        backBtn.setTitle("Logout", for: UIControlState.normal)
        backBtn.addTarget(self, action: #selector(logout), for: .touchUpInside)
        backBtn.contentHorizontalAlignment = .left
        backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        backBtn.setTitleColor(.blue, for: UIControlState.normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        
        var rightBtn: UIButton!
        rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 25))
        rightBtn.setImage(UIImage(named: "add.png"), for: UIControlState.normal)
        rightBtn.addTarget(self, action: #selector(loadImage), for: .touchUpInside)
        rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        rightBtn.tintColor = .blue
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
       let flowLayout = UICollectionViewFlowLayout()
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        //layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        flowLayout.itemSize = CGSize(width: (screenWidth-6)/3, height: (screenWidth-6)/3)
        flowLayout.minimumInteritemSpacing = 3
        flowLayout.minimumLineSpacing = 3
        self.collectionView.collectionViewLayout = flowLayout
        imagePicker.delegate = self
        
        
      
        // Initialize Database, Auth, Storage
        database = Database.database()
        if PHPhotoLibrary.authorizationStatus() != .authorized {
           // NSLog("Will request authorization")
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    DispatchQueue.main.async(execute: {
                        //completion(true)
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        //completion(false)
                    })
                }
            })
            
        } else {
            DispatchQueue.main.async(execute: {
                //completion(true)
            })
        }
        getData()
    }
    
    
    func getData() {
        //observing the data changes
        databaseRef.observe(DataEventType.value, with: { (snapshot) in
            print("get data")
            
            DispatchQueue.global().async {
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                print("get data1")
                //clearing the list
                self.cellArr.removeAll()
                
                //iterating through all the values
                for image in snapshot.children.allObjects as! [DataSnapshot] {
                    print("get data2")
                    //getting values
                    let imgUrl = image.value as? String
                   
                    let imgKey = image.key
                    
                    
                    //appending it to list
                    self.cellArr.append((imgKey, imgUrl!))
                }
                
                //self.cellArr.reverse()
                
                //reloading the tableview
                 DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                }
            }
        })
    }
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            NotificationCenter.default.post(name: Notification.Name("com.amad.inclass06"), object: self, userInfo: nil)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func loadImage(sender: UIButton) {
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = .photoLibrary
                    
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            })
        } else {
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            SVProgressHUD.show()
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let time = Date.timeIntervalSinceReferenceDate * 1000
            
            let mediaFolder = self.storageRef.child("\(time).jpeg")
            if let data = UIImagePNGRepresentation(pickedImage) {
                mediaFolder.putData(data, metadata: nil, completion: { (metadata, error) in
                    SVProgressHUD.dismiss()
                                                            if error != nil {
                                                                let alert = UIAlertController(title: "Error", message:
                                                                    error?.localizedDescription, preferredStyle:
                                                                    UIAlertControllerStyle.alert)
                                                                let ok = UIAlertAction(title: "OK", style:
                                                                    UIAlertActionStyle.cancel, handler: nil)
                                                                alert.addAction(ok)
                                                                self.present(alert, animated: true, completion: nil)
                                                            } else {
                                                                mediaFolder.downloadURL { (url, error) in
                                                                    guard let downloadURL = url else {
                                                                        print(" error occurred")
                                                                        return
                                                                    }
                                                                    print(downloadURL.absoluteString)
                                                                    let key = self.databaseRef.childByAutoId().key
                                                                    self.databaseRef.child(key!).setValue(downloadURL.absoluteString)
                                                                    
                                                                }
                                                            }
                })
            }
           
        }
     }
          
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellItem", for: indexPath) as! photoCell
        //cell.cellImg.image = UIImage(named: "1.png")
        
        cell.cellImg.sd_setImage(with: URL(string:cellArr[indexPath.row].1), placeholderImage: UIImage(named: "loading.png"))
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        performSegue(withIdentifier: "viewPhoto", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = (sender as? UIView)?.findCollectionViewIndexPath() else { return }
            guard let photoViewController = segue.destination as? PhotoViewController else { return }
            photoViewController.imageDetails = cellArr[indexPath.row]
            
            
       
    }

    
}

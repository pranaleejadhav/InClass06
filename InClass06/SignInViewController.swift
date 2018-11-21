//
//  SignInViewController.swift
//  InClass05
//
//  Created by Pranalee Jadhav on 11/9/18.
//  Copyright © 2018 Pranalee Jadhav. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var uname: UITextField!
    @IBOutlet weak var pwd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    @IBAction func signUp(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func signIn(_ sender: Any) {
        let uname = self.uname.text?.trimmingCharacters(in: .newlines)
        let pwd = self.pwd.text?.trimmingCharacters(in: .newlines)
        
        if uname == "" {
            showMsg(title: "", subTitle: "Email cannot be empty")
        } else if pwd == "" {
            showMsg(title: "", subTitle: "Password cannot be empty")
        } else {
        
        
            Auth.auth().signIn(withEmail: uname!, password: pwd!) { (user, error) in
                if let error = error {
                    print(error)
                } else if let user = Auth.auth().currentUser {
                    NotificationCenter.default.post(name: Notification.Name("com.amad.inclass06"), object: self, userInfo: nil)
                    
                }
                
                //UserDefaults.standard.setValue(user?.user.uid, forKey: "userid")
                
            }
        }
    }
    
    func showMsg(title: String, subTitle: String) -> Void {
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: title, message:
                subTitle, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    
}

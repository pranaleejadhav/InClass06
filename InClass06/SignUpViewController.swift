//
//  SignUpViewController.swift
//  InClass05
//
//  Created by Pranalee Jadhav on 11/9/18.
//  Copyright © 2018 Pranalee Jadhav. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var confirm_pwdField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
    @IBAction func signUp(_ sender: Any) {
        let uname = self.nameField.text?.trimmingCharacters(in: .newlines)
        let email = self.emailField.text?.trimmingCharacters(in: .newlines)
        let pwd = self.pwdField.text?.trimmingCharacters(in: .newlines)
        let rpwd = self.confirm_pwdField.text?.trimmingCharacters(in: .newlines)
        
        if uname == "" {
            showMsg(title: "", subTitle: "Username cannot be empty")
        } else if email == "" {
            showMsg(title: "", subTitle: "Email cannot be empty")
        } else if !isValidEmail(testStr: email!) {
            showMsg(title: "", subTitle: "Email is invalid")
        } else if pwd == "" {
            showMsg(title: "", subTitle: "Password cannot be empty")
        } else if (pwd?.count)! < 6 {
            showMsg(title: "", subTitle: "Password should be at least 6 characters")
        } else if rpwd != pwd {
            showMsg(title: "", subTitle: "Passwords do not match")
        } else {
            Auth.auth().createUser(withEmail: email!, password: pwd!) { (user, error) in
                //UserDefaults.standard.setValue(user?.user.uid, forKey: "userid")
                if error == nil {
                    let ref = Database.database().reference().root
                    let userObj = ["email": email, "username": uname]
                    ref.child("user_details").child((user!.user.uid)).setValue(userObj)
                    self.showMsg(title: "", subTitle: "User created successfully!")
                    DispatchQueue.main.async(execute: {
                        NotificationCenter.default.post(name: Notification.Name("com.amad.inclass06"), object: self, userInfo: nil)
                    })
                    
                } else {
                    if error != nil {
                        print(error)
                    }
                }
                
            }
        }
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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

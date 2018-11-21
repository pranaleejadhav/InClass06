//
//  AppDelegate.swift
//  InClass05
//
//  Created by Pranalee Jadhav on 11/9/18.
//  Copyright © 2018 Pranalee Jadhav. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override init() {
        FirebaseApp.configure()
        
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Use Firebase library to configure APIs
        NotificationCenter.default.addObserver(self, selector: #selector(showHomeScreen(_:)), name: Notification.Name("com.amad.inclass06"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("com.amad.inclass06"), object: self, userInfo: nil)
        
        
        return true
    }

    @objc func showHomeScreen(_ notification:Notification) {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                let viewController: PhotosViewController = storyboard.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController
                let navigationController = UINavigationController(rootViewController: viewController)
                
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.rootViewController = navigationController
                self.window?.makeKeyAndVisible()
                // User is signed in.
            } else {
                // No user is signed in.
                let loginViewController: SignInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.rootViewController = loginViewController
                self.window?.makeKeyAndVisible()
            }
        }
        
        
        if Auth.auth().currentUser != nil {
            
            print(Auth.auth().currentUser?.uid)
            // User is signed in.
            
        } else {
            // No user is signed in.
            
            
        }
            
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


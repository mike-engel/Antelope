//
//  AppDelegate.swift
//  Antelope
//
//  Created by Adam Gluck on 8/30/15.
//  Copyright © 2015 Antelope. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var mainViewController: MainViewController!
    var window: UIWindow?
    var app: UIApplication = UIApplication.sharedApplication()

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let facebookDeepLinked : Bool = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        return facebookDeepLinked
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        mainViewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        
        app.unregisterForRemoteNotifications()
        
        self.setupRemoteNotifications()
        
        let facebookLaunched : Bool = FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return facebookLaunched
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        FBSDKAppEvents.activateApp()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Notifications
    
    func setupRemoteNotifications() {
        let type: UIUserNotificationType = UIUserNotificationType.Alert
        let settings = UIUserNotificationSettings(forTypes: type, categories: nil)
        
        app.registerUserNotificationSettings(settings)
        app.registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let characterSet = NSCharacterSet(charactersInString: "<>")
        
        let deviceTokenString: String = String(deviceToken.description as NSString)
            .stringByTrimmingCharactersInSet(characterSet)
            .stringByReplacingOccurrencesOfString(" ", withString: "")
        
        print(deviceTokenString)
        
        _registerDeviceToken(deviceTokenString)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    
    }
    
    func _registerDeviceToken(deviceTokenString: String) {
        print("registering device token remotely")
        let request = NSMutableURLRequest(URL: NSURL(string: "http://10.0.0.14:4000/users")!)
        request.HTTPMethod = "POST"
        
        let postParams = "device_token=\(deviceTokenString)"
        request.HTTPBody = postParams.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            } else {
                print(response?.description)
            }
        }
        
        task.resume()
    }

}


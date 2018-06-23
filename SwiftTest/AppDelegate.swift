//
//  AppDelegate.swift
//  SwiftTest
//
//  Created by Hy on 2018/3/1.
//  Copyright © 2018年 Hy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        SSRequest().postNormalUrlSuccess({ (request, dic) in
            
        }) { (request, error) in
            
        }
        let tabBarVC = TabBarViewController()
        let frame =
        CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        window = UIWindow.init(frame: frame);
        window?.rootViewController = tabBarVC;
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        configNavBar()
        return true
    }
    //配置全局导航栏属性
    @objc func configNavBar(){
        
        let navBar = UINavigationBar.appearance()
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17)]
        navBar.tintColor = UIColor.black
        
        let barItem = UIBarButtonItem.appearance()
        barItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17),NSAttributedStringKey.foregroundColor:UIColor.black], for: .normal)
        barItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17),NSAttributedStringKey.foregroundColor:UIColor.black], for: .highlighted)
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


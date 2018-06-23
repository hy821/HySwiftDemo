//
//  TabBarViewController.swift
//  SwiftTest
//
//  Created by Hy on 2018/3/1.
//  Copyright © 2018年 Hy. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        configController();
        // Do any additional setup after loading the view.
    }
    @objc func configController(){

        let home = HomeViewController()
        let mine = MineViewController()

        configChildVC(home, "首页", "tab_homeUnSelect", "tab_homeSelect", BaseNavViewController.classForCoder())
        configChildVC(mine, "我的", "tab_mineUnSelect", "tab_mineSelect", BaseNavViewController.classForCoder())
    }
    @objc func configChildVC(_ viewController:UIViewController,_ title:NSString,_ imageName:NSString,_ selectImageName:NSString,_ NavVc:AnyClass){
        
        viewController.title = title as String
        viewController.tabBarItem.image = UIImage.init(named: imageName as String)?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.selectedImage = UIImage.init(named: selectImageName as String)?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.brown] , for: UIControlState.normal)
        viewController.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black] , for: UIControlState.selected)
        let nav = BaseNavViewController.init(rootViewController: viewController)
        addChildViewController(nav)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

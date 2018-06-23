//
//  DetailViewController.swift
//  SwiftTest
//
//  Created by Hy on 2018/3/1.
//  Copyright © 2018年 Hy. All rights reserved.
//

import UIKit
protocol detailDelegate {
    func sendText(userInfo:NSDictionary)
}
class DetailViewController: UIViewController {
    typealias detailBlock = (NSDictionary)-> Void
    var  customBlock : detailBlock?
    public var delegate:detailDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
//        fd_interactivePopDisabled = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        popAction()
    }
    @objc func popAction(){
        let dic:[String:Any] = ["name":"myh","age":"24"]
        if customBlock != nil {
            customBlock!(dic as NSDictionary)
        }

        if (delegate != nil){
            delegate?.sendText(userInfo: dic as NSDictionary)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DetailNoti), object: dic as NSDictionary)
        
        print(dic)
        navigationController?.popViewController(animated: true)
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

//
//  HomeViewController.swift
//  SwiftTest
//
//  Created by Hy on 2018/3/1.
//  Copyright © 2018年 Hy. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh
import ObjectMapper

class HomeViewController: UIViewController,detailDelegate,UITableViewDelegate,UITableViewDataSource {
    var btn : UIButton?
    var page = 1
    let ID =  "cell"
    lazy var dataArr : NSMutableArray = {
        var data = NSMutableArray.init()
        return data
    }()
    lazy var tableView : UITableView = {
        let table = UITableView.init(frame: CGRect(x:0,y:0,width:0,height:0), style: .plain)
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 100
        table.tableFooterView = UIView();
        table.register(HomeListCell.classForCoder(), forCellReuseIdentifier: ID)
        weak var weakSelf = self
        table.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            weakSelf?.page = 1
            weakSelf?.loadData(animation: true)
        })
        table.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            weakSelf?.page = (weakSelf?.page)! + 1
            weakSelf?.loadData(animation: false)
        })
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        configUI();
        loadData(animation: true)
        NotificationCenter.default.addObserver(self, selector: #selector(detailNoti(_:)), name: NSNotification.Name(rawValue: DetailNoti), object: nil)
    }
    @objc func configUI(){

        view?.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })

    }
    @objc func loadData(animation : Bool){
        let dic = ["lat":"31.22748426649305","lng":"121.4481160481771","cate":"0","page":page] as [String : Any]
        let parm = NSMutableDictionary.init(dictionary: dic)
        let urlStr =   String(format: "%@%@", (UserManager.share() as AnyObject).serverAddress(),Home_Category_Page)
        if animation{
            SSHudShow(view, "loading")
        }
        SSRequest().post(withAllReturn: urlStr, parameters: parm , success: { (request, response ) in
            print(response ?? NSObject())
            if animation{
                SSDissMissMBHud(self.view, true)
            }
            let data:NSDictionary = response as! NSDictionary
            let dataA:NSArray = data.object(forKey: "data") as! NSArray
            if self.page == 1{
                self.dataArr.removeAllObjects()
            }
            let modelArr = Mapper<HomeModel>().mapArray(JSONArray: dataA as! [[String : Any]])
            self.dataArr.addObjects(from: modelArr as [Any])
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }) { (request, errorStr) in
            print(errorStr ?? String())
            if animation{
                SSDissMissMBHud(self.view, true)
            }
            SSMBToast(errorStr, self.view)
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }
        
        
        
    }
    
   //tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      print(indexPath.row)
       btnClick()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : HomeListCell?
        cell = tableView.dequeueReusableCell(withIdentifier: ID) as? HomeListCell
        if cell == nil {
            cell = HomeListCell.init(style: .default, reuseIdentifier: ID)
        }
        cell?.refreshModel(model: dataArr.object(at: indexPath.row) as! HomeModel)
        return cell!
    }
    @objc func detailNoti(_ noti:NSNotification){
        print("通知传值---\(noti.object as Any)")
    }
    @objc func btnClick(){
        
        let VC  = DetailViewController()
        VC.customBlock = {(userInfo)in
            print("block传值")
        }
        VC.delegate = self
        navigationController?.pushViewController(VC, animated: true)
        
    }
    //代理
    func sendText(userInfo: NSDictionary) {
        print("代理传值 = \(userInfo)")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
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

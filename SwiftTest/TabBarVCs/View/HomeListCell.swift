//
//  HomeListCell.swift
//  SwiftTest
//
//  Created by Hy on 2018/3/2.
//  Copyright © 2018年 Hy. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
class HomeListCell: UITableViewCell {
    var nameLable : UILabel?
    var leftImg  : UIImageView?
    var numLable : UILabel?
    var placeLable : UILabel?
    var placeNumLable : UILabel?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configUI()
        makeMas()
    }
    func configUI(){
        leftImg = UIImageView()
        leftImg?.contentMode = .scaleAspectFill
        leftImg?.backgroundColor = UIColor.white
        leftImg?.layer.masksToBounds = true
        contentView.addSubview(leftImg!)

        nameLable = UILabel()
        nameLable?.font = UIFont.systemFont(ofSize: 15)
        nameLable?.textColor = UIColor.black
        contentView.addSubview(nameLable!)
        
        numLable = UILabel()
        numLable?.font = UIFont.systemFont(ofSize: 12)
        numLable?.textColor = Utils.colorConvert(from: "#666666")
        contentView.addSubview(numLable!)
        
        placeLable = UILabel()
        placeLable?.numberOfLines = 0
        placeLable?.font = UIFont.systemFont(ofSize: 13)
        placeLable?.textColor = Utils.colorConvert(from: "#666666")
        placeLable?.textAlignment = .left
        contentView.addSubview(placeLable!)
        
        placeNumLable = UILabel()
        placeNumLable?.font = UIFont.systemFont(ofSize: 11)
        placeNumLable?.textColor = Utils.colorConvert(from: "#666666")
        placeNumLable?.textAlignment = .right
        contentView.addSubview(placeNumLable!)
    }
    func makeMas(){
        leftImg?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        make.size.equalTo(CGSize(width:Helper.returnUpWidth(91),height:Helper.returnUpWidth(81)))
        })
        nameLable?.snp.makeConstraints({ (make) in
            make.left.equalTo((leftImg?.snp.right)!).offset(10)
            make.top.equalTo(leftImg!).offset(3)
        })
        placeNumLable?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(11)
            make.bottom.equalTo((leftImg?.snp.bottom)!).offset(-3)
        })
        placeLable?.snp.makeConstraints({ (make) in
            make.left.equalTo(nameLable!)
            make.top.equalTo((nameLable?.snp.bottom)!).offset(8)
            make.right.equalTo((placeNumLable?.snp.left)!).offset(5)
            make.bottom.equalToSuperview().offset(-10)
        })

     placeNumLable?.setContentHuggingPriority(.required, for: .horizontal)
     placeNumLable?.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    func refreshModel(model:HomeModel){
        if model.logo.isEmpty{
            model.logo = "https://ylm.yejingying.com/asset/img/bar_bg.jpg"
        }
        leftImg?.sd_setImage(with: NSURL.init(string: model.logo)! as URL, placeholderImage: nil, options: SDWebImageOptions(rawValue: 0) , completed: nil)
        nameLable?.text = model.name
        placeLable?.text =         String(format: "地址：%@", model.addr)
//String.init(format: "地址：\(model.addr)", locale: Locale.current,CVarArg.self as! CVarArg)
        let num = model.distance/1000
        let s = String(format: "%.2fkm", num)
        placeNumLable?.text = s
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

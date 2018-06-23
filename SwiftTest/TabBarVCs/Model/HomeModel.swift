//
//  HomeModel.swift
//  SwiftTest
//
//  Created by Hy on 2018/3/2.
//  Copyright © 2018年 Hy. All rights reserved.
//

import UIKit
import ObjectMapper
class HomeModel: Mappable {
    var name : String = ""
    var lat : Float = 0
    var lng : Float = 0
    var addr : String = ""
    var barId : String = ""
    var distance : Float = 0
    var logo : String = ""
    var mSales : NSInteger = 0
    required init?(map : Map){
       
    }
    func mapping(map : Map){
        
        name  <- map["name"]
        lat <- map["lat"]
        lng <- map["lng"]
        addr <- map["addr"]
        barId <- map["barId"]
        distance <- map["distance"]
        logo <- map["logo"]
        mSales <- map["mSales"]

    }
}

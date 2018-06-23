//
//  NetWorkTool.swift
//  SwiftTest
//
//  Created by Hy on 2018/3/2.
//  Copyright © 2018年 Hy. All rights reserved.
//

import UIKit
import Alamofire
private let AESKey = "7oUbm2cN58TieMIH"
class NetWorkTool: NSObject {
    static let shareManager : NetWorkTool = {
        let tools = NetWorkTool()
        return tools
    }()
}

extension NetWorkTool {
    
    /// 发送POST请求
    
    func postRequest(urlString:String, params : [String : Any], finished : @escaping (_ response : [String :AnyObject]?,_ error:NSError?)->()) {
       
        Alamofire.request(urlString, method: .post, parameters: params)
            
            .responseJSON { (response)in
                
                
                
                if response.result.isSuccess{
                    
                    
                    
                    finished(response.result.value as? [String : AnyObject],nil)
                    
                }else{
                    
                    
                    
                    finished(nil,response.result.error as NSError?)
                    
                    
                    
                }
                
        }
        
        
        
    }
    
    
    
    //发送get请求
    
    
    
    func getRequest(urlString:String, params : [String : Any], finished : @escaping (_ response : [String :AnyObject]?,_ error:NSError?)->()) {
        
        
        
        
        
        Alamofire.request(urlString, method: .get, parameters: params)
            
            .responseJSON { (response)in
                
                
                
                if response.result.isSuccess{
                    
                    
                    
                    finished(response.result.value as? [String : AnyObject],nil)
                    
                }else{
                    
                    
                    
                    finished(nil,response.result.error as NSError?)
                    
                    
                    
                }
                
        }
        
    }
    
    
    
}

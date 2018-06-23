//
//  SSRequest.m
//  SmallStuff
//
//  Created by Hy on 2017/3/29.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import "SSRequest.h"
#import "AppInterface.h"
#import "NSData+AES.h"
#import "Tool.h"
#import "GTMBase64.h"
#import "UserManager.h"
#import "SwiftTest-Bridging-Header.h"
#import "Config.h"
#import "SSUrlManager.h"
#import "HudCenter.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#define AESKey  @"7oUbm2cN58TieMIH"
@interface SSRequest ()
@end
/*
 extern const NSString *  Authorization; //token
 extern const NSString *  Version;//版本号
 extern const NSString * Device;//设备
 extern const NSString * Timestamp;//时间戳 10位
 extern const NSString * Sign;//参数签名
 */
@implementation SSRequest
//参数加密
-(NSDictionary * )getPublicDic:(NSDictionary*)apiDic{
    if(!apiDic)
    {
        apiDic = @{};
    }
    NSString * time = [self getNowTimeTimestamp3];
    //hyAdd
    NSString* version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString * auth = [USER_MANAGER userToken];
    NSString * device = @"1";
    NSString * aesNormalStr = [self sortedDictionary:apiDic];
    NSMutableDictionary * aesDic = [NSMutableDictionary dictionary];
    NSDictionary * dic = @{
                           Authorization:auth,
                           Version : version,
                           Device : device,
                           Timestamp : time
                           };
    [aesDic addEntriesFromDictionary:dic];
    NSString * aesStr = [[Tool md5:[NSString stringWithFormat:@"%@%@%@",AESKey,aesNormalStr,time]] lowercaseString];
    [aesDic setObject:aesStr forKey:Sign];
    return aesDic.copy;
}

-(NSData *)sortDic:(NSDictionary *)dic withAesKey:(NSString *)key
{
    NSString * aesNormalStr  = [self sortedDictionary:dic];
    NSData *data1 = [aesNormalStr dataUsingEncoding:NSUTF8StringEncoding];
    //加密
    data1 = [data1 AES128EncryptWithKey:key iv:AESKey];
    return data1;
}

//获取当前时间戳  10位
-(NSString *)getNowTimeTimestamp3{
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return [timeSp substringWithRange:NSMakeRange(0, 10)];
    
}
/**
 对字典(Key-Value)排序 区分大小写
 
 @param dict 要排序的字典
 */
- (NSString  *)sortedDictionary:(NSDictionary *)dict{
    
    //将所有的key放进数组
    NSArray *allKeyArray = [dict allKeys];
    //序列化器对数组进行排序的block 返回值为排序后的数组
    NSArray *afterSortKeyArray =  [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        //排序操作
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    //通过排列的key值获取value
    NSString * aesNormalStr = @"";
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [dict objectForKey:sortsing];
        if(aesNormalStr.length == 0)
        {
            aesNormalStr = [NSString stringWithFormat:@"%@=%@",sortsing,valueString];
        }else
        {
            aesNormalStr = [NSString stringWithFormat:@"%@&%@=%@",aesNormalStr,sortsing,valueString];
        }
    }
    return aesNormalStr;
}

+ (instancetype)request {
    
    static SSRequest *ssrequest = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ssrequest = [[SSRequest alloc]init];
    });
    
    return ssrequest;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sessionManager = [AFHTTPSessionManager manager];
    }
    return self;
}

- (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void (^)(SSRequest *request, NSDictionary *response))success
    failure:(void (^)(SSRequest *request, NSError *error))failure {
    
    self.operationQueue=self.sessionManager.operationQueue;
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.sessionManager.requestSerializer.timeoutInterval = 10;
    
    AFJSONResponseSerializer *JsonSerializer = [AFJSONResponseSerializer serializer];
    JsonSerializer.removesKeysWithNullValues=YES;
    self.sessionManager.responseSerializer = JsonSerializer;
    
    [self.sessionManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(self,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        SSLog(@"[SSRequest]: %@",error.localizedDescription);
        failure(self,error);
    }];
    
}

static AFHTTPSessionManager * extracted(SSRequest *object) {
    return object.sessionManager;
}
- (void)POST:(NSString *)URLString
  parameters:(NSMutableDictionary*)parameters
     success:(void (^)(SSRequest *request, id response))success
     failure:(void (^)(SSRequest *request, NSString *errorMsg))failure{
    
    if([USER_MANAGER serverAddress].length == 0)
    {
        [[SSRequest request]postNormalUrlSuccess:^(SSRequest * request, id response) {
            [self BasePostWithURL:URLString parameters:parameters success:^(SSRequest *request, id response) {
                if(RequestStateCode == completionCode){
                    if(success)
                    {
                        success(request,response);
                    }
                }else
                {
                    if(failure)
                    {
                        failure(request,response[@"msg"]);
                    }
                }
            } failure:^(SSRequest *request, NSError * error) {
                if(failure)
                {
                    failure(request,error.localizedDescription);
                }
            }];
        } failure:^(SSRequest * request, NSError * error) {
            if(failure)
            {
                failure(request,error!=nil?error.localizedDescription:@"网络错误请重试");
            }
        }];
    }else{
        
        self.operationQueue = self.sessionManager.operationQueue;
        
        AFJSONResponseSerializer *JsonSerializer = [AFJSONResponseSerializer serializer];
        JsonSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        JsonSerializer.removesKeysWithNullValues=YES;
        self.sessionManager.responseSerializer = JsonSerializer;
        
        NSDictionary * signDic = [self getPublicDic:parameters];
        //获取AES加密数据
        NSString * key = [[signDic objectForKey:Sign] substringWithRange:NSMakeRange(0, 16)];
        NSData * dataStr = [self sortDic:parameters withAesKey:key];
        //重新组合的字典
        parameters = [self getPublicDic:parameters].mutableCopy;
        //重组 request
//        SSLog(@"%@%@",URLString,parameters);
        self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
        request.timeoutInterval= 15.f;
        
        if ([URLString isEqualToString:KURLSTR([USER_MANAGER serverAddress], SendDynamic_Url)]) {
            request.timeoutInterval= 30.f;
        }
        
        [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [request setValue:obj forHTTPHeaderField:key];
        }];
        [request setHTTPBody: dataStr];
//        SSLog(@"%@",dataStr);
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        //底层请求
        [[self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if([responseObject[@"ret"] integerValue] == 306)
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:OverDateToken object:nil];
            }
            if(error!=nil)
            {
                failure(self,error.localizedDescription);
            }else
            {
                if([responseObject[@"ret"] integerValue] == 200){
                    success(self,responseObject);
                }else
                {
                    failure(self,responseObject[@"msg"]);
                }
            }
        }]resume];
    }
}
-(void)BasePostWithURL:(NSString*)URLString parameters:(NSMutableDictionary*)parameters
               success:(void (^)(SSRequest *request, id response))success
               failure:(void (^)(SSRequest *request, NSError *error))failure
{
    self.operationQueue = self.sessionManager.operationQueue;
    AFJSONResponseSerializer *JsonSerializer = [AFJSONResponseSerializer serializer];
    JsonSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    JsonSerializer.removesKeysWithNullValues=YES;
    self.sessionManager.responseSerializer = JsonSerializer;
    
    NSDictionary * signDic = [self getPublicDic:parameters];
    //获取AES加密数据
    NSString * key = [[signDic objectForKey:Sign] substringWithRange:NSMakeRange(0, 16)];
    NSData * dataStr = [self sortDic:parameters withAesKey:key];
    //重新组合的字典
    parameters = [self getPublicDic:parameters].mutableCopy;
    //重组 request
//    SSLog(@"%@%@",URLString,parameters);
    self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    request.timeoutInterval= 15.f;
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    [request setHTTPBody: dataStr];
//    SSLog(@"%@",dataStr);
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //底层请求
    [[self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        SSLog(@"%@",responseObject);
        if(error!=nil)
        {
            failure(self,error);
        }else
        {
            success(self,responseObject);
            if([responseObject[@"ret"] integerValue] == 306)
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:OverDateToken object:nil];
            }
        }
    }]resume];
}
//ret != 200时  也需要返回的ret的情况
- (void)POSTWithAllReturn:(NSString *)URLString
               parameters:(NSMutableDictionary*)parameters
                  success:(void (^)(SSRequest *request, id response))success
                  failure:(void (^)(SSRequest *request, NSString *errorMsg))failure{
    
    if([USER_MANAGER serverAddress].length == 0)
    {
        [[SSRequest request]postNormalUrlSuccess:^(SSRequest * request, id response) {
            [self BasePostWithURL:URLString parameters:parameters success:^(SSRequest *request, id response) {
                if(success)
                {
                    success(request,response);
                }
            } failure:^(SSRequest *request, NSError * error) {
                if(failure)
                {
                    failure(request,error.localizedDescription);
                }
            }];
        } failure:^(SSRequest * request, NSError * error) {
            if(failure)
            {
                failure(request,error!=nil?error.localizedDescription:@"网络错误请重试");
            }
        }];
    }else{
        self.operationQueue = self.sessionManager.operationQueue;
        AFJSONResponseSerializer *JsonSerializer = [AFJSONResponseSerializer serializer];
        JsonSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        JsonSerializer.removesKeysWithNullValues=YES;
        self.sessionManager.responseSerializer = JsonSerializer;
        
        NSDictionary * signDic = [self getPublicDic:parameters];
        //获取AES加密数据
        NSString * key = [[signDic objectForKey:Sign] substringWithRange:NSMakeRange(0, 16)];
        NSData * dataStr = [self sortDic:parameters withAesKey:key];
        //重新组合的字典
        parameters = [self getPublicDic:parameters].mutableCopy;
        //重组 request
//        SSLog(@"%@%@",URLString,parameters);
        self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
        request.timeoutInterval= 15.f;
        [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [request setValue:obj forHTTPHeaderField:key];
        }];
        [request setHTTPBody: dataStr];
//        SSLog(@"%@",dataStr);
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        //底层请求
        [[self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//            SSLog(@"%@",responseObject);
            if(error!=nil)
            {
                failure(self,error.localizedDescription);
            }else
            {
                success(self,responseObject);
                if([responseObject[@"ret"] integerValue] == 306)
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:OverDateToken object:nil];
                }
            }
        }]resume];
    }
}


- (void)POSTNoToken:(NSString *)URLString
         parameters:(NSDictionary *)parameters
            success:(void (^)(SSRequest *request, id response))success
            failure:(void (^)(SSRequest *request, NSError *error))failure{
    
    self.operationQueue = self.sessionManager.operationQueue;
    self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.sessionManager.requestSerializer.timeoutInterval = 10;
    
    AFJSONResponseSerializer *JsonSerializer = [AFJSONResponseSerializer serializer];
    JsonSerializer.removesKeysWithNullValues=YES;
    self.sessionManager.responseSerializer = JsonSerializer;
    //打印
    NSMutableString * urlString=[[NSMutableString alloc]initWithString:URLString];
    for(NSString * keys in parameters) {
        [urlString appendFormat:@"&%@=%@",keys,[parameters objectForKey:keys]];
    }
    [self.sessionManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //        SSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"errCode"] integerValue] == 403) {
            //token过期，重新登录
            //            [USER_MANAGER removeUserAllData];
            [[NSNotificationCenter defaultCenter]postNotificationName:OverDateToken object:nil];
        }
        success(self,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        SSLog(@"[SSRequest]: %@",error.localizedDescription);
        failure(self,error);
        
    }];
}

- (void)getWithURL:(NSString *)URLString {
    
    [self GET:URLString parameters:nil success:^(SSRequest *request, NSDictionary *response) {
        if ([self.delegate respondsToSelector:@selector(SSRequest:finished:)]) {
            [self.delegate SSRequest:request finished:response];
        }
    } failure:^(SSRequest *request, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(SSRequest:Error:)]) {
            [self.delegate SSRequest:request Error:error.description];
        }
    }];
}

- (void)cancelAllOperations{
    [self.operationQueue cancelAllOperations];
}

+(void)SSNetType:(NetType)netType URLString:(NSString *)URLString parameters:(NSDictionary *)parameters animationHud:(BOOL)isAnimation animationView:(UIView *)view MJRefreshScroll:(UIScrollView *)scroll refreshType:(SSRefreshType)refreshType success:(void (^)(BaseModel *, BOOL))success failure:(void (^)(NSString *))failure
{
    if(isAnimation)
    {
        SSGifShow(view, @"加载中...");
    }
    if(netType == GET)
    {
        [[SSRequest request] GET:URLString parameters:parameters success:^(SSRequest *request, NSDictionary *response) {
            if(isAnimation)
            {
                SSDissMissMBHud(view, YES);
            }
            if(scroll)
            {
                [[SSRequest request] MJRefreshStop:scroll refreshType:refreshType];
            }
            BaseModel * model = [BaseModel mj_objectWithKeyValues:response];
            if(success)
            {
                success(model,model.succeed);
            }
        } failure:^(SSRequest *request, NSError *error)
         {
             if(isAnimation)
             {
                 SSDissMissMBHud(view, YES);
             }
             if(scroll)
             {
                 [[SSRequest request] MJRefreshStop:scroll refreshType:refreshType];
             }
             if(failure)
             {
                 failure(error.localizedDescription);
             }
         }];
    }
    else
    {
        [[SSRequest request] POST:URLString parameters:[parameters mutableCopy] success:^(SSRequest *request, id response) {
            
            if(isAnimation)
            {
                SSDissMissMBHud(view, YES);
            }
            if(scroll)
            {
                [[SSRequest request] MJRefreshStop:scroll refreshType:refreshType];
            }
            BaseModel * model = [BaseModel mj_objectWithKeyValues:response];
            if(success)
            {
                success(model,model.succeed);
            }
            
        } failure:^(SSRequest *request, NSString *errorMsg) {
            
            if(isAnimation)
            {
                SSDissMissMBHud(view, YES);
            }
            if(scroll)
            {
                [[SSRequest request] MJRefreshStop:scroll refreshType:refreshType];
            }
            if(failure)
            {
                failure(errorMsg);
            }
            
        }];
        
    }
}
-(void)MJRefreshStop:(UIScrollView*)scroll refreshType:(SSRefreshType)type
{
    if(type == SSHeaderRefreshType)
    {
        [scroll.mj_header endRefreshing];
    }else if (type == SSFooterRefreshType)
    {
        [scroll.mj_footer endRefreshing];
    }else
    {
        [scroll.mj_header endRefreshing];
        [scroll.mj_footer endRefreshing];
    }
}

-(void)postNormalUrlSuccess:(void (^)(SSRequest *, id))success failure:(void (^)(SSRequest *, NSError *))failure
{
    self.operationQueue = self.sessionManager.operationQueue;
    
    AFJSONResponseSerializer *JsonSerializer = [AFJSONResponseSerializer serializer];
    JsonSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    JsonSerializer.removesKeysWithNullValues=YES;
    self.sessionManager.responseSerializer = JsonSerializer;
    NSDictionary * parameters = @{};
    NSString * URLString = KURLSTR(@"https://wx.yejingying.com/api/", @"version/check");
    NSDictionary * signDic = [self getPublicDic:parameters];
    //获取AES加密数据
    NSString * key = [[signDic objectForKey:Sign] substringWithRange:NSMakeRange(0, 16)];
    NSData * dataStr = [self sortDic:parameters withAesKey:key];
    //重新组合的字典
    parameters = [self getPublicDic:parameters].mutableCopy;
    self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    request.timeoutInterval= 15.f;
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    [request setHTTPBody: dataStr];
//    SSLog(@"%@",dataStr);
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //底层请求
    [[self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"%@",responseObject);
        if(error!=nil)
        {
            failure(self,error);
        }else{
            NSDictionary * dic = responseObject;
            if([dic[@"ret"] integerValue] == completionCode)
            {
                
                CheckVersionModel * model = [CheckVersionModel mj_objectWithKeyValues:dic[@"data"]];
                if((model.content.length == 0)|(!model.content)){
                model.content = @"该APP有新的版本，是否需要更新？" ;
                }
                if(model.deploy == 1)
                {
                    [USERDEFAULTS setObject:CE_Test_URL forKey:PublishURLKey];
                    [USERDEFAULTS setObject:model.downloadurl forKey:DownAppUrl];
                    [USERDEFAULTS setObject:model.content forKey:DownLoadContent];
                    [USERDEFAULTS synchronize];
                }else if (model.deploy == 2)
                {
                    [USERDEFAULTS setObject:CE_Normal_URL forKey:PublishURLKey];
                    [USERDEFAULTS setObject:model.downloadurl forKey:DownAppUrl];
                     [USERDEFAULTS setObject:model.content forKey:DownLoadContent];
                    [USERDEFAULTS synchronize];
                    
                }
                if(model.uri.length>0)
                {
                    [USERDEFAULTS setObject:model.uri forKey:PublishURLKey];
                    [USERDEFAULTS synchronize];
                }
               
                switch (model.upgrade) {
                    case 0:
                        break;
                    case 1:
                    {
                    
                    }break;
                    case 2:
                    {
                       
                        
                    }break;
                    default:
                        break;
                }
                if(success)
                {
                    success(self,responseObject);
                }
                
            }else
            {
                failure(self,nil);
                
            }
        }
    }]resume];
    
}

@end
@implementation BaseModel


@end
@implementation CheckVersionModel


@end

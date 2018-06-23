//
//  UserManager.m
//  NewTarget
//
//  Created by Mr.差不多 on 16/4/19.
//  Copyright © 2016年  rw. All rights reserved.
//

#import "UserManager.h"
#import "Config.h"
#import "AFNetworkReachabilityManager.h"
#import "AppInterface.h"
#import "SSRequest.h"
#import <AFNetworking/AFNetworking.h>
#define iswifi @"wifi"
#define PWD @"paycode"
#define USER_DATA @"userData"
#define AccID @"accid"
#define AccToken @"accessToken"
#define NormalUserId @"userId"
@interface UserManager()
//开始时间
@property (nonatomic,strong) NSDate * startDateStr;
//刷新的时间timer
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,strong) NSDate * timerStartDate;
//统计下拉加载次数
@property (nonatomic,assign) NSInteger refreshTimes;

@property (nonatomic,copy)  void(^comple)();

@end
@implementation UserManager
+(id)shareManager
{
    static UserManager * manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    return manager;

}
- (instancetype)init
{
    if (self = [super init])
    {
        _isLogin = NO;
    }
    return self;
}
/**
 * 判断是否登录
 */
-(BOOL)isLogin
{
   NSString * token = [USER_MANAGER userToken];
    
  if(token.length>0)
  {
      return YES;
  }else
  {
      return NO;
  }

}
/**
 *  保存数据
 */
- (void)saveUserDataWithDic:(NSDictionary *)dic
{
    [USERDEFAULTS setObject:dic forKey:USER_DATA];
    [USERDEFAULTS setObject:dic[@"token"] forKey:@"token"];
    [USERDEFAULTS setObject:dic[@"account"] forKey:@"account"];

    NSDictionary *yunxinDic = dic[@"yunxin"];
    [USERDEFAULTS setObject:yunxinDic[@"accessToken"] forKey:@"accessToken"];
    [USERDEFAULTS setObject:yunxinDic[@"accid"] forKey:AccID];

    NSString * userID = yunxinDic[@"accid"];
    NSRange range = [userID rangeOfString:@"-"];
    userID = [userID substringWithRange:NSMakeRange(range.location+1, userID.length - range.location-1)];
    [USERDEFAULTS setObject:userID forKey:NormalUserId];
    
    if([dic objectForKey:PWD])
    {
        [USERDEFAULTS setBool:[dic[PWD] boolValue] forKey:PWD];
    }
    if(dic[MOBILE]!=[NSNull null]){
        [USERDEFAULTS setObject:dic[@"mobile"] forKey:@"mobile"];
    }
    
    if(dic[Birth] != [NSNull null]){
        [USERDEFAULTS setObject:dic[Birth] forKey:[Birth copy]];
    }
    
    [USERDEFAULTS setObject:dic[@"nickName"] forKey:@"nickName"];
    [USERDEFAULTS synchronize];

}
-(NSString *)yunxinAccidOrAccount:(BOOL)isAccid
{
    NSString * str = @"";
  if(isAccid)
  {
      str = [USERDEFAULTS objectForKey:AccID]?[USERDEFAULTS objectForKey:AccID]:@"";
  }else
  {
    str = [USERDEFAULTS objectForKey:AccToken]?[USERDEFAULTS objectForKey:AccToken]:@"";
  }
    return str;
}
/**
 *清空数据
 */
- (void)removeUserAllData
{

    [USERDEFAULTS removeObjectForKey:USER_DATA];
    [USERDEFAULTS removeObjectForKey:AccID];
    [USERDEFAULTS removeObjectForKey:NormalUserId];
    [USERDEFAULTS removeObjectForKey:AccToken];
    [USERDEFAULTS removeObjectForKey:@"token"];
    [USERDEFAULTS removeObjectForKey:@"account"];
    [USERDEFAULTS removeObjectForKey:@"mobile"];
    [USERDEFAULTS removeObjectForKey:PWD];
    [USERDEFAULTS removeObjectForKey:@"nickName"];
    [USERDEFAULTS synchronize];
}
/**
 * token
 **/
-(NSString *)userToken
{
    NSString * str = [USERDEFAULTS objectForKey:@"token"];
    return str?str:@"";
}
/**
 * 头像url
 */
-(NSString *)avatarUrl
{
    NSString * str = [USERDEFAULTS objectForKey:[Avatar copy]];
    return str?str:@"";
}
/**
 *  缓存的名字
 */
-(NSString *)CEUserName
{
  NSString * str = [USERDEFAULTS objectForKey:@"nickName"];
    return str?[NSString stringWithFormat:@"%@",[USERDEFAULTS objectForKey:@"nickName"]]:@"";
}
/**
 * 用户性别(BOOL值)
 */
-(BOOL)isMan
{
    NSInteger sex = [[USERDEFAULTS objectForKey:[Sex copy]] integerValue];
    NSLog(@"性别:%ld",(long)sex);
    if(sex ==1) {
        return YES;
    }else if(sex == 2) {
        return NO;
    }else {
        return YES;
    }
}
/**
 * 用户手机
 */
-(NSString*)mobile
{
    NSString * mobile = [USERDEFAULTS objectForKey:@"mobile"]?[USERDEFAULTS objectForKey:@"mobile"]:@"";
    return mobile;
}
/**
 * 用户uid
 */
-(NSString*)UUIDStr
{

    NSString * uuid = [USERDEFAULTS objectForKey:NormalUserId];
    
    if(uuid == nil)
    {
        return @"";
    }
    return uuid;

}
/**
 * 用户生日
 */
-(NSString*)birth_date{
    NSString * str;
    if([USERDEFAULTS objectForKey:[Birth copy]]!=[NSNull null])
    {
        str = [USERDEFAULTS objectForKey:[Birth copy]];
    }else
    {
        str = @"";
    }

    return str;
    
}
/** 是男是女 */
-(BOOL)isGirl
{
  NSString * number = [USERDEFAULTS objectForKey:[Sex copy]];
    
  if([number isEqualToString:@"1"])
  {
      return NO;
  }else if ([number isEqualToString:@"2"])
  {
      return YES;
  }else
  {
      return NO;
  }

}
/**
 * 保存wifi开关
 */
-(void)saveWifiSelect:(BOOL)isSelect
{
    [USERDEFAULTS setBool:isSelect forKey:iswifi];
    [USERDEFAULTS synchronize];
}
/**
 * 取wifi开关
 */
-(BOOL)wifiSelect
{
    return [USERDEFAULTS boolForKey:iswifi]?[USERDEFAULTS boolForKey:iswifi]:NO;
}

-(void)saveMobileWith:(NSString *)str
{
    [USERDEFAULTS setObject:str forKey:[MOBILE copy]];
    [USERDEFAULTS synchronize];
}
/**
 * 通过键获取值
 **/
-(id)dataStrForKey:(NSString*)key
{
    id data = [USERDEFAULTS objectForKey:USER_DATA];
    if(data!=nil){
    id  str=  [data isKindOfClass:[NSDictionary class]]?data[key]:@"";
    return str?str:@"";
    }else
        return @"";
    
}
/**
 * 修改头像
 **/
-(void)reloadAvatar:(NSString *)imgUrl
{
    [USERDEFAULTS setObject:imgUrl forKey:[Avatar copy]];
    [USERDEFAULTS synchronize];
}
/**
 * 修改昵称
 **/
-(void)reloadNickName:(NSString *)name
{
    [USERDEFAULTS setObject:name forKey:@"nickName"];
    [USERDEFAULTS synchronize];
}

#pragma mark--刷新次数
-(void)addTimeForRefresh:(void (^)(void))complete
{
    //是否为空
    if(!self.startDateStr)
    {
        self.startDateStr  = [NSDate date];
        self.refreshTimes = 1;
    }else
    {
        //不为空再查询时间间隔
        if([self resolveTimeBefore:60 timeRefresh:NO])
        {
            self.refreshTimes++;
            if(self.refreshTimes == 2)
            {
                complete();
                self.refreshTimes = 0;
                self.startDateStr = nil;
            }
        }else
        {
            //大于时间间隔就重置
            self.startDateStr = [NSDate date];
            self.refreshTimes = 1;
        }
    }
}
-(void)reloadTimeFresh
{
    self.startDateStr = nil;
    self.refreshTimes  = 0;
}
//是否在60秒以内操作
-(BOOL)resolveTimeBefore:(NSInteger)time timeRefresh:(BOOL)isTimer
{
    //返回以1970/01/01 GMT为基准，然后过了secs秒的时间
    NSDate * date  = isTimer?self.timerStartDate:self.startDateStr;
    NSTimeInterval late=[date timeIntervalSince1970]*1;
    //返回以当前时间为基准，然后过了secs秒的时间
    NSDate* dat = [NSDate date];
    //获取到了当前时刻距离GMT基准的总秒数
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    //    NSString *timeString=@"";
    //得到时间差
    NSTimeInterval cha= now - late;
    //设置60秒间隔次数有效
    NSInteger index = round(cha);
    if(isTimer)
    {
    return index>=time?YES:NO;
    }
    return index<time?YES:NO;
}
#pragma mark--定时器
-(void)startTimerForRefresh:(void (^)(void))complete
{
    self.comple = complete;
    self.timerStartDate = [NSDate date];
    self.timer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}
-(void)timerRun{
    //不为空再查询时间间隔
    if([self resolveTimeBefore:1800 timeRefresh:YES])
    {
        if(self.comple)
        {
            self.comple();
        }
        self.timerStartDate = [NSDate date];
    }
}
-(void)removeTimer
{
    
    if(_timer)
    {
        self.timerStartDate = nil;
        self.comple =nil;
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(NSString*)serverAddress
{
    NSString * server = [USERDEFAULTS objectForKey:PublishURLKey];
    if((!server)|(server.length == 0))
    {
        server = @"";
    }else
    {
        server = [server stringByAppendingString:@"/"];
    }
    return server;
}



-(BOOL)isPrdServer
{
    //[[USER_MANAGER serverAddress] isEqualToString:CE_Normal_URL]
    return YES;
}
@end

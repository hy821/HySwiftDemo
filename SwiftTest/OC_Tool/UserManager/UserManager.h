//
//  UserManager.h
//  NewTarget
//
//  Created by Mr.差不多 on 16/4/19.
//  Copyright © 2016年  rw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UserManager : NSObject
/**
 *实例化用户管理器对象
 */
+(id)shareManager;
/**
 *  保存数据
 */
- (void)saveUserDataWithDic:(NSDictionary *)dic;
/**
 保存绑定手机
 */
-(void)saveMobileWith:(NSString*)str;
/**
 * 修改头像
 **/
-(void)reloadAvatar:(NSString *)imgUrl;
/**
 * 修改昵称
 **/
-(void)reloadNickName:(NSString *)name;
/**
 *清空数据
 */
- (void)removeUserAllData;
/**
 *  是否登录
 */
@property (nonatomic,assign) BOOL isLogin;
/**
 * 头像url
 */
-(NSString *)avatarUrl;
/**
 *  缓存的名字
 */
-(NSString *)CEUserName;
/**
 * 用户性别(BOOL值)男为YES女为NO
 */
-(BOOL)isMan;
/**
 * 用户手机
 */
-(NSString*)mobile;
/**
 * 用户uid
 */
-(NSString*)UUIDStr;
/**
 * 用户生日
 */
-(NSString*)birth_date;
/**
 * token
 **/
-(NSString *)userToken;
/**
 * 通过键获取值
 **/
-(id)dataStrForKey:(NSString*)key;
/**
 * 去主页
 **/
-(void)gotoHome:(NSString*)uid;

-(NSString *)yunxinAccidOrAccount:(BOOL)isAccid;
-(void)showGifAnimation;
//超过三次刷新操作
-(void)addTimeForRefresh:(void(^)(void))complete;
//开启时间定时器
-(void)startTimerForRefresh:(void(^)(void))complete;
//销毁时间定时器
-(void)removeTimer;
-(void)reloadTimeFresh;
//服务器地址
-(NSString*)serverAddress;
//是否是正式服
-(BOOL)isPrdServer;

@end

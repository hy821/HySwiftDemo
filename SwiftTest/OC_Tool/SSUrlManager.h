//
//  SSUrlManager.h
//  SmallStuff
//
//  Created by Hy on 2017/3/29.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#ifndef SSUrlManager_h
#define SSUrlManager_h

#ifdef DEBUG

/** 测试服务器地址  */
#define ServerAddress                   @"https://webapitst.yejingying.com/api/"

/** -----------------测试服: H5_Url------------------  */
#define UserProtocol_H5_Url @"https://ylmtst.yejingying.com/agreements.html"
#define ShopIn_H5_Url   @"https://ylmtst.yejingying.com/recruit_shops.html"
#define QA_H5_Url           @"https://ylmtst.yejingying.com/faq.html"
#define ExpenseAwardH5_Url      @"https://ylmtst.yejingying.com/incentives.html"
#define HowToFindCardName_H5  @"https://ylmtst.yejingying.com/find_openbank.html"
#define RedPacketDynamic_H5 @"https://ylmtst.yejingying.com/redpacketdate_realtime.html"
#else

  
/** 正式服务器地址 */
#define ServerAddress                                  @"https://webapitst.yejingying.com/api/"          // @"https://wx.yejingying.com/api/"

/** -----------------正式服: H5_Url------------------  */
#define UserProtocol_H5_Url @"https://ylmtst.yejingying.com/agreements.html";
#define ShopIn_H5_Url   @"https://ylmtst.yejingying.com/recruit_shops.html"
#define QA_H5_Url           @"https://ylmtst.yejingying.com/faq.html"
#define ExpenseAwardH5_Url      @"https://ylmtst.yejingying.com/incentives.html"
#define HowToFindCardName_H5  @"https://ylmtst.yejingying.com/find_openbank.html"
#define RedPacketDynamic_H5 @"https://ylmtst.yejingying.com/redpacketdate_realtime.html"
#endif
//图片上传url拼接前缀
#define NormalImage_PrefixAddress @"https://ylm.yejingying.com/asset/"
#define TestImage_PrefixAddress  @"https://ylmtst.yejingying.com/asset/"

#define UserProtocol_H5_Url_PRD @"https://ylm.yejingying.com/agreements.html"
#define ShopIn_H5_Url_PRD   @"https://ylm.yejingying.com/recruit_shops.html"
#define QA_H5_Url_PRD          @"https://ylm.yejingying.com/faq.html"
#define ExpenseAwardH5_Url_PRD     @"https://ylm.yejingying.com/incentives.html"
#define HowToFindCardName_H5_PRD  @"https://ylm.yejingying.com/find_openbank.html"
#define RedPacketDynamic_H5_PRD @"https://ylm.yejingying.com/redpacketdate_realtime.html"


/** 官网地址  */
#define WebHome_Url  @"https://ylm.yejingying.com/home.html"

/** 测试服务器地址  http://test.qqxsapp.com/QQXS/api/ */
#define CE_Test_URL                   @"https://webapitst.yejingying.com/api/"

/** 正式服务器地址 */
#define CE_Normal_URL                   @"https://wx.yejingying.com/api/"

/** -----------------------接口Url------------------------------  */
//短信发送
#define SMS_Send                         @"sms/send"
//手机号登录
#define PhoneLogin                      @"auth/login"
//微信登录
#define WXLogin                            @"auth/wxLogin"
//商家滑动列表
#define Home_Scroll_Page          @"shop/slidList"
//商家分类列表
#define Home_Category_Page         @"shop/cateList"
//热门搜索
#define Hot_Search                           @"search/hotword"
//商家详情
#define  ShopMsg_Detail                         @"shop/detail"
//商家详情页 订单列表
#define Shop_GoodsList                         @"Order/productList"
//获取群聊的URL
#define  TeamChat_URL                  @"web/chatUrl"
//现金明细
#define  CashList_URL                  @"user/cashLog"
//个人中心数据
#define User_Center                       @"user/center"
//商家详情页 生成订单 前去支付 接口
#define CreatOrderToPay_URL                       @"Order/toPayFor"
//商家商品 选择 余额 立即支付 接口
#define PayByBalance_URL            @"Order/balanceToPay"
//上传图片
#define  UploadImg_URL                                             @"user/uploadImg"
//删除图片
#define  DeleteImg_URL                                             @"user/delImg"
//用户资料详情
#define  UserMsg_URL                                             @"user/myinfo"

//我的订单 -> 待付款 商品列表
#define MyOrder_ForPayOrder_URL                          @"Order/waitForPayList"
//我的订单 -> 待付款 -> 取消订单
#define MyOrder_CancelForPayOrder_URL                          @"Order/cancelForOrder"
//我的订单 -> 待使用
#define MyOrder_WaitForUser @"Order/waitForUseList"
//修改用户资料
#define ModifyUserMsg_Url       @"user/updateInfo"
//查看其他用户资料
#define GetOtherUserMsg_Url        @"user/viewinfo"

//退款
#define RefundForOrder @"Order/refundForOrder"
//立即出品
#define AtOnceToUse @"Order/atOnceToUse"

//最近访客列表
#define  VisiterList_Url                    @"user/visitList"
//附近的人列表
#define  NearbyPeopleList_Url      @"user/nearbyList"

//已退款
#define GetRefundedList @"Order/refundedList"
//已完成
#define IsGoneOrderList @"Order/usedOrderList"

//用户银行卡列表
#define UserBandList_Url        @"user/bankList"
//添加银行卡
#define  AddUserBand_Url    @"user/addBank"
//解绑/删除银行卡
#define   DeleteBand_Url    @"user/delBank"

//用户提现
#define  UserWithdraw_Url    @"user/withdraw"


//消费奖励列表
#define RewardList @"Reward/rewardList"

//获取云信账号
#define GetIMAccount  @"user/yunxin"

//顶部 滚动 消费奖励列表
#define TopRewardList_Url     @"Reward/topRewardList"
//领取奖励
#define ReceiveReward_Url        @"Reward/receiveReward"

//购买商品 -> 微信支付
#define WxPayGoods_Url             @"Wxpay/productWxPay"

//余额支付单聊红包
#define YLMMoney_Pay_RedPackets @"redpacket/addSingle"

//红包领取
#define Get_RedPacket @"redpacket/receiveSingle"

//单聊红包记录
#define RedPacketRecord  @"redpacket/recordSingle"

//上传用户坐标
#define uploadUserLocationMess  @"user/setCoord"

//我的余额
#define MyBalance_Url     @"user/balance"

//余额直接买单
#define DirectPayByBalance_Url  @"Order/balanceToDirectPay"

//微信直接买单
#define DirectPayByWx_Url  @"Wxpay/productDirectWxPay"

//群在线成员
#define TeamOnlineUsers  @"user/onlineList"

//发群聊红包
#define SendTeamredPacket  @"redpacket/addGroup"

//检查群聊红包状态
#define CheckTeamRedPacketState @"redpacket/groupStatus"

//群聊红包领取
#define GetTeamRedPacket @"redpacket/receiveGroup"

//群聊红包记录
#define TeamRedPacketDetail @"redpacket/recordGroup"
#endif /* SSUrlManager_h */

//发帖
#define SendDynamic_Url      @"Show/addMyShow"

//猫圈动态列表
#define CatCirlce_Dynamic_List @"Show/showList"
//动态详情 动态内容
#define DynamicDetail_Url      @"Show/showDetail"
//动态详情 评论内容
#define DynamicComment_Url      @"Show/commentList"

//检查是否设置验证码
#define CheckBalancePWD   @"paycode/auth"

//设置支付密码
#define SetPayPWD  @"paycode/add"
//重置支付密码
#define ResetPayPWD @"paycode/modify"
//发表一级评论
#define Dynamic_Comment_one @"Show/commentToShow"
//发表二级评论or回复评论
#define Dynamic_Comment_sub @"Show/commentOrReply"
//点赞接口
#define Dynamic_star  @"Show/likeToShow"
//评论的赞
#define Dynamic_subComStar   @"Show/likeToComment"
//获取顶部消息接口
#define GetDynamic_TopMessage @"Show/getNewMessage"
//举报动态接口
#define ReportDynamic @"Show/reportToShow"
//点赞列表
#define Dynamic_Star_List @"Show/likeList"
//我的和他人动态列表
#define MineOrOther_Dynamic_List @"Show/meOrHerShowList"
//删除动态
#define DeleteDynamic @"Show/showToDel"
//回复我的 数据
#define ReplyDynamicList_Url @"Show/replyMeList"
//回复我的->删除 操作接口
#define DeleteReplyList_Url @"Show/replyMeToDel"

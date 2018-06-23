//
//  NSString+AES.h
//  CatEntertainment
//
//  Created by Hy on 2017/11/10.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AES)
-(NSString *) aes256_encrypt:(NSString *)key; //加密;
-(NSString *) aes256_decrypt:(NSString *)key;//解密

+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key;
+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key;
@end

//
//  NSData+AES.h
//  CatEntertainment
//
//  Created by Hy on 2017/11/10.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSData (AES)
- (NSData *)Aes256_encrypt:(NSString *)key;   //加密;
- (NSData *)Aes256_decrypt:(NSString *)key;   //解密
//加密
- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;
//解密
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;
@end

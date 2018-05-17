//
//  AMCommon.h
//  AnyMeetUIKit
//
//  Created by derek on 2018/4/28.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AMCommon : NSObject

// 将16进制颜色转换成UIColor
+(UIColor *)getColor:(NSString *)color;

//将若干view等宽布局于容器containerView中
+ (void)makeEqualWidthViews:(NSArray *)views inView:(UIView *)containerView LRpadding:(CGFloat)LRpadding viewPadding :(CGFloat)viewPadding;

//最上层视图
+ (UIViewController *)topViewController;

//隐藏界面上所有键盘
+ (void)hideKeyBoard;

//将字典转换为JSON对象
+ (NSString *)fromDicToJSONStr:(NSDictionary *)dic;

// 将字符串转换为字典
+ (id)fromJsonStr:(NSString*)jsonStrong;

//随机字符串
+ (NSString*)randomString:(int)len;

//获取当前时间戳
+ (NSString *)getTimestamp;
//间距
+ (NSDictionary *)setTextLineSpaceWithString:(NSString*)str withFont:(UIFont*)font withLineSpace:(CGFloat)lineSpace withTextlengthSpace:(NSNumber *)textlengthSpace paragraphSpacing:(CGFloat)paragraphSpacing;

@end


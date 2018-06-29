//
//  AMUserModel.h
//  AnyMeetUIKit
//
//  Created by derek on 2018/4/28.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMUserModel : NSObject
// 用户Id（自己平台的用户Id）
@property (nonatomic, strong) NSString *userId;
// 用户名称(自己平台的用户名称)
@property (nonatomic, strong) NSString *userName;
// 用户头像（自己平台的用户头像）
@property (nonatomic, strong) NSString *userHeadUrl;

@end

//
//  AnyBoardOption.h
//  AnyBoardEngine
//
//  Created by derek on 2018/2/6.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AnyBoardOption : NSObject

@property (nonatomic, strong) NSString *strDeveloperId;
@property (nonatomic, strong) NSString *strAppId;
@property (nonatomic, strong) NSString *strKey;
@property (nonatomic, strong) NSString *strToken;
//自己平台的用户Id,用于画笔标识（如果不填写，系统会默认给一个随机字符串）
@property (nonatomic, strong) NSString *userId;
//是否是主持人
@property (nonatomic, assign) BOOL isHost;
// 会议Id
@property (nonatomic, strong) NSString *strMeetingId;
//文档序列Id,文档在自己服务器中存储的Id,保持系统唯一
@property (nonatomic, strong) NSString *strFileId;

/**
 画板背景颜色（画图区域）
 */
@property (nonatomic, strong) UIColor *boardBgColor;

@end

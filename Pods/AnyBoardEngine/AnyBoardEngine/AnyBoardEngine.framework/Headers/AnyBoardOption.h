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

#pragma mark - 平台信息
@property (nonatomic, strong) NSString *strDeveloperId;
@property (nonatomic, strong) NSString *strAppId;
@property (nonatomic, strong) NSString *strKey;
@property (nonatomic, strong) NSString *strToken;

#pragma mark - 权限
//自己平台的用户Id,用于画笔标识（如果不填写，用户讲不能操作画板）
@property (nonatomic, strong) NSString *userId;
//是否是主持人(主持人可以清空画板，可以让学生跟着自己的页码显示)
@property (nonatomic, assign) BOOL isHost;

#pragma mark - 白板信息以及配置
// 会议Id
@property (nonatomic, strong) NSString *strMeetingId;
//文档序列Id,文档在自己服务器中存储的Id,保持系统唯一
@property (nonatomic, strong) NSString *strFileId;
//画板背景颜色（画图区域）
@property (nonatomic, strong) UIColor *boardBgColor;
//是否输出日志：默认YES
@property (nonatomic, assign) BOOL isOpenLog;

@end

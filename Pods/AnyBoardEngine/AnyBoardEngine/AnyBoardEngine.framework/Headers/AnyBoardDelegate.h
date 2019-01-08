//
//  AnyBoardDelegate.h
//  ARWriteBoard
//
//  Created by zjq on 2018/9/21.
//  Copyright © 2018年 zjq. All rights reserved.
//

#ifndef AnyBoardDelegate_h
#define AnyBoardDelegate_h


typedef NS_ENUM(NSInteger,BoardErrorCode) {
    InitBoardParameterEmpty = 3000,//初始化参数为空
    InitBoardNoNet = 3001,         //初始化无网络
    SessionPastDue = 201,         //session过期
    DeveloperInfoError = 202,     //开发者信息错误
    DeveloperArrearage = 203,      //欠费
    DeveloperDidNotOpenFunction = 206,    //用户未开通该功能
    DeveloperServerDatabaseError = 301 //数据库异常
};

typedef NS_ENUM(NSInteger, JQDrawingType) {
    JQDrawingTypeArrow = 0,     //单箭头
    JQDrawingTypeLine,          //直线
    JQDrawingTypeGraffiti,      //涂鸦
    JQDrawingTypeRect          //矩形
};


@protocol AnyBoardViewDelegate <NSObject>
//文档初始化成功
- (void)initBoardScuess;
//文档初始化失败
- (void)initBoardFaild:(int)nCode;
//服务断开链接（可能网络原因）
- (void)anyBoardServerDisconnect;
//背景更改
- (void)anyBoardBgChange:(int)currentPage withTotalPage:(int)totalPage withImageUrl:(NSString*)imageUrl;
//文档共享主持人翻到了那一页
- (void)anyBoardPageChange:(int)currentPage withTotalPage:(int)totalPage withImageUrl:(NSString*)imageUrl;
//自己翻页页码变化回调
- (void)anyBoardPageChangeByMe:(int)currentPage withTotalPage:(int)totalPage withImageUrl:(NSString*)imageUrl;
//文档是否可编辑变化
- (void)onBoardEditable:(BOOL)editable;
//操作文档出错 0:未登录；1:禁画
- (void)onBoardOperationFaile:(int)code;
//文档添加了一页
- (void)onBoardAddScuess;
//文档删除了一页
- (void)onBoardDeleteScuess;
//文档销毁了
- (void)onBoardDestoryScuess;
@end

#endif /* AnyBoardDelegate_h */

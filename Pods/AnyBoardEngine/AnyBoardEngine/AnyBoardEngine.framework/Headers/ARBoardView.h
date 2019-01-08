//
//  ARBoardView.h
//  ARWriteBoard
//
//  Created by zjq on 2018/9/18.
//  Copyright © 2018年 zjq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnyBoardOption.h"
#import "AnyBoardDelegate.h"

@interface ARBoardView : UIView
/**
 初始化
 
 @param frame 画板坐标
 @param option 配置项
 @param urlArray 图片地址数组
 @param delegate 代理
 @return 画板对象
 */
- (id)initWithFrame:(CGRect)frame withOption:(AnyBoardOption*)option withImageUrlArray:(NSArray*)urlArray withDelegate:(id<AnyBoardViewDelegate>)delegate;

//画笔类型：（默认:JQDrawingTypeGraffiti涂鸦）
@property (nonatomic, assign) JQDrawingType drawType;
//画笔颜色：（默认:#0000FF蓝色）
@property (nonatomic, strong) NSString *drawColor;
//画笔的粗细（默认是:2 ,该值必须大于０）
@property (nonatomic, assign) int lineWidth;
//获取当前画板是否可以编辑（如果是主持人，不是手动调用不可编辑，都是可编辑的）
@property (nonatomic, assign,readonly) BOOL boardEditable;
//获取别人的画板是否可编辑（主持人调用）
@property (nonatomic, assign,readonly) BOOL boardOtherEditable;

// 上一页（如果是主持人，其他人会同步翻页）
- (BOOL)lastPage;
// 下一页（如果是主持人，其他人会同步翻页）
- (BOOL)nextPage;
// 跳转到某一页（如果是主持人，其他人会同步翻页）
- (BOOL)goSpecifiedPage:(int)pageNum;
// 获取当前页
- (int)getCurrentPage;
// 设置画板别人是否可以编辑(主持人)，其他端会有相应的回调
- (BOOL)setOtherBoardCanEdit:(BOOL)canEdit;
// 设置自己的画板是否可以编辑
- (BOOL)setMyBoardCanEdit:(BOOL)canEdit;
//撤销当前页最后一笔
- (BOOL)removeLastStroke;
//清空当前白板所有画笔（主持人）
- (BOOL)clearBoard;
//更改当前画板图片
- (void)changeCurrentBackGroundImage:(NSString*)imageUrl;
//当前页前面插入一页
- (void)addBoardFont:(NSString*)imageUrl;
//当前页后面插入一页
- (void)addBoardBack:(NSString*)imageUrl;
//删除当前页
- (BOOL)deleteCurrentBoard;
//获取屏幕当前图片
- (UIImage*)getCurrentSnapShotImage;
//销毁画板（主持人），其他端会收到画板被摧毁的回调
- (void)destroyBoard;
//离开画板
- (void)leaveBoard;

@end

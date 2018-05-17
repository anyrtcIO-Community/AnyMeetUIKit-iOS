//
//  AMVideoView.h
//  AnyMeetUIKit
//
//  Created by jh on 2018/5/9.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMVideoView : UIView

@property (nonatomic, assign) CGSize videoSize;     // 视图的分辨率大小

@property (nonatomic, copy) NSString *strPeerId;    // 标识Id

@property (nonatomic, copy) NSString *strPubId;     //标识流id

@property (nonatomic, strong) UIView *localView;    //本地视图

+ (AMVideoView *)loadVideoWithpeerId:(NSString *)peerId pubId:(NSString *)pubId size:(CGSize)videoSize;

@end

//
//  AMFunctionView.h
//  anyRTCMeeting
//
//  Created by jh on 2018/5/31.
//  Copyright © 2018年 anyRTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMFunctionDelegate <NSObject>

- (void)functionEvent:(NSInteger)index;

@end

@interface AMFunctionView : UIView

@property (nonatomic, weak) id <AMFunctionDelegate> delegate;

@end

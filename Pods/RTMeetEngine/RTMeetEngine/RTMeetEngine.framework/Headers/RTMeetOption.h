//
//  RTMeetOption.h
//  RTMeetEngine
//
//  Created by derek on 2017/11/20.
//  Copyright © 2017年 EricTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTCCommon.h"

typedef NS_ENUM(NSInteger,AnyMeetingType) {
    AnyMeetingTypeNomal = 0, //一般模式：大家进入会议互相观看
    AnyMeetingTypeHoster = 1//主持模式：主持人进入，可以看到所有人，其他人员只看到主持人
};
@interface RTMeetOption : NSObject
/**
 使用默认配置生成一个 RTMeetOption 对象
 
 @return 生成的 RTMeetOption 对象
 */
+ (nonnull RTMeetOption *)defaultOption;


/**
 是否是前置摄像头
 说明：默认前置摄像头
 */
@property (nonatomic, assign) BOOL isFont;

/**
 设置视频分辨率
 说明：默认为：RTCMeet_Videos_SD
 */
@property (nonatomic, assign) RTCMeetVideosMode videoMode;

/**
 视频方向：默认：RTC_SCRN_Portrait竖屏
 */
@property (nonatomic, assign) RTCScreenOrientation videoScreenOrientation;

/**
 设置显示模板。人数上限默认为4个，根据个人需要联系客服开通更多人会议。
 说明：默认：RTC_V_1X3
 　　　RTC_V_1X3为小型会议模式，视频窗口比例默认为３：４，根据设置videoMode而定；
 　　　RTC_V_3X3_auto为多人小型会议模式，窗口比例为１：１，该模式下分辨率为288*288
 */
@property (nonatomic, assign) RTCVideoLayout videoLayOut;

/**
 设置会议模式：默认为：AnyMeetingTypeNomal
 */
@property (nonatomic, assign) AnyMeetingType meetingType;

@end

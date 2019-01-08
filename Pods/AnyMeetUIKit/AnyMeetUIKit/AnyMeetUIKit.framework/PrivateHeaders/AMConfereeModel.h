//
//  AMConfereeModel.h
//  AnyMeetUIKit
//
//  Created by jh on 2018/5/7.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMConfereeModel : NSObject

@property (nonatomic ,copy)NSString *headUrl;

@property (nonatomic ,copy)NSString *nickName;

@property (nonatomic ,copy)NSString *userId;

@property (nonatomic, copy) NSString *peerId;

@property (nonatomic, assign) int video_state;

@property (nonatomic, assign) int audio_state;

@end

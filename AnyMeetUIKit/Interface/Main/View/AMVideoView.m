//
//  AMVideoView.m
//  AnyMeetUIKit
//
//  Created by jh on 2018/5/9.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "AMVideoView.h"

@implementation AMVideoView

- (instancetype)init{
    if (self = [super init]) {
        self.localView = [[UIView alloc]init];
        [self addSubview:self.localView];
    }
    return self;
}

+ (AMVideoView *)loadVideoWithpeerId:(NSString *)peerId pubId:(NSString *)pubId size:(CGSize)videoSize{
    AMVideoView *video = [[AMVideoView alloc]init];
    video.strPeerId = peerId;
    video.strPubId = pubId;
    video.videoSize = videoSize;
    return video;
}

@end

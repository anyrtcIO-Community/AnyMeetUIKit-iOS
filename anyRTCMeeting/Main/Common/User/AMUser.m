//
//  AMUser.m
//  anyRTCMeeting
//
//  Created by jh on 2018/5/31.
//  Copyright © 2018年 anyRTC. All rights reserved.
//

#import "AMUser.h"

@implementation AMUser

// MARK: - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self mj_encode:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
}

@end

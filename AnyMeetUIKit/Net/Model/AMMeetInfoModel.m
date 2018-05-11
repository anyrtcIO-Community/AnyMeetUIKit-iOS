//
//  AMMeetInfoModel.m
//  AnyMeetUIKit
//
//  Created by derek on 2018/5/9.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "AMMeetInfoModel.h"

@implementation Meetinginfo

@end
@implementation Memberlist

@end

@implementation AMMeetInfoModel
+ (NSDictionary *)objectClassInArray{
    return @{@"meetinginfo" : [Meetinginfo class],@"memberlist" :[Memberlist class]};
}
@end

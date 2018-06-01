//
//  AMMeetListModel.m
//  AnyMeetUIKit
//
//  Created by derek on 2018/5/9.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "AMMeetListModel.h"

@implementation MeetingInfo

@end

@implementation AMMeetListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"meetinglist" : [MeetingInfo class]};
}

@end

@implementation Memberlist

@end

@implementation AMMeetInfoModel

+ (NSDictionary *)objectClassInArray{
    return @{@"meetinginfo" : [MeetingInfo class],@"memberlist" :[Memberlist class]};
}
@end

//
//  AMLog.m
//  AnyMeetUIKit
//
//  Created by derek on 2018/5/11.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "AMLog.h"
extern BOOL *getDebugLog();
@implementation AMLog

+ (void)log:(NSString *)log,... {
    if (getDebugLog()) {
        NSLog(@"%@", log);
    }
}
@end

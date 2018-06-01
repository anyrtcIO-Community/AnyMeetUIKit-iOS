//
//  AnyMeetVideoController.h
//  AnyMeetUIKit
//
//  Created by derek on 2018/4/27.
//  Copyright © 2018年 derek. All rights reserved.
//


#import "AMVideoController.h"
#import <UIKit/UIKit.h>

//待上传图片
typedef void(^GotoUploadPicsBlock)(NSArray *picArray);

@interface AnyMeetVideoController : AMVideoController

@property (nonatomic, strong) MeetingInfo *meetModel;

@property (nonatomic, strong) AMUserModel *userModel;

@property (nonatomic, copy) GotoUploadPicsBlock uploadBlock;

- (void)gotoShearPics:(NSArray*)picArray withFileId:(NSString*)fileId;

@end

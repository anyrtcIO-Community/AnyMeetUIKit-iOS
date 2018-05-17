//
//  AMDocBlockView.h
//  AnyMeetUIKit
//
//  Created by derek on 2018/4/28.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AMDocItem:NSObject

@property (nonatomic, strong) NSString *fildId;
@property (nonatomic, strong) NSString *meetingId;
@property (nonatomic, strong) NSArray *urlArray;

@end


@interface AMDocBlockView : UIView

- (id)initWithDoc:(AMUserModel*)userModel withHost:(BOOL)docHost withDocItem:(AMDocItem*)docItem;

typedef void(^DocBlockFail)(NSString *errorStr);
@property (nonatomic, copy)DocBlockFail docBlockFial;

typedef void(^ToolShowBlock)(void);
@property (nonatomic, copy)ToolShowBlock toolShowBlock;

@end

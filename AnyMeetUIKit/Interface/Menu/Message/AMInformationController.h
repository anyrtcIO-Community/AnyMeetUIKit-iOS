//
//  AMInformationController.h
//  AnyMeetUIKit
//
//  Created by jh on 2018/5/2.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMInformationController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *infoArr;

@property (nonatomic, strong) RTMeetKit *meetKit;

@property (nonatomic, strong) AMUserModel *userModel;

@property (nonatomic, assign) BOOL isLandscape;

@end

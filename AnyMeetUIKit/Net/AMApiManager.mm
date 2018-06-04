//
//  AMApiManager.m
//  AnyMeetUIKit
//
//  Created by derek on 2018/5/11.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "AMApiManager.h"
#import "AMNetManager.h"
#import <MJExtension/MJExtension.h>

extern NSString *GetDevelopId();
extern NSString *GetAppId();
extern NSString *GetAppKey();
extern NSString *GetAppToken();
extern NSString *GetVerifyUrl();

@interface AMApiManager()

@end

@implementation AMApiManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        //配置
        [[AMNetManager shareInstance] configNetRequestParameter:GetDevelopId() withAppId:GetAppId() withAppKey:GetAppKey() withAppToken:GetAppToken() withVerifyUrl:GetVerifyUrl()];
    
    }
    return self;
}

static AMApiManager *manager = NULL;
+(AMApiManager*)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AMApiManager alloc] init];
    });
    return manager;
}
- (void)chuanzhi:(NSDictionary*)dict {
    NSDictionary *userInfo = [dict objectForKey:@"userinfo"];
    if (userInfo) {
        _userId = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"u_anyrtc_openid"]];
        _anyUserId = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"userid"]];
    }
}
- (void)registeredDockingMeeting:(AMUserModel*)userModel
                         success:(CompleteBlock)successBlock
                         failure:(FailBlock)failureBlock {

    __weak typeof(self)weakSelf = self;
    [[AMNetManager shareInstance] registeredDockingMeeting:userModel.userId withNickName:userModel.userName withHeadUrl:userModel.userHeadUrl success:^(NSDictionary *data) {
        if ([[data objectForKey:@"code"] intValue] == 200) {
            [weakSelf chuanzhi:data];
            if (successBlock) {
                successBlock(200);
            }
        }else{
            if (successBlock) {
                successBlock([[data objectForKey:@"code"] intValue]);
            }
        }
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}
//创建房间
- (void)createMeetingRoom:(NSString*)meetingName
             withMeetType:(AMMeetType)type
        withMeetStartTime:(NSString*)startTime
             withPassWord:(NSString*)passWord
            withLimitType:(AMMeetLimitType)limitType
    withDefaultPersonList:(NSArray*)personList
                  success:(CompleteBlock)successBlock
                  failure:(FailBlock)failureBlock {
    if (self.userId.length >0 && self.userId) {
        [[AMNetManager shareInstance] createMeetingRoom:self.userId withMeetName:meetingName withMeetType:type withMeetStartTime:startTime withPassWord:passWord withLimitType:limitType withDefaultPersonList:personList success:^(NSDictionary *data) {
            if ([[data objectForKey:@"code"] intValue]==200) {
                successBlock(200);
            }else{
                successBlock([[data objectForKey:@"code"] intValue]);
            }
        } failure:^(NSError *error) {
            failureBlock(error);
        }];
    }else{
        //用户不存在
        if (successBlock) {
            successBlock(AM_No_User_Error);
        }
    }
}

- (void)deleteMeetingRoom:(NSString*)meetingId
                  success:(CompleteBlock)successBlock
                  failure:(FailBlock)failureBlock {
    if (self.userId.length >0 && self.userId) {
        [[AMNetManager shareInstance] deleteMeetingRoom:self.userId withMeetingId:meetingId success:^(NSDictionary *data) {
            if ([[data objectForKey:@"code"] intValue]==200) {
                successBlock(200);
            }else{
                successBlock([[data objectForKey:@"code"] intValue]);
            }
        } failure:^(NSError *error) {
            failureBlock(error);
        }];
    }else{
        //用户不存在
        if (successBlock) {
            successBlock(AM_No_User_Error);
        }
    }
}
- (void)getMeetingInfo:(NSString*)meetingId
               success:(GetMeetInfoBlock)successBlock
               failure:(FailBlock)failureBlock {
    if (self.userId.length >0 && self.userId) {
        [[AMNetManager shareInstance] getMeetingInfo:self.userId withMeetingId:meetingId success:^(NSDictionary *data) {
            AMMeetInfoModel *model = [AMMeetInfoModel mj_objectWithKeyValues:data];
            successBlock(model,model.code);
        } failure:^(NSError *error) {
            failureBlock(error);
        }];
    }else{
        //用户不存在
        if (successBlock) {
            successBlock(NULL,AM_No_User_Error);
        }
    }
}
- (void)updateMeetingStartTime:(NSString*)meetingId
           withUpdateStartTime:(NSString*)startTime
                       success:(CompleteBlock)successBlock
                       failure:(FailBlock)failureBlock {
    
    if (self.userId.length >0 && self.userId) {
        [[AMNetManager shareInstance] updateMeetingStartTime:self.userId withMeetingId:meetingId withUpdateStartTime:startTime success:^(NSDictionary *data) {
            if ([[data objectForKey:@"code"] intValue]==200) {
                successBlock(200);
            }else{
                successBlock([[data objectForKey:@"code"] intValue]);
            }
        } failure:^(NSError *error) {
            failureBlock(error);
        }];
    }else{
        //用户不存在
        if (successBlock) {
            successBlock(AM_No_User_Error);
        }
    }
}
- (void)getUserMeetingListWithPageNum:(int)pageNum
                         withPageSize:(int)pageSize
                              success:(GetMeetListBlock)successBlock
                              failure:(FailBlock)failureBlock {
    if (self.userId.length >0 && self.userId) {
        [[AMNetManager shareInstance] getUserMeetingList:self.userId withPageNum:pageNum withPageSize:pageSize success:^(NSDictionary *data) {
            AMMeetListModel *model = [AMMeetListModel mj_objectWithKeyValues:data];
            successBlock(model,model.code);
        } failure:^(NSError *error) {
            failureBlock(error);
        }];
    }else{
        //用户不存在
        if (successBlock) {
            successBlock(NULL,AM_No_User_Error);
        }
    }
}
- (void)inviteMeetingMember:(NSString*)meetingId
       withInvitePersonList:(NSArray*)personList
                    success:(CompleteBlock)successBlock
                    failure:(FailBlock)failureBlock {
    if (self.userId.length >0 && self.userId) {
        [[AMNetManager shareInstance] inviteMeetingMember:self.userId withMeetingId:meetingId withInvitePersonList:personList success:^(NSDictionary *data) {
            if ([[data objectForKey:@"code"] intValue]==200) {
                successBlock(200);
            }else{
                successBlock([[data objectForKey:@"code"] intValue]);
            }
        } failure:^(NSError *error) {
            failureBlock(error);
        }];
    }else{
        //用户不存在
        if (successBlock) {
            successBlock(AM_No_User_Error);
        }
    }
}
- (void)deleteMeetingMember:(NSString*)meetingId
       withDeletePersonList:(NSArray*)personList
                    success:(CompleteBlock)successBlock
                    failure:(FailBlock)failureBlock {
    if (self.userId.length >0 && self.userId) {
        [[AMNetManager shareInstance] deleteMeetingMember:self.userId withMeetingId:meetingId withDeletePersonList:personList success:^(NSDictionary *data) {
            if ([[data objectForKey:@"code"] intValue]==200) {
                successBlock(200);
            }else{
                successBlock([[data objectForKey:@"code"] intValue]);
            }
        } failure:^(NSError *error) {
            failureBlock(error);
        }];
    }else{
        //用户不存在
        if (successBlock) {
            successBlock(AM_No_User_Error);
        }
    }
}
//获取邀请过的参会人员列表
- (void)getInviteMemberList:(NSString*)meetingId
                    success:(GetInviteMembersBlock)successBlock
                    failure:(FailBlock)failureBlock {
    if (self.userId.length >0 && self.userId) {
        [[AMNetManager shareInstance] getInviteMemberList:meetingId success:^(NSDictionary *data) {
            if ([[data objectForKey:@"code"] intValue]==200) {
                NSArray *array = [MeetingInfo mj_objectArrayWithKeyValuesArray:[data objectForKey:@"memberlist"]];
                successBlock(array,200);
            }else{
                successBlock(NULL,[[data objectForKey:@"code"] intValue]);
            }
        } failure:^(NSError *error) {
            failureBlock(error);
        }];
    }else{
        //用户不存在
        if (successBlock) {
            successBlock(NULL,AM_No_User_Error);
        }
    }
}

-(void)updateMeetingLock:(NSString*)meetingId
                withLock:(NSInteger)lock
                 success:(CompleteBlock)successBlock
                 failure:(FailBlock)failureBlock {
    if (self.userId.length >0 && self.userId) {
        [[AMNetManager shareInstance] updateMeetingLock:meetingId withLock:lock success:^(NSDictionary *data) {
            if ([[data objectForKey:@"code"] intValue]==200) {
                successBlock(200);
            }else{
                successBlock([[data objectForKey:@"code"] intValue]);
            }
        } failure:^(NSError *error) {
            failureBlock(error);
        }];
    }else{
        //用户不存在
        if (successBlock) {
            successBlock(AM_No_User_Error);
        }
    }
}
- (NSString *)getErrorInfoWithCode:(int)nCode {
    return [[AMNetManager shareInstance] getErrorInfoWithCode:nCode];
}
@end

//
//  AMApiManager.h
//  AnyMeetUIKit
//
//  Created by derek on 2018/5/11.
//  Copyright © 2018年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMApiCommon.h"
#import "AMUserModel.h"
#import "AMMeetInfoModel.h"
#import "AMMeetListModel.h"

//数据回调
typedef void(^CompleteBlock)(int code);
//出错回调
typedef void(^FailBlock)(NSError *error);
//获取会议详情数据回调
typedef void(^GetMeetInfoBlock)(AMMeetInfoModel *model,int code);
//获取会议列表的数据回调
typedef void(^GetMeetListBlock)(AMMeetListModel*model,int code);
//获取邀请过的参会人员列表
typedef void(GetInviteMembersBlock)(NSArray<Memberlist *> * memberlist,int code);


@interface AMApiManager : NSObject

+(AMApiManager*)shareInstance;

//注册成功后，系统给予的用户Id
@property (nonatomic, strong,readonly) NSString *anyUserId;
/**
 用户对接（调用成功后，其他接口才能使用）

 @param userModel 用户model:
 @param successBlock 数据回调
 @param failureBlock 出错回调
 */
- (void)registeredDockingMeeting:(AMUserModel*)userModel
                         success:(CompleteBlock)successBlock
                         failure:(FailBlock)failureBlock;

/**
 创建房间

 @param meetingName 会议名称
 @param type 会议类型
 @param startTime 会议开始时间（请大于当前时间，格式2018-05-11 16:32:33,格式不正确会出错）
 @param passWord 会议密码
 @param limitType 会议限制类型
 @param personList 邀请人数组（邀请人的用户ID的数组）
 @param successBlock 数据回调
 @param failureBlock 出错回调
 */
- (void)createMeetingRoom:(NSString*)meetingName
             withMeetType:(AMMeetType)type
        withMeetStartTime:(NSString*)startTime
             withPassWord:(NSString*)passWord
            withLimitType:(AMMeetLimitType)limitType
    withDefaultPersonList:(NSArray*)personList
                  success:(CompleteBlock)successBlock
                  failure:(FailBlock)failureBlock;

/**
 删除会议

 @param meetingId 会议ID
 @param successBlock 数据回调
 @param failureBlock 出错回调
 */
- (void)deleteMeetingRoom:(NSString*)meetingId
                  success:(CompleteBlock)successBlock
                  failure:(FailBlock)failureBlock;

/**
 获取会议详情

 @param meetingId 会议ID
 @param successBlock 数据回调
 @param failureBlock 出错回调
 */
- (void)getMeetingInfo:(NSString*)meetingId
               success:(GetMeetInfoBlock)successBlock
               failure:(FailBlock)failureBlock;
/**
 更新会议时间

 @param meetingId 会议ID
 @param startTime 会议的开始时间（必须大于等于当前时间）
 @param successBlock 数据回调
 @param failureBlock 出错回调
 */
- (void)updateMeetingStartTime:(NSString*)meetingId
           withUpdateStartTime:(NSString*)startTime
                       success:(CompleteBlock)successBlock
                       failure:(FailBlock)failureBlock;


/**
 获取会议列表

 @param pageNum 第几页（从第一页开始）
 @param pageSize 一页几条数据（必须大于0）
 @param successBlock 数据回调
 @param failureBlock 出错回调
 */
- (void)getUserMeetingListWithPageNum:(int)pageNum
                         withPageSize:(int)pageSize
                              success:(GetMeetListBlock)successBlock
                              failure:(FailBlock)failureBlock;

/**
 邀请参会人员

 @param meetingId 会议ID
 @param personList 邀请人数组（邀请人的用户ID的数组）
 @param successBlock 数据回调
 @param failureBlock 出错回调
 */
- (void)inviteMeetingMember:(NSString*)meetingId
       withInvitePersonList:(NSArray*)personList
                    success:(CompleteBlock)successBlock
                    failure:(FailBlock)failureBlock;
//删除踢出参会人员

/**
 删除踢出参会人员

 @param meetingId 会议ID
 @param personList 删除人数组（删除人的用户ID的数组）
 @param successBlock 数据回调
 @param failureBlock 出错回调
 */
- (void)deleteMeetingMember:(NSString*)meetingId
       withDeletePersonList:(NSArray*)personList
                    success:(CompleteBlock)successBlock
                    failure:(FailBlock)failureBlock;


/**
 获取邀请过的参会人员列表

 @param meetingId 会议ID
 @param successBlock 数据回调
 @param failureBlock 出错回调
 */
- (void)getInviteMemberList:(NSString*)meetingId
                    success:(GetInviteMembersBlock)successBlock
                    failure:(FailBlock)failureBlock;


/**
 获取错误码

 @param nCode 错误码
 @return 错误原因
 */
- (NSString *)getErrorInfoWithCode:(int)nCode;

@end

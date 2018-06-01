//
//  AMNetManager.m
//  NetRequest
//
//  Created by derek on 2018/5/4.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "AMNetManager.h"
#import<CommonCrypto/CommonDigest.h>
#import "AMNetWork.h"

@interface AMNetManager()

@property (nonatomic, strong) NSString *strDeveloperID;
@property (nonatomic, strong) NSString *strAppID;
@property (nonatomic, strong) NSString *strAppKey;
@property (nonatomic, strong) NSString *strAppToken;
@property (nonatomic, strong) NSString *strVerifyURL;

@property (nonatomic, strong) NSMutableArray *parameterArray;

@end

@implementation AMNetManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        //公共参数（排序）
        NSArray * array = [[NSArray alloc]initWithObjects:@"developerid",@"appid",@"verify_url",@"charset",@"timestamp",@"version",@"biz_content",nil];
        NSStringCompareOptions comparisonOptions =NSCaseInsensitiveSearch|NSNumericSearch|
        NSWidthInsensitiveSearch|NSForcedOrderingSearch;
        NSComparator sort = ^(NSString *obj1,NSString *obj2){
            NSRange range =NSMakeRange(0,obj1.length);
             return [obj1 compare:obj2 options:comparisonOptions range:range];
        };
        self.parameterArray = [[NSMutableArray alloc]initWithArray:[array sortedArrayUsingComparator:sort]];
    }
    return self;
}
static AMNetManager *manager = NULL;

+(AMNetManager*)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AMNetManager alloc] init];
    });
    return manager;
}
#pragma mark - 配置参数
- (void)configNetRequestParameter:(NSString*)strDeveloperId
                        withAppId:(NSString*)strAppId
                       withAppKey:(NSString*)strAppKey
                     withAppToken:(NSString*)strAppToken
                    withVerifyUrl:(NSString*)strVerifyUrl {
    
    self.strDeveloperID = strDeveloperId;
    self.strAppID = strAppId;
    self.strAppKey = strAppKey;
    self.strAppToken = strAppToken;
    self.strVerifyURL = strVerifyUrl;
}
#pragma mark - private methods
- (BOOL)verifyConfigParamter {
    if (self.strDeveloperID.length == 0 || self.strAppID.length == 0 || self.strAppKey.length == 0 || self.strAppToken.length == 0 || self.strVerifyURL.length == 0) {
        return NO;
    }else{
        return YES;
    }
}
- (NSString *)getTimestamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSString* stringData = [formatter stringFromDate:[NSDate date]];
    return stringData;
}
- (NSString *) md5:(NSString *) input {
    
    const char *cStr = [input UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = @"";
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
- (NSString*)signStr:(NSString*)parameterStr {
    //签名
    NSMutableString *mutableUrl = [[NSMutableString alloc] init];
    for (int i = 0;i<self.parameterArray.count;i++ ) {
        NSString *str = [self.parameterArray objectAtIndex:i];
        BOOL isLast = NO;
        if (i== self.parameterArray.count-1) {
            isLast = YES;
        }
        if ([str isEqualToString:@"developerid"]) {
            if (isLast) {
                [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@", str, self.strDeveloperID]];
            }else{
                [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@&", str, self.strDeveloperID]];
            }
        }else if ([str isEqualToString:@"appid"]) {
            if (isLast) {
                [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@", str, self.strAppID]];
            }else{
                [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@&", str, self.strAppID]];
            }
        }else if ([str isEqualToString:@"verify_url"]) {
            if (isLast) {
                [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@", str, self.strVerifyURL]];
            }else{
                [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@&", str, self.strVerifyURL]];
            }
        }else if ([str isEqualToString:@"charset"]) {
            if (isLast) {
                [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@", str, @"utf-8"]];
            }else{
                [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@&", str, @"utf-8"]];
            }
        }else if ([str isEqualToString:@"timestamp"]) {
            if (isLast) {
                [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@", str, [self getTimestamp]]];
            }else{
                [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@&", str, [self getTimestamp]]];
            }
        }else if ([str isEqualToString:@"version"]) {
            if (isLast) {
                [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@", str, @"1.0"]];
            }else{
                [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@&", str, @"1.0"]];
            }
        }else if ([str isEqualToString:@"biz_content"]) {
            if (isLast) {
                [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@", str, parameterStr]];
            }else{
                [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@&", str, parameterStr]];
            }
        }
    }
    return mutableUrl;
}
//参数拼接
- (NSString *)getRequestParameters:(NSDictionary*)dict {
    NSString *jsonStr = [self convertToJSONData:dict];
    //公共参数以及方法参数拼接
    NSString *signStr = [self signStr:jsonStr];
    
    NSString *endStr = [NSString stringWithFormat:@"%@%@%@",self.strAppKey,signStr,self.strAppToken];
   
    //L_INFO(@"待签名:%@",endStr);
    NSString *md5Str = [self md5:endStr];
    //L_INFO(@"MD5:%@",md5Str);
    // 组装参数
    NSMutableString *requestParameter = [[NSMutableString alloc] initWithString:signStr];
    [requestParameter appendString:[NSString stringWithFormat:@"&%@=%@",@"sign", md5Str]];
   // L_INFO(@"请求参数:%@",requestParameter);
    return requestParameter;
}
- (void)chuanzhi:(NSDictionary*)dict {
    NSDictionary *userInfo = [dict objectForKey:@"userinfo"];
    if (userInfo) {
        _anyUserId = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"u_anyrtc_openid"]];
    }
}
#pragma mark -　方法请求
- (void)registeredDockingMeeting:(NSString*)userId
                    withNickName:(NSString*)nickName
                     withHeadUrl:(NSString*)headUrl
                         success:(SuccessBlock)successBlock
                         failure:(FailureBlock)failureBlock {
    // 参数
    NSDictionary *parameter = [[NSDictionary alloc] initWithObjectsAndKeys:userId,@"userid",nickName,@"nickname",headUrl,@"head_url", nil];
    
    NSString *requestStr = [self getRequestParameters:parameter];
    __weak typeof(self)weakSelf = self;
    [AMNetWork getWithUrlString:@"init_teameeting" parameters:requestStr success:^(NSDictionary *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[data objectForKey:@"code"] integerValue] == 200) {
                [weakSelf chuanzhi:data];
            }
            
            if (successBlock) {
                successBlock(data);
            }
        });
       
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failureBlock) {
                failureBlock(error);
            }
        });
    }];
}
- (void)createMeetingRoom:(NSString*)userId
             withMeetName:(NSString*)meetingName
             withMeetType:(AMMeetType)type
        withMeetStartTime:(NSString*)startTime
             withPassWord:(NSString*)passWord
            withLimitType:(AMMeetLimitType)limitType
    withDefaultPersonList:(NSArray*)personList
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock {
    // 参数
    NSDictionary *parameter;
    switch (limitType) {
        case AMMeetLimitOpenType:
        {
            parameter = [[NSDictionary alloc] initWithObjectsAndKeys:userId,@"userid",meetingName,@"meet_name",[NSNumber numberWithInteger:type],@"meet_type",startTime,@"meet_start_time",[NSNumber numberWithInteger:limitType],@"meet_limit_type", nil];
        }
            break;
        case AMMeetLimitPassWordType:
        {
            if (passWord.length==0) {
                parameter = [[NSDictionary alloc] initWithObjectsAndKeys:userId,@"userid",meetingName,@"meet_name",[NSNumber numberWithInteger:type],@"meet_type",startTime,@"meet_start_time",[NSNumber numberWithInteger:limitType],@"meet_limit_type",nil];
            }else{
                parameter = [[NSDictionary alloc] initWithObjectsAndKeys:userId,@"userid",meetingName,@"meet_name",[NSNumber numberWithInteger:type],@"meet_type",startTime,@"meet_start_time",passWord,@"meet_password",[NSNumber numberWithInteger:limitType],@"meet_limit_type",nil];
            }
        }
            break;
        case AMMeetLimitDefaultPersonType:
        {
            if (personList.count !=0 && personList) {
                NSString *userStr = [self convertToJSONData:personList];
                if (userStr.length!=0) {
                     parameter = [[NSDictionary alloc] initWithObjectsAndKeys:userId,@"userid",meetingName,@"meet_name",[NSNumber numberWithInteger:type],@"meet_type",startTime,@"meet_start_time",[NSNumber numberWithInteger:limitType],@"meet_limit_type",userStr, @"meet_member_list",nil];
                }else{
                     parameter = [[NSDictionary alloc] initWithObjectsAndKeys:userId,@"userid",meetingName,@"meet_name",[NSNumber numberWithInteger:type],@"meet_type",startTime,@"meet_start_time",[NSNumber numberWithInteger:limitType],@"meet_limit_type",nil];
                }
            }else{
                parameter = [[NSDictionary alloc] initWithObjectsAndKeys:userId,@"userid",meetingName,@"meet_name",[NSNumber numberWithInteger:type],@"meet_type",startTime,@"meet_start_time",[NSNumber numberWithInteger:limitType],@"meet_limit_type",nil];
            }
        }
            break;
        default:
            break;
    }
 
    NSString *requestStr = [self getRequestParameters:parameter];

    [AMNetWork getWithUrlString:@"create_meeting_room" parameters:requestStr success:^(NSDictionary *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (successBlock) {
                successBlock(data);
            }
        });
        
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failureBlock) {
                failureBlock(error);
            }
        });
    }];
}
//删除会议
- (void)deleteMeetingRoom:(NSString*)userId
            withMeetingId:(NSString*)meetingId
                  success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlock {
    
    // 参数
    NSDictionary *parameter = [[NSDictionary alloc] initWithObjectsAndKeys:userId,@"userid",meetingId,@"meetingid", nil];
    NSString *requestStr = [self getRequestParameters:parameter];
    
    [AMNetWork getWithUrlString:@"delete_meeting_room" parameters:requestStr success:^(NSDictionary *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (successBlock) {
                successBlock(data);
            }
        });
        
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failureBlock) {
                failureBlock(error);
            }
        });
    }];
}

- (void)getMeetingInfo:(NSString*)userId
         withMeetingId:(NSString*)meetingId
               success:(SuccessBlock)successBlock
               failure:(FailureBlock)failureBlock {
    
    NSDictionary *parameter  = [[NSDictionary alloc] initWithObjectsAndKeys:userId,@"userid",meetingId,@"meetingid", nil];
    NSString *requestStr = [self getRequestParameters:parameter];
    
    [AMNetWork getWithUrlString:@"get_meeting_info" parameters:requestStr success:^(NSDictionary *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (successBlock) {
                successBlock(data);
            }
        });
        
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failureBlock) {
                failureBlock(error);
            }
        });
    }];
}
- (void)updateMeetingStartTime:(NSString*)userId
                 withMeetingId:(NSString*)meetingId
           withUpdateStartTime:(NSString*)startTime
                       success:(SuccessBlock)successBlock
                       failure:(FailureBlock)failureBlock {
   
    // 参数
    NSDictionary *parameter = [[NSDictionary alloc] initWithObjectsAndKeys:userId,@"userid",meetingId,@"meetingid",startTime,@"meet_start_time", nil];
    NSString *requestStr = [self getRequestParameters:parameter];
    
    [AMNetWork getWithUrlString:@"update_meeting_start_time" parameters:requestStr success:^(NSDictionary *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (successBlock) {
                successBlock(data);
            }
        });
        
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failureBlock) {
                failureBlock(error);
            }
        });
    }];
}
//获取会议列表
- (void)getUserMeetingList:(NSString*)userId
               withPageNum:(int)pageNum
              withPageSize:(int)pageSize
                   success:(SuccessBlock)successBlock
                   failure:(FailureBlock)failureBlock {
    if (pageNum<=0) {
        pageNum = 1;
    }
    if (pageSize<0) {
        pageSize = 10;
    }
    // 参数
    NSDictionary *parameter = [[NSDictionary alloc] initWithObjectsAndKeys:userId,@"userid",[NSNumber numberWithInt:pageNum],@"page_num",[NSNumber numberWithInt:pageSize],@"page_size", nil];
    
    NSString *requestStr = [self getRequestParameters:parameter];
    
    [AMNetWork getWithUrlString:@"get_user_meeting_list" parameters:requestStr success:^(NSDictionary *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (successBlock) {
                successBlock(data);
            }
        });
        
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failureBlock) {
                failureBlock(error);
            }
        });
    }];
}

- (void)inviteMeetingMember:(NSString*)userId
              withMeetingId:(NSString*)meetingId
       withInvitePersonList:(NSArray*)personList
                    success:(SuccessBlock)successBlock
                    failure:(FailureBlock)failureBlock {
    
    NSString *userStr = [self convertToJSONData:personList];
    // 参数
    NSDictionary *parameter = [[NSDictionary alloc] initWithObjectsAndKeys:userId,@"userid",meetingId,@"meetingid",userStr,@"meet_member_list", nil];
    
    NSString *requestStr = [self getRequestParameters:parameter];
   
    [AMNetWork getWithUrlString:@"invite_meeting_member" parameters:requestStr success:^(NSDictionary *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (successBlock) {
                successBlock(data);
            }
        });
        
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failureBlock) {
                failureBlock(error);
            }
        });
    }];
}

- (void)deleteMeetingMember:(NSString*)userId
              withMeetingId:(NSString*)meetingId
       withDeletePersonList:(NSArray*)personList
                    success:(SuccessBlock)successBlock
                    failure:(FailureBlock)failureBlock {
    
    NSString *userStr = [self convertToJSONData:personList];
    // 参数
    NSDictionary *parameter = [[NSDictionary alloc] initWithObjectsAndKeys:userId,@"userid",meetingId,@"meetingid",userStr,@"meet_member_list", nil];
    
    NSString *requestStr = [self getRequestParameters:parameter];
    
    [AMNetWork getWithUrlString:@"delete_meeting_member" parameters:requestStr success:^(NSDictionary *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (successBlock) {
                successBlock(data);
            }
        });
        
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failureBlock) {
                failureBlock(error);
            }
        });
    }];
}

- (void)getInviteMemberList:(NSString*)meetingId
                    success:(SuccessBlock)successBlock
                    failure:(FailureBlock)failureBlock {
   
    NSDictionary *parameter = [[NSDictionary alloc] initWithObjectsAndKeys:meetingId,@"meetingid", nil];
    
    NSString *requestStr = [self getRequestParameters:parameter];
    
    [AMNetWork getWithUrlString:@"get_meeting_member_list" parameters:requestStr success:^(NSDictionary *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (successBlock) {
                successBlock(data);
            }
        });
        
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failureBlock) {
                failureBlock(error);
            }
        });
    }];
}
-(void)updateMeetingLock:(NSString*)meetingId
                withLock:(NSInteger)lock
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock {
    
    NSDictionary *parameter = [[NSDictionary alloc] initWithObjectsAndKeys:meetingId?meetingId:@"",@"meetingid",self.anyUserId,@"userid",[NSNumber numberWithInteger:lock],@"is_lock", nil];
    
    NSString *requestStr = [self getRequestParameters:parameter];
    
    [AMNetWork getWithUrlString:@"update_meeting_lock" parameters:requestStr success:^(NSDictionary *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (successBlock) {
                successBlock(data);
            }
        });
        
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failureBlock) {
                failureBlock(error);
            }
        });
    }];
}
- (NSString *)getErrorInfoWithCode:(int)nCode {
    switch (nCode) {
        case 100004:
            return @"用户不存在";
            break;
        case 100005:
            return @"用户注册失败";
            break;
        case 100013:
            return @"会议室不存在";
            break;
        case 100014:
            return @"会议室密码错误";
            break;
        case 100017:
            return @"会议开始时间不能小于当前时间";
            break;
       
        case 400001:
            return @"数据库异常";
            break;
        case 400002:
            return @"数据参数缺失";
            break;
        case 400003:
            return @"据参数格式不正确";
            break;
        case 400004:
            return @"数据参数不符合系统规则";
            break;
        case 400005:
            return @"数据参数超出系统规范长度";
            break;
        case 400006:
            return @"列表为空";
            break;
        
        case 500000:
            return @"服务器访问失败";
            break;
        case 500001:
            return @"接口访问频繁";
            break;
          
        case 600001:
            return @"数据更新失败";
            break;
        case 600002:
            return @"有会议成员存在于会议列表中";
            break;
        case 600003:
            return @"邀请人员不存在";
            break;
        case 700001:
            return @"验证签名失败";
            break;
            
        case 800001:
            return @"验证anyRTC信息失败";
            break;
        case 800002:
            return @"访问anyRTC网站信息失败";
            break;
        case 800003:
            return @"anyRTC 账户欠费";
            break;
        case 800004:
            return @"访问Teameeting模块回调地址失败";
            break;
        case 800005:
            return @"初始化用户信息失败";
            break;
        case 800006:
            return @"用户接口访问时间戳大于60秒";
            break;
            
        default:
            return @"未知错误";
            break;
    }
}
@end

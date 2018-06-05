//
//  AMNetWorkTool.h
//  anyRTCMeeting
//
//  Created by jh on 2018/5/31.
//  Copyright © 2018年 anyRTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface AMNetWorkTool : NSObject

+ (instancetype)shareInstance;

//Get
- (void)getWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(NSDictionary * dictionary))success
                  failure:(void (^)(NSError * error))failure;

// 取消请求
- (void)cancelAllRequest;

@end

//
//  AMNetWork.h
//  NetRequest
//
//  Created by derek on 2017/11/3.
//  Copyright © 2017年 derek. All rights reserved.
//

#import <Foundation/Foundation.h>
//restful.api.teameeting.cn:8799
#define JQNetWorkUrl @"http://restful.api.teameeting.cn:8799/teameeting/gateway/meeting"
//#define JQNetWorkUrl @"http://192.168.1.111:8799/teameeting/gateway/meeting"

typedef void (^SuccessBlock)(NSDictionary *data);
typedef void (^FailureBlock)(NSError *error);


@interface AMNetWork : NSURLSession
/**
 *  get请求
 */
+ (void)getWithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
 * post请求
 */
+ (void)postWithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

@end

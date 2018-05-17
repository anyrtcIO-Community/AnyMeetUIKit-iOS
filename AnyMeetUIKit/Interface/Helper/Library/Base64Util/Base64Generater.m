//
//  Base64Generater.m
//  AvconLook
//
//  Created by zjq on 14/11/26.
//  Copyright (c) 2014年 zjq. All rights reserved.
//

#import "Base64Generater.h"
#import "GTMBase64.h"

@implementation Base64Generater

// 编码
+ (NSString*)EncodedWithBase64:(NSString*)string
{
    NSData* originData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData* encodeData = [GTMBase64 encodeData:originData];
    return [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
    //return [Base64Generater encodeToPercentEscapeString:[[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding]];
}

// 解码
+ (NSString*)DecoderWithBase64:(NSString*)string
{
    NSData* encodeData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData* decodeData = [GTMBase64 decodeData:encodeData];
    return [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
}

// 去掉容易出错的字符集
+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString*outputStr = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( NULL, /* allocator */
                                                                                              (__bridge CFStringRef)input,                 NULL, /* charactersToLeaveUnescaped */                      (CFStringRef)@"!*'();:@&=+$,/?%#[]",                 kCFStringEncodingUTF8));
    
    return outputStr;
}

@end

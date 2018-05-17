//
//  Base64Generater.h
//  AvconLook
//
//  Created by zjq on 14/11/26.
//  Copyright (c) 2014年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64Generater : NSObject

// 编码
+ (NSString*)EncodedWithBase64:(NSString*)string;
// 解码
+ (NSString*)DecoderWithBase64:(NSString*)string;

+ (NSString *)encodeToPercentEscapeString: (NSString *) input;

@end

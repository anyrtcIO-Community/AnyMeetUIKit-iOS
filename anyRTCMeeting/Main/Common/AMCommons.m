//
//  AMCommons.m
//  anyRTCMeeting
//
//  Created by jh on 2018/6/5.
//  Copyright © 2018年 derek. All rights reserved.
//

#import "AMCommons.h"
#import "SSKeychain.h"

#define kService [NSBundle mainBundle].bundleIdentifier

#define kAccount @"com.dync.anyRTCMeeting"

@implementation AMCommons

/**
 * 将16进制颜色转换成UIColor
 *
 **/
+(UIColor *)getColor:(NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip "0X" or "#" if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

//得到从1970年到现在的秒数
+(long)getSecondsSince1970 {
    NSTimeInterval time =[[NSDate date] timeIntervalSince1970];
    long second = time;
    return second;
}

//yyyy年MM月dd日 HH:mm:ss
+ (NSString *)getCurrentTime:(NSInteger)time formate:(NSString *)formate{
    NSDate *select = [[NSDate date] dateByAddingTimeInterval:time];
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = formate;
    return [selectDateFormatter stringFromDate:select];
}

//时间转时间戳
+ (NSString *)transformTimeStampString:(NSString *)time formate:(NSString *)formate{
    NSTimeInterval timer=[time doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:timer];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formate];
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}

//随机字符串
+ (NSString*)randomString:(int)len {
    char* charSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    char* temp = malloc(len + 1);
    for (int i = 0; i < len; i++) {
        int randomPoz = (int) floor(arc4random() % strlen(charSet));
        temp[i] = charSet[randomPoz];
    }
    temp[len] = '\0';
    NSMutableString* randomString = [[NSMutableString alloc] initWithUTF8String:temp];
    free(temp);
    return randomString;
}

//纯数字
+ (BOOL)validateNumber:(NSString*)number{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

//获取uuid（卸载、升级,标识唯一）
+ (NSString *)getUUID{
    
    CFUUIDRef puuid  =  CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result  =  (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));    CFRelease(puuid);
    CFRelease(uuidString);
    //SSKeyChains
    if(![SSKeychain passwordForService:kService account:kAccount]){
        [SSKeychain setPassword:result forService:kService account:kAccount];
        
    }
    NSString *devicenumber = [SSKeychain passwordForService:kService account:kAccount];
    
    return devicenumber.length > 0 ? devicenumber : @"" ;
}

+ (UIButton *)produceButton:(NSString *)title image:(NSString *)image{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button sizeToFit];
    return button;
}


@end

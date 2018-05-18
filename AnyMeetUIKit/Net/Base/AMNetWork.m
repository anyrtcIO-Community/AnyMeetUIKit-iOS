//
//  JQNetWork.m
//  NetRequest
//
//  Created by derek on 2017/11/3.
//  Copyright © 2017年 derek. All rights reserved.
//

#import "AMNetWork.h"

#define DefaultTimeOut 12

@implementation AMNetWork
+ (void)getWithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@",JQNetWorkUrl,url];
    NSMutableString *mutableUrl = [[NSMutableString alloc] initWithString:requestUrl];
    NSString *urlEnCode;
    //不是字典就是字符串
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        if ([parameters allKeys]) {
            [mutableUrl appendString:@"?"];
            for (id key in parameters) {
                NSString *value = [[parameters objectForKey:key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
            }
             urlEnCode = [[mutableUrl substringToIndex:mutableUrl.length - 1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
       
    }else{
        [mutableUrl appendString:@"?"];
        [mutableUrl appendString:parameters];
        urlEnCode = [mutableUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlEnCode] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:DefaultTimeOut];
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            failureBlock(error);
        } else {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            successBlock(dic);
        }
    }];
    [dataTask resume];
}

+ (void)postWithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@",JQNetWorkUrl,url];
    NSURL *nsurl = [NSURL URLWithString:requestUrl];
    //如果想要设置网络超时的时间的话，可以使用下面的方法：
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:nsurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:DefaultTimeOut];
    //设置请求类型
    request.HTTPMethod = @"POST";
    NSString *postStr = [AMNetWork parseParams:parameters];
    //把参数放到请求体内
    request.HTTPBody = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) { //请求失败
            failureBlock(error);
        } else {  //请求成功
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            successBlock(dic);
        }
    }];
    [dataTask resume];  //开始请求
}

//把NSDictionary解析成post格式的NSString字符串
+ (NSString *)parseParams:(NSDictionary *)params
{
    NSString *keyValueFormat;
    NSMutableString *result = [NSMutableString new];
    NSMutableArray *array = [NSMutableArray new];
    //实例化一个key枚举器用来存放dictionary的key
    NSEnumerator *keyEnum = [params keyEnumerator];
    id key;
    while (key = [keyEnum nextObject]) {
        keyValueFormat = [NSString stringWithFormat:@"%@=%@&", key, [params valueForKey:key]];
        [result appendString:keyValueFormat];
        [array addObject:keyValueFormat];
    }
    return result;
}
@end

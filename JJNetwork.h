//
//  JJNetwork.h
//  ESKUTE
//
//  Created by HJJ on 2021/6/8.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

typedef void (^RequestCompletedBlock)(bool success, id responseObject, NSError *error);

@interface JJNetwork : NSObject

/**
 GET数据请求

 @param urlString  URL
 @param parameters 参数
 @param callback    回调
 */
+ (void)getWithUrl:(NSString *)urlString parameters:(id)parameters callback:(RequestCompletedBlock)callback;
/**
 POST数据请求

 @param urlString  URL
 @param parameters 参数
 @param callback    回调
 */
+ (void)postWithUrl:(NSString *)urlString parameters:(id)parameters callback:(RequestCompletedBlock)callback;
/**
 图片上传

 @param urlString URL
 @param parameters 参数
 @param imageArray 图片数组 @[UIImage]
 @param imageKeys 上传图片对应的 key
 @param callback 回调
 */
+ (void)uploadWithUrl:(NSString *)urlString parameters:(id)parameters uploadImage:(NSArray *)imageArray imageKey:(NSArray *)imageKeys callback:(RequestCompletedBlock)callback;

+ (NSString *)baseUrl;

+ (void)cancelAllRequest;

+ (void)reachabilityStatus:(void (^)(id string))netStatus;

@end

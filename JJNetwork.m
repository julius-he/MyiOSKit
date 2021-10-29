//
//  JJNetwork.m
//  ESKUTE
//
//  Created by HJJ on 2021/6/8.
//

#import "JJNetwork.h"
#import "AFNetworking.h"

NSInteger const kTimeoutInterval = 10;

static AFHTTPSessionManager *manager;

static NSString *const baseUrl = @"http://ld01-app.com";

@implementation JJNetwork

+ (AFHTTPSessionManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
//        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        // 超时时间
        manager.requestSerializer.timeoutInterval = kTimeoutInterval;
        // 参数编码的序列化器（http编码格式）
//        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        // 接收的数据类型
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/json",@"text/plain",@"text/JavaScript",@"application/json",@"image/jpeg",@"image/png",@"application/octet-stream",nil];
        // 返回内容编码的序列化器（http编码格式）
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return manager;
}

+ (void)getWithUrl:(NSString *)urlString parameters:(id)parameters callback:(RequestCompletedBlock)callback {
    [self requestBeginLog:urlString parameters:parameters];
    [[self shareManager] GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 打印请求结果
        [self requestEndLog:responseObject];
        if (callback) {
            callback(YES, responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self errorLog:error];
        if (callback) {
            callback(NO, nil, error);
        }
    }];
}

+ (void)postWithUrl:(NSString *)urlString parameters:(id)parameters callback:(RequestCompletedBlock)callback {
    parameters = [parameters yy_modelToJSONObject];
    [self requestBeginLog:urlString parameters:parameters];
    [[self shareManager] POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 打印请求结果
        responseObject = [responseObject jsonValueDecoded];
        [self requestEndLog:responseObject];
        if (callback) {
            callback(YES, responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self errorLog:error];
        if (callback) {
            callback(NO, nil, error);
        }
    }];
}

+ (void)uploadWithUrl:(NSString *)urlString parameters:(id)parameters uploadImage:(NSArray *)imageArray imageKey:(NSArray *)imageKeys callback:(RequestCompletedBlock)callback {
    [self requestBeginLog:urlString parameters:parameters];
    [[self shareManager] POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < imageArray.count; i++) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *fileName = [NSString stringWithFormat:@"%@.png", [formatter stringFromDate:[NSDate date]]];
            UIImage *image = imageArray[i];
            NSData *data = UIImageJPEGRepresentation(image, 0.7);
            [formData appendPartWithFileData:data name:((imageKeys.count > 1) ? (imageKeys[i]) : (imageKeys.firstObject)) fileName:fileName mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [self progressLog:uploadProgress.fractionCompleted * 100];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 打印请求结果
        responseObject = [responseObject jsonValueDecoded];
        [self requestEndLog:responseObject];
        if (callback) {
            callback(YES, responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self errorLog:error];
        if (callback) {
            callback(NO, nil, error);
        }
    }];
}

+ (void)reachabilityStatus:(void (^)(id string))netStatus {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                if (netStatus) {
                    netStatus(@"未知网络类型");
                }
                break;
            case AFNetworkReachabilityStatusNotReachable:
                if (netStatus) {
                    netStatus(@"无可用网络");
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                if (netStatus) {
                    netStatus(@"当前Wi-Fi下");
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                if (netStatus) {
                    netStatus(@"使用蜂窝流量");
                }
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
}

+ (void)cancelAllRequest {
    [manager.operationQueue cancelAllOperations];
}

+ (NSString *)baseUrl {
    return baseUrl;
}

#pragma mark - 输出打印
+ (void)requestBeginLog:(NSString *)url parameters:(id)parameters {
#if DEBUG
    NSLog(@"\n==================== Request Begin ====================\n%@\nparameters:\n%@\n=======================================================", url, parameters);
#endif
}

+ (void)requestEndLog:(id)responseObject {
#if DEBUG
    NSLog(@"\n===================== Request End =====================\nresponseData:\n%@\n=======================================================", responseObject);
#endif
}

+ (void)errorLog:(NSError *)error {
#if DEBUG
    NSLog(@"\n===================== Request Error ====================\nerror:\n%@\n======================================================", error);
#endif
}

+ (void)progressLog:(double)progress {
#if DEBUG
    NSLog(@"\n====================== Uploading ======================\nprogress: %.1f%%\n=======================================================", progress);
#endif
}

@end

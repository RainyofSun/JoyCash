//
//  JCAPPNetRequestConfig.m
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#import "JCAPPNetRequestConfig.h"
#import "JCAPPNetRequestURLConfig.h"

@implementation JCAPPNetRequestConfig

+ (instancetype)requestConfig {
    static JCAPPNetRequestConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (config == nil) {
            config = [[JCAPPNetRequestConfig alloc] init];
        }
    });
    
    return config;
}

+ (void)reloadNetworkRequestURL {
    [[JCAPPNetRequestConfig requestConfig] updateNetworkRequestURL];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setDefaultConfig];
    }
    return self;
}

- (void)setDefaultConfig {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 30;
    config.allowsCellularAccess = YES;
    self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[JCAPPNetRequestURLConfig urlConfig].networkRequestURL sessionConfiguration:config];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"image/png",@"image/jpeg",@"multipart/form-data", nil];
}

- (void)updateNetworkRequestURL {
    [self.manager.requestSerializer willChangeValueForKey:@"baseURL"];
    [self.manager setValue:[JCAPPNetRequestURLConfig urlConfig].networkRequestURL forKey:@"baseURL"];
    [self.manager.requestSerializer didChangeValueForKey:@"baseURL"];
}

@end

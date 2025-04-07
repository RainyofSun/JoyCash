//
//  JCAPPNetRequestURLConfig.m
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#import "JCAPPNetRequestURLConfig.h"
#import "NSString+JCAPPStringExtension.h"
#import "JCAPPURLMacroHeader.h"

@interface JCAPPNetRequestURLConfig ()

@property (nonatomic, copy) NSString *requestDomainURL;
@property (nonatomic, strong) NSMutableArray<NSString *>* usedDomainURLs;

@end

@implementation JCAPPNetRequestURLConfig

+ (instancetype)urlConfig {
    static JCAPPNetRequestURLConfig *url;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (url == nil) {
            url = [[JCAPPNetRequestURLConfig alloc] init];
        }
    });
    
    return url;
}

+ (BOOL)reloadNetworkRequestDomainURL:(NSString *)url {
    return [[JCAPPNetRequestURLConfig urlConfig] setNewNetworkRequestDomainURL:url];
}

+ (void)clearDomainURLCache {
    [[JCAPPNetRequestURLConfig urlConfig].usedDomainURLs removeAllObjects];
}

- (BOOL)setNewNetworkRequestDomainURL:(NSString *)url {
    if ([self.usedDomainURLs containsObject:url]) {
        return NO;
    }
    
    self.requestDomainURL = url;
    [self.usedDomainURLs addObject:url];
    NSLog(@"-------- 设置新的域名 = %@ success ---------", url);
    
    return YES;
}

- (NSURL *)networkRequestURL {
    if ([NSString isEmptyString:self.requestDomainURL]) {
        return [NSURL URLWithString:NET_REQUEST_BASE_URL];
    }
    
    return [NSURL URLWithString:self.requestDomainURL];
}

- (NSMutableArray<NSString *> *)usedDomainURLs {
    if (!_usedDomainURLs) {
        _usedDomainURLs = [NSMutableArray array];
    }
    
    return _usedDomainURLs;
}
@end

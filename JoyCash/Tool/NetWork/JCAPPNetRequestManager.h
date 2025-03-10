//
//  JCAPPNetRequestManager.h
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#import <Foundation/Foundation.h>
#import "JCAPPURLMacroHeader.h"
#import "JCAPPNetResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JCAPPNetRequestManager : NSObject

/**
 * @brief                                         基本数据请求
 * @param   requestConfig NetworkRequestConfig    数据请求配置
 * @param   success       SuccessCallBack         成功返回
 * @param   failure       FailureCallBack         失败返回
 * @return                NSURLSessionDataTask    请求标识
 */
+ (nullable NSURLSessionTask *)AFNReqeustType:(NetworkRequestConfig *)requestConfig success:(SuccessCallBack)success failure:(FailureCallBack)failure;

@end

NS_ASSUME_NONNULL_END

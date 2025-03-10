//
//  NSString+JCAPPStringExtension.h
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (JCAPPStringExtension)

+ (BOOL)isEmptyString:(NSString *)str;
- (NSString *)maskPhoneNumber;

@end

NS_ASSUME_NONNULL_END

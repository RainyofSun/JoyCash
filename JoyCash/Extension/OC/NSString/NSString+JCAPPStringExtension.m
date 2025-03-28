//
//  NSString+JCAPPStringExtension.m
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#import "NSString+JCAPPStringExtension.h"

@implementation NSString (JCAPPStringExtension)

+ (BOOL)isEmptyString:(NSString *)str {
    if ([str isEqual:[NSNull null]] || str == nil || str.length == 0) {
        return YES;
    }
    
    return NO;
}

- (NSString *)maskPhoneNumber {
    NSInteger start = 2;
    NSInteger end = 4;
    NSString *str = @"";
    for (int i = 0; i < (self.length - start - end); i ++) {
        str = [NSString stringWithFormat:@"%@*", str];
    }
    
    return [self stringByReplacingCharactersInRange:NSMakeRange(start, (self.length - start - end)) withString:str];;
}

@end

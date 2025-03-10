//
//  UIViewController+JCAPPControllerExtension.h
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CurrentControllerShouldPopProtocol <NSObject>

- (BOOL)shouldPop;

@end

@interface UIViewController (JCAPPControllerExtension)<CurrentControllerShouldPopProtocol>

- (UIViewController *)topController;
- (void)showSystemStyleSettingAlert:(NSString *)content okTitle:(NSString * _Nullable )ok cancelTitle:(NSString * _Nullable )cancel;

@end

NS_ASSUME_NONNULL_END

//
//  ZTDropDownNotification.h
//  ZTDropDownNotification
//
//  Created by Zhang Tao on 2017/8/16.
//  Copyright © 2017年 Zhang Tao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const _Nonnull ZTDropDownNotificationInfoIconKey;
extern NSString *const _Nonnull ZTDropDownNotificationSuccessIconKey;
extern NSString *const _Nonnull ZTDropDownNotificationFailureIconKey;

@protocol ZTDropDownNotificationLayout
- (void)setIcon:(UIImage *_Nullable)icon;
- (void)setMessage:(NSString *_Nonnull)message;
@optional
@property(nonatomic, assign, readonly) CGFloat topPadding;
@end

@interface ZTDropDownNotification : NSObject
+ (void)setDefaultLayout:(UIView <ZTDropDownNotificationLayout> *_Nullable)layout;
+ (void)registerIconSets:(NSDictionary<NSString *, UIImage *> *_Nonnull)iconSets;

+ (void)notifyMessage:(NSString *_Nonnull)message withIconKey:(NSString *_Nullable)iconKey;

+ (void)notifyInfoMessage:(NSString *_Nonnull)message;
+ (void)notifySuccessMessage:(NSString *_Nonnull)message;
+ (void)notifyFailureMessage:(NSString *_Nonnull)message;

+ (void)notifyMessage:(NSString *_Nonnull)message withIcon:(UIImage *_Nullable)icon;
+ (void)notifyMessage:(NSString *_Nonnull)message withIcon:(UIImage *_Nullable)icon usingLayout:(UIView <ZTDropDownNotificationLayout> *_Nonnull)layout;
@end

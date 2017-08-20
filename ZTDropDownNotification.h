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

@interface ZTDropDownNotification : NSObject
+ (void)registerIconSets:(NSDictionary<NSString *, UIImage *> *_Nonnull)iconSets;

+ (void)notifyMessage:(NSString *_Nonnull)message withIconKey:(NSString *_Nullable)iconKey;

+ (void)notifyInfoMessage:(NSString *_Nonnull)message;
+ (void)notifySuccessMessage:(NSString *_Nonnull)message;
+ (void)notifyFailureMessage:(NSString *_Nonnull)message;

+ (void)notifyMessage:(NSString *_Nonnull)message withIcon:(UIImage *_Nullable)icon;
@end

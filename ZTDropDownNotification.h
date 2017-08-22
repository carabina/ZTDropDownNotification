//
//  ZTDropDownNotification.h
//  ZTDropDownNotification
//
//  Created by Zhang Tao on 2017/8/16.
//  Copyright © 2017年 Zhang Tao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const _Nonnull ZTNInfoIconKey;
extern NSString *const _Nonnull ZTNSuccessIconKey;
extern NSString *const _Nonnull ZTNFailureIconKey;

@protocol ZTNLayout
- (void)setIcon:(UIImage *_Nullable)icon;
- (void)setMessage:(NSString *_Nonnull)message;
@end

typedef UIView <ZTNLayout> *_Nonnull (^ZTNLayoutGeneratorBlock)();

@interface ZTDropDownNotification : NSObject
+ (void)setDefaultLayoutGenerator:(ZTNLayoutGeneratorBlock _Nullable)generator;
+ (void)registerIconSets:(NSDictionary<NSString *, UIImage *> *_Nonnull)iconSets;

+ (void)notifyMessage:(NSString *_Nonnull)message withIconKey:(NSString *_Nullable)iconKey;

+ (void)notifyInfoMessage:(NSString *_Nonnull)message;
+ (void)notifySuccessMessage:(NSString *_Nonnull)message;
+ (void)notifyFailureMessage:(NSString *_Nonnull)message;

+ (void)notifyMessage:(NSString *_Nonnull)message withIcon:(UIImage *_Nullable)icon;
+ (void)notifyView:(UIView *_Nonnull)view;
@end

//
//  ZTDropDownNotification.h
//  ZTDropDownNotification
//
//  Created by Zhang Tao on 2017/8/16.
//  Copyright © 2017年 Zhang Tao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Icon keys for info, success, failure notifications, used for registering icons
extern NSString *const _Nonnull ZTNInfoIconKey;
extern NSString *const _Nonnull ZTNSuccessIconKey;
extern NSString *const _Nonnull ZTNFailureIconKey;

@protocol ZTNLayout
- (void)setIcon:(UIImage *_Nullable)icon;
- (void)setMessage:(NSString *_Nonnull)message;
@end

/**
 Generate custom layout.

 @attention Leave extra `8pt` height padding area on top of the real content area.
 @return Custom layout object
 */
typedef UIView <ZTNLayout> *_Nonnull (^ZTNLayoutGeneratorBlock)();

/**
 Display a drop-down notification for a while and dismiss it automatically.
 
 This is a notification class inspried by Mobile QQ, supporting three shortcut notifying methods, custom layout and custom temporary view.
 @note Three shortcut notifying methods and `notifyMessage:withIconKey:` method require registered icons, or they will notify message only.
 @attention All notifying methods must be running in the main thread.
 */
@interface ZTDropDownNotification : NSObject

/**
 Set the generator to use custom layout in notifying methods.

 @param generator nil to reset the built-in default layout, otherwise use generated custom layout instead.
 */
+ (void)setCustomLayoutGenerator:(ZTNLayoutGeneratorBlock _Nullable)generator;

/**
 Register icons used in three shortcut notifying methods and `notifyMessage:withIconKey:` method.

 @note If register different icons with the same key multiple times, the last icon will take effect for that key.
 */
+ (void)registerIcons:(NSDictionary<NSString *, UIImage *> *_Nonnull)icons;

#pragma mark - Notifying methods
/**
 Notify message with registered icon key.

 @param message Notification text content.
 @param iconKey Pre-registered icon key.
 */
+ (void)notifyMessage:(NSString *_Nonnull)message withIconKey:(NSString *_Nullable)iconKey;

/**
 Notify message with temporary icon.

 This method is used for notifying message with temporary icon.
 
 For those icons which are used many times, registering them and calling `notifyMessage:withIconKey:` may be a better choice.
 @param message Notification text content.
 @param icon Temporary icon.
 */
+ (void)notifyMessage:(NSString *_Nonnull)message withIcon:(UIImage *_Nullable)icon;

/**
 Notify custom view.

 @attention Leave extra `8pt` height padding area on top of the real content area.
 */
+ (void)notifyView:(UIView *_Nonnull)view;

#pragma mark - Three shortcut notifying methods
/**
 Shortcut method for `notifyMessage:withIconKey:` using ZTNInfoIconKey.

 @param message Notification text content.
 */
+ (void)notifyInfoMessage:(NSString *_Nonnull)message;

/**
 Shortcut method for `notifyMessage:withIconKey:` using ZTNSuccessIconKey.
 
 @param message Notification text content.
 */
+ (void)notifySuccessMessage:(NSString *_Nonnull)message;

/**
 Shortcut method for `notifyMessage:withIconKey:` using ZTNFailureIconKey.
 
 @param message Notification text content.
 */
+ (void)notifyFailureMessage:(NSString *_Nonnull)message;
@end

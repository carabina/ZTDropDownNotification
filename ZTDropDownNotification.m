//
//  ZTDropDownNotification.m
//  ZTDropDownNotification
//
//  Created by Zhang Tao on 2017/8/16.
//  Copyright © 2017年 Zhang Tao. All rights reserved.
//

#import "ZTDropDownNotification.h"

NSString *const _Nonnull ZTDropDownNotificationInfoKey = @"ZTDropDownNotificationInfoKey";
NSString *const _Nonnull ZTDropDownNotificationSuccessKey = @"ZTDropDownNotificationSuccessKey";
NSString *const _Nonnull ZTDropDownNotificationFailureKey = @"ZTDropDownNotificationFailureKey";

static const CGFloat marginH = 12, padding = 8;
static const CGFloat statusBarHeight = 20, navigationBarHeight = 44;
static const CGFloat iconLength = 20;
static const CGFloat viewHeight = statusBarHeight + navigationBarHeight;

@interface ZTDropDownNotification ()

@property(nonatomic) NSMutableDictionary<NSString *, UIImage *> *iconSets;
@end

@implementation ZTDropDownNotification

+ (instancetype)sharedInstance {
  static ZTDropDownNotification *_sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedInstance = [ZTDropDownNotification new];
  });
  return _sharedInstance;
}

- (instancetype)init {
  if (self = [super init]) {
    _iconSets = [NSMutableDictionary new];
  }
  return self;
}

+ (void)registerIconSets:(NSDictionary<NSString *, UIImage *> *)iconSets {
  [[ZTDropDownNotification sharedInstance].iconSets addEntriesFromDictionary:iconSets];
}

+ (void)notifyMessage:(NSString *_Nonnull)message withIconKey:(NSString *_Nullable)iconKey {
  [ZTDropDownNotification notifyMessage:message withIcon:[ZTDropDownNotification iconSets][iconKey]];
}

+ (void)notifyInfoMessage:(NSString *_Nonnull)message {
  [ZTDropDownNotification notifyMessage:message withIconKey:ZTDropDownNotificationInfoKey];
}

+ (void)notifySuccessMessage:(NSString *_Nonnull)message {
  [ZTDropDownNotification notifyMessage:message withIconKey:ZTDropDownNotificationSuccessKey];
}

+ (void)notifyFailureMessage:(NSString *_Nonnull)message {
  [ZTDropDownNotification notifyMessage:message withIconKey:ZTDropDownNotificationFailureKey];
}

+ (void)notifyMessage:(NSString *_Nonnull)message withIcon:(UIImage *_Nullable)icon {
  NSAssert([NSThread isMainThread], @"[ZTDropDownNotification notifyMessage:withIcon:] should run in main thread");
  NSAssert(message, @"message cannot be nil");

  const CGRect originalFrame = CGRectMake(0, -viewHeight, CGRectGetWidth([[UIScreen mainScreen] bounds]), viewHeight);
  UIView *view = [[UIView alloc] initWithFrame:originalFrame];
  view.backgroundColor = [UIColor whiteColor];
  view.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
  view.layer.shadowOffset = CGSizeMake(0, 1);
  view.layer.shadowOpacity = 0.9;
  [[[UIApplication sharedApplication] keyWindow] addSubview:view];

  CGRect textLabelFrame = CGRectMake(marginH, statusBarHeight, CGRectGetWidth(view.bounds) - marginH * 2, navigationBarHeight);
  UILabel *textLabel = [[UILabel alloc] initWithFrame:textLabelFrame];
  textLabel.font = [UIFont systemFontOfSize:15];
  textLabel.text = message;
  [view addSubview:textLabel];

  if (icon) {
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(marginH, statusBarHeight + (navigationBarHeight - iconLength) / 2, iconLength, iconLength)];
    iconView.image = icon;
    [view addSubview:iconView];

    CGFloat adjust = iconLength + padding;
    textLabelFrame.origin.x += adjust;
    textLabelFrame.size.width -= adjust;
    textLabel.frame = textLabelFrame;
  }

  [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:0 animations:^{
    CGRect targetFrame = originalFrame;
    targetFrame.origin.y = 0;
    view.frame = targetFrame;
  }                completion:^(BOOL finished) {
    [NSTimer scheduledTimerWithTimeInterval:1.7 target:[ZTDropDownNotification sharedInstance] selector:@selector(handleTimer:) userInfo:view repeats:NO];
  }];
}

- (void)handleTimer:(NSTimer *)timer {
  UIView *view = (UIView *) timer.userInfo;
  [UIView animateWithDuration:0.2 animations:^{
    CGRect targetFrame = view.frame;
    targetFrame.origin.y -= CGRectGetMaxY(targetFrame);
    view.frame = targetFrame;
  }                completion:^(BOOL finished) {
    [view removeFromSuperview];
  }];
}

+ (NSMutableDictionary<NSString *, UIImage *> *)iconSets {
  return [[ZTDropDownNotification sharedInstance] iconSets];
}
@end

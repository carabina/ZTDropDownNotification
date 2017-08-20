//
//  ZTDropDownNotification.m
//  ZTDropDownNotification
//
//  Created by Zhang Tao on 2017/8/16.
//  Copyright © 2017年 Zhang Tao. All rights reserved.
//

#import "ZTDropDownNotification.h"

NSString *const _Nonnull ZTDropDownNotificationInfoIconKey = @"ZTDropDownNotificationInfoIconKey";
NSString *const _Nonnull ZTDropDownNotificationSuccessIconKey = @"ZTDropDownNotificationSuccessIconKey";
NSString *const _Nonnull ZTDropDownNotificationFailureIconKey = @"ZTDropDownNotificationFailureIconKey";

static const CGFloat HorizontalMargin = 12, StandardPadding = 8;
static const CGFloat StatusBarHeight = 20, NavigationBarHeight = 44;

@protocol NotificationLayout
@property(nonatomic, assign, readonly) CGFloat contentHeight;
- (void)setIcon:(UIImage *)icon;
- (void)setMessage:(NSString *)message;
@end

@interface TextOnlyLayout : UIView <NotificationLayout>
@property(nonatomic) UILabel *labelView;
@end

@implementation TextOnlyLayout
- (instancetype)init {
  if (self = [super init]) {
    [self setupBackground];
    [self setupLabelView];
  }
  return self;
}

- (void)setupBackground {
  self.backgroundColor = [UIColor whiteColor];
  self.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
  self.layer.shadowOffset = CGSizeMake(0, 1);
  self.layer.shadowOpacity = 0.9;
}

- (void)setupLabelView {
  self.labelView = [UILabel new];
  self.labelView.translatesAutoresizingMaskIntoConstraints = NO;
  self.labelView.font = [UIFont systemFontOfSize:15];
  self.labelView.textAlignment = NSTextAlignmentCenter;
  [self addSubview:self.labelView];

  [self addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"|-(margin)-[labelView]-(margin)-|"
                                              options:NSLayoutFormatAlignAllCenterY
                                              metrics:@{
                                                  @"margin": @(HorizontalMargin),
                                              }
                                                views:@{
                                                    @"labelView": self.labelView
                                                }]];

  [self addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[labelView(==height)]|"
                                              options:NSLayoutFormatDirectionLeadingToTrailing
                                              metrics:@{
                                                  @"margin": @(StandardPadding + StatusBarHeight),
                                                  @"height": @(NavigationBarHeight)
                                              }
                                                views:@{
                                                    @"labelView": self.labelView
                                                }]];
}

- (void)setIcon:(UIImage *)icon {}

- (void)setMessage:(NSString *)message {
  self.labelView.text = message;
}

- (CGFloat)contentHeight {
  return StatusBarHeight + NavigationBarHeight;
}
@end

@interface DefaultLayout : UIView <NotificationLayout>
@property(nonatomic) UIImageView *iconView;
@property(nonatomic) UILabel *labelView;
@end

@implementation DefaultLayout
- (instancetype)init {
  if (self = [super init]) {
    [self setupBackground];
    [self setupSubviews];
  }
  return self;
}

- (void)setupBackground {
  self.backgroundColor = [UIColor whiteColor];
  self.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
  self.layer.shadowOffset = CGSizeMake(0, 1);
  self.layer.shadowOpacity = 0.9;
}

- (void)setupSubviews {
  self.iconView = [UIImageView new];
  self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:self.iconView];

  self.labelView = [UILabel new];
  self.labelView.translatesAutoresizingMaskIntoConstraints = NO;
  self.labelView.font = [UIFont systemFontOfSize:15];
  [self addSubview:self.labelView];

  [self addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"|-(margin)-[iconView]-(padding)-[labelView]-(margin)-|"
                                              options:NSLayoutFormatAlignAllCenterY
                                              metrics:@{
                                                  @"margin": @(HorizontalMargin),
                                                  @"padding": @(StandardPadding),
                                              }
                                                views:@{
                                                    @"iconView": self.iconView,
                                                    @"labelView": self.labelView
                                                }]];

  [self addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[labelView(==height)]|"
                                              options:NSLayoutFormatDirectionLeadingToTrailing
                                              metrics:@{
                                                  @"margin": @(StandardPadding + StatusBarHeight),
                                                  @"height": @(NavigationBarHeight)
                                              }
                                                views:@{
                                                    @"labelView": self.labelView
                                                }]];
}

- (void)setIcon:(UIImage *)icon {
  NSAssert(icon, @"icon cannot be nil");
  self.iconView.image = icon;
}

- (void)setMessage:(NSString *)message {
  self.labelView.text = message;
}

- (CGFloat)contentHeight {
  return StatusBarHeight + NavigationBarHeight;
}
@end

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
  [ZTDropDownNotification notifyMessage:message withIconKey:ZTDropDownNotificationInfoIconKey];
}

+ (void)notifySuccessMessage:(NSString *_Nonnull)message {
  [ZTDropDownNotification notifyMessage:message withIconKey:ZTDropDownNotificationSuccessIconKey];
}

+ (void)notifyFailureMessage:(NSString *_Nonnull)message {
  [ZTDropDownNotification notifyMessage:message withIconKey:ZTDropDownNotificationFailureIconKey];
}

+ (void)notifyMessage:(NSString *_Nonnull)message withIcon:(UIImage *_Nullable)icon {
  NSAssert([NSThread isMainThread], @"[ZTDropDownNotification notifyMessage:withIcon:] should run in main thread");
  NSAssert(message, @"message cannot be nil");

  UIView <NotificationLayout> *layout = icon ? [DefaultLayout new] : [TextOnlyLayout new];
  layout.translatesAutoresizingMaskIntoConstraints = NO;
  [layout setMessage:message];
  [layout setIcon:icon];

  UIWindow *window = [[UIApplication sharedApplication] keyWindow];
  [window addSubview:layout];
  [window addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"|[layout]|"
                                              options:NSLayoutFormatDirectionLeadingToTrailing
                                              metrics:nil
                                                views:NSDictionaryOfVariableBindings(layout)]];
  [window addConstraint:
      [NSLayoutConstraint constraintWithItem:layout
                                   attribute:NSLayoutAttributeBottom
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:window
                                   attribute:NSLayoutAttributeTop
                                  multiplier:1
                                    constant:0]];
  [window layoutIfNeeded];

  [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:0 animations:^{
    CGRect target = layout.frame;
    target.origin.y = -CGRectGetHeight(target) + layout.contentHeight;
    layout.frame = target;
  }                completion:^(BOOL finished) {
    [NSTimer scheduledTimerWithTimeInterval:1.7
                                     target:[ZTDropDownNotification sharedInstance]
                                   selector:@selector(handleDurationTimer:)
                                   userInfo:layout
                                    repeats:NO];
  }];
}

- (void)handleDurationTimer:(NSTimer *)timer {
  UIView *layout = (UIView *) timer.userInfo;
  [UIView animateWithDuration:0.2 animations:^{
    CGRect target = layout.frame;
    target.origin.y = -CGRectGetHeight(target);
    layout.frame = target;
  }                completion:^(BOOL finished) {
    [layout removeFromSuperview];
  }];
}

+ (NSMutableDictionary<NSString *, UIImage *> *)iconSets {
  return [[ZTDropDownNotification sharedInstance] iconSets];
}
@end

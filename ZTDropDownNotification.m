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

@interface DefaultTextOnlyLayout : UIView <ZTDropDownNotificationLayout>
@property(nonatomic) UILabel *labelView;
@end

@implementation DefaultTextOnlyLayout
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

- (void)setIcon:(UIImage *_Nullable)icon {}

- (void)setMessage:(NSString *_Nonnull)message {
  self.labelView.text = message;
}

@end

@interface DefaultLayout : UIView <ZTDropDownNotificationLayout>
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
  [self.iconView setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
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

- (void)setIcon:(UIImage *_Nullable)icon {
  NSAssert(icon, @"icon cannot be nil");
  self.iconView.image = icon;
}

- (void)setMessage:(NSString *_Nonnull)message {
  self.labelView.text = message;
}

@end

@interface ZTDropDownNotification ()
@property(nonatomic) NSMutableDictionary<NSString *, UIImage *> *iconSets;
@property(nonatomic) UIView <ZTDropDownNotificationLayout> *defaultLayout;
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

+ (void)setDefaultLayout:(UIView <ZTDropDownNotificationLayout> *_Nullable)layout {
  [ZTDropDownNotification sharedInstance].defaultLayout = layout;
}

+ (void)notifyMessage:(NSString *_Nonnull)message withIconKey:(NSString *_Nullable)iconKey {
  [ZTDropDownNotification notifyMessage:message withIcon:[ZTDropDownNotification sharedInstance].iconSets[iconKey]];
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
  UIView <ZTDropDownNotificationLayout> *layout = [ZTDropDownNotification sharedInstance].defaultLayout;
  if (!layout) {
    layout = icon ? [DefaultLayout new] : [DefaultTextOnlyLayout new];
  }

  [ZTDropDownNotification notifyMessage:message withIcon:icon usingLayout:layout];
}

+ (void)notifyMessage:(NSString *_Nonnull)message withIcon:(UIImage *_Nullable)icon usingLayout:(UIView <ZTDropDownNotificationLayout> *_Nonnull)layout {
  NSAssert([NSThread isMainThread], @"[ZTDropDownNotification notifyMessage:withIcon:usingLayout:] should run in main thread");
  NSAssert(message, @"message cannot be nil");

  [layout setMessage:message];
  [layout setIcon:icon];

  [ZTDropDownNotification addLayoutToKeyWindow:layout];
  [ZTDropDownNotification showNotificationView:layout];
}

+ (void)addLayoutToKeyWindow:(UIView <ZTDropDownNotificationLayout> *)layout {
  layout.translatesAutoresizingMaskIntoConstraints = NO;

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
}

+ (void)showNotificationView:(UIView <ZTDropDownNotificationLayout> *)view {
  [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:0 animations:^{
    CGRect target = view.frame;
    target.origin.y = [view respondsToSelector:@selector(topPadding)] ? -view.topPadding : -StandardPadding;
    view.frame = target;
  }                completion:^(BOOL finished) {
    [NSTimer scheduledTimerWithTimeInterval:1.7
                                     target:[ZTDropDownNotification sharedInstance]
                                   selector:@selector(handleDurationTimer:)
                                   userInfo:view
                                    repeats:NO];
  }];
}

+ (void)hideNotificationView:(UIView *)view {
  [UIView animateWithDuration:0.2 animations:^{
    CGRect target = view.frame;
    target.origin.y = -CGRectGetHeight(target);
    view.frame = target;
  }                completion:^(BOOL finished) {
    [view removeFromSuperview];
  }];
}

- (void)handleDurationTimer:(NSTimer *)timer {
  [ZTDropDownNotification hideNotificationView:(UIView *) timer.userInfo];
}
@end

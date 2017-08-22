//
//  ZTDropDownNotification.m
//  ZTDropDownNotification
//
//  Created by Zhang Tao on 2017/8/16.
//  Copyright © 2017年 Zhang Tao. All rights reserved.
//

#import "ZTDropDownNotification.h"

NSString *const _Nonnull ZTNInfoIconKey = @"ZTNInfoIconKey";
NSString *const _Nonnull ZTNSuccessIconKey = @"ZTNSuccessIconKey";
NSString *const _Nonnull ZTNFailureIconKey = @"ZTNFailureIconKey";

static const CGFloat HorizontalMargin = 12, StandardPadding = 8;
static const CGFloat StatusBarHeight = 20, NavigationBarHeight = 44;

@interface DefaultTextOnlyLayout : UIView <ZTNLayout>
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
  UILabel *labelView = [UILabel new];
  labelView.translatesAutoresizingMaskIntoConstraints = NO;
  labelView.font = [UIFont systemFontOfSize:15];
  labelView.textAlignment = NSTextAlignmentCenter;
  [self addSubview:labelView];

  [self addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"|-(margin)-[labelView]-(margin)-|"
                                              options:NSLayoutFormatAlignAllCenterY
                                              metrics:@{
                                                  @"margin": @(HorizontalMargin),
                                              }
                                                views:NSDictionaryOfVariableBindings(labelView)]];
  [self addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[labelView(==height)]|"
                                              options:NSLayoutFormatDirectionLeadingToTrailing
                                              metrics:@{
                                                  @"margin": @(StandardPadding + StatusBarHeight),
                                                  @"height": @(NavigationBarHeight)
                                              }
                                                views:NSDictionaryOfVariableBindings(labelView)]];
  self.labelView = labelView;
}

- (void)setIcon:(UIImage *_Nullable)icon {}

- (void)setMessage:(NSString *_Nonnull)message {
  self.labelView.text = message;
}

@end

@interface DefaultLayout : UIView <ZTNLayout>
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
  UIImageView *iconView = [UIImageView new];
  iconView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:iconView];

  UILabel *labelView = [UILabel new];
  labelView.translatesAutoresizingMaskIntoConstraints = NO;
  labelView.font = [UIFont systemFontOfSize:15];
  [self addSubview:labelView];

  [self addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"|-(margin)-[iconView]-(padding)-[labelView]-(margin)-|"
                                              options:NSLayoutFormatAlignAllCenterY
                                              metrics:@{
                                                  @"margin": @(HorizontalMargin),
                                                  @"padding": @(StandardPadding),
                                              }
                                                views:NSDictionaryOfVariableBindings(iconView, labelView)]];
  [iconView setContentHuggingPriority:UILayoutPriorityDefaultLow + 1 forAxis:UILayoutConstraintAxisHorizontal];
  [self addConstraint:
      [NSLayoutConstraint constraintWithItem:iconView
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationLessThanOrEqual
                                      toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1
                                    constant:NavigationBarHeight]];
  [self addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[labelView(==height)]|"
                                              options:NSLayoutFormatDirectionLeadingToTrailing
                                              metrics:@{
                                                  @"margin": @(StandardPadding + StatusBarHeight),
                                                  @"height": @(NavigationBarHeight)
                                              }
                                                views:NSDictionaryOfVariableBindings(labelView)]];
  self.iconView = iconView;
  self.labelView = labelView;
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
@property(nonatomic) NSMutableArray *queue;
@property(nonatomic, copy) ZTNLayoutGeneratorBlock defaultLayoutGenerator;
@property(nonatomic, assign) BOOL showing;
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
    _queue = [NSMutableArray new];
    _defaultLayoutGenerator = nil;
    _showing = NO;
  }
  return self;
}

+ (void)registerIconSets:(NSDictionary<NSString *, UIImage *> *)iconSets {
  [[ZTDropDownNotification sharedInstance].iconSets addEntriesFromDictionary:iconSets];
}

+ (void)setDefaultLayoutGenerator:(ZTNLayoutGeneratorBlock _Nullable)generator {
  [ZTDropDownNotification sharedInstance].defaultLayoutGenerator = generator;
}

+ (void)notifyMessage:(NSString *_Nonnull)message withIconKey:(NSString *_Nullable)iconKey {
  [ZTDropDownNotification notifyMessage:message withIcon:[ZTDropDownNotification sharedInstance].iconSets[iconKey]];
}

+ (void)notifyInfoMessage:(NSString *_Nonnull)message {
  [ZTDropDownNotification notifyMessage:message withIconKey:ZTNInfoIconKey];
}

+ (void)notifySuccessMessage:(NSString *_Nonnull)message {
  [ZTDropDownNotification notifyMessage:message withIconKey:ZTNSuccessIconKey];
}

+ (void)notifyFailureMessage:(NSString *_Nonnull)message {
  [ZTDropDownNotification notifyMessage:message withIconKey:ZTNFailureIconKey];
}

+ (void)notifyMessage:(NSString *_Nonnull)message withIcon:(UIImage *_Nullable)icon {
  NSAssert(message, @"message cannot be nil");
  UIView <ZTNLayout> *layout;
  if ([ZTDropDownNotification sharedInstance].defaultLayoutGenerator) {
    layout = [ZTDropDownNotification sharedInstance].defaultLayoutGenerator();
  } else {
    layout = icon ? [DefaultLayout new] : [DefaultTextOnlyLayout new];
  }
  [layout setMessage:message];
  [layout setIcon:icon];

  [ZTDropDownNotification notifyView:layout];
}

+ (void)notifyView:(UIView *_Nonnull)view {
  NSAssert([NSThread isMainThread], @"[ZTDropDownNotification notifyView:] should run in main thread");

  if ([ZTDropDownNotification sharedInstance].showing) {
    [[ZTDropDownNotification sharedInstance].queue addObject:view];
  } else {
    [ZTDropDownNotification notifyViewDirectly:view];
  }
}

+ (void)notifyViewDirectly:(UIView *)view {
  [ZTDropDownNotification addLayoutToKeyWindow:view];
  [ZTDropDownNotification showNotificationView:view];
}

+ (void)addLayoutToKeyWindow:(UIView *)layout {
  layout.translatesAutoresizingMaskIntoConstraints = NO;

  UIWindow *window = [[UIApplication sharedApplication] keyWindow];
  [window addSubview:layout];
  [window addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"|-(0@priority)-[layout]-(0@priority)-|"
                                              options:NSLayoutFormatDirectionLeadingToTrailing
                                              metrics:@{
                                                  @"priority": @(UILayoutPriorityRequired - 1)
                                              }
                                                views:NSDictionaryOfVariableBindings(layout)]];
  [window addConstraint:
      [NSLayoutConstraint constraintWithItem:layout
                                   attribute:NSLayoutAttributeCenterX
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:window
                                   attribute:NSLayoutAttributeCenterX
                                  multiplier:1
                                    constant:0]];
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

+ (void)showNotificationView:(UIView *)view {
  [ZTDropDownNotification sharedInstance].showing = YES;
  [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:0 animations:^{
    CGRect target = view.frame;
    target.origin.y = -StandardPadding;
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
    if ([ZTDropDownNotification sharedInstance].queue.count > 0) {
      UIView <ZTNLayout> *layout = [ZTDropDownNotification sharedInstance].queue.firstObject;
      [[ZTDropDownNotification sharedInstance].queue removeObjectAtIndex:0];
      [ZTDropDownNotification notifyViewDirectly:layout];
    } else {
      [ZTDropDownNotification sharedInstance].showing = NO;
    }
  }];
}

- (void)handleDurationTimer:(NSTimer *)timer {
  [ZTDropDownNotification hideNotificationView:(UIView *) timer.userInfo];
}
@end

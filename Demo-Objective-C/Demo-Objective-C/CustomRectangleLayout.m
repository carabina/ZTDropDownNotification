//
//  CustomRectangleLayout.m
//  Demo-Objective-C
//
//  Created by Zhang Tao on 2017/8/21.
//  Copyright © 2017年 Zhang Tao. All rights reserved.
//

#import "CustomRectangleLayout.h"

@interface CustomRectangleLayout ()
@property(nonatomic) UILabel *labelView;
@property(nonatomic) UIImageView *iconView;
@end

@implementation CustomRectangleLayout
- (instancetype)init {
  if (self = [super init]) {
    [self setupBackground];
    [self setupSubViews];
  }
  return self;
}

- (void)setupBackground {
  self.backgroundColor = [UIColor whiteColor];
  self.layer.shadowOffset = CGSizeMake(1, 1);
  self.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
  self.layer.shadowOpacity = 1;
}

- (void)setupSubViews {
  UIImageView *iconView = [UIImageView new];
  iconView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:iconView];
  self.iconView = iconView;

  UILabel *labelView = [UILabel new];
  labelView.translatesAutoresizingMaskIntoConstraints = NO;
  labelView.textAlignment = NSTextAlignmentCenter;
  labelView.numberOfLines = 0;
  [self addSubview:labelView];
  self.labelView = labelView;

  [self addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[iconView]-[labelView]-|"
                                              options:NSLayoutFormatAlignAllCenterX
                                              metrics:@{
                                                  @"margin": @(44)
                                              }
                                                views:NSDictionaryOfVariableBindings(iconView, labelView)]];
  [labelView setContentHuggingPriority:UILayoutPriorityDefaultLow + 1 forAxis:UILayoutConstraintAxisVertical];
  [self addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"|-[labelView]-|"
                                              options:0
                                              metrics:nil
                                                views:NSDictionaryOfVariableBindings(labelView)]];
  [self addConstraint:
      [NSLayoutConstraint constraintWithItem:self
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1
                                    constant:200]];
}

- (void)setIcon:(UIImage *_Nullable)icon {
  self.iconView.image = icon;
}

- (void)setMessage:(NSString *_Nonnull)message {
  self.labelView.text = message;
}

@end

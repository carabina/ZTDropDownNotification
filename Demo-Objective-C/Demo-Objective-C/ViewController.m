//
//  ViewController.m
//  Demo-Objective-C
//
//  Created by Zhang Tao on 2017/8/16.
//  Copyright © 2017年 Zhang Tao. All rights reserved.
//

#import "ViewController.h"
#import "ZTDropDownNotification.h"
#import "CustomRectangleLayout.h"

static NSString *const NotificationRegisteredIconKey = @"NotificationRegisteredIconKey";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [ZTDropDownNotification registerIconSets:@{
      NotificationRegisteredIconKey: [UIImage imageNamed:@"registered_blue"],
      ZTNSuccessIconKey: [UIImage imageNamed:@"check_green"]}];
}

- (IBAction)notifyMessageOnly:(UIButton *)button {
  [ZTDropDownNotification notifyMessage:button.titleLabel.text withIcon:nil];
}

- (IBAction)notifySuccessMessage:(UIButton *)button {
  [ZTDropDownNotification notifySuccessMessage:button.titleLabel.text];
}

- (IBAction)notifyMessageWithRegisteredIcon:(UIButton *)button {
  [ZTDropDownNotification notifyMessage:button.titleLabel.text withIconKey:NotificationRegisteredIconKey];
}

- (IBAction)notifyMessageWithIconOnce:(UIButton *)button {
  [ZTDropDownNotification notifyMessage:button.titleLabel.text withIcon:[UIImage imageNamed:@"thumbs_up_blue"]];
}

- (IBAction)setCustomDefaultLayout:(UIButton *)button {
  [ZTDropDownNotification setDefaultLayoutGenerator:^UIView <ZTNLayout> * {
    return [CustomRectangleLayout new];
  }];
}

- (IBAction)resetLayoutToBuiltIns:(UIButton *)button {
  [ZTDropDownNotification setDefaultLayoutGenerator:nil];
}

- (IBAction)notifyCustomTemporaryView:(UIButton *)button {
  UIView *view = [UIView new];
  view.translatesAutoresizingMaskIntoConstraints = NO;
  view.backgroundColor = [UIColor whiteColor];
  view.layer.cornerRadius = 5.0;
  view.layer.shadowOffset = CGSizeMake(0, 1);
  view.layer.shadowRadius = 5.0;
  view.layer.shadowOpacity = 0.9;
  [view addConstraint:
      [NSLayoutConstraint constraintWithItem:view
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1
                                    constant:CGRectGetWidth([UIScreen mainScreen].bounds) * 0.6f]];

  UILabel *label = [UILabel new];
  label.translatesAutoresizingMaskIntoConstraints = NO;
  label.textColor = [UIColor orangeColor];
  label.text = button.titleLabel.text;
  label.shadowOffset = CGSizeMake(1, 0);
  label.shadowColor = [UIColor lightGrayColor];
  [view addSubview:label];

  UIImageView *icon = [UIImageView new];
  icon.translatesAutoresizingMaskIntoConstraints = NO;
  icon.image = [UIImage imageNamed:@"check_green"];
  [view addSubview:icon];

  [view addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"|-[label]-[icon]-|"
                                              options:NSLayoutFormatAlignAllCenterY
                                              metrics:nil
                                                views:NSDictionaryOfVariableBindings(label, icon)]];
  [view addConstraints:
      [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(28)-[label(==44)]|"
                                              options:NSLayoutFormatDirectionLeadingToTrailing
                                              metrics:nil
                                                views:NSDictionaryOfVariableBindings(label)]];
  [icon setContentHuggingPriority:UILayoutPriorityDefaultLow + 1 forAxis:UILayoutConstraintAxisHorizontal];

  [ZTDropDownNotification notifyView:view];
}
@end

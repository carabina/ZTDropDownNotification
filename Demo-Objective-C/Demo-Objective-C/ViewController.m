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
  [ZTDropDownNotification setDefaultLayoutGenerator:^UIView<ZTNLayout>*{
    return [CustomRectangleLayout new];
  }];
}

- (IBAction)resetLayoutToBuiltIns:(UIButton *)button {
  [ZTDropDownNotification setDefaultLayoutGenerator:nil];
}
@end

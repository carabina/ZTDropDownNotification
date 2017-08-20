//
//  ViewController.m
//  Demo-Objective-C
//
//  Created by Zhang Tao on 2017/8/16.
//  Copyright © 2017年 Zhang Tao. All rights reserved.
//

#import "ViewController.h"
#import "ZTDropDownNotification.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (IBAction)notifyMessageOnly:(UIButton *)button {
  [ZTDropDownNotification notifyMessage:button.titleLabel.text withIcon:nil];
}
@end

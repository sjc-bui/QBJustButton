//
//  QBViewController.m
//  QBJustButton
//
//  Created by sjc-bui on 05/31/2021.
//  Copyright (c) 2021 sjc-bui. All rights reserved.
//

#import "QBViewController.h"

@interface QBViewController ()

@end

@implementation QBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.continueBtn.tap = ^{
        NSLog(@"button callback handler");
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

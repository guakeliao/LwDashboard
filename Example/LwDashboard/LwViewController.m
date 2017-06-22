//
//  LwViewController.m
//  LwDashboard
//
//  Created by guakeliao on 06/22/2017.
//  Copyright (c) 2017 guakeliao. All rights reserved.
//

#import "LwViewController.h"
#import <LwDashboard/LwDashboard.h>
@interface LwViewController ()
@property (weak, nonatomic) IBOutlet LwDashboard *dashboard;

@end

@implementation LwViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"test" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(20, 20, 60, 30);
    [self.view addSubview:btn];
    
    self.dashboard.percent = 0.4;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.dashboard setPercent:0.99 animated:YES];
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.dashboard setPercent:0.1 animated:YES];
//    });
}

-(void)test{
    CGFloat percent = arc4random() % 101 / 100.0;
   [self.dashboard setPercent:percent animated:YES];
}
@end

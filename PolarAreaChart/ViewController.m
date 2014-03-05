//
//  ViewController.m
//  PolarAreaChart
//
//  Created by Rohit Kharat on 3/4/14.
//  Copyright (c) 2014 Rohit Kharat. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    polarChartView = [[PolarChartView alloc]initWithFrame:CGRectMake(0, 0, 768, 768)];
    polarChartView.center = self.view.center;
    //NSLog(@"view width = %f", self.view.frame.size.width);
    //NSLog(@"view height = %f", self.view.frame.size.height);

    [self.view addSubview:polarChartView];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

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
@synthesize numberOfSlices, inputData;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.inputData = [[NSMutableArray alloc]init];
    [self loadData];

    polarChartView = [[PolarChartView alloc]initWithFrame:CGRectMake(0, 0, 768, 768)];
    polarChartView.center = self.view.center;
    //NSLog(@"view width = %f", self.view.frame.size.width);
    //NSLog(@"view height = %f", self.view.frame.size.height);

    [self.view addSubview:polarChartView];
    
}

-(void)loadData
{
    NSNumber *int1 = [[NSNumber alloc]initWithInt:90];
    NSNumber *int2 = [[NSNumber alloc]initWithInt:40];
    NSNumber *int3 = [[NSNumber alloc]initWithInt:35];
    NSNumber *int4 = [[NSNumber alloc]initWithInt:15];
    NSNumber *int5 = [[NSNumber alloc]initWithInt:65];
    
    [inputData addObject:int1];
    [inputData addObject:int2];
    [inputData addObject:int3];
    [inputData addObject:int4];
    [inputData addObject:int5];
    
    self.numberOfSlices = [self.inputData count];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

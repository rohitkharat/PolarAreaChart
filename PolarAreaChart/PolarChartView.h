//
//  PolarChartView.h
//  PolarAreaChart
//
//  Created by Rohit Kharat on 3/4/14.
//  Copyright (c) 2014 Rohit Kharat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PolarChartView : UIView
{
    int closePathFlag;
}

@property NSMutableArray *inputData;
@property int numberOfSlices;
@property CGPoint viewCenter;


@end

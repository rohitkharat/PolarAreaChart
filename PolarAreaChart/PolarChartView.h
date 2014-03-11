//
//  PolarChartView.h
//  PolarAreaChart
//
//  Created by Rohit Kharat on 3/4/14.
//  Copyright (c) 2014 Rohit Kharat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PolarChartView : UIView <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    int closePathFlag;
    CABasicAnimation *sliceAnimation;
    int maxValue;
    NSMutableData *jsonData;
    NSURLConnection *connection;
}

@property NSMutableArray *inputData;
@property NSMutableArray *normalizedData;
@property int numberOfSlices;
@property CGPoint viewCenter;
@property NSString *textFromFile;


@end

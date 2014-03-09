//
//  SliceLayer.h
//  PolarAreaChart
//
//  Created by Rohit Kharat on 3/5/14.
//  Copyright (c) 2014 Rohit Kharat. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface SliceLayer : CALayer

@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat endAngle;

@property (nonatomic, retain) UIColor *fillColor;
@property (nonatomic, retain) UIColor *strokeColor;

@end

//
//  PolarChartView.m
//  PolarAreaChart
//
//  Created by Rohit Kharat on 3/4/14.
//  Copyright (c) 2014 Rohit Kharat. All rights reserved.
//

#import "PolarChartView.h"

@implementation PolarChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
     CGPoint center = CGPointMake(self.frame.size.height/2, self.frame.size.width/2);
     NSLog(@"center = %f, %f", self.frame.size.width/2, self.frame.size.height/2);

     ////draws 5 concentric circles
     for (float radius = 60; radius<=300; radius +=60)
     {
         UIBezierPath *circularPath = [UIBezierPath bezierPath];
         [circularPath setLineWidth:0.2];
         [circularPath addArcWithCenter:center radius:radius startAngle:0 endAngle:2*3.142 clockwise:YES];
         [circularPath closePath];
         [circularPath stroke];
     }
     
     
 }


@end

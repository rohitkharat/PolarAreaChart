//
//  PolarChartView.m
//  PolarAreaChart
//
//  Created by Rohit Kharat on 3/4/14.
//  Copyright (c) 2014 Rohit Kharat. All rights reserved.
//

#import "PolarChartView.h"

@implementation PolarChartView
@synthesize numberOfSlices, inputData, viewCenter;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        self.inputData = [[NSMutableArray alloc]init];
        [self loadData];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
     self.viewCenter = CGPointMake(self.frame.size.height/2, self.frame.size.width/2);
    // NSLog(@"center = %f, %f", self.frame.size.width/2, self.frame.size.height/2);

     [self drawConcentricCircles];
     [self drawPolarChart:inputData];
     
 }

-(void)drawConcentricCircles
{
    ////draws 5 concentric circles
    for (float radius = 60; radius<=300; radius +=60)
    {
        UIBezierPath *circularPath = [UIBezierPath bezierPath];
        [circularPath setLineWidth:0.2];
        [circularPath addArcWithCenter:self.viewCenter radius:radius startAngle:0 endAngle:2*3.142 clockwise:YES];
        [circularPath closePath];
        [circularPath stroke];
    }
}

-(void)drawPolarChart:(NSMutableArray*)inputArray
{
    self.numberOfSlices = [inputArray count];
    
    float redColor = 0.1;
    float greenColor = 0.3;
    float blueColor = 0.6;
    int i = 0;
    float sliceAngle = 2*3.142/self.numberOfSlices;
    float startAngle, endAngle = 0.0;
    float gap = 0.1;
    
    for (NSNumber *radius in inputArray)
    {
        startAngle = i * sliceAngle;
        endAngle = (i+1)*sliceAngle;
    
        [self addSlice:[radius floatValue] fromStartAngle:startAngle+gap toEndAngle:endAngle withColor:[UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:0.6]];
        redColor+=0.3;
        greenColor+=0.2;
        i++;
    }
    
}

-(void)loadData
{
    NSNumber *int1 = [[NSNumber alloc]initWithInt:250];
    NSNumber *int2 = [[NSNumber alloc]initWithInt:100];
    NSNumber *int3 = [[NSNumber alloc]initWithInt:180];
    NSNumber *int4 = [[NSNumber alloc]initWithInt:60];
    NSNumber *int5 = [[NSNumber alloc]initWithInt:290];
    
    [inputData addObject:int1];
    [inputData addObject:int2];
    [inputData addObject:int3];
    [inputData addObject:int4];
    [inputData addObject:int5];
    
    self.numberOfSlices = [self.inputData count];
}

-(void)addSlice: (CGFloat)radius fromStartAngle:(CGFloat)startAngle toEndAngle:(CGFloat)endAngle withColor:(UIColor *)color
{
    UIBezierPath *arc = [UIBezierPath bezierPath]; //empty path
    [arc setLineWidth:0.5];
    [arc moveToPoint:self.viewCenter];
    CGPoint next;
    next.x = self.viewCenter.x + radius * cos(startAngle);
    next.y = self.viewCenter.y + radius * sin(startAngle);
    [arc addLineToPoint:next]; //go one end of arc
    
    [arc addArcWithCenter:self.viewCenter radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES]; //add the arc
    [arc addLineToPoint:self.viewCenter]; //back to center
    
    [color set];
    [arc fill];
//    [strokeColor set];
    [arc stroke];

}


@end

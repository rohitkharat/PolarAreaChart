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
        closePathFlag = 0;
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
    
        CGPathRef fromPath = [self addSlice:[radius floatValue] fromStartAngle:startAngle+gap toEndAngle:startAngle+gap withColor:[UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:0.6]];
        CGPathRef toPath = [self addSlice:[radius floatValue] fromStartAngle:startAngle+gap toEndAngle:endAngle withColor:[UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:0.6]];

        redColor+=0.3;
        greenColor+=0.2;
        i++;
        
        
        CAShapeLayer *slice = [CAShapeLayer layer];
        slice.fillColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:0.7].CGColor;
        slice.strokeColor = [UIColor blackColor].CGColor;
        slice.lineWidth = 0.0;
        slice.path = fromPath;
        
        [self.layer addSublayer:slice];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.duration = 0.5;
        
        animation.fromValue = (__bridge id)fromPath;
        animation.toValue = (__bridge id)toPath;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        [slice addAnimation:animation forKey:nil];
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

-(CGPathRef)addSlice: (CGFloat)radius fromStartAngle:(CGFloat)startAngle toEndAngle:(CGFloat)endAngle withColor:(UIColor *)color
{
    UIBezierPath *sliceArc = [UIBezierPath bezierPath]; //empty path
    [sliceArc setLineWidth:0.5];
    //CGPoint offsetFromCenter = CGPointMake(self.viewCenter.x + 10* cos(startAngle), self.viewCenter.y + 10* sin(startAngle));
    [sliceArc moveToPoint:self.viewCenter];
    CGPoint next;
    next.x = self.viewCenter.x + radius * cos(startAngle);
    next.y = self.viewCenter.y + radius * sin(startAngle);
    [sliceArc addLineToPoint:next];
    [sliceArc addArcWithCenter:self.viewCenter radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
//    if (closePathFlag == 0)
//    {
//        closePathFlag = 1;
//        NSLog(@"not closing path");
//
//    }
//    else
//    {
//        closePathFlag = 0;
//        [sliceArc closePath];
//        NSLog(@"closing path");
//    }
//    [color set];
//    [sliceArc fill];
//    [sliceArc stroke];
    
    return sliceArc.CGPath;

}


@end

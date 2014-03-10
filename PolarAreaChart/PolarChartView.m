//
//  PolarChartView.m
//  PolarAreaChart
//
//  Created by Rohit Kharat on 3/4/14.
//  Copyright (c) 2014 Rohit Kharat. All rights reserved.
//

#import "PolarChartView.h"
#import <math.h>
#define kSATURATION 0.5
#define kBRIGHTNESS 0.75
#define kALPHA 0.7
#define kAnimationDuration 1.0

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

    CALayer *chartLayer = [CALayer layer];
    self.numberOfSlices = [inputArray count];
    
//    float redColor = 0.1;
//    float greenColor = 0.3;
//    float blueColor = 0.6;
    int index = 0;
    float sliceAngle = 2*3.142/self.numberOfSlices;
    float startAngle, endAngle = 0.0;
    float gap = 0.1;
    
    for (NSNumber *radius in inputArray)
    {
        startAngle = index * sliceAngle;
        endAngle = (index+1)*sliceAngle;
    
        CGPathRef fromPath = [self addSlice:[radius floatValue] fromStartAngle:startAngle+gap toEndAngle:startAngle+gap withColor:[UIColor colorWithHue:index/self.numberOfSlices saturation:0.5 brightness:0.75 alpha:1.0]];
        CGPathRef toPath = [self addSlice:[radius floatValue] fromStartAngle:startAngle+gap toEndAngle:endAngle withColor:[UIColor colorWithHue:index/self.numberOfSlices saturation:0.5 brightness:0.75 alpha:1.0]];

//        redColor+=0.3;
//        greenColor+=0.2;
        index++;
        //------------------------------------------
        //Animation of each slice
        CAShapeLayer *slice = [CAShapeLayer layer];
        slice.fillColor = [UIColor colorWithHue:fmodf(index*0.15, 1.0) saturation:kSATURATION brightness:kBRIGHTNESS alpha:kALPHA].CGColor;
        slice.strokeColor = [UIColor blackColor].CGColor;
        slice.lineWidth = 0.0;
        slice.path = fromPath;

        [chartLayer addSublayer:slice];
        
        sliceAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        sliceAnimation.duration = kAnimationDuration;
        
        sliceAnimation.fromValue = (__bridge id)fromPath;
        sliceAnimation.toValue = (__bridge id)toPath;
        sliceAnimation.removedOnCompletion = NO;
        sliceAnimation.fillMode = kCAFillModeForwards;
        
        [slice addAnimation:sliceAnimation forKey:nil];
        //------------------------------------------
        
        //----
//        NSNumber *rotationAtStart = [myLayer valueForKeyPath:@"transform.rotation"];
//        CATransform3D myRotationTransform = CATransform3DRotate(myLayer.transform, myRotationAngle, 0.0, 0.0, 1.0);
//        myLayer.transform = myRotationTransform;
//        CABasicAnimation *myAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//        myAnimation.duration = kMyAnimationDuration;
//        myAnimation.fromValue = rotationAtStart;
//        myAnimation.toValue = [NSNumber numberWithFloat:([rotationAtStart floatValue] + myRotationAngle)];
//        [myLayer addAnimation:myAnimation forKey:@"transform.rotation"];
        //----
        
        //------------------------------------------
//        //Rotation of each slice
//        int rads = [@(M_PI/2) intValue];
//        CATransform3D zRotation;
//        zRotation = CATransform3DMakeRotation(rads, 0, 0, 1.0);
//        CABasicAnimation *rotationAnimation;
//        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
//        rotationAnimation.toValue = [NSValue valueWithCATransform3D:zRotation];
//        rotationAnimation.duration = 5.5;
//        rotationAnimation.fillMode = kCAFillModeForwards;
//        [chartLayer addAnimation:rotationAnimation forKey:nil];
        //------------------------------------------
        
        //adding animations into a group.
//        CAAnimationGroup* group = [CAAnimationGroup animation];
//        [group setDuration: 5.0];  //Set the duration of the group to the time for all animations
//        group.removedOnCompletion = FALSE;
//        group.fillMode = kCAFillModeForwards;
//        [group setAnimations: [NSArray arrayWithObjects: sliceAnimation, rotationAnimation, nil]];
//        [slice addAnimation: group forKey:  nil];
    }

    //[chartLayer setFrame:CGRectMake(self.viewCenter.x, self.viewCenter.y, 10 , 10)];

    //self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    chartLayer.position = self.viewCenter;

    [self.layer addSublayer:chartLayer];
    [chartLayer setBounds:CGRectMake(self.bounds.size.width/2, self.bounds.size.height/2, 0 , 0)];

   // chartLayer.anchorPoint = CGPointMake(1.0, 0.0);

    //Rotation of polar area chart
//    int rads = [@(M_PI/2) intValue];
//    CATransform3D zRotation;
//    zRotation = CATransform3DMakeRotation(rads, 0, 0, 1.0);
//    CABasicAnimation *rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    rotationAnimation.toValue = [NSValue valueWithCATransform3D:zRotation];
//    rotationAnimation.duration = 2;
//    rotationAnimation.fillMode = kCAFillModeForwards;
//    [chartLayer addAnimation:rotationAnimation forKey:nil];
//
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
    rotationAnimation.duration = kAnimationDuration;
    rotationAnimation.repeatCount = 0;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //[chartLayer addAnimation:rotationAnimation forKey:@"transform.rotation.z"];
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    [group setDuration: kAnimationDuration];  //Set the duration of the group to the time for all animations
    group.removedOnCompletion = FALSE;
    group.fillMode = kCAFillModeForwards;
    [group setAnimations: [NSArray arrayWithObjects: sliceAnimation, rotationAnimation, nil]];
    [chartLayer addAnimation: group forKey:  nil];
}

-(void)loadData
{
    NSNumber *int1 = [[NSNumber alloc]initWithInt:250];
    NSNumber *int2 = [[NSNumber alloc]initWithInt:100];
    NSNumber *int3 = [[NSNumber alloc]initWithInt:180];
    NSNumber *int4 = [[NSNumber alloc]initWithInt:160];
    NSNumber *int5 = [[NSNumber alloc]initWithInt:290];
    NSNumber *int6 = [[NSNumber alloc]initWithInt:200];
    NSNumber *int7 = [[NSNumber alloc]initWithInt:200];
    
    [inputData addObject:int1];
    [inputData addObject:int2];
    [inputData addObject:int3];
    [inputData addObject:int4];
    [inputData addObject:int5];
    [inputData addObject:int6];
    [inputData addObject:int7];
    
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

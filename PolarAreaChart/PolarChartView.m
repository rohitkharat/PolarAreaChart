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
#define kAnimationDuration 0.7

@implementation PolarChartView
@synthesize numberOfSlices, inputData, viewCenter, normalizedData;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        self.inputData = [[NSMutableArray alloc]init];
        self.normalizedData = [[NSMutableArray alloc]init];
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
     [self drawPolarChart:self.normalizedData];
     
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
    
    int index = 0;
    float sliceAngle = 2*3.142/self.numberOfSlices;
    float startAngle = (3.142) - sliceAngle;
    float endAngle = 0.0;
    float gap = 0.1;
    
    for (NSNumber *radius in inputArray)
    {
        startAngle = ((index-1) * sliceAngle);
        endAngle = index*sliceAngle;
    
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
        
    }

    //[chartLayer setFrame:CGRectMake(self.viewCenter.x, self.viewCenter.y, 10 , 10)];

    //self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    chartLayer.position = self.viewCenter;

    [self.layer addSublayer:chartLayer];
    [chartLayer setBounds:CGRectMake(self.bounds.size.width/2, self.bounds.size.height/2, 0 , 0)];

   // chartLayer.anchorPoint = CGPointMake(1.0, 0.0);

    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat: sliceAngle - gap];
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
    
    chartLayer.shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5].CGColor;
    chartLayer.shadowOffset = CGSizeMake(0, 5);
    chartLayer.shadowOpacity = 1.0;
    chartLayer.shadowRadius = 1;
    chartLayer.masksToBounds = NO;
    
    [self addLabelsOnChart];
}

-(void)loadData
{
    NSNumber *int1 = [[NSNumber alloc]initWithInt:250];
    NSNumber *int2 = [[NSNumber alloc]initWithInt:100];
    NSNumber *int3 = [[NSNumber alloc]initWithInt:183];
    NSNumber *int4 = [[NSNumber alloc]initWithInt:167];
    NSNumber *int5 = [[NSNumber alloc]initWithInt:293];
    NSNumber *int6 = [[NSNumber alloc]initWithInt:208];
    NSNumber *int7 = [[NSNumber alloc]initWithInt:132];
    
    [self.inputData addObject:int1];
    [self.inputData addObject:int2];
    [self.inputData addObject:int3];
    [self.inputData addObject:int4];
    [self.inputData addObject:int5];
    [self.inputData addObject:int6];
    [self.inputData addObject:int7];
    
    self.normalizedData = [self normalizeArray:self.inputData];
    
    self.numberOfSlices = [self.inputData count];
}

-(NSMutableArray*)normalizeArray: (NSMutableArray*)inputArray
{
    NSMutableArray *normalizedArray = [[NSMutableArray alloc]init];
    
    maxValue = [[inputArray valueForKeyPath:@"@max.intValue"] intValue];
    NSLog(@"max value = %d",maxValue );
    
    float normalizationFactor = 300.0/maxValue;
    NSLog(@"normalizationFactor = %f", normalizationFactor);
    
    for (NSNumber* originalNumber in inputArray)
    {
        NSNumber *normalizedValue = [[NSNumber alloc]initWithFloat:[originalNumber floatValue]*normalizationFactor];
        [normalizedArray addObject:normalizedValue];
    }
    
    NSLog(@"%@", normalizedArray);
    return normalizedArray;

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
    
    return sliceArc.CGPath;

}

-(void)addLabelsOnChart
{
    int startValue = maxValue/5;
    int valueToBeAdded = startValue;
    NSString *stringValue;
    
    for (int i = 0; i<5; i++)
    {
        
        if (i==4)
        {
             stringValue = [NSString stringWithFormat:@"%d",maxValue];

        }
        else
        {
             stringValue = [NSString stringWithFormat:@"%d",startValue];
        }
        
        CATextLayer *label = [[CATextLayer alloc] init];
        [label setFont:@"Helvetica"];
        [label setFontSize:15];
        [label setForegroundColor:[[UIColor darkGrayColor] CGColor]];
        [label setBackgroundColor:[[UIColor colorWithWhite:0.9 alpha:0.4] CGColor]];
        [label setFrame:CGRectMake(self.viewCenter.x + (i+1)*60, self.viewCenter.y-7, 40, 20)];
        [label setAlignmentMode:kCAAlignmentCenter];
        [label setString:stringValue];
        [self.layer addSublayer:label];
        startValue+= valueToBeAdded;
        
    }
}


@end

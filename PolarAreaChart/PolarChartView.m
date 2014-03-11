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
#define kAnimationDuration 0.5
#define myQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation PolarChartView
@synthesize numberOfSlices, inputData, viewCenter, normalizedData, textFromFile;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        [self performSelectorOnMainThread:@selector(getDataFromServer) withObject:nil waitUntilDone:YES];
        
        UIButton *refreshButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 13, 700, 100, 50)];
        [self addSubview:refreshButton];
        [refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
        [refreshButton setBackgroundColor:[UIColor clearColor]];
        [refreshButton setImage:[UIImage imageNamed:@"redo.png"] forState:UIControlStateNormal];
        refreshButton.showsTouchWhenHighlighted = TRUE;
        [refreshButton addTarget:self action:@selector(refreshScreen) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}


-(void)refreshScreen
{
    NSLog(@"refresh");
    [self drawPolarChart:self.normalizedData];
}

/**
 Method to fetch data from json file which is stored on a server
 */
-(void)getDataFromServer
{
    //NSString *string = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"samplejson" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"%@", string);
    
    //return string;
    //NSLog(@"getDataFromServer");
    
    NSString *dataURLString = @"http://chatbuff.com:8080/rohit/sample.json";
    
    NSURL *dataURL = [[NSURL alloc]initWithString:dataURLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:dataURL];
    
    //connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                               if (data != nil && error == nil && [httpResponse statusCode] == 200)
                               {
                                   [self performSelectorOnMainThread:@selector(loadData:) withObject:data waitUntilDone:YES];
                                   [self drawPolarChart:self.normalizedData];
                               }
                               else
                               {
                                   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error connecting to the server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                   [alert show];
                                   NSLog(@"data is nil");
                                   
                               }
                               
                           }];
    
}

//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    if (data == nil)
//    {
//        NSLog(@"data is nil");
//    }
//    else
//    {
//        //jsonData = [[NSMutableData alloc]init];
//        //[jsonData appendData:data];
//
//        //NSLog(@"data: %@", data);
//    }
//}


/**
 Method to get array of values from json data
 */
-(void)loadData:(NSData*)jData
{
    //NSLog(@"jdata: %@", jData);
    //self.textFromFile = [self getTextFromFile];
    //    dispatch_async(myQueue, ^{NSData *data = [NSData dataWithData:jData];
    //        [self performSelectorOnMainThread:@selector(getValuesFromJsonData:)
    //                               withObject:data waitUntilDone:YES];
    //    });
    
    self.normalizedData = [[NSMutableArray alloc]init];
    
    [self performSelectorOnMainThread:@selector(getValuesFromJsonData:) withObject:jData waitUntilDone:YES];
    
    //NSLog(@"jData = %@", jData);
    //NSLog(@"inputData: %@", self.inputData);
    [self performSelectorOnMainThread:@selector(normalizeArray:) withObject:self.inputData waitUntilDone:YES];
    //NSLog(@"normalized: %@",self.normalizedData);
    
    self.numberOfSlices = [self.inputData count];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error %@", error);
}

/**
 Method to parse json data and get required values
 */
-(NSMutableArray*)getValuesFromJsonData:(NSData*)json
{
    NSError *localError = nil;
    NSDictionary *parsedObject;
    //NSLog(@"json data passed to getValuesFromJsonData: %@", json);
    if (json!=nil)
    {
        parsedObject = [NSJSONSerialization JSONObjectWithData:json options:0 error:&localError];
        if (localError != nil)
        {
            return nil;
            NSLog(@"error");
        }
        
        NSMutableArray* array = [[NSMutableArray alloc]initWithArray:[parsedObject valueForKey:@"values"]];
        //NSLog(@"received %d values", [array count]);
        //NSLog(@"array received %@", array);
        self.inputData = [[NSMutableArray alloc]initWithArray:array];
        return array;
    }
    
    else
    {
        return nil;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.viewCenter = CGPointMake(self.frame.size.height/2, self.frame.size.width/2);
    // NSLog(@"center = %f, %f", self.frame.size.width/2, self.frame.size.height/2);
    
    [self drawConcentricCircles];
    //[self setNeedsDisplay];
    
}

/**
 Method to draw concentric circles as a base for the polar area chart
 */
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

/**
 This is the method in which each slice is rendered and animated
 */
-(void)drawPolarChart:(NSMutableArray*)inputArray
{
    
    [chartLayer removeFromSuperlayer];
    NSLog(@"drawing polar chart");
    chartLayer = [CALayer layer];
    self.numberOfSlices = [inputArray count];
    
    int index = 0;
    sliceAngle = 2*3.142/self.numberOfSlices;
    float startAngle = (3.142) - sliceAngle;
    float endAngle = 0.0;
    float gap = 0.1;
    
    for (NSNumber *radius in inputArray)
    {
        startAngle = ((index-1) * sliceAngle);
        endAngle = index*sliceAngle;
        
        CGPathRef fromPath = [self addSlice:[radius floatValue] fromStartAngle:startAngle+gap toEndAngle:startAngle+gap];
        CGPathRef toPath = [self addSlice:[radius floatValue] fromStartAngle:startAngle+gap toEndAngle:endAngle];
        
        index++;
        
        //------------------------------------------
        //Animation of each slice
        slice = [CAShapeLayer layer];
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
        sliceAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        [slice addAnimation:sliceAnimation forKey:nil];
    }
    
    //[chartLayer setFrame:CGRectMake(self.viewCenter.x, self.viewCenter.y, 10 , 10)];
    
    //self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    chartLayer.position = self.viewCenter;
    
    [self.layer addSublayer:chartLayer];
    [chartLayer setBounds:CGRectMake(self.bounds.size.width/2, self.bounds.size.height/2, 0 , 0)];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:1.5*3.14];
    rotationAnimation.toValue = [NSNumber numberWithFloat: 1.5*3.14 + sliceAngle - gap];
    rotationAnimation.duration = kAnimationDuration;
    rotationAnimation.repeatCount = 0;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    [group setDuration: kAnimationDuration];
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

/**
 Method to normalize the received values with respect to the largest value and the maximum radius
 */
-(NSMutableArray*)normalizeArray: (NSMutableArray*)inputArray
{
    NSMutableArray *normalizedArray = [[NSMutableArray alloc]init];
    
    maxValue = [[inputArray valueForKeyPath:@"@max.intValue"] intValue];
    //NSLog(@"max value = %d",maxValue );
    
    float normalizationFactor = 300.0/maxValue;
    //NSLog(@"normalizationFactor = %f", normalizationFactor);
    
    for (NSNumber* originalNumber in inputArray)
    {
        NSNumber *normalizedValue = [[NSNumber alloc]initWithFloat:[originalNumber floatValue]*normalizationFactor];
        [normalizedArray addObject:normalizedValue];
    }
    
    //NSLog(@"%@", normalizedArray);
    self.normalizedData = normalizedArray;
    return normalizedArray;
    
}

/**
 Method to add a slice to the polar area chart using UIBezierPath
 */
-(CGPathRef)addSlice: (CGFloat)radius fromStartAngle:(CGFloat)startAngle toEndAngle:(CGFloat)endAngle
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

/**
 Method to add labels on the chart to indicate the scale
 */
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
        [label setFrame:CGRectMake(self.viewCenter.x - 20, self.viewCenter.y - (i+1)*62, 40, 20)];
        [label setAlignmentMode:kCAAlignmentCenter];
        [label setString:stringValue];
        [self.layer addSublayer:label];
        startValue+= valueToBeAdded;
        
    }
}


@end

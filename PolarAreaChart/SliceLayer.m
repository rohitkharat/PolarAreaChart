//
//  SliceLayer.m
//  PolarAreaChart
//
//  Created by Rohit Kharat on 3/5/14.
//  Copyright (c) 2014 Rohit Kharat. All rights reserved.
//

#import "SliceLayer.h"

@implementation SliceLayer

@dynamic startAngle, endAngle;
@synthesize fillColor;

-(id)init
{
    self = [super init];
    if (self)
    {
        self.fillColor = [UIColor lightGrayColor];
        self.strokeColor = [UIColor blackColor];
        
        [self setNeedsDisplay];
    }
    return self;
}

-(CABasicAnimation*)getAnimation:(NSString *)key
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:key];
    animation.fromValue = [[self presentationLayer] valueForKey:key];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.duration = 1.0;
    
    return animation;
}

-(id<CAAction>)actionForKey:(NSString *)event
{
    if ([event isEqualToString:@"startAngle"] || [event isEqualToString:@"endAngle"]) {
        return [self getAnimation:event];
    }
    
    return [super actionForKey:event];
}

+(BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"startAngle"] || [key isEqualToString:@"endAngle"]) {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

@end

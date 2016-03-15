//
//  YXFlyBallFactoryVersion1.m
//  testBubble3
//
//  Created by 沈 晨豪 on 15/10/21.
//  Copyright © 2015年 sch. All rights reserved.
//

#import "YXFlyBallFactoryVersion1.h"
#import "YXFlyBall.h"

@implementation YXFlyBallFactoryVersion1

- (CGFloat)frequency
{
    return 2.0f;
}

- (NSArray *)getCreateFlyBallWithWidth: (CGFloat) width view: (UIView *) view ballColor: (UIColor *)color;
{
    
    
//    CGFloat radius;
//    
//    CGFloat
//    
//    CGFloat tempMinRadius = MIN(_minRadius, _maxRadius);
//    CGFloat tempMaxRadius = MAX(_minRadius, _maxRadius);
//    
//    if (tempMinRadius == tempMaxRadius)
//    {
//        radius = tempMinRadius;
//    }
//    else
//    {
//        radius = ((CGFloat)(random() %((NSInteger)((tempMaxRadius - tempMinRadius)  * 10000.0f)))) / 10000.0f + tempMinRadius;
//        
//        
//    }
    
//    CGFloat top;
//    
//    CGFloat tempMinTop = MIN(_minTop, _maxTop);
//    CGFloat tempMaxTop = MAX(_minTop, _maxTop);
//    
//    if (tempMinTop == tempMaxTop)
//    {
//        top = tempMinTop;
//    }
//    else
//    {
//        top = ((CGFloat)(random() %((NSInteger)((tempMaxTop - tempMinTop)  * 10000.0f)))) / 10000.0f + tempMinTop;
//    }
//    
//    
//    CGFloat startX = radius +  random() %((NSInteger)(self.bounds.size.width - 2 * radius - 2.0f));
//    CGFloat endX   = radius +  random() %((NSInteger)(self.bounds.size.width - 2 * radius - 2.0f));
//    CGPoint startPoint = CGPointMake(startX, radius + _startOffsetY);
//    CGPoint endPoint   = CGPointMake(endX, radius + _startOffsetY) ;
//    
//    YXFlyBall *ball = [[YXFlyBall alloc] init];
//    
//    ball.radius         = radius;
//    ball.startPoint     = startPoint;
//    ball.endPoint       = endPoint;
//    ball.top            = top;
//    ball.ballColor      = _ballColor;
//    ball.backgroundView = self;
//    ball.a              = -3 * _speed;
//    ball.g              = _g * _speed;
//    [_ballArray addObject:ball];
//    
//    [ball reset];
    
    
    NSMutableArray *ballArray = [@[] mutableCopy];
    
    /*球从左往右*/
    
    /*4*/
    {
        CGFloat radius     = 4;
        CGPoint startPoint = CGPointMake(width - 20.0f, radius + 5);
        CGPoint endPoint   = CGPointMake(width - 20.0f, radius + 5);
        CGFloat top        = 21;
        YXFlyBall *ball = [[YXFlyBall alloc] init];
        ball.radius         = radius;
        ball.startPoint     = startPoint;
        ball.endPoint       = endPoint;
        ball.top            = top;
        ball.ballColor      = color;
        ball.backgroundView = view;
        ball.a              =  0;
        ball.g              = 18.1 * 9;
        [ball reset];
        
        [ballArray addObject:ball];
    }
    
    /*3*/
    {
        CGFloat radius     = 4;
        CGPoint startPoint = CGPointMake(width - 30.0f, radius + 5);
        CGPoint endPoint   = CGPointMake(width - 30.0f, radius + 5);
        CGFloat top        = 21;
        YXFlyBall *ball = [[YXFlyBall alloc] init];
        ball.radius         = radius;
        ball.startPoint     = startPoint;
        ball.endPoint       = endPoint;
        ball.top            = top;
        ball.ballColor      = color;
        ball.backgroundView = view;
        ball.a              =  0;
        ball.g              = 18.1 * 9;
        ball.delay          = 0.3f;
        [ball reset];
        
        [ballArray addObject:ball];
    }
    
    /*2*/
    {
        CGFloat radius     = 1;
        CGPoint startPoint = CGPointMake((width - 30.0f) / 2.0f, radius + 5);
        CGPoint endPoint   = CGPointMake((width - 30.0f) / 2.0f, radius + 5);
        CGFloat top        = 8;
        YXFlyBall *ball = [[YXFlyBall alloc] init];
        ball.radius         = radius;
        ball.startPoint     = startPoint;
        ball.endPoint       = endPoint;
        ball.top            = top;
        ball.ballColor      = color;
        ball.backgroundView = view;
        ball.a              =  0;
        ball.g              = 18.1 * 9;
        ball.delay          = 0.3f;
        [ball reset];
        
        [ballArray addObject:ball];
    }
    
    /*1*/
    {
        CGFloat radius     = 2;
        CGPoint startPoint = CGPointMake(10.0f, radius + 5);
        CGPoint endPoint   = CGPointMake(width - 40.0f, radius + 5);
        CGFloat top        = 21;
        YXFlyBall *ball = [[YXFlyBall alloc] init];
        ball.radius         = radius;
        ball.startPoint     = startPoint;
        ball.endPoint       = endPoint;
        ball.top            = top;
        ball.ballColor      = color;
        ball.backgroundView = view;
        ball.a              =  0;
        ball.g              = 18.1 * 9;
        ball.delay          = 0.3f;
        [ball reset];
        
        [ballArray addObject:ball];
    }
    
    return ballArray;
}

@end




























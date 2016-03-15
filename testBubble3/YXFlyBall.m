//
//  YXFlyBall.m
//  testBubble
//
//  Created by 沈 晨豪 on 15/7/21.
//  Copyright (c) 2015年 sch. All rights reserved.
//

#import "YXFlyBall.h"
#import "YXCADisplayLinkHolder.h"



@interface YXFlyBall()<YXCADisplayLinkHolderDelegate>
{

    CGFloat _xRun;             //水平方向偏移的距离
    CGPoint _rippleStartPoint; //球脱离水面的点
    CGPoint _rippleEndPoint;   //球进入水面的点
    CGFloat _rippleStartDelay; //水波开始的点
    CGFloat _rippleEndDelay;   //水波结束的点
    CGFloat _rippleStartHV;    //水纹开始的点 垂直方向的速度
    CGFloat _rippleEndHV;      //水纹结束的点 垂直方向的速度
    
    CGFloat _verticalV;        //垂直速度
    CGFloat _horizontalV;      //水平速度
    CGFloat _time;             //运行的时间
    CGFloat _h;                //最低点到最高点的高度
    CGFloat _duration;         //持续时间
    BOOL    _isRight;          //YES:向右加 NO: 向左 加

    
    CAShapeLayer          *_ballLayer;
    UIBezierPath          *_ballPath;
    YXCADisplayLinkHolder *_displayLinkHolder;
    
}


- (void)calculateMath;

- (void)clean;

@end

@implementation YXFlyBall

#pragma mark -
#pragma mark - init 

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        _ballLayer             = [CAShapeLayer layer];

        _ballLayer             = [CAShapeLayer layer];
        _ballLayer.fillColor   = [UIColor greenColor].CGColor;
        _ballLayer.strokeColor = [UIColor greenColor].CGColor;
        _ballLayer.lineWidth   = 1;
        _ballLayer.strokeStart = 0.0f;
        _ballLayer.strokeEnd   = 1.0f;
        _ballLayer.lineJoin    = kCALineJoinRound;
        _ballLayer.lineCap     = kCALineCapRound;
        
        
        _ballPath              = [[UIBezierPath alloc] init];
        _displayLinkHolder     = [[YXCADisplayLinkHolder alloc] init];
        
        _a = -3.0f;
        _g = 10.0f;
    }
    
    return self;
}

#pragma mark -
#pragma mark - private 

- (void)clean
{
    [_displayLinkHolder stop];
    
    if (_backgroundView && nil != _ballLayer.superlayer)
    {
        [_ballLayer removeFromSuperlayer];
    }
}

- (void)calculateMath
{
    _ballLayer.fillColor   = _ballColor.CGColor;
    _ballLayer.strokeColor = _ballColor.CGColor;
    _ballLayer.frame = _backgroundView.bounds;
    
    [_backgroundView.layer addSublayer:_ballLayer];
    
    _time        = -_delay;
    _h           = _top + _startPoint.y;
    _isRight     = (_endPoint.x - _startPoint.x) > 0?YES:NO;
    _xRun        = (CGFloat)(fabs(_startPoint.x - _endPoint.x));
    
    /*防止出现nan值*/
    if (_xRun == 0)
    {
        _xRun = 0.001f;
    }
    
    /*      ______
     * t = | 2h/g
           `
     */
    {
    
        _duration = sqrt(2 * _h / _g) * 2;
    }
    
    /*
     * v = a * t;
     */
    {
        _verticalV =  _g * _duration / 2.0f;
    }
    
    /*
     * v0 = (s - 1/2 * a * t^2) / t;
     */
    {
        _horizontalV = (_xRun - 0.5f * _a * _duration * _duration ) / _duration;
    }
    
    
    /*
     * 波纹开始和结束  的点,延迟的时间, 速度
     */
    {
        CGFloat rippleStartY = _startPoint.y;
        CGFloat rippleEndY   = _startPoint.y - _radius;
        
        
        /*因为 rippleStartY  rippleEndY 必然是在水面下 设定就是这样 所以肯定有解*/
         _rippleStartDelay = (- _verticalV + sqrt(_verticalV * _verticalV - 2 * _g * rippleStartY)) / (-_g);
         _rippleEndDelay   = (- _verticalV - sqrt(_verticalV * _verticalV - 2 * _g * rippleEndY))   / (-_g);
        
        CGFloat rippleOffsetStartX = _horizontalV * _rippleStartDelay + 0.5f * _a * _rippleStartDelay * _rippleStartDelay;
        rippleOffsetStartX = _isRight?rippleOffsetStartX :-rippleOffsetStartX;
        
        CGFloat rippleOffsetEndX = _horizontalV * _rippleEndDelay + 0.5f * _a * _rippleEndDelay * _rippleEndDelay;
        rippleOffsetEndX = _isRight?rippleOffsetEndX :-rippleOffsetEndX;
        
        _rippleStartPoint = CGPointMake(_startPoint.x + rippleOffsetStartX,0.0f);
        _rippleEndPoint   = CGPointMake(_startPoint.x + rippleOffsetEndX,  _radius);
        
        _rippleStartHV    = _verticalV - _g * _rippleStartDelay;
        _rippleEndHV      = _g * (_rippleEndDelay - _duration / 2.0f);
    }

}

- (void)drawFlyWithTime: (NSTimeInterval) time
{
    _time += time;
    
    if (_time < 0) return;
    
    if (_time >= _duration)
    {
        _time = _duration;
    }
    
    /*
     * s=V0*t+1/2*a*t^2
     */
    
    CGFloat xBallOffset = _horizontalV * _time + 0.5f * _a * _time * _time;
    xBallOffset = _isRight?xBallOffset :-xBallOffset;
    
    CGFloat yBallOffset = -(_verticalV * _time -  0.5f * _g * _time * _time) + _startPoint.y;
    
    
    /*ball*/
    {
        _ballPath = [[UIBezierPath alloc] init];
        CGPoint ballPoint = CGPointMake(_startPoint.x + xBallOffset,yBallOffset);
        _currentBallPoint = ballPoint;
        [_ballPath moveToPoint:ballPoint];
        [_ballPath addArcWithCenter:ballPoint radius:_radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
        
        _ballLayer.path = _ballPath.CGPath;
    }
    
    _finish = _time>= _duration;
    
}

#pragma mark -
#pragma mark - public

- (void)reset
{
    [self calculateMath];
}

- (void)startFly
{
    [self calculateMath];
    
    [_displayLinkHolder startCADisplayLinkWithDelegate:self];

}


- (void)stopFly
{
    [self clean];
    
    if (_delegate && [_delegate respondsToSelector:@selector(YXFlyBallFnish:ball:)])
    {
        [_delegate YXFlyBallFnish:_finish ball:self];
    }
}

#pragma mark - 
#pragma mark - get set 

- (CGPoint)rippleStartPoint
{
    return _rippleStartPoint;
}

- (CGPoint)rippleEndPoint
{
    return _rippleEndPoint;
}


- (CGFloat)rippleStartDelay
{
    return _rippleStartDelay + _delay;
}

- (CGFloat)rippleEndDelay
{
    return _rippleEndDelay + _delay;
}


- (CGFloat)rippleStartHV
{
    return _rippleStartHV;
}

- (CGFloat)rippleEndHV
{
    return _rippleEndHV;
}


- (CGFloat)duration
{
    return _duration;
}


#pragma mark -
#pragma mark - YXCADisplayLinkHolderDelegate

- (void)onDisplayLinkFire:(YXCADisplayLinkHolder *)holder interval:(NSTimeInterval)interval displayLink:(CADisplayLink *)displayLink
{
    [self drawFlyWithTime:interval];
}


#pragma mark -
#pragma mark - dealloc

- (void)dealloc
{
    [self clean];
}

@end






























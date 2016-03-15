//
//  YXFlyBubbleView.m
//  testBubble
//
//  Created by 沈 晨豪 on 15/7/16.
//  Copyright (c) 2015年 sch. All rights reserved.
//

#import "YXFlyBalManageView.h"
#import "YXCADisplayLinkHolder.h"
#import "YXFlyBall.h"
#import "YXRipplePointModel.h"


@interface YXFlyBalManageView()<YXCADisplayLinkHolderDelegate>
{
    NSMutableArray        *_ballArray;
    
    YXCADisplayLinkHolder *_displayLinkHolder;
    NSLock                *_lock;
    
    CAShapeLayer          *_waterShapeLayer;
    NSMutableArray        *_waterEffectPointModelArray;  //需要产生影响的点
    
    CGFloat                _createTime;
    BOOL                   _canCreateBall;
    
}

- (void)initData;

- (void)createFlyBall;


@end

@implementation YXFlyBalManageView

#pragma mark -
#pragma mark - private 

- (void)initData
{
    
    {
        _frequency    = 1.0f;
        _createTime   = 0.0f;
        
        _minRadius    = 1.0f;
        _maxRadius    = 5.0f;
        
        _minTop       = 25.0f;
        _maxTop       = 45.0f;
        
        
        _speed        = 1.0f;
        _startOffsetY = 5.0f;
        
        _count        = 2;
        _k            = 1000;
        _p            = 20;
        _g            = 50.0f;
        _multipleDiameter = 2;
        
        _ballColor   = [UIColor colorWithRed:95.0f / 255.0f green:151.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f];
        _waterColor  = [UIColor colorWithRed:95.0f / 255.0f green:151.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f];
        
    }
    
    
    {
        _displayLinkHolder     = [[YXCADisplayLinkHolder alloc] init];
        
        _ballArray                 = [@[] mutableCopy];
        _lock                  = [[NSLock alloc] init];
        
        _waterEffectPointModelArray = [@[] mutableCopy];
    }
    
    {
        _waterShapeLayer             = [CAShapeLayer layer];
        
        _waterShapeLayer             = [CAShapeLayer layer];
        _waterShapeLayer.fillColor   = _waterColor.CGColor;
        _waterShapeLayer.strokeColor = _waterColor.CGColor;
        _waterShapeLayer.lineWidth   = 1.0f/ [UIScreen mainScreen].scale;
        _waterShapeLayer.strokeStart = 0.0f;
        _waterShapeLayer.strokeEnd   = 1.0f;
        _waterShapeLayer.lineJoin    = kCALineJoinRound;
        _waterShapeLayer.lineCap     = kCALineCapRound;
        _waterShapeLayer.frame       = self.bounds;
        [self.layer addSublayer:_waterShapeLayer];
    }
}

- (void)createFlyBallBySelf
{
    CGFloat radius;
    
    CGFloat tempMinRadius = MIN(_minRadius, _maxRadius);
    CGFloat tempMaxRadius = MAX(_minRadius, _maxRadius);
    
    if (tempMinRadius == tempMaxRadius)
    {
        radius = tempMinRadius;
    }
    else
    {
        radius = ((CGFloat)(random() %((NSInteger)((tempMaxRadius - tempMinRadius)  * 10000.0f)))) / 10000.0f + tempMinRadius;
        
        
    }
    
    CGFloat top;
    
    CGFloat tempMinTop = MIN(_minTop, _maxTop);
    CGFloat tempMaxTop = MAX(_minTop, _maxTop);
    
    if (tempMinTop == tempMaxTop)
    {
        top = tempMinTop;
    }
    else
    {
        top = ((CGFloat)(random() %((NSInteger)((tempMaxTop - tempMinTop)  * 10000.0f)))) / 10000.0f + tempMinTop;
    }
    
    
    CGFloat startX = radius +  random() %((NSInteger)(self.bounds.size.width - 2 * radius - 2.0f));
    CGFloat endX   = radius +  random() %((NSInteger)(self.bounds.size.width - 2 * radius - 2.0f));
    CGPoint startPoint = CGPointMake(startX, radius + _startOffsetY);
    CGPoint endPoint   = CGPointMake(endX, radius + _startOffsetY) ;
    
    YXFlyBall *ball = [[YXFlyBall alloc] init];
    
    ball.radius         = radius;
    ball.startPoint     = startPoint;
    ball.endPoint       = endPoint;
    ball.top            = top;
    ball.ballColor      = _ballColor;
    ball.backgroundView = self;
    ball.a              = -3 * _speed;
    ball.g              = _g * _speed;
    [_ballArray addObject:ball];
    
    [ball reset];
    
    [self createRipplePointWihtBall:ball];
}

- (void)createFlyBallByProtocol
{
    
    NSArray *array = [_createProtocol getCreateFlyBallWithWidth:self.bounds.size.width view:self ballColor:_ballColor];
    
    [_ballArray addObjectsFromArray:array];
    
    for (YXFlyBall *ball in array)
    {
        [self createRipplePointWihtBall:ball];
    }
}

- (void)createFlyBall
{
    if (!_canCreateBall) return;
    
    if (nil != _createProtocol && [_createProtocol respondsToSelector:@selector(getCreateFlyBallWithWidth:view:ballColor:)])
    {
        [self createFlyBallByProtocol];
        return;
    }
    
    
    [self createFlyBallBySelf];
    
}

- (void)createRipplePointWihtBall: (YXFlyBall *)ball
{
    YXRipplePointModel *modelStart = [YXRipplePointModel new];
    modelStart.up       = YES;
    
    modelStart.delay      = ball.rippleStartDelay;
    modelStart.startPoint = ball.rippleStartPoint;
    modelStart.v          = ball.rippleStartHV;
    modelStart.count      = _count;
    modelStart.p          = _p;
    modelStart.k          = _k;
    modelStart.width      = self.bounds.size.width;
    modelStart.radius     = ball.radius;
    modelStart.multipleDiameter = _multipleDiameter;
    [modelStart reset];
    
    
    YXRipplePointModel *modelEnd = [YXRipplePointModel new];
    modelEnd.up       = NO;
    
    modelEnd.delay      = ball.rippleEndDelay;
    modelEnd.startPoint = ball.rippleEndPoint;
    modelEnd.v          = ball.rippleEndHV;
    modelEnd.count      = _count;
    modelEnd.p          = _p;
    modelEnd.k          = _k;
    modelEnd.width      = self.bounds.size.width;
    modelEnd.radius     = ball.radius;
    modelEnd.multipleDiameter = _multipleDiameter;
    [modelEnd reset];
    
    [_waterEffectPointModelArray addObject:modelStart];
    [_waterEffectPointModelArray addObject:modelEnd];
}


- (void)createWaterPathWithInterval: (NSTimeInterval) interval
{
    NSMutableDictionary *allPointDic = [@{} mutableCopy];
    
    for (YXRipplePointModel *model in _waterEffectPointModelArray)
    {
        NSDictionary *dic = [model getPointWithTime:interval];
        
        for (NSNumber *key in dic.allKeys)
        {
            NSNumber *value  = dic[key];
            NSNumber *value2 = allPointDic[key];
            
            if (nil != value2)
            {
                value = @([value floatValue] + [value2 floatValue]);
            }
            
            allPointDic[key] = value;
        }
    }
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(self.bounds.size.width, 0.0f)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [path addLineToPoint:CGPointMake(0.0f, self.bounds.size.height)];
    [path addLineToPoint:CGPointMake(0.0f, 0.0f)];
    for (NSInteger i = 0; i <= self.bounds.size.width; ++i)
    {
        CGPoint   point;
        NSNumber *value = allPointDic[@(i)];
        
        if (nil != value)
        {
            CGFloat y = [value floatValue];
            
            if (y > self.bounds.size.height)
            {
                y = self.bounds.size.height;
            }
            
            point = CGPointMake(i, y);
            //NSLog(@"%@",NSStringFromCGPoint(point));
        }
        else
        {
            point = CGPointMake(i, 0.0f);
        }
        
        
        
        [path addLineToPoint:point];
    }
    
    
    _waterShapeLayer.path = path.CGPath;
    
}

- (void)removeFinishDraw
{
    {
        NSMutableArray *removeArray = [@[] mutableCopy];
        
        for (YXFlyBall *ball in _ballArray)
        {
            if (ball.finish)
            {
                [removeArray addObject:ball];
            }
            
        }
        
        for (YXFlyBall *ball in removeArray)
        {
            [_ballArray removeObject:ball];
        }
    
    }
    
    {
        NSMutableArray *removeArray = [@[] mutableCopy];
        for (YXRipplePointModel *model in _waterEffectPointModelArray)
        {

            if (model.finish)
            {
                [removeArray addObject:model];
            }

        }

        for (YXRipplePointModel *model in removeArray)
        {
            [_waterEffectPointModelArray removeObject:model];
        }
    }
    
}

- (void)draw: (NSTimeInterval) interval
{
    for (YXFlyBall *ball in _ballArray)
    {
        [ball drawFlyWithTime:interval];
    }
    
    [self createWaterPathWithInterval:interval];
    
    if (_waterEffectPointModelArray.count <= 0 && _ballArray.count <= 0 )
    {
        [_displayLinkHolder stop];
    }
    
}

- (void)drawWithTime: (NSTimeInterval) interval
{
    [self removeFinishDraw];
    [self draw:interval];
    
}

#pragma mark -
#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initData];
    }
    
    return self;
}

#pragma mark -
#pragma mark - awakeFromNib

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initData];
}


#pragma mark -
#pragma mark - layoutSubviews

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _waterShapeLayer.frame  = self.bounds;
}

#pragma mark -
#pragma mark - public

- (void)reset
{
    [_displayLinkHolder stop];
    [_ballArray removeAllObjects];
    [_waterEffectPointModelArray removeAllObjects];
    [self draw:0.0f];
}

- (void)startFly;
{
    _canCreateBall = YES;
    [self createFlyBall];
    [_displayLinkHolder startCADisplayLinkWithDelegate:self];
}

- (void)stopFly
{
    _createTime    = 0.0f;
    _canCreateBall = NO;
}

#pragma mark - 
#pragma mark - YXCADisplayLinkHolderDelegate

- (void)onDisplayLinkFire:(YXCADisplayLinkHolder *)holder interval:(NSTimeInterval)interval displayLink:(CADisplayLink *)displayLink
{
    _createTime += interval;
    
    CGFloat tempFrequency = 0.0f;
    
    if (nil != _createProtocol)
    {
        tempFrequency = [_createProtocol frequency];
    }
    else
    {
        tempFrequency = _frequency;
    }
    
    if (_createTime >= tempFrequency)
    {
        
        NSInteger count = (NSInteger)(_createTime/tempFrequency + 0.5f);
        _createTime = 0.0f;

        for (NSInteger i = 0; i < count; ++i)
        {
            [self createFlyBall];
        }
    }
    
    [self drawWithTime:interval];
}


#pragma mark - 
#pragma mark - dealloc 

- (void)dealloc
{
    [_displayLinkHolder stop];
}



@end

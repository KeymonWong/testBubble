//
//  YXRipplePointModel.m
//  testBubble
//
//  Created by 沈 晨豪 on 15/7/28.
//  Copyright (c) 2015年 sch. All rights reserved.
//

#import "YXRipplePointModel.h"


@interface YXRipplePointModel()

@property (nonatomic,assign) CGFloat time;

@end

@implementation YXRipplePointModel
{
    NSMutableArray *_xArray;      //能起飞的点的array
    NSMutableArray *_topArray;    //每个x对应最高点的Array
    NSInteger       _centerX;     //中心点
    NSInteger       _centerIndex; //中心点的索引
    CGFloat         _ySinFactor;
    CGFloat         _a;           //为 1.0f 或者 -1.0f; 向上为1.0f 向下为-1.0f
    CGFloat         _duration;    //持续的时间 自行计算
    CGFloat         _top;         //最高点
    CGFloat         _m;           //质量

}


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _xArray           = [@[] mutableCopy];
        _topArray         = [@[] mutableCopy];
        _count            = 3;
        _k                = 1000.0f;
        _p                = 100.0f;
        _multipleDiameter = 2;
    }
    
    return self;
}

- (void)reset
{
    _time      = - _delay;
    
    /*计算 次数 时间 的一些 因子*/
    {
        _a          = _up?-1.0f:1.0f;
        
        _m          = M_PI * powf(_radius, 2) * _p;
        
        /*    ___________
          x =|m * v^2 / k
         
         */
        
        _top = sqrtf(_m * _v * _v / _k) / 40.0f;
        
        
        /*               __
           t = 2 * pi * |m/k     
         */
        
        _duration  = 2 * M_PI * sqrtf(_m / _k) / 50.0f *_count;
        
        if (_duration < 0.4f)
        {
            _duration = 0.4f;
        }
        
        CGFloat d = _duration;
        for (NSInteger i = 1; i < _count; ++i)
        {
            d = d / 2.0f;
            
            _duration += d;
        }
        
        
        
        _ySinFactor =   ((CGFloat)_count) *2 * M_PI  / _duration;
    }
    
    [_xArray   removeAllObjects];
    [_topArray removeAllObjects];
    
    /*转化为整数*/
    NSInteger  centerX = (NSInteger)(_startPoint.x + 0.5f);
    NSInteger  offsetX = (NSInteger)(_radius + 0.5f) * 2 * _multipleDiameter;
    


    /*往前算*/
    for (NSInteger i = 1; i <= offsetX; ++i)
    {
        if (centerX - i < 0)
        {
            break;
        }
        
        [_xArray insertObject:@(centerX - i) atIndex:0];
    }

    
    _centerIndex = _xArray.count;
    
    CGFloat   factor  = 1.0f / ((CGFloat)(_xArray.count + 1))  * M_PI;
    
    for (NSInteger i = 0; i <_xArray.count ; ++i)
    {

        
        CGFloat tempTop = _top / 2.0f * sin(factor * ((CGFloat)i) - M_PI_2) + _top * 0.5f;
        

        [_topArray addObject:@(tempTop)];
    }
    
    /*中间点*/
    [_xArray addObject:@(centerX)];
    [_topArray addObject:@(_top )];
    
    /*往后算*/
    for (NSInteger i = 1; i <= offsetX; ++i)
    {
        if (centerX + i > _width)
        {
            break;
        }
        
        [_xArray addObject:@(centerX +i)];
    }
    
    
    NSInteger count = _xArray.count - _centerIndex - 1;
    factor = 1.0f/((CGFloat)(count + 1)) * M_PI ;
    
    for (NSInteger i = 0; i < count; ++i)
    {
        
        CGFloat tempTop = _top / 2.0f * sin(factor * ((CGFloat)(i + 1)) + M_PI_2) +  _top * 0.5f ;

        [_topArray addObject:@(tempTop)];

    }

}

- (NSDictionary *)getPointWithTime: (NSTimeInterval) interval
{
    _time += interval;
    
    if (_time < 0.0f) return [@{} mutableCopy];
    
    if(_time >= _duration)
    {
        _time   = _duration;
        
        _finish = YES;
    }
    
    CGFloat value = 1.0f * (1.0f - _time/_duration * 0.88f);
    
    NSMutableDictionary *dic = [@{} mutableCopy];
    
    
    for (NSInteger i = 0; i < _xArray.count; ++i)
    {
        CGFloat   y     = [_topArray[i] floatValue] * sin(_ySinFactor * _time) * _a * value;

        NSNumber *index = _xArray[i];
        dic[index]      = @(y);
    }

    return dic;
}

@end




















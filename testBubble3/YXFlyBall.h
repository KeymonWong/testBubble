//
//  YXFlyBall.h
//  testBubble
//
//  Created by 沈 晨豪 on 15/7/21.
//  Copyright (c) 2015年 sch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class YXFlyBall;

@protocol YXFlyBallDelegate <NSObject>

- (void)YXFlyBallFnish: (BOOL) finish ball: (YXFlyBall *) ball;
@end

@interface YXFlyBall : NSObject

@property (nonatomic,assign) CGPoint  startPoint;
@property (nonatomic,assign) CGPoint  endPoint;
@property (nonatomic,assign) CGFloat  top;              //距离水面的 最高点
@property (nonatomic,assign) CGFloat  radius;
@property (nonatomic,strong) UIColor *ballColor;        //球的颜色
@property (nonatomic,assign) CGFloat  a;                //只对水平方向做空气阻力 默认 -3.0f
@property (nonatomic,weak  ) UIView  *backgroundView;
@property (nonatomic,assign) CGFloat  g;                //重力  默认 10.0f
@property (nonatomic,assign) CGFloat  delay;            //延迟 默认0.0f

@property (nonatomic,assign) CGPoint  currentBallPoint; //当前的位置
@property (nonatomic,assign) BOOL     finish;           //YES:完成 NO:没有完成


@property (nonatomic,weak  ) id<YXFlyBallDelegate> delegate;

/**
 * 水纹开始的点
 */
- (CGPoint)rippleStartPoint;

/**
 * 水纹结束的点
 */
- (CGPoint)rippleEndPoint;

- (CGFloat)rippleStartDelay;
- (CGFloat)rippleEndDelay;

/**
 * 水纹开始的点 垂直方向的速度
 */
- (CGFloat)rippleStartHV;

/**
 * 水纹结束的点 垂直方向的速度
 */
- (CGFloat)rippleEndHV;

/**
 * 持续时间
 */
- (CGFloat)duration;


/**
 * 1: 自主运动
 */
- (void)startFly;
- (void)stopFly;

/**
 * 2:外部赋值运动
 */
- (void)reset;
- (void)drawFlyWithTime: (NSTimeInterval) time;


@end










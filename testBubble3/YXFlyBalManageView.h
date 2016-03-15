//
//  YXFlyBubbleView.h
//  testBubble
//
//  Created by 沈 晨豪 on 15/7/16.
//  Copyright (c) 2015年 sch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol YXFlyBallCreateProtocol <NSObject>

@required

- (CGFloat)frequency;
- (NSArray *)getCreateFlyBallWithWidth: (CGFloat) width view: (UIView *) view ballColor: (UIColor *) color;

@end

@interface YXFlyBalManageView : UIView

/**
 * 频率 默认是 1.0f
 */
@property (nonatomic,assign) CGFloat  frequency;

/**
 * 球的最小的半径  默认 1.0f
 */
@property (nonatomic,assign) CGFloat  minRadius;

/**
 * 球的最大的半径  默认 5.0f
 */
@property (nonatomic,assign) CGFloat  maxRadius;


@property (nonatomic,assign) CGFloat  speed; //速度

/**
 * 出发点 y的偏移量 默认 5.0f
 */
@property (nonatomic,assign) CGFloat  startOffsetY;

/**
 * 球的最大的飞行最低点  默认 25.0f
 */
@property (nonatomic,assign) CGFloat  minTop;

/**
 * 球的最大的飞行最高点  默认 45.0f
 */
@property (nonatomic,assign) CGFloat  maxTop;

@property (nonatomic,strong) UIColor *ballColor;
@property (nonatomic,strong) UIColor *waterColor;

/**
 * 震荡的次数 默认 2次
 */
@property (nonatomic,assign) NSInteger count;

/**
 * 弹性系数 默认 1000.0f;
 */
@property (nonatomic,assign) CGFloat   k;

/**
 * 密度系数 默认是 20.0f
 */
@property (nonatomic,assign) CGFloat   p;

/**
 * 重力 默认是 50.0f
 */
@property (nonatomic,assign) CGFloat   g;

/**
 * 波纹受影响的直径倍数 默认是 2
 */
@property (nonatomic,assign) NSInteger   multipleDiameter;

/**
 * 默认是 nil  如果有: 遵从协议创建的方式 不遵循上面的物理参数    没有: 就随机生成 遵循上面的设定的好的 物理参数
 */
@property (nonatomic,strong) id<YXFlyBallCreateProtocol> createProtocol;


- (void)reset;

- (void)startFly;
- (void)stopFly;

@end













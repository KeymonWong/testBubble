//
//  YXRipplePointModel.h
//  testBubble
//
//  Created by 沈 晨豪 on 15/7/28.
//  Copyright (c) 2015年 sch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YXRipplePointModel : NSObject

@property (nonatomic,assign) CGFloat   width;             //水面宽度
@property (nonatomic,assign) CGPoint   startPoint;        //开始的点
@property (nonatomic,assign) CGFloat   radius;            //球的半径
@property (nonatomic,assign) NSInteger count;             //震荡的次数 默认 3次
@property (nonatomic,assign) CGFloat   v;                 //速度
@property (nonatomic,assign) BOOL      up;                //YES:向上 NO:向下
@property (nonatomic,assign) CGFloat   delay;             //延迟的时间 默认0.0f
@property (nonatomic,assign) CGFloat   k;                 //弹性系数 默认 1000.0f;
@property (nonatomic,assign) CGFloat   p;                 //密度系数 默认是 100.0f
@property (nonatomic,assign) NSInteger multipleDiameter;  //半径的倍数 默认 2

@property (nonatomic,assign,readonly) CGFloat   time;     //进行了多长时间

@property (nonatomic,assign) CGFloat   finish;            //YES:完成 NO:没完成

- (void)reset;
- (NSDictionary *)getPointWithTime: (NSTimeInterval) interval;

@end

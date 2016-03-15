//
//  YXBubbleView.h
//  testBubble
//
//  Created by 沈 晨豪 on 15/7/15.
//  Copyright (c) 2015年 sch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXBubbleView : UIView

/**
 * 默认 1.0f
 */
@property (nonatomic,assign) CGFloat speed;

/**
 * 默认 2秒
 */
@property (nonatomic,assign) CGFloat duration;

/**
 * 扩展的长度 默认 100.0f
 */
@property (nonatomic,assign) CGFloat expansionLength;

- (void)reset;

- (void)showBubbleView: (void (^)(BOOL finish)) finishBlock;

@end

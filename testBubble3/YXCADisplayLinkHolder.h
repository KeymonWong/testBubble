//
//  YXCADisplayLinkHolder.h
//  testBubble
//
//  Created by 沈 晨豪 on 15/7/15.
//  Copyright (c) 2015年 sch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YXCADisplayLinkHolder;

@protocol YXCADisplayLinkHolderDelegate <NSObject>

- (void)onDisplayLinkFire: (YXCADisplayLinkHolder *) holder interval: (NSTimeInterval) interval displayLink:(CADisplayLink *) displayLink;

@end


@interface YXCADisplayLinkHolder : NSObject

@property (nonatomic,weak  ) id<YXCADisplayLinkHolderDelegate> delegate;
@property (nonatomic,strong) NSDictionary   *info;


- (void)startCADisplayLinkWithDelegate: (id<YXCADisplayLinkHolderDelegate>) delegate;

- (void)stop;

@end


























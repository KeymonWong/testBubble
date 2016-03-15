//
//  YXCADisplayLinkHolder.m
//  testBubble
//
//  Created by 沈 晨豪 on 15/7/15.
//  Copyright (c) 2015年 sch. All rights reserved.
//

#import "YXCADisplayLinkHolder.h"


@implementation YXCADisplayLinkHolder
{
    CADisplayLink *_displayLink;
}


- (void)startCADisplayLinkWithDelegate:(id<YXCADisplayLinkHolderDelegate>)delegate
{
    [self stop];
    
    _delegate = delegate;
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink:)];
    
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

}

- (void)stop
{
    if (_displayLink)
    {
        [_displayLink invalidate];
        
        _displayLink = nil;
    }
}

#pragma mark -
#pragma mark - onDisplayLink

- (void)onDisplayLink: (CADisplayLink *) displayLink
{
    if (_delegate && [_delegate respondsToSelector:@selector(onDisplayLinkFire:interval:displayLink:)])
    {
        [_delegate onDisplayLinkFire:self
                            interval:displayLink.duration
                         displayLink:displayLink];
    }
}


#pragma mark - 
#pragma mark - dealloc

- (void)dealloc
{
    [self stop];
    _delegate = nil;
}

@end

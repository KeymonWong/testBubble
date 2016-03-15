//
//  YXBubbleView.m
//  testBubble
//
//  Created by 沈 晨豪 on 15/7/15.
//  Copyright (c) 2015年 sch. All rights reserved.
//

#import "YXBubbleView.h"
#import "YXCADisplayLinkHolder.h"

@interface YXBubbleView()<YXCADisplayLinkHolderDelegate>
{
    YXCADisplayLinkHolder *_displayLinkHolder;
    CAShapeLayer          *_shapeLayer;
    UIBezierPath          *_path;
}

@property (nonatomic,copy)  void (^finishBlock)(BOOL finish) ;

- (void)initData;
- (void)initUI;

@end

@implementation YXBubbleView


#pragma mark -
#pragma mark - private 

- (void)initData
{
    _speed             = 1.0f;
    _duration          = 2.0f;
    _displayLinkHolder = [YXCADisplayLinkHolder new];
    _expansionLength   = 100.0f;
}

- (void)initUI
{
    _shapeLayer             = [CAShapeLayer layer];
    _shapeLayer.fillColor   = [UIColor greenColor].CGColor;
    _shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    _shapeLayer.lineWidth   = 1;
    _shapeLayer.strokeStart = 0.0f;
    _shapeLayer.strokeEnd   = 1.0f;
    _shapeLayer.lineJoin    = kCALineJoinRound;
    _shapeLayer.lineCap     = kCALineCapRound;
    
    _shapeLayer.frame       = self.bounds;
    
    [self.layer addSublayer:_shapeLayer];
    
    [self drawBubble:0.0f];
    
}

#pragma mark -
#pragma mark - init 

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initData];
        [self initUI];
    }
    
    return self;
}

#pragma mark - 
#pragma mark - awakeFromNib

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initData];
    [self initUI];
    
    
   
}

#pragma mark -
#pragma mark -  public

- (void)reset
{
    if (_finishBlock)
    {
        _finishBlock(NO);
        _finishBlock = nil;
    }
    
    [self drawBubble:0.0f];
}

- (void)showBubbleView:(void (^)(BOOL))finishBlock
{
    self.finishBlock = finishBlock;
    [_displayLinkHolder startCADisplayLinkWithDelegate:self];
}



#pragma mark -
#pragma mark - layoutSubviews

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _shapeLayer.frame = self.bounds;
}

#pragma mark - 
#pragma mark - drawRect

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}


#pragma mark -
#pragma mark - onDisplayLinkFire

- (void)onDisplayLinkFire:(YXCADisplayLinkHolder *)holder interval:(NSTimeInterval)interval displayLink:(CADisplayLink *)displayLink
{
    static CGFloat addValue = 0.0f;
    
    addValue += interval * _expansionLength /_duration;
    CGFloat value = addValue;
    if (addValue >=_expansionLength)
    {
        addValue = _expansionLength;
        addValue = 0.0f;
        value    = _expansionLength;
        [holder stop];
        
        if (_finishBlock)
        {
            _finishBlock(YES);
            _finishBlock = nil;
        }
    }
    
    [self drawBubble:value];
    
}

/**
 *
  __cp1___cp2___
 (__cp2___cp1___)
 *
 **/

- (void)drawBubble:(CGFloat) value
{
    _path = [[UIBezierPath alloc] init];
  
    
    
    CGFloat startPointOffSetX  = 0.0f;
    CGFloat startPointOffsetY  = 0.0f;
    CGFloat endPointOffSetX    = 0.0f;
    CGFloat endPointOffsetY    = 0.0f;
    CGFloat radiusOffset1      = 0.0f;
    CGFloat radiusOffset2      = 0.0f;
    
    /*top 线 cp1 cp2*/
    CGFloat line1PointScaleX1  = 1/3.0f;
    CGFloat line1PointOffsetY1  = 0.0f;
    CGFloat line1PointScaleX2 = 2/3.0f;
    CGFloat line1PointOffSetY2 = 0.0f;
    
    /*bottom 线 cp1 cp2*/
    CGFloat line2PointScaleX1 = 2/3.0f;
    CGFloat line2PointOffsetY1 = 0.0f;
    CGFloat line2PointScaleX2 = 1/3.0f;
    CGFloat line2PointOffSetY2 = 0.0f;
    

    
    if (0 == value || _expansionLength == value )
    {
        startPointOffSetX = -value;
    }
    /*开始计算*/
    else
    {
        startPointOffSetX = -value;
        
        /*radiusOffset2 endPointOffsetY*/
        if (value < _expansionLength / 2.0f)
        {
            CGFloat pi = value/_expansionLength * 2* M_PI;
            
            radiusOffset2 = 2 * sin(pi);
            
            pi  = value / _expansionLength * 4 * M_PI;
            
            endPointOffsetY = 2 * sin(pi);
        }
        
        /*radiusOffset1*/
        
        if (value > _expansionLength / 2.0f)
        {
            CGFloat pi = (value - _expansionLength / 2.0f)/ (_expansionLength / 2.0f) * 2* M_PI;
            
            radiusOffset1 = 3 * sin(pi - M_PI);
    
        }

        
        /*startPointOffsetY*/
        if (value > _expansionLength / 4.0f)
        {
            CGFloat pi = (value - _expansionLength/4)/(_expansionLength/4)  * M_PI;
            startPointOffsetY = -5 * sin(pi);
        }
        
        /*line1PointOffSetY2*/
        {
            CGFloat pi = value/_expansionLength * 6 * M_PI;
            
            line1PointOffSetY2 = 2 *sin(pi);
        }
        
        
        /*line2PointOffsetY1*/
        {
            CGFloat pi = value/_expansionLength * 6 * M_PI;
            
            line2PointOffsetY1 = 2 *cos(pi);
        }
 
    }
    
    CGFloat radius1     = self.bounds.size.height / 2.0f + radiusOffset1;
    CGFloat radius2     = self.bounds.size.height / 2.0f + radiusOffset2;
    
    
    CGPoint startPoint  = CGPointMake(0.0f + startPointOffSetX + radius1,self.bounds.size.height / 2.0f + startPointOffsetY) ;
    CGPoint endPoint    = CGPointMake(self.bounds.size.width + endPointOffSetX - radius2, self.bounds.size.height / 2.0f + endPointOffsetY);
    
    CGFloat pointLength = endPoint.x - startPoint.x;

    
    /*top cp1 cp2*/
    CGPoint line1CP1     = CGPointMake(startPoint.x + pointLength * line1PointScaleX1, startPoint.y - radius1 + line1PointOffsetY1);
    CGPoint line1CP2     = CGPointMake(startPoint.x + pointLength * line1PointScaleX2, endPoint.y - radius2 + line1PointOffSetY2);
    
    /*top cp1 cp2*/
    CGPoint line2CP1     = CGPointMake(startPoint.x + pointLength * line2PointScaleX1, endPoint.y + radius2 + line2PointOffsetY1);
    CGPoint line2CP2     = CGPointMake(startPoint.x + pointLength * line2PointScaleX2, startPoint.y + radius1 + line2PointOffSetY2);
    
    [_path moveToPoint:startPoint];
    [_path addArcWithCenter:startPoint radius:radius1  startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    [_path moveToPoint:endPoint];
    [_path addArcWithCenter:endPoint radius:radius2  startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    [_path moveToPoint:CGPointMake(startPoint.x , startPoint.y - radius1)];
    [_path addCurveToPoint:CGPointMake(endPoint.x , endPoint.y - radius2) controlPoint1:line1CP1 controlPoint2:line1CP2];
    
    [_path addLineToPoint:CGPointMake(endPoint.x,endPoint.y + radius2)];
    [_path addCurveToPoint:CGPointMake(startPoint.x,  startPoint.y + radius1) controlPoint1:line2CP1 controlPoint2:line2CP2];
    [_path addLineToPoint:CGPointMake(startPoint.x, startPoint.y - radius1)];
   // [_path stroke];
    
    _shapeLayer.path = _path.CGPath;

}

#pragma mark -
#pragma mark -dealloc 

- (void)dealloc
{
    if (_displayLinkHolder)
    {
        [_displayLinkHolder stop];
    }
}

@end

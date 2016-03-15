//
//  ViewController.m
//  testBubble3
//
//  Created by 沈 晨豪 on 15/7/31.
//  Copyright (c) 2015年 sch. All rights reserved.
//

#import "ViewController.h"
#import "YXFlyBalManageView.h"

@interface ViewController ()

@property (nonatomic,weak) IBOutlet YXFlyBalManageView *manageView;
@property (nonatomic,weak) IBOutlet UILabel            *label;


@property (nonatomic,weak) IBOutlet UILabel *gLabel;
@property (nonatomic,weak) IBOutlet UILabel *pLabel;
@property (nonatomic,weak) IBOutlet UILabel *kLabel;
@property (nonatomic,weak) IBOutlet UILabel *countLabel;
@property (nonatomic,weak) IBOutlet UILabel *minTopLabel;
@property (nonatomic,weak) IBOutlet UILabel *maxTopLabel;
@property (nonatomic,weak) IBOutlet UILabel *minRadiusLabel;
@property (nonatomic,weak) IBOutlet UILabel *maxRadiusLabel;
@property (nonatomic,weak) IBOutlet UILabel *diameterLabel;

@end

@implementation ViewController


- (IBAction)changeValue:(id)sender
{
    UISlider *s = (UISlider *)sender;
    
    switch (s.tag)
    {
        case 1:
        {
            _manageView.g = s.value;
            _gLabel.text = [NSString stringWithFormat:@"g:%0.1f",s.value];
        }
            break;
        case 2:
        {
            _manageView.p = s.value;
            _pLabel.text = [NSString stringWithFormat:@"p:%0.1f",s.value];
        }
            break;
        case 3:
        {
            _manageView.k = s.value;
            _kLabel.text  = [NSString stringWithFormat:@"k:%0.1f",s.value];
        }
            break;
        case 4:
        {
            _manageView.count = s.value;
            _countLabel.text  = [NSString stringWithFormat:@"震荡次数:%0.1f",s.value];
        }
            break;
        case 5:
        {
            _manageView.minTop =  floorf(s.value + 0.5f);;
            _minTopLabel.text  = [NSString stringWithFormat:@"最低点:%0.1f",_manageView.minTop ];
        }
            break;
        case 6:
        {
            _manageView.maxTop =  floorf(s.value + 0.5f);;
            _maxTopLabel.text  = [NSString stringWithFormat:@"最高点:%0.1f",_manageView.maxTop];
        }
            break;
        case 7:
        {
            _manageView.minRadius =  floorf(s.value + 0.5f);;
            _minRadiusLabel.text  = [NSString stringWithFormat:@"最小半径:%0.1f",_manageView.minRadius];
        }
            break;
        case 8:
        {
            _manageView.maxRadius = floorf(s.value + 0.5f);
            _maxRadiusLabel.text  = [NSString stringWithFormat:@"最大半径:%0.1f",_manageView.maxRadius];
        }
            break;
            
        case 9:
        {
            _manageView.multipleDiameter = floorf(s.value + 0.5f);
            _diameterLabel.text  = [NSString stringWithFormat:@"直径倍数:%@",@(_manageView.multipleDiameter)];
        }
            break;
            
        default:
            break;
    }
}


- (IBAction)change:(id)sender
{
    UISlider *s = (UISlider *)sender;
    
    if (s.value >= 100.0f)
    {
        CGFloat a = (s.value -100.0f);
        
        if (a < 1.0f)
        {
            a = 1.0f;
        }
        
        _manageView.frequency =  1.0f / a;
    }
    else
    {
        CGFloat a = s.value;
        if (a >= 99.0f)
        {
            a = 99.0f;
        }
        
        _manageView.frequency = 100.0f - a;
        
    }
    
    
    
    _label.text = [NSString stringWithFormat:@"一秒出现个数: %0.6f",1.0f/ _manageView.frequency];
}


- (IBAction)changec: (id)s
{
    static NSInteger i = 0 ;
    
    ++i;
    
    if (i %2)
    {
        _manageView.ballColor = [UIColor clearColor];
    }
    else
    {
        _manageView.ballColor =  [UIColor colorWithRed:95.0f / 255.0f green:151.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f];
    }
    

}

#pragma mark -
#pragma mark - view life

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _manageView.speed     = 9.0f;
    _manageView.maxRadius = 6.0f;
    _manageView.minTop    = 30.0f;
    _manageView.maxTop    = 66.0f;
    _manageView.frequency = 1.0f;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - dealloc

- (void)dealloc
{
    
}


#pragma mark - 
#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    static int i = 0;
    
    if (i%2 == 0)
    {
        [_manageView startFly];
    }
    else
    {
        [_manageView stopFly];
    }
    
    ++i;
    
}

@end

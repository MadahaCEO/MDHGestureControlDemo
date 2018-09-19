//
//  ViewController.m
//  MDHGestureControlDemo
//
//  Created by Apple on 2018/9/19.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import "ViewController.h"
#import "MDHGestureControl.h"

@interface ViewController ()
{
    MDHGestureControl *gestureControl;
}

@property (nonatomic, strong) UIView *smallContainerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self.view addSubview:self.smallContainerView];


   
    gestureControl = [[MDHGestureControl alloc] initWithTargetView:self.smallContainerView];
    NSLog(@"++++++++++  %lu",(unsigned long)gestureControl.panDirection);
}


- (UIView *)smallContainerView {
    if (!_smallContainerView) {
        
        CGFloat width  = CGRectGetWidth(self.view.frame);
        CGFloat height = width*9/16;
        
        _smallContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, width, height)];
        _smallContainerView.backgroundColor = [UIColor orangeColor];
        
    }
    return _smallContainerView;
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [gestureControl removeGesturesOnView:self.smallContainerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

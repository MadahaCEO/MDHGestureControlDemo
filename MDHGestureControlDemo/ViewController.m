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

@property (nonatomic, strong) UIButton  *playBtn;

@property (nonatomic, assign) NSTimeInterval sumTime; /* 拖动的距离和 */
@property (nonatomic, assign) NSTimeInterval playerTotalTime;   /* 视频总时间 */
@property (nonatomic, assign) NSTimeInterval playerCurrentTime; /* 视频当前播放的时间 */


@end

@implementation ViewController



- (UIView *)smallContainerView {
    if (!_smallContainerView) {
        
        CGFloat width  = CGRectGetWidth(self.view.frame);
        CGFloat height = width*9/16;
        
        _smallContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, width, height)];
        _smallContainerView.backgroundColor = [UIColor orangeColor];
        
    }
    return _smallContainerView;
}

- (UIButton *)playBtn {
    
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.frame = CGRectMake(0, 450, self.view.frame.size.width, 50);
        _playBtn.backgroundColor = [UIColor blackColor];
        [_playBtn setTitle:@"移除View注册的所有手势" forState: UIControlStateNormal];
        [_playBtn addTarget: self
                     action: @selector(playBtnClick:)
           forControlEvents: UIControlEventTouchUpInside];
    }
    return _playBtn;
}


- (void)playBtnClick:(UIButton *)button {
    
    [gestureControl removeGesturesOnView:self.smallContainerView];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.playerTotalTime = 600; // 单位 s
    self.playerCurrentTime = 120;
    
    [self.view addSubview:self.smallContainerView];

    [self.view addSubview:self.playBtn];

   
    gestureControl = [[MDHGestureControl alloc] initWithTargetView:self.smallContainerView];
    
    __weak typeof(self)weakSelf = self;
    gestureControl.singleTappedBlock = ^{
        NSLog(@"方法调用 ==========单击==========一般处理 播放控制页面显示/隐藏");
    };
    
    gestureControl.doubleTappedBlock = ^{
        NSLog(@"方法调用 ==========双击==========一般处理暂停/播放");
    };
    
    gestureControl.startBlock = ^(MDHPanDimension panDimension, MDHPanLocation panLocation) {
        
        NSString *dimension = panDimension == MDHPanDimensionHorizontal ? @"《水平》" : @"《垂直》";
        NSString *area      = panLocation == MDHPanLocationLeft ? @"《左》" : @"屏幕区域《右》";

        NSLog(@"panStart ==========滑动方向纬度 %@==========手指接触屏幕区域 %@", dimension,area);

    };
    
    gestureControl.movingBlock = ^(MDHPanDimension panDimension, MDHPanLocation panLocation, CGPoint velocity) {
       
        __strong typeof(weakSelf)strongSelf = weakSelf;

        NSString *dimension = panDimension == MDHPanDimensionHorizontal ? @"《水平》" : @"《垂直》";
        NSString *area      = panLocation == MDHPanLocationLeft ? @"《左》" : @"屏幕区域《右》";
        
        if (panDimension == MDHPanDimensionHorizontal) { /* 水平纬度拖动 */
            
            // 每次滑动需要叠加时间
            strongSelf.sumTime += velocity.x / 200;
            // 需要限定sumTime的范围
            NSTimeInterval totalMovieDuration = strongSelf.playerTotalTime;
           
            // 位移为 0
            if (totalMovieDuration == 0) return;
            
            // 位移距离为正，大于视频总时间
            if (self.sumTime > totalMovieDuration) {
                strongSelf.sumTime = totalMovieDuration;
            }
            
            // 位移距离为负
            if (strongSelf.sumTime < 0) {
                weakSelf.sumTime = 0;
            }
            BOOL style = false;
            
            // 快进
            if (velocity.x > 0) { style = YES; }
            // 快退
            if (velocity.x < 0) { style = NO; }
            // 未知
            if (velocity.x == 0) { return; }
            
            NSLog(@"panMoving ==========准确滑动方向 %@==========手指接触屏幕区域 %@==========速率 %.1f", dimension,area,strongSelf.sumTime/totalMovieDuration);

        } else if (panDimension == MDHPanDimensionVertical) { /* 垂直纬度拖动 */
            
            if (panLocation == MDHPanLocationLeft) { /// 调节亮度
                
            } else if (panLocation == MDHPanLocationRight) { /// 调节声音
               
            }
        }
    };
    
    gestureControl.finishedBlock = ^(MDHPanDimension panDimension, MDHPanLocation panLocation) {
        __strong typeof(weakSelf)strongSelf = weakSelf;

        NSLog(@"滑动手势结束 ====================一般处理 按照当前选择的跳转时间 seekToTime播放 %.1f",strongSelf.sumTime);
        
    };
    
    gestureControl.pinchBlock = ^(float scale) {
        NSLog(@"捏合手势 ==========%.1f",scale);
    };
    
//    gestureControl.disableTypes = MDHGestureTypeDoubleTap|MDHGestureDisableTypesPan;
//    NSLog(@"++++++++++  %lu",(unsigned long)gestureControl.panDimension);
}




- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

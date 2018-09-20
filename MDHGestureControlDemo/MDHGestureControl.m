//
//  MDHGestureControl.m
//  MDHGestureControlDemo
//
//  Created by Apple on 2018/9/19.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import "MDHGestureControl.h"

@interface MDHGestureControl () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong) UIPanGestureRecognizer *panGR;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGR;
@property (nonatomic, assign) MDHPanDimension panDimension;
@property (nonatomic, assign) MDHPanLocation panLocation;
@property (nonatomic, assign) MDHPanMovingDirection panMovingDirection;
@property (nonatomic, weak)   UIView *targetView;


@end


@implementation MDHGestureControl


- (instancetype)initWithTargetView:(UIView *)view {
    
    self = [super init];
    if (self) {
        _targetView = view;
        
        _targetView.multipleTouchEnabled = YES;
        
        /*
         requireGestureRecognizerToFail: A手势与其他手势建立一种关系: 如果其他手势的状态为Failed则会启用A手势动作。
                                         (其他手势侦测失败就会调用A手势)
         */
        [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
        [self.doubleTap requireGestureRecognizerToFail:self.panGR];
        [_targetView addGestureRecognizer:self.singleTap];
        [_targetView addGestureRecognizer:self.doubleTap];
        [_targetView addGestureRecognizer:self.panGR];
        [_targetView addGestureRecognizer:self.pinchGR];
        
    }
    return self;
}



#pragma mark - Api

- (void)removeGesturesOnView:(UIView *)view {
    
    if (view && [view isKindOfClass:[UIView class]]) {
        
        __block UIView *tempView = view;
        
        NSArray *gestureArray = view.gestureRecognizers;
        [gestureArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            if ([obj isKindOfClass:[UIGestureRecognizer class]]) {
                [tempView removeGestureRecognizer:(UIGestureRecognizer *)obj];
            }
        }];
    }
}

/*
 手指触摸屏幕后回调的方法，返回NO则不再进行手势识别，方法触发等
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    MDHGestureType type = MDHGestureTypeUnknown;
    if (gestureRecognizer == self.singleTap) {
        
        type = MDHGestureTypeSingleTap;
        NSLog(@"获取手势类型 ==========单击");

    } else if (gestureRecognizer == self.doubleTap) {
        
        type = MDHGestureTypeDoubleTap;
        NSLog(@"获取手势类型 ==========双击");

    } else if (gestureRecognizer == self.panGR) {
        
        type = MDHGestureTypePan;
        NSLog(@"获取手势类型 ==========滑动");

    } else if (gestureRecognizer == self.pinchGR) {
        
        type = MDHGestureTypePinch;
        NSLog(@"获取手势类型 ==========捏合");
    }
    
    CGPoint locationPoint = [touch locationInView:touch.view];
    if (locationPoint.x > _targetView.bounds.size.width / 2) {
        self.panLocation = MDHPanLocationRight;
        NSLog(@"手指接触屏幕区域 ==========右==========一般处理 音量调节");

    } else {
        self.panLocation = MDHPanLocationLeft;
        NSLog(@"手指接触屏幕区域 ==========左==========一般处理 亮度调节");
    }
    
    
    MDHGestureDisableTypes disableTypes = self.disableTypes;
    if (disableTypes & MDHGestureDisableTypesAll) {
        NSLog(@"不支持的手势类型 ==========所有");
        disableTypes = MDHGestureDisableTypesPan | MDHGestureDisableTypesPinch | MDHGestureDisableTypesDoubleTap | MDHGestureDisableTypesSingleTap;
    }
    switch (type) {
        case MDHGestureTypeUnknown: break;
        case MDHGestureTypePan: {
            if (disableTypes & MDHGestureDisableTypesPan) {
                NSLog(@"不支持的手势类型 ==========滑动");
                return NO;
            }
        }
            break;
        case MDHGestureTypePinch: {
            if (disableTypes & MDHGestureDisableTypesPinch) {
                NSLog(@"不支持的手势类型 ==========捏合");
                return NO;
            }
        }
            break;
        case MDHGestureTypeDoubleTap: {
            if (disableTypes & MDHGestureDisableTypesDoubleTap) {
                NSLog(@"不支持的手势类型 ==========双击");
                return NO;
            }
        }
            break;
        case MDHGestureTypeSingleTap: {
            if (disableTypes & MDHGestureDisableTypesSingleTap) {
                NSLog(@"不支持的手势类型 ==========单击");
                return NO;
            }
        }
            break;
    }
    
//    if (self.triggerCondition) return self.triggerCondition(self, type, gestureRecognizer, touch);
    return YES;
}

/*
 是否允许同时支持多个手势，默认是不支持多个手势
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (otherGestureRecognizer != self.singleTap &&
        otherGestureRecognizer != self.doubleTap &&
        otherGestureRecognizer != self.panGR &&
        otherGestureRecognizer != self.pinchGR) return NO;
    if (gestureRecognizer.numberOfTouches >= 2) {
        NSLog(@"两根手指接触屏幕==========不支持");
        return NO;
    }
    return YES;
}



#pragma mark - getter

- (UITapGestureRecognizer *)singleTap {
    if (!_singleTap){
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        _singleTap.delegate = self;
        _singleTap.delaysTouchesBegan = YES;
        _singleTap.delaysTouchesEnded = YES;
        _singleTap.numberOfTouchesRequired = 1;
        _singleTap.numberOfTapsRequired = 1;
    }
    return _singleTap;
}

- (UITapGestureRecognizer *)doubleTap {
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.delegate = self;
        _doubleTap.delaysTouchesBegan = YES;
        _singleTap.delaysTouchesEnded = YES;
        _doubleTap.numberOfTouchesRequired = 1;
        _doubleTap.numberOfTapsRequired = 2;
    }
    return _doubleTap;
}

- (UIPanGestureRecognizer *)panGR {
    if (!_panGR) {
        _panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _panGR.delegate = self;
        _panGR.delaysTouchesBegan = YES;
        _panGR.delaysTouchesEnded = YES;
        _panGR.maximumNumberOfTouches = 1;
        _panGR.cancelsTouchesInView = YES;
    }
    return _panGR;
}

- (UIPinchGestureRecognizer *)pinchGR {
    if (!_pinchGR) {
        _pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        _pinchGR.delegate = self;
        _pinchGR.delaysTouchesBegan = YES;
    }
    return _pinchGR;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTappedBlock) self.singleTappedBlock();
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    if (self.doubleTappedBlock) self.doubleTappedBlock();
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint translate = [pan translationInView:pan.view];
    CGPoint velocity = [pan velocityInView:pan.view];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            self.panMovingDirection = MDHPanMovingDirectionUnkown;
            CGFloat x = fabs(velocity.x);
            CGFloat y = fabs(velocity.y);
            if (x > y) {
                self.panDimension = MDHPanDimensionHorizontal;
            } else {
                self.panDimension = MDHPanDimensionVertical;
            }
            
            if (self.startBlock) self.startBlock(self.panDimension, self.panLocation);
        }
            break;
        case UIGestureRecognizerStateChanged: {
            switch (_panDimension) {
                case MDHPanDimensionHorizontal: {
                    if (translate.x > 0) {
                        self.panMovingDirection = MDHPanMovingDirectionRight;
                        NSLog(@"滑动趋势 ==========手指 向右 滑动");

                    } else if (translate.y < 0) {
                        self.panMovingDirection = MDHPanMovingDirectionLeft;
                        NSLog(@"滑动趋势 ==========手指 向左 滑动");
                    }
                }
                    break;
                case MDHPanDimensionVertical: {
                    if (translate.y > 0) {
                        self.panMovingDirection = MDHPanMovingDirectionBottom;
                        NSLog(@"滑动趋势 ==========手指 向下 滑动");

                    } else {
                        self.panMovingDirection = MDHPanMovingDirectionTop;
                        NSLog(@"滑动趋势 ==========手指 向上 滑动");
                    }
                }
                    break;
                case MDHPanDimensionUnknown:
                    break;
            }
            if (self.movingBlock) self.movingBlock(self.panDimension, self.panLocation, velocity);
            
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            if (self.finishedBlock) self.finishedBlock(self.panDimension, self.panLocation);
        }
            break;
        default:
            break;
    }
    [pan setTranslation:CGPointZero inView:pan.view];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinch {
    switch (pinch.state) {
        case UIGestureRecognizerStateEnded: {
            if (self.pinchBlock) self.pinchBlock(pinch.scale);
        }
            break;
        default:
            break;
    }
}



/*
 
 // 是否允许触发手势
 - (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
 
 // 是否允许同时支持多个手势，默认是不支持多个手势
 - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
 
 // 手指触摸屏幕后回调的方法，返回NO则不再进行手势识别，方法触发等
 - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
 
 // 手指按压屏幕后回调的方法，返回NO则不再进行手势识别，方法触发等
 - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press;
 */

@end

//
//  MDHGestureControl.h
//  MDHGestureControlDemo
//
//  Created by Apple on 2018/9/19.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 当前手势类型
 */
typedef NS_ENUM(NSUInteger, MDHGestureType) {
    MDHGestureTypeUnknown,    // 位置类型
    MDHGestureTypeSingleTap,  // 单击
    MDHGestureTypeDoubleTap,  // 双击
    MDHGestureTypePan,        // 滑动
    MDHGestureTypePinch       // 捏合
};

/*
 手势滑动纬度
 */
typedef NS_ENUM(NSUInteger, MDHPanDirection) {
    MDHPanDirectionUnknown,      // 未知方向
    MDHPanDirectionVertical,     // 垂直滑动
    MDHPanDirectionHorizontal,   // 水平滑动
};

/*
 手势滑动起始区域（手指接触屏幕时在左边区域 or 右边区域）
 */
typedef NS_ENUM(NSUInteger, MDHPanLocation) {
    MDHPanLocationUnknown,   // 未知区域
    MDHPanLocationLeft,      // 左区域
    MDHPanLocationRight,     // 右区域
};

/*
 手势滑动趋势
 */
typedef NS_ENUM(NSUInteger, MDHPanMovingDirection) {
    MDHPanMovingDirectionUnkown,  // 未知趋势
    MDHPanMovingDirectionTop,     // 向上滑动
    MDHPanMovingDirectionLeft,    // 向左滑动
    MDHPanMovingDirectionBottom,  // 向下滑动
    MDHPanMovingDirectionRight,   // 向右滑动
};

/*
 提供目标view拒绝的手势类型
 */
typedef NS_OPTIONS(NSUInteger, MDHGestureDisableTypes) {
    MDHGestureDisableTypesNone         = 0,
    MDHGestureDisableTypesSingleTap    = 1 << 0,
    MDHGestureDisableTypesDoubleTap    = 1 << 1,
    MDHGestureDisableTypesPan          = 1 << 2,
    MDHGestureDisableTypesPinch        = 1 << 3,
    MDHGestureDisableTypesAll          = 1 << 4
};


@interface MDHGestureControl : NSObject


@property (nonatomic, assign, readonly) MDHPanDirection panDirection;
@property (nonatomic, assign, readonly) MDHPanLocation  panLocation;
@property (nonatomic, assign, readonly) MDHPanMovingDirection panMovingDirection;
@property (nonatomic, assign) MDHGestureDisableTypes disableTypes;


- (instancetype)initWithTargetView:(UIView *)view;

- (void)removeGesturesOnView:(UIView *)view;


@end

//
//  circle.h
//  circleDemo
//
//  Created by guakeliao on 2017/6/20.
//  Copyright © 2017年 span. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface LwDashboard: UIView

@property (nonatomic, assign) IBInspectable CGFloat percent;//0~1;
@property (nonatomic, strong) IBInspectable UIColor *percentColor;//仪表盘字体颜色

@property (nonatomic, strong) IBInspectable UIColor *pointerColor;//指针颜色

@property (nonatomic, assign) IBInspectable CGFloat roundelwidth;// 圆盘宽度
@property (nonatomic, strong) IBInspectable UIColor *roundelAColor;//大圆盘颜色
@property (nonatomic, strong) IBInspectable UIColor *roundelBColor;//小圆盘颜色

-(void)setPercent:(CGFloat)totalPercent animated:(BOOL)animated;

@end

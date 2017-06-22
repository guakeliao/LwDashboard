//
//  circle.m
//  circleDemo
//
//  Created by guakeliao on 2017/6/20.
//  Copyright © 2017年 span. All rights reserved.
//

#import "LwDashboard.h"
#import <math.h>

/**
 point相加
 
 @param p0 p0
 @param p1 p0
 @return  p
 */
CG_INLINE CGPoint
addPoint(CGPoint p0, CGPoint p1)
{
    CGPoint p; p.x = p0.x + p1.x; p.y = p0.y + p1.y; return p;
}

/**
 point按比例变换
 
 @param p0 p0
 @param scale 比例
 @return P
 */
CG_INLINE CGPoint
mulPoint(CGPoint p0, CGFloat scale)
{
    CGPoint p; p.x = p0.x * scale; p.y = p0.y * scale; return p;
}
/**
 point按中心点旋转
 
 @param center 中心点
 @param p1 待转换的点
 @param angle 角度
 @return 转换后的点
 */
CG_INLINE CGPoint
rotatePoint(CGPoint center, CGPoint p1 ,CGFloat angle)
{
    CGPoint p;
    double angleHude = angle *  M_PI / 180;/*角度变成弧度*/
    double x1 = (p1.x - center.x) * cos(angleHude) - (p1.y - center.y ) * sin(angleHude) + center.x;
    double y1 = (p1.y - center.y) * cos(angleHude) + (p1.x - center.x ) * sin(angleHude) + center.y;
    p.x = (int)x1;
    p.y = (int)y1;
    return p;
}

@interface LwDashboard()

@property (nonatomic, assign) CGFloat totalPercent;//百分比
@property (nonatomic, assign) NSInteger arrow;//-1 递减 1递增

@end

@implementation LwDashboard

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat space = 8; //间隙
    CGPoint zeroPoint = CGPointMake(rect.size.width/2 , rect.size.height - space);//坐标
    CGFloat scale = MIN(zeroPoint.x - space, zeroPoint.y - space);//实际高度
    
    if (self.percent < 0) {
        self.percent = 0;
    }
    if (!self.percentColor) {
        self.percentColor = [UIColor whiteColor];
    }
    if (!self.pointerColor) {
        self.pointerColor = [UIColor colorWithRed:0.086 green:0.435 blue:0.769 alpha:1.00];
    }
    if (self.roundelwidth <= 0) {
        self.roundelwidth = scale/2;
    }
    if (!self.roundelAColor) {
        self.roundelAColor = [UIColor colorWithRed:0.761 green:0.761 blue:0.761 alpha:1.00];
    }
    if (!self.roundelBColor) {
        self.roundelBColor = [UIColor colorWithRed:0.506 green:0.671 blue:0.859 alpha:1.00];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGContextFillRect(context, rect);
    
    //以圆盘开始为0°
    CGFloat angle = 90 + 180 * (1.1 + self.percent * (1.9 - 1.1));
    
    //默认指针高度为1.针脚为0.03. 针脚45°
    CGPoint onePoint = CGPointMake(0,0);
    CGPoint twoPoint = CGPointMake(0.03,-0.03);
    CGPoint thrPoint = CGPointMake(0,-1);
    CGPoint fouPoint = CGPointMake(-0.03,-0.03);

    //转化之后的坐标
    CGPoint p0 = addPoint(mulPoint(onePoint, scale - self.roundelwidth/2) , zeroPoint);
    CGPoint p1 = addPoint(mulPoint(twoPoint, scale - self.roundelwidth/2) , zeroPoint);
    CGPoint p2 = addPoint(mulPoint(thrPoint, scale - self.roundelwidth/2) , zeroPoint);
    CGPoint p3 = addPoint(mulPoint(fouPoint, scale - self.roundelwidth/2) , zeroPoint);

    
    //画背景圆弧
    UIBezierPath *bPath = [[UIBezierPath alloc] init];
    bPath.lineWidth = self.roundelwidth;
    [bPath addArcWithCenter:p0
                    radius:scale - self.roundelwidth/2
                startAngle:M_PI*1.1
                  endAngle:M_PI*1.9
                 clockwise:YES];
    [self.roundelAColor set];
    [bPath stroke];
    
    //画里面圆弧
    UIBezierPath *ipath = [[UIBezierPath alloc] init];
    ipath.lineWidth = self.roundelwidth;
    [ipath addArcWithCenter:p0
                    radius:scale - self.roundelwidth/2
                startAngle:M_PI*1.1
                  endAngle:M_PI*(1.1 + self.percent * 0.8)
                 clockwise:YES];
    [self.roundelBColor set];
    [ipath stroke];
    
    //绘制文字
    NSString *str = [NSString stringWithFormat:@"%.1f%%",self.percent*100];
    //段落格式
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;//水平居中
//    textStyle
    //构建属性集合
    CGFloat fontSize = 10;
    NSDictionary *attributes ;
    CGSize strSize;
    while (1) {
        attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize], NSForegroundColorAttributeName:self.percentColor, NSParagraphStyleAttributeName:textStyle};
        //获得size
        strSize = [str sizeWithAttributes:attributes];
        if (strSize.height < self.roundelwidth * 0.35 && strSize.width  < scale) {
            fontSize ++;
            continue;
        }
        break;
    }
    //垂直居中要自己计算
    CGRect r = CGRectMake(ABS(p2.x - strSize.width/2), ABS(p2.y - strSize.height/2), strSize.width, strSize.height);
    [str drawInRect:r withAttributes:attributes];
    //指针
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.flatness = 1;
    aPath.lineWidth = 1;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    
    [aPath moveToPoint:rotatePoint(p0, p0, angle)];
    [aPath addLineToPoint:rotatePoint(p0, p1, angle)];
    [aPath addLineToPoint:rotatePoint(p0, p2, angle)];
    [aPath addLineToPoint:rotatePoint(p0, p3, angle)];
    [aPath closePath];
    [self.pointerColor set];
    [aPath stroke];
    [aPath fill];
}
-(void)animate:(NSNumber *)percentNum{
    CGFloat currentPercent = [percentNum floatValue];
    if (self.arrow == -1) {
        //递减
        currentPercent-=1/60.0;
        if (currentPercent - self.totalPercent > 0.000001 && currentPercent > 0){
            [self performSelector:@selector(animate:) withObject:@(currentPercent) afterDelay:1/60.0];
        }else{
            self.percent = self.totalPercent;
            return;
        }
    }else{
        //递增
        currentPercent+=1/60.0;
        if (currentPercent - self.totalPercent < 0.000001 && currentPercent < 1){
            [self performSelector:@selector(animate:) withObject:@(currentPercent) afterDelay:1/60.0];
        }else{
            self.percent = self.totalPercent;
            return;
        }
    }
    self.percent = currentPercent;
    [self setNeedsDisplay];
}
-(void)setPercent:(CGFloat)totalPercent animated:(BOOL)animated{
    if (animated) {
        self.totalPercent = totalPercent;
        if (self.percent - totalPercent > 0.000001) {
            self.arrow = -1;
        }else{
            self.arrow = 1;
        }
        [self animate:@(self.percent)];
    }else{
        self.percent = totalPercent;
    }
}
#pragma mark
#pragma mark setter

-(void)setPercent:(CGFloat)percent{
    if (percent > 1) {
        percent = 1;
    }
    _percent = percent;
    [self setNeedsDisplay];
}
-(void)setPointerColor:(UIColor *)pointerColor{
    _pointerColor = pointerColor;
    [self setNeedsDisplay];
}
-(void)setRoundelwidth:(CGFloat)roundelwidth{
    _roundelwidth = roundelwidth;
    [self setNeedsDisplay];
}
-(void)setRoundelAColor:(UIColor *)roundelAColor{
    _roundelAColor = roundelAColor;
    [self setNeedsDisplay];
}
-(void)setRoundelBColor:(UIColor *)roundelBColor{
    _roundelBColor = roundelBColor;
    [self setNeedsDisplay];
}
@end


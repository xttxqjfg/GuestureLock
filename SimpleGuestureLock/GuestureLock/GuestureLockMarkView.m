//
//  GuestureLockMarkView.m
//  SimpleGuestureLock
//
//  Created by 易博 on 2018/4/3.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "GuestureLockMarkView.h"

#import "GuestureLockDefine.h"

@implementation GuestureLockMarkView

-(void)drawRect:(CGRect)rect{
    
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //设置属性
    CGContextSetLineWidth(ctx, GuestureLockArcLineW);
    
    //设置线条颜色
    [GuestureLockCircleLineNormalColor set];
    
    //新建路径
    CGMutablePathRef pathM = CGPathCreateMutable();
    
    CGFloat marginV = 3.f;
    CGFloat padding = 1.0f;
    CGFloat rectWH = (rect.size.width - marginV * 2 - padding*2) / 3;
    
    //添加圆形路径
    for (NSUInteger i=0; i<9; i++) {
        
        NSUInteger row = i % 3;
        NSUInteger col = i / 3;
        
        CGFloat rectX = (rectWH + marginV) * row + padding;
        
        CGFloat rectY = (rectWH + marginV) * col + padding;
        
        CGRect rect = CGRectMake(rectX, rectY, rectWH, rectWH);
        
        CGPathAddEllipseInRect(pathM, NULL, rect);
    }
    
    //绘制直线路径
    for (NSUInteger j=0; j<_tagsArr.count; j++) {
        NSInteger tag = [[_tagsArr objectAtIndex:j] integerValue];
        NSUInteger row = tag % 3;
        NSUInteger col = tag / 3;
        
        CGFloat rectX = (rectWH + marginV) * row + padding + rectWH / 2;
        
        CGFloat rectY = (rectWH + marginV) * col + padding + rectWH / 2;
        
        if(j == 0){//第一个
            
            //添加起点
            CGPathMoveToPoint(pathM, NULL, rectX, rectY);
            
        }else{//其他
            
            //添加路径线条
            CGPathAddLineToPoint(pathM, NULL, rectX, rectY);
        }
    }
    
    //添加路径
    CGContextAddPath(ctx, pathM);
    
    //绘制路径
    CGContextStrokePath(ctx);
    
    //释放路径
    CGPathRelease(pathM);
}

#pragma mark --- get  set ---
-(void)setTagsArr:(NSMutableArray *)tagsArr
{
    _tagsArr = tagsArr;
    [self setNeedsDisplay];
}

@end

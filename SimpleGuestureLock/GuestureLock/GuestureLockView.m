//
//  GuestureLockView.m
//  SimpleGuestureLock
//
//  Created by 易博 on 2018/4/3.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "GuestureLockView.h"

#import "GuestureLockItemView.h"
#import "GuestureLockDefine.h"

@interface GuestureLockView()

/** 装itemView的可变数组*/
@property (nonatomic,strong) NSMutableArray *itemViewsM;


/** 临时密码记录器 */
@property (nonatomic,copy) NSMutableString *pwdM;


/** 设置密码：第一次设置的密码 */
@property (nonatomic,copy) NSString *firstPWD;


/** 修改密码过程中的验证旧密码正确 */
@property (nonatomic,assign) BOOL modify_oldPswRight;

/** 记录选中item的tag值数组，用于回显在markView */
@property (nonatomic,strong) NSMutableArray *itemTags;

@end

@implementation GuestureLockView

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if(self){
        
        //解锁视图准备
        [self lockViewPrepare];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        //解锁视图准备
        [self lockViewPrepare];
    }
    
    return self;
}

/*
 *  绘制线条
 */
-(void)drawRect:(CGRect)rect{
    
    //数组为空直接返回
    if(_itemViewsM == nil || _itemViewsM.count == 0) return;
    
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //添加路径
    CGContextAddRect(ctx, rect);
    
    //添加圆形路径
    //遍历所有的itemView
    [_itemViewsM enumerateObjectsUsingBlock:^(GuestureLockItemView *itemView, NSUInteger idx, BOOL *stop) {
        
        CGContextAddEllipseInRect(ctx, itemView.frame);
    }];
    
    //剪裁
    CGContextEOClip(ctx);
    
    //新建路径：管理线条
    CGMutablePathRef pathM = CGPathCreateMutable();
    
    //设置上下文属性
    //1.设置线条颜色
    [GuestureLockLockLineColor set];
    
    //线条转角样式
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    //设置线宽
    CGContextSetLineWidth(ctx, 1.0f);
    
    //遍历所有的itemView
    [_itemViewsM enumerateObjectsUsingBlock:^(GuestureLockItemView *itemView, NSUInteger idx, BOOL *stop) {
        
        CGPoint directPoint = itemView.center;
        
        if(idx == 0){//第一个
            
            //添加起点
            CGPathMoveToPoint(pathM, NULL, directPoint.x, directPoint.y);
            
        }else{//其他
            
            //添加路径线条
            CGPathAddLineToPoint(pathM, NULL, directPoint.x, directPoint.y);
        }
    }];
    
    //将路径添加到上下文
    CGContextAddPath(ctx, pathM);
    
    //渲染路径
    CGContextStrokePath(ctx);
    
    //释放路径
    CGPathRelease(pathM);
}

/*
 *  解锁视图准备
 */
-(void)lockViewPrepare{
    
    for (NSUInteger i=0; i<9; i++) {
        
        GuestureLockItemView *itemView = [[GuestureLockItemView alloc] init];
        
        [self addSubview:itemView];
    }
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat itemViewWH = (self.frame.size.width - 4 * GuestureLockMarginValue) /3.0f;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        
        NSUInteger row = idx % 3;
        
        NSUInteger col = idx / 3;
        
        CGFloat x = GuestureLockMarginValue * (row +1) + row * itemViewWH;
        
        CGFloat y =GuestureLockMarginValue * (col +1) + col * itemViewWH;
        
        CGRect frame = CGRectMake(x, y, itemViewWH, itemViewWH);
        
        //设置tag
        subview.tag = idx;
        
        subview.frame = frame;
    }];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //解锁处理
    [self lockHandle:touches];
    
    if(GuestureLockTypeSetPwd == _type){ // 设置密码
        //开始
        if(self.firstPWD == nil){//第一次输入
            
            if(_showMsgBlock != nil) _showMsgBlock(GuestureLockPWDTitleFirst,0);
            
        }else{//确认
            
            if(_showMsgBlock != nil) _showMsgBlock(GuestureLockPWDTitleConfirm,0);
        }
    }else if(GuestureLockTypeVeryfiPwd == _type){//验证密码
        
        //开始
        if(_showMsgBlock != nil) _showMsgBlock(GuestureLockVerifyNormalTitle,0);
        
    }else if (GuestureLockTypeModifyPwd == _type){
        
        //开始
        if(_showMsgBlock != nil) _showMsgBlock(GuestureLockModifyNormalTitle,0);
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //解锁处理
    [self lockHandle:touches];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //手势结束
    [self gestureEnd];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //手势结束
    [self gestureEnd];
}

/*
 *  手势结束
 */
-(void)gestureEnd{
    
    
    //设置密码检查
    if(self.pwdM.length != 0){
        [self setpwdCheck];
    }
    
    for (GuestureLockItemView *itemView in self.itemViewsM) {
        
        itemView.selected = NO;
        [self.itemTags addObject:@(itemView.tag)];
    }
    
    //回传
    if(_updateMarkViewBlock != nil) _updateMarkViewBlock(self.itemTags);
    
    //清空数组所有对象
    [self.itemViewsM removeAllObjects];
    [self.itemTags removeAllObjects];
    
    //再绘制
    [self setNeedsDisplay];
    
    //清空密码
    self.pwdM = nil;
    
}

/*
 *  设置密码检查
 */
-(void)setpwdCheck{
    
    NSUInteger count = self.itemViewsM.count;
    
    if(count < GuestureLockMinItemCount){
        if(_showMsgBlock != nil) _showMsgBlock([NSString stringWithFormat:@"请连接至少%@个点",@(GuestureLockMinItemCount)],0);
        return;
    }
    
    if(GuestureLockTypeSetPwd == _type){//设置密码
        
        //设置密码
        [self setpwd];
        
    }else if(GuestureLockTypeVeryfiPwd == _type){//验证密码
        
        if(_verifyPwdBlock != nil) _verifyPwdBlock(self.pwdM);
        
    }else if (GuestureLockTypeModifyPwd == _type){//修改密码
        
        if(!_modify_oldPswRight){
            
            if(_verifyPwdBlock != nil){
                _modify_oldPswRight = _verifyPwdBlock(self.pwdM);
            }
            
        }else{
            
            //设置密码
            [self setpwd];
        }
    }
    
}

/*
 *  设置密码
 */
-(void)setpwd{
    
    //密码合法
    if(self.firstPWD == nil){// 第一次设置密码
        self.firstPWD = self.pwdM;
        if(_showMsgBlock != nil) _showMsgBlock(GuestureLockPWDTitleConfirm,0);
    }else{
        
        if(![self.firstPWD isEqualToString:self.pwdM]){//两次密码不一致
            //两次密码输入不一致，重新开始
            self.firstPWD = nil;
            if(_showMsgBlock != nil) _showMsgBlock(GuestureLockPWDDiffTitle,1);
            return;
            
        }else{//再次密码输入一致
            
            if(_setPwdSuccessBlock != nil) _setPwdSuccessBlock(self.firstPWD);
        }
    }
    
}

/*
 *  解锁处理
 */
-(void)lockHandle:(NSSet *)touches{
    
    //取出触摸点
    UITouch *touch = [touches anyObject];
    
    CGPoint loc = [touch locationInView:self];
    
    GuestureLockItemView *itemView = [self itemViewWithTouchLocation:loc];
    
    //如果为空，返回
    if(itemView == nil) return;
    
    //如果已经存在，返回
    if([self.itemViewsM containsObject:itemView]) return;
    
    //添加
    [self.itemViewsM addObject:itemView];
    
    //记录密码
    [self.pwdM appendFormat:@"%@",@(itemView.tag)];
    
    //item处理
    [self itemHandel:itemView];
}

/*
 *  item处理
 */
-(void)itemHandel:(GuestureLockItemView *)itemView{
    
    //选中
    itemView.selected = YES;
    
    //绘制
    [self setNeedsDisplay];
}

-(GuestureLockItemView *)itemViewWithTouchLocation:(CGPoint)loc{
    
    GuestureLockItemView *itemView = nil;
    
    for (GuestureLockItemView *itemViewSub in self.subviews) {
        
        if(!CGRectContainsPoint(itemViewSub.frame, loc)) continue;
        itemView = itemViewSub;
        break;
    }
    
    return itemView;
}

-(NSMutableArray *)itemViewsM{
    
    if(_itemViewsM == nil){
        
        _itemViewsM = [NSMutableArray array];
    }
    
    return _itemViewsM;
}

-(NSMutableString *)pwdM{
    
    if(_pwdM == nil){
        
        _pwdM = [NSMutableString string];
    }
    
    return _pwdM;
}

-(NSMutableArray *)itemTags
{
    if (!_itemTags) {
        _itemTags = [[NSMutableArray alloc] init];
    }
    return _itemTags;
}

/*
 *  重设密码
 */
-(void)resetPwd{
    
    //清空第一次密码即可
    self.firstPWD = nil;
}


@end

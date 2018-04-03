//
//  GuestureLockLabel.m
//  SimpleGuestureLock
//
//  Created by 易博 on 2018/4/3.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "GuestureLockLabel.h"

#import "GuestureLockDefine.h"
#import "GuestureLockCategory.h"

@implementation GuestureLockLabel

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        //视图初始化
        [self viewPrepare];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self=[super initWithCoder:aDecoder];
    
    if(self){
        
        //视图初始化
        [self viewPrepare];
    }
    
    return self;
}

/*
 *  视图初始化
 */
-(void)viewPrepare{
    
    self.font = [UIFont systemFontOfSize:16.0f];
    self.textAlignment = NSTextAlignmentCenter;
}

/*
 *  普通提示信息
 */
-(void)showNormalMsg:(NSString *)msg{
    
    self.text = msg;
    self.textColor = GuestureLockCircleLineNormalColor;
}

/*
 *  警示信息
 */
-(void)showWarnMsg:(NSString *)msg{
    
    self.text = msg;
    self.textColor = GuestureLockWarnColor;
    
    //添加一个shake动画
    [self.layer shake];
}

@end

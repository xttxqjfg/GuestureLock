//
//  GuestureLockView.h
//  SimpleGuestureLock
//
//  Created by 易博 on 2018/4/3.
//  Copyright © 2018年 易博. All rights reserved.
//

//解锁区域

#import <UIKit/UIKit.h>

#import "GuestureLockDefine.h"

@interface GuestureLockView : UIView

@property (nonatomic,assign) GuestureLockType type;

/**
 设置提示语的block
 msg:提示语 type:提示类型，0为常规提示 1位摇动提示
 */
@property (nonatomic,copy) void (^showMsgBlock)(NSString *msg,NSInteger type);

/**
 设置或者修改密码的block
 pwd:设置的密码
 */
@property (nonatomic,copy) void (^setPwdSuccessBlock)(NSString *pwd);

//验证密码的block
@property (nonatomic,copy) BOOL (^verifyPwdBlock)(NSString *pwd);

//更新markView的block
@property (nonatomic,copy) void (^updateMarkViewBlock)(NSMutableArray *pwdArr);

@end

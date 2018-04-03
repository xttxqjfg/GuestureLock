//
//  GuestureLockDefine.h
//  SimpleGuestureLock
//
//  Created by 易博 on 2018/4/3.
//  Copyright © 2018年 易博. All rights reserved.
//

#ifndef GuestureLockDefine_h
#define GuestureLockDefine_h

typedef enum{
    
    // 设置密码
    GuestureLockTypeSetPwd = 0,
    
    // 输入并验证密码
    GuestureLockTypeVeryfiPwd,
    
    // 修改密码
    GuestureLockTypeModifyPwd,
    
}GuestureLockType;

//颜色相关设置 --- start----
// 颜色设置宏定义
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

// 背景色
#define GuestureLockViewBgColor RGBA(13,52,89,1)

// 外环线条颜色：默认
#define GuestureLockCircleLineNormalColor RGBA(241,241,241,1)

// 外环线条颜色：选中
#define GuestureLockCircleLineSelectedColor RGBA(34,178,246,1)

// 实心圆
#define GuestureLockCircleLineSelectedCircleColor RGBA(34,178,246,1)

// 实心圆
#define GuestureLockLockLineColor RGBA(34,178,246,1)

// 警示文字颜色
#define GuestureLockWarnColor RGBA(254,82,92,1)

//颜色相关设置 --- end ----

//提示语、size相关设置 --- start----

// 选中圆大小的线宽
#define GuestureLockArcLineW 1.0f

// 选中圆大小比例
#define GuestureLockArcWHR 0.3f

// 手势点间距
#define GuestureLockMarginValue 36.0f

// 最低设置密码数目
#define GuestureLockMinItemCount 4

// 设置密码提示文字
#define GuestureLockPWDTitleFirst @"请滑动设置新密码"

// 设置密码提示文字：确认
#define GuestureLockPWDTitleConfirm @"请再次输入确认密码"

// 设置密码提示文字：再次密码不一致
#define GuestureLockPWDDiffTitle @"再次密码输入不一致,请滑动设置新密码"

// 设置密码提示文字：设置成功
#define GuestureLockPWSuccessTitle @"密码设置成功！"

// 验证密码：普通提示文字
#define GuestureLockVerifyNormalTitle @"请滑动输入密码"

// 验证密码：密码错误
#define GuestureLockVerifyErrorPwdTitle @"输入密码错误"

// 验证密码：验证成功
#define GuestureLockVerifySuccesslTitle @"密码正确"

// 修改密码：普通提示文字
#define GuestureLockModifyNormalTitle @"请输入旧密码"

// 密码存储Key
#define GuestureLockPWDKey @"GuestureLockPWDKey"

// 屏幕宽高
#define kScreenW [[UIScreen mainScreen] bounds].size.width
#define kScreenH [[UIScreen mainScreen] bounds].size.height

//提示语、size相关设置 --- end----


#endif /* GuestureLockDefine_h */

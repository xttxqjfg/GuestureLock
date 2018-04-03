//
//  GuestureLockLabel.h
//  SimpleGuestureLock
//
//  Created by 易博 on 2018/4/3.
//  Copyright © 2018年 易博. All rights reserved.
//

//文本提示

#import <UIKit/UIKit.h>

@interface GuestureLockLabel : UILabel

/*
 *  普通提示信息
 */
-(void)showNormalMsg:(NSString *)msg;

/*
 *  警示信息
 */
-(void)showWarnMsg:(NSString *)msg;

@end

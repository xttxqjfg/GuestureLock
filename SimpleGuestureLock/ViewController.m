//
//  ViewController.m
//  SimpleGuestureLock
//
//  Created by 易博 on 2018/4/3.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "ViewController.h"

#import "GuestureLockVC.h"
#import "GuestureLockNavVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)btnClicked:(UIButton *)sender {
    
    GuestureLockVC *lockVC = [[GuestureLockVC alloc]init];
    
    if(1000 == sender.tag)
    {
        lockVC.type = GuestureLockTypeSetPwd;
        lockVC.title = @"设置密码";
    }
    else if (2000 == sender.tag)
    {
        lockVC.type = GuestureLockTypeVeryfiPwd;
        lockVC.title = @"验证密码";
    }
    else if(3000 == sender.tag)
    {
        lockVC.type = GuestureLockTypeModifyPwd;
        lockVC.title = @"修改密码";
    }
    else
    {
        return;
    }
    
    GuestureLockNavVC *nav = [[GuestureLockNavVC alloc]initWithRootViewController:lockVC];
    
    [self presentViewController:nav animated:YES completion:^{
        //
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

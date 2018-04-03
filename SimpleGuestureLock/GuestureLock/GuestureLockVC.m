//
//  GuestureLockVC.m
//  SimpleGuestureLock
//
//  Created by 易博 on 2018/4/3.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "GuestureLockVC.h"

#import "GuestureLockLabel.h"
#import "GuestureLockView.h"
#import "GuestureLockMarkView.h"

@interface GuestureLockVC ()

//文本提示
@property (nonatomic,strong) GuestureLockLabel *lockLabel;

//小提示view
@property (nonatomic,strong) GuestureLockMarkView *markView;

//手势区域
@property (nonatomic,strong) GuestureLockView *lockView;

@end

@implementation GuestureLockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //控制器准备
    [self vcPrepare];
    
    //事件
    [self event];
}

/*
 *  控制器准备
 */
-(void)vcPrepare{
    
    //设置背景色
    self.view.backgroundColor = GuestureLockViewBgColor;
    
    [self.view addSubview:self.lockLabel];
    [self.view addSubview:self.markView];
    [self.view addSubview:self.lockView];
    
    //传递类型
    self.lockView.type = self.type;
}

/*
 *  事件
 */
-(void)event{

    __weak typeof(self) weakSelf = self;
    
    //提示语处理
    self.lockView.showMsgBlock = ^(NSString *msg,NSInteger type)
    {
        if (0 == type) {
            [weakSelf.lockLabel showNormalMsg:msg];
        }
        else
        {
            [weakSelf.lockLabel showWarnMsg:msg];
        }
    };
    
    //设置密码、修改密码成功
    self.lockView.setPwdSuccessBlock = ^(NSString *pwd) {
        [weakSelf.lockLabel showNormalMsg:GuestureLockPWSuccessTitle];
        
        //存储密码
        [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:GuestureLockPWDKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //禁用交互
        weakSelf.view.userInteractionEnabled = NO;
        
        [weakSelf dismiss:1.0];
    };
    
    //验证密码
    self.lockView.verifyPwdBlock = ^BOOL(NSString *pwd) {
        //取出本地密码
        NSString *pwdLocal = [[NSUserDefaults standardUserDefaults] objectForKey:GuestureLockPWDKey];
        
        BOOL res = [pwdLocal isEqualToString:pwd];
        
        if(res){//密码一致
            
            [weakSelf.lockLabel showNormalMsg:GuestureLockVerifySuccesslTitle];
            
            if(GuestureLockTypeVeryfiPwd == _type){
                
                //禁用交互
                weakSelf.view.userInteractionEnabled = NO;
                [weakSelf dismiss:1.0];
                
            }else if (GuestureLockTypeModifyPwd == _type){//修改密码
                
                [weakSelf.lockLabel showNormalMsg:GuestureLockPWDTitleFirst];
            }
            
        }else{//密码不一致
            
            [weakSelf.lockLabel showWarnMsg:GuestureLockVerifyErrorPwdTitle];
            
        }
        return res;
    };
    
    self.lockView.updateMarkViewBlock = ^(NSMutableArray *pwdArr) {
        weakSelf.markView.tagsArr = [pwdArr mutableCopy];
    };
}

-(void)dismiss:(NSTimeInterval)interval{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark -- set --
-(void)setType:(GuestureLockType)type
{
    _type = type;
    
    switch (type) {
        case GuestureLockTypeSetPwd :
        {
            [self.lockLabel showNormalMsg:GuestureLockPWDTitleFirst];
            break;
        }
        case GuestureLockTypeVeryfiPwd :
        {
            [self.lockLabel showNormalMsg:GuestureLockVerifyNormalTitle];
            break;
        }
        case GuestureLockTypeModifyPwd :
        {
            [self.lockLabel showNormalMsg:GuestureLockModifyNormalTitle];
            break;
        }
        default:
            break;
    }
}

#pragma mark -- get --
-(GuestureLockLabel *)lockLabel
{
    if (!_lockLabel) {
        _lockLabel = [[GuestureLockLabel alloc]initWithFrame:CGRectMake(20, 70, kScreenW - 40, 40)];
    }
    return _lockLabel;
}

-(GuestureLockMarkView *)markView
{
    if (!_markView) {
        _markView = [[GuestureLockMarkView alloc]initWithFrame:CGRectMake((kScreenW - 60) / 2, CGRectGetMaxY(self.lockLabel.frame) + 20, 60, 60)];
        _markView.backgroundColor = [UIColor clearColor];
    }
    return _markView;
}

-(GuestureLockView *)lockView
{
    if (!_lockView) {
        _lockView = [[GuestureLockView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.markView.frame) + 20, kScreenW - 40, kScreenW - 40)];
        _lockView.backgroundColor = [UIColor clearColor];
    }
    return _lockView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

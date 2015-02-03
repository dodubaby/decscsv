//
//  PDLoginViewController.m
//  PDSupplier
//
//  Created by zdf on 14/12/21.
//  Copyright (c) 2014年 Man. All rights reserved.
//

#import "PDLoginViewController.h"
#import "PDRegisterViewController.h"
#import "PDFindPasswordViewController.h"
#import "PDUtils.h"
#import "UIColor+Utils.h"
#import "PDHTTPEngine.h"

@interface PDLoginViewController ()
{
    UILabel *logintitle;
    UITextField *usernametfd;
    UITextField *passwordtfd;
    UIButton *loginbtn;
    UIButton *registbtn;
    UIButton *forgetbtn;
}
@end

@implementation PDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mode = MMReachabilityModeOverlay;
    self.visibilityTime = 3.0;
    logintitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kAppWidth, 44)];
    logintitle.text=@"登录";
    logintitle.font=[UIFont systemFontOfSize:kAppFontSize];
    logintitle.textColor=[UIColor colorWithHexString:kAppNormalColor];
    logintitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=logintitle;
    
    
    usernametfd=[[UITextField alloc] initWithFrame:CGRectMake(kGap, 64+kGap*2, kAppWidth-kGap*2, 50)];
    usernametfd.delegate=self;
    usernametfd.placeholder=@"请输入手机号";
    usernametfd.layer.cornerRadius = 0;
    usernametfd.layer.masksToBounds = YES;
    usernametfd.layer.borderWidth = 1;
    usernametfd.layer.borderColor = [[UIColor colorWithHexString:kAppLineColor] CGColor];
    usernametfd.font=[UIFont systemFontOfSize:kAppFontSize];
    usernametfd.textColor=[UIColor colorWithHexString:kAppNormalColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTextFieldLeft, usernametfd.frame.size.height)];
    usernametfd.leftView = view;
    usernametfd.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:usernametfd];
    
    
    
    passwordtfd=[[UITextField alloc] initWithFrame:CGRectMake(kGap, usernametfd.bottom+kGap, kAppWidth-kGap*2, 50)];
    passwordtfd.delegate=self;
    passwordtfd.layer.cornerRadius = 0;
    passwordtfd.layer.masksToBounds = YES;
    passwordtfd.layer.borderWidth = 1;
    passwordtfd.layer.borderColor = [[UIColor colorWithHexString:kAppLineColor] CGColor];
    passwordtfd.font=[UIFont systemFontOfSize:kAppFontSize];
    passwordtfd.textColor=[UIColor colorWithHexString:kAppNormalColor];
    passwordtfd.placeholder=@"请输入密码";
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTextFieldLeft, passwordtfd.frame.size.height)];
    passwordtfd.leftView = view1;
    passwordtfd.leftViewMode = UITextFieldViewModeAlways;
    passwordtfd.secureTextEntry=YES;
    [self.view addSubview:passwordtfd];


    
    loginbtn = [[UIButton alloc] initWithFrame:CGRectMake(passwordtfd.left, passwordtfd.bottom+kGap*1.5, kAppWidth-kGap*2, 40)];
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithHexString:kAppRedColor] size:loginbtn.size];
    [loginbtn setBackgroundImage:image forState:UIControlStateNormal];
    [loginbtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [self.view addSubview:loginbtn];
    [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginbtn setTitle:@"登录" forState:UIControlStateNormal];
    loginbtn.layer.cornerRadius = kBtnCornerRadius;
    loginbtn.layer.masksToBounds = YES;
    loginbtn.layer.borderWidth = 1;
    loginbtn.layer.borderColor = [[UIColor colorWithHexString:kAppRedColor] CGColor];
    
    [loginbtn handleControlEvents:UIControlEventTouchUpInside actionBlock:^(id sender) {
        //
        NSLog(@"login");
        PDHTTPEngine *engine=[[PDHTTPEngine alloc] init];
        if (usernametfd.text.length==0||passwordtfd.text.length==0) {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"请输入账号密码后再登录。" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alt show];
        }else{
            [engine  loginWithphone:usernametfd.text password:passwordtfd.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"responseObject==%@",responseObject);
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                [defaults setObject:[responseObject objectForKey:@"courierid"] forKey:@"courierid"];
                //[defaults setObject:[responseObject objectForKey:@"today_new_order"] forKey:@"today_new_order"];
                [defaults synchronize];
                AppDelegate *app=[[UIApplication sharedApplication] delegate];
                [app changetoMainViewController];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *alt=[[UIAlertView alloc] initWithTitle:[error.userInfo objectForKey:@"Message"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alt show];
            }];
        }
    }];
    
    forgetbtn = [[UIButton alloc] initWithFrame:CGRectMake(loginbtn.left, loginbtn.bottom+kGap, 120, 40)];
    forgetbtn.backgroundColor=[UIColor clearColor];
    [self.view addSubview:forgetbtn];
    [forgetbtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [forgetbtn.titleLabel setFont:[UIFont systemFontOfSize:kAppFontSize]];
    [forgetbtn setTitleColor:[UIColor colorWithHexString:kAppNormalColor] forState:UIControlStateNormal];
    [forgetbtn handleControlEvents:UIControlEventTouchUpInside actionBlock:^(id sender) {
        //
        NSLog(@"forgetbtn");
        PDFindPasswordViewController *controller=[[PDFindPasswordViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    
    
    registbtn = [[UIButton alloc] initWithFrame:CGRectMake(loginbtn.right-120, loginbtn.bottom+kGap, 120, 40)];
    registbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    registbtn.backgroundColor=[UIColor clearColor];
    [self.view addSubview:registbtn];
    [registbtn setTitle:@"注册" forState:UIControlStateNormal];
    [registbtn.titleLabel setFont:[UIFont systemFontOfSize:kAppFontSize]];
    [registbtn setTitleColor:[UIColor colorWithHexString:kAppNormalColor] forState:UIControlStateNormal];
    [registbtn handleControlEvents:UIControlEventTouchUpInside actionBlock:^(id sender) {
        //
        NSLog(@"registbtn");
        PDRegisterViewController *controller=[[PDRegisterViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
//    usernametfd.text=@"18601212008";
//    passwordtfd.text=@"1";
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==usernametfd) {
        usernametfd.layer.borderColor = [[UIColor colorWithHexString:kAppRedColor] CGColor];
        usernametfd.textColor=[UIColor colorWithHexString:kAppRedColor];
    }else if (textField==passwordtfd){
        passwordtfd.layer.borderColor = [[UIColor colorWithHexString:kAppRedColor] CGColor];
        passwordtfd.textColor=[UIColor colorWithHexString:kAppRedColor];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==usernametfd) {
        usernametfd.layer.borderColor = [[UIColor colorWithHexString:kAppLineColor] CGColor];
        usernametfd.textColor=[UIColor colorWithHexString:kAppNormalColor];
    }else if (textField==passwordtfd){
        passwordtfd.layer.borderColor = [[UIColor colorWithHexString:kAppLineColor] CGColor];
        passwordtfd.textColor=[UIColor colorWithHexString:kAppNormalColor];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

//
//  PDRegisterViewController.m
//  PDSupplier
//
//  Created by zdf on 14/12/21.
//  Copyright (c) 2014年 Man. All rights reserved.
//

#import "PDRegisterViewController.h"
#import "PDHTTPEngine.h"

#define TFDGAP 10

@interface PDRegisterViewController ()
{
    UITextField *phonetfd;
    UIButton *sendcodebtn;
    UIImageView *sendimg;
    UITextField *codetfd;
    UITextField *passwordtfd;
    UIButton *submitbtn;
    UILabel *timelab;
}
@end

@implementation PDRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(0, 0, 26, 40);
    [button setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem * leftDrawerButton  = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    UILabel *ttitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kAppWidth, 44)];
    ttitle.text=@"注册";
    ttitle.font=[UIFont systemFontOfSize:kAppFontSize];
    ttitle.textColor=[UIColor colorWithHexString:kAppNormalColor];
    ttitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=ttitle;
    
    phonetfd=[[UITextField alloc] initWithFrame:CGRectMake(kGap, 64+kGap*2, kAppWidth-kGap*2, 50)];
    phonetfd.delegate=self;
    phonetfd.placeholder=@"请输入手机号";
    phonetfd.layer.cornerRadius = 0;
    phonetfd.layer.masksToBounds = YES;
    phonetfd.layer.borderWidth = 1;
    phonetfd.layer.borderColor = [[UIColor colorWithHexString:kAppLineColor] CGColor];
    phonetfd.font=[UIFont systemFontOfSize:kAppFontSize];
    phonetfd.textColor=[UIColor colorWithHexString:kAppNormalColor];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTextFieldLeft, phonetfd.frame.size.height)];
    phonetfd.leftView = view1;
    phonetfd.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:phonetfd];
    
    
    
    sendcodebtn = [[UIButton alloc] initWithFrame:CGRectMake(phonetfd.right-130-kGap, phonetfd.top, 90, 50)];
    sendcodebtn.backgroundColor=[UIColor clearColor];
    [self.view addSubview:sendcodebtn];
    [sendcodebtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [sendcodebtn setTitleColor:[UIColor colorWithHexString:kAppPlaceHoderColor] forState:UIControlStateNormal];
    [sendcodebtn.titleLabel setFont:[UIFont systemFontOfSize:kAppBtnSize]];
    sendimg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"发送"]];
    [self.view addSubview:sendimg];
    sendimg.frame=CGRectMake(sendcodebtn.right+5, sendcodebtn.top+5, 40, 40);
    timelab=[[UILabel alloc] initWithFrame:CGRectMake(sendcodebtn.right+5, sendcodebtn.top+5, 40, 40)];
    timelab.font=[UIFont systemFontOfSize:kAppFontSize];
    timelab.hidden=YES;
    [self.view addSubview:timelab];
    
    [sendcodebtn handleControlEvents:UIControlEventTouchUpInside actionBlock:^(id sender) {
        //
        NSLog(@"forgetBtn");
        if (phonetfd.text.length==0) {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"请输入手机号码再发送验证码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alt show];
        }else{
            PDHTTPEngine *engine=[[PDHTTPEngine alloc] init];
            [engine sendverificationWithphone:phonetfd.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"responseObject==%@",responseObject);
                sendcodebtn.hidden=YES;
                sendimg.hidden=YES;
                timelab.hidden=NO;
                timelab.text=[NSString stringWithFormat:@"%ds",60];
                [self performSelector:@selector(waitingSendCode:) withObject:[NSNumber numberWithInt:60] afterDelay:1.0f];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *alt=[[UIAlertView alloc] initWithTitle:[error.userInfo objectForKey:@"Message"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alt show];
            }];
        }
    }];
    
    codetfd=[[UITextField alloc] initWithFrame:CGRectMake(kGap, phonetfd.bottom+kGap, kAppWidth-kGap*2, 50)];
    codetfd.delegate=self;
    codetfd.layer.cornerRadius = 0;
    codetfd.layer.masksToBounds = YES;
    codetfd.layer.borderWidth = 1;
    codetfd.layer.borderColor = [[UIColor colorWithHexString:kAppLineColor] CGColor];
    codetfd.font=[UIFont systemFontOfSize:kAppFontSize];
    codetfd.textColor=[UIColor colorWithHexString:kAppNormalColor];
    codetfd.placeholder=@"请输入验证码";
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTextFieldLeft, codetfd.frame.size.height)];
    codetfd.leftView = view2;
    codetfd.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:codetfd];
    
    
    passwordtfd=[[UITextField alloc] initWithFrame:CGRectMake(kGap, codetfd.bottom+kGap, kAppWidth-kGap*2, 50)];
    passwordtfd.delegate=self;
    passwordtfd.borderStyle=UITextBorderStyleLine;
    passwordtfd.layer.cornerRadius = 0;
    passwordtfd.layer.masksToBounds = YES;
    passwordtfd.layer.borderWidth = 1;
    passwordtfd.layer.borderColor = [[UIColor colorWithHexString:kAppLineColor] CGColor];
    passwordtfd.font=[UIFont systemFontOfSize:kAppFontSize];
    passwordtfd.textColor=[UIColor colorWithHexString:kAppNormalColor];
    passwordtfd.placeholder=@"请输入密码";
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTextFieldLeft, passwordtfd.frame.size.height)];
    passwordtfd.leftView = view3;
    passwordtfd.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:passwordtfd];
    
    submitbtn = [[UIButton alloc] initWithFrame:CGRectMake(kGap, passwordtfd.bottom+kGap, kAppWidth-kGap*2, 40)];
    submitbtn.backgroundColor=[UIColor colorWithHexString:kAppRedColor];
    [submitbtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [self.view addSubview:submitbtn];
    [submitbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitbtn setTitle:@"提交" forState:UIControlStateNormal];
    submitbtn.layer.cornerRadius = kBtnCornerRadius;
    submitbtn.layer.masksToBounds = YES;
    submitbtn.layer.borderWidth = 1;
    submitbtn.layer.borderColor = [[UIColor colorWithHexString:kAppRedColor] CGColor];
    [submitbtn handleControlEvents:UIControlEventTouchUpInside actionBlock:^(id sender) {
        //
        NSLog(@"registBtn");
        if (phonetfd.text.length==0||codetfd.text.length==0||passwordtfd.text.length==0) {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"请输入全部信息后再注册" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alt show];
        }else{
            PDHTTPEngine *engine=[[PDHTTPEngine alloc] init];
            [engine registerWithphone:phonetfd.text verification:codetfd.text password:passwordtfd.text type:@"register" success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"responseObject==%@",responseObject);
                UIAlertView *alt=[[UIAlertView alloc] initWithTitle:[responseObject objectForKey:@"msg"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alt show];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *alt=[[UIAlertView alloc] initWithTitle:[error.userInfo objectForKey:@"Message"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alt show];
            }];
        }
    }];
    
}
-(void)waitingSendCode:(NSNumber*)times
{
    int etime=[times intValue];
    if (etime==0) {
        sendcodebtn.hidden=NO;
        sendimg.hidden=NO;
        timelab.hidden=YES;
    }
    timelab.text=[NSString stringWithFormat:@"%ds",etime];
    [self performSelector:@selector(waitingSendCode:) withObject:[NSNumber numberWithInt:etime-1] afterDelay:1.0f];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor = [[UIColor colorWithHexString:kAppRedColor] CGColor];
    textField.textColor=[UIColor colorWithHexString:kAppRedColor];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.layer.borderColor = [[UIColor colorWithHexString:kAppLineColor] CGColor];
    textField.textColor=[UIColor colorWithHexString:kAppNormalColor];
}
-(void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

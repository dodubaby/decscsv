//
//  PDOrderInquiryTableViewController.m
//  PDSupplier
//
//  Created by zdf on 14/12/21.
//  Copyright (c) 2014年 Man. All rights reserved.
//

#import "PDOrderInquiryTableViewController.h"
#import "PDOrderModel.h"
#import "PDOrderCell.h"
#import "PDAllOrderTableViewController.h"
#import "PDHTTPEngine.h"


@interface PDOrderInquiryTableViewController ()
{
    
    UIView *footer;
}
@end

@implementation PDOrderInquiryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _list=[[NSMutableArray alloc] init];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(0, 0, 26, 40);
    [button setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem * leftDrawerButton  = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    UILabel *ttitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kAppWidth, 44)];
    ttitle.text=@"配送的";
    ttitle.font=[UIFont systemFontOfSize:kAppFontSize];
    ttitle.textColor=[UIColor colorWithHexString:kAppNormalColor];
    ttitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=ttitle;
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.backgroundColor = [UIColor clearColor];
    rightbutton.frame = CGRectMake(0, 0, 64, 44);
    [rightbutton.titleLabel setFont:[UIFont systemFontOfSize:kAppFontSize]];
    [rightbutton setTitle:@"全部订单" forState:UIControlStateNormal];
    rightbutton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [rightbutton setTitleColor:[UIColor colorWithHexString:kAppNormalColor] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(allOrderAciton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightbarbutton  = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    [self.navigationItem setRightBarButtonItem:rightbarbutton animated:YES];
    
    
    footer=[[UIView alloc] initWithFrame:CGRectMake(0, kAppHeight-50, kAppWidth, 50)];
    footer.backgroundColor=[UIColor colorWithRed:0.4000 green:0.4000 blue:0.4000 alpha:1.0f];
    
    UIButton *searchutton = [[UIButton alloc] initWithFrame:CGRectMake(kAppWidth-kCellLeftGap-120, kCellLeftGap/2, 120, 40)];
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithHexString:kAppRedColor] size:searchutton.size];
    [searchutton setBackgroundImage:image forState:UIControlStateNormal];
    [footer addSubview:searchutton];
    [searchutton setTitle:@"查询" forState:UIControlStateNormal];
    [searchutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchutton.titleLabel setFont:[UIFont systemFontOfSize:kAppBtnSize]];
    [searchutton handleControlEvents:UIControlEventTouchUpInside actionBlock:^(id sender) {
        [self.tableView triggerPullToRefresh];
    }];
    searchutton.layer.cornerRadius = kBtnCornerRadius;
    searchutton.layer.masksToBounds = YES;
    searchutton.layer.borderWidth = 1;
    searchutton.layer.borderColor = [[UIColor colorWithHexString:kAppRedColor] CGColor];
    
    _input =[[UITextField alloc] initWithFrame:CGRectMake(kCellLeftGap, kCellLeftGap/2, kAppWidth-kCellLeftGap*2.5-searchutton.width, 40)];
    _input.borderStyle=UITextBorderStyleNone;
    _input.clearButtonMode=UITextFieldViewModeWhileEditing;
    _input.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    _input.placeholder=@"输入手机号后4位";
    _input.backgroundColor=[UIColor whiteColor];
    _input.delegate=self;
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kTextFieldLeft, _input.frame.size.height)];
    _input.leftView = view1;
    _input.leftViewMode = UITextFieldViewModeAlways;
    [footer addSubview:_input];

    UIWindow *keywindow=[[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:footer];

    // pull
    _type=1;
    _curpage=0;
    __weak PDOrderInquiryTableViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        //
        PDHTTPEngine *engine=[[PDHTTPEngine alloc] init];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *kitchenid=[defaults objectForKey:@"kitchenid"];
        [engine searchOrderWithKitchenid:kitchenid type:weakSelf.type phone:weakSelf.input.text page:weakSelf.curpage success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [weakSelf.list removeAllObjects];
            weakSelf.curpage=0;
            NSArray *arr=(NSArray*)responseObject;
            for (int i=0; i<arr.count; i++) {
                PDOrderModel *model = [PDOrderModel objectWithJoy:[arr objectAtIndex:i]];
                [weakSelf.list addObject:model];
            }
            
            [weakSelf.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:[error.userInfo objectForKey:@"Message"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alt show];
        }];
        
        
    }];
    //
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.curpage++;
        PDHTTPEngine *engine=[[PDHTTPEngine alloc] init];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *kitchenid=[defaults objectForKey:@"kitchenid"];
        [engine searchOrderWithKitchenid:kitchenid type:weakSelf.type phone:weakSelf.input.text page:weakSelf.curpage success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            NSArray *arr=(NSArray*)responseObject;
            for (int i=0; i<arr.count; i++) {
                PDOrderModel *model = [PDOrderModel objectWithJoy:[arr objectAtIndex:i]];
                [weakSelf.list addObject:model];
            }
            [weakSelf.tableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:[error.userInfo objectForKey:@"Message"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alt show];
        }];
    }];
    
}
-(void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)allOrderAciton:(id)sender
{
    PDAllOrderTableViewController*vc=[[PDAllOrderTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIWindow *keywindow=[[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:footer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disappearKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    if (self.list.count==0) {
        [self.tableView triggerPullToRefresh];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [footer removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)showKeyBoard:(NSNotification *)notification{
    NSDictionary *userinfo =notification.userInfo;
    NSLog(@"%@",userinfo);
    CGRect NeedToFrame=CGRectZero;
    double duration =[[userinfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endRect =[[userinfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float Y=0.0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        Y=[UIScreen mainScreen].bounds.size.height-endRect.size.height;
    }else{
        CGRect _rect        =[[userinfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        //  需要手动 转化一下
        /* ios7
         "The key for an NSValue object containing a CGRect that identifies the start/end frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the window’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to window coordinates (using the convertRect:fromWindow: method) or to view coordinates (using the convertRect:fromView: method) before using it."
         
         大意说，这个CGRect不考虑任何旋转，用的时候一定要对这个rect进行坐标转换（convertRect:）。
         （这里找到资料说，The first view should be your view. The second view should be nil, meaning window/screen coordinates. ）
         */
        CGRect _convertRect=[self.view convertRect:_rect fromView:nil];
        NSLog(@"_convertRect=====%@",NSStringFromCGRect(_convertRect));
        Y  =[UIScreen mainScreen].bounds.size.width-_convertRect.size.height;
    }
    NeedToFrame =(CGRect){footer.origin.x,Y-footer.frame.size.height,footer.size.width,footer.size.height};
    [UIView animateWithDuration:duration animations:^{
        footer.frame =NeedToFrame;
    } completion:nil];
    
}
-(void)disappearKeyboard:(NSNotification *)notification{
    NSDictionary *userinfo =notification.userInfo;
    NSLog(@"%@",userinfo);
    double duration =[[userinfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        footer.frame =CGRectMake(0, kAppHeight-50, kAppWidth, 50);
    } completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _list.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, 60)];
    header.backgroundColor=[UIColor whiteColor];
    
    UIButton *AMButton = [[UIButton alloc] initWithFrame:CGRectMake(kGap, kGap, (kAppWidth-2*kGap)/2, 50)];
    AMButton.backgroundColor=[UIColor whiteColor];
    [header addSubview:AMButton];
    [AMButton setTitle:@"配送的订单" forState:UIControlStateNormal];
    [AMButton.titleLabel setFont:[UIFont systemFontOfSize:kAppFontSize]];
    [AMButton setTitleColor:[UIColor colorWithHexString:kAppNormalColor] forState:UIControlStateNormal];

    
    UIImageView *gapimg=[[UIImageView alloc] initWithFrame:CGRectMake(AMButton.right, AMButton.top+18, 1, 16)];
    gapimg.backgroundColor=[UIColor colorWithHexString:kAppLineColor];
    [header addSubview:gapimg];
    UIButton *PMButton = [[UIButton alloc] initWithFrame:CGRectMake(AMButton.right+1, kGap, (kAppWidth-2*kGap)/2, 50)];
    PMButton.backgroundColor=[UIColor whiteColor];
    [header addSubview:PMButton];
    [PMButton setTitle:@"退款的订单" forState:UIControlStateNormal];
    [PMButton setTitleColor:[UIColor colorWithHexString:kAppNormalColor] forState:UIControlStateNormal];
    [PMButton.titleLabel setFont:[UIFont systemFontOfSize:kAppFontSize]];

    
    [AMButton handleControlEvents:UIControlEventTouchUpInside actionBlock:^(id sender) {
        [AMButton setTitleColor:[UIColor colorWithHexString:kAppRedColor] forState:UIControlStateNormal];
        [PMButton setTitleColor:[UIColor colorWithHexString:kAppNormalColor] forState:UIControlStateNormal];
        _type=1;
        [self.tableView triggerPullToRefresh];
    }];
    [PMButton handleControlEvents:UIControlEventTouchUpInside actionBlock:^(id sender) {
        [AMButton setTitleColor:[UIColor colorWithHexString:kAppNormalColor] forState:UIControlStateNormal];
        [PMButton setTitleColor:[UIColor colorWithHexString:kAppRedColor] forState:UIControlStateNormal];
        _type=2;
        [self.tableView triggerPullToRefresh];
    }];
    if (_type==1) {
        [AMButton setTitleColor:[UIColor colorWithHexString:kAppRedColor] forState:UIControlStateNormal];
        [PMButton setTitleColor:[UIColor colorWithHexString:kAppNormalColor] forState:UIControlStateNormal];
    }else{
        [AMButton setTitleColor:[UIColor colorWithHexString:kAppNormalColor] forState:UIControlStateNormal];
        [PMButton setTitleColor:[UIColor colorWithHexString:kAppRedColor] forState:UIControlStateNormal];
    }
    
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDOrderModel *order=[_list objectAtIndex:indexPath.row];
    order.type=OrderTypeToday;
    return [PDOrderCell cellHeightWithData:order];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellstring=@"inOrdercellID";
    PDOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellstring];
    if (!cell) {
        cell = [[PDOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellstring];
    }
    PDOrderModel *order=[_list objectAtIndex:indexPath.row];
    order.index=indexPath.row;
    order.type=OrderTypeToday;
    [cell setData:order];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



// 开始配送
-(void)pdBaseTableViewCellDelegate:(PDBaseTableViewCell *)cell startSendOrderWithData:(id)data
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *kitchenid=[defaults objectForKey:@"kitchenid"];
    PDOrderModel *order=(PDOrderModel*)data;
    PDHTTPEngine *engine=[[PDHTTPEngine alloc] init];
    [engine finishOrderWithKitchenid:kitchenid orderid:[order.order_id integerValue] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject==%@",responseObject);
        UIAlertView *alt=[[UIAlertView alloc] initWithTitle:responseObject[@"msg"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alt=[[UIAlertView alloc] initWithTitle:[error.userInfo objectForKey:@"Message"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
    }];
}

// 配送完成
-(void)pdBaseTableViewCellDelegate:(PDBaseTableViewCell *)cell finishSendOrderWithData:(id)data
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *kitchenid=[defaults objectForKey:@"kitchenid"];
    PDOrderModel *order=(PDOrderModel*)data;
    PDHTTPEngine *engine=[[PDHTTPEngine alloc] init];
    [engine refundOrderWithKitchenid:kitchenid orderid:[order.order_id integerValue] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject==%@",responseObject);
        UIAlertView *alt=[[UIAlertView alloc] initWithTitle:responseObject[@"msg"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alt=[[UIAlertView alloc] initWithTitle:[error.userInfo objectForKey:@"Message"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
    }];
}


@end

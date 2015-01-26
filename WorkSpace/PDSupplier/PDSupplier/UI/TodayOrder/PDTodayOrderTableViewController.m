//
//  PDTodayOrderTableViewController.m
//  PDSupplier
//
//  Created by zdf on 14/12/21.
//  Copyright (c) 2014年 Man. All rights reserved.
//

#import "PDTodayOrderTableViewController.h"
#import "PDOrderModel.h"
#import "PDOrderCell.h"
#import "PDHTTPEngine.h"



@interface PDTodayOrderTableViewController ()
{
    
}
@end

@implementation PDTodayOrderTableViewController
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)recieveNeworder:(NSNotification*)notification
{
    NSLog(@"notification==%@",notification);
    [self.tableView triggerPullToRefresh];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNeworder:) name:@"recieveNeworder" object:nil];
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
    ttitle.text=@"今日订单";
    ttitle.font=[UIFont systemFontOfSize:kAppFontSize];
    ttitle.textColor=[UIColor colorWithHexString:kAppNormalColor];
    ttitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=ttitle;
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    // pull
    _type=1;
    __weak PDTodayOrderTableViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        //
        weakSelf.curpage=0;
        PDHTTPEngine *engine=[[PDHTTPEngine alloc] init];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *kitchenid=[defaults objectForKey:@"kitchenid"];
        [engine getTodayOrderWithKitchenid:kitchenid type:weakSelf.type page:weakSelf.curpage success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [weakSelf.list removeAllObjects];
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
        [engine getTodayOrderWithKitchenid:kitchenid type:weakSelf.type page:weakSelf.curpage success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSArray *arr=(NSArray*)responseObject;
            if (arr.count>0) {
                for (int i=0; i<arr.count; i++) {
                    PDOrderModel *model = [PDOrderModel objectWithJoy:[arr objectAtIndex:i]];
                    [weakSelf.list addObject:model];
                }
                [weakSelf.tableView reloadData];
            }else if(weakSelf.list.count>0){
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, 40)];
                label.backgroundColor = [UIColor whiteColor];
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = [UIColor colorWithHexString:@"#666666"];
                label.textAlignment = NSTextAlignmentCenter;
                label.text = @"没有更多的订单";
                [weakSelf.tableView.infiniteScrollingView setCustomView:label forState:SVInfiniteScrollingStateStopped];
            }
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.list.count==0) {
        [self.tableView triggerPullToRefresh];
    }
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
    if (_list.count==0) {
        [self showDefaultView];
    }else{
        [self hiddenDefaultView];
    }
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
    [AMButton setTitle:@"上午订单" forState:UIControlStateNormal];
    [AMButton.titleLabel setFont:[UIFont systemFontOfSize:kAppFontSize]];
    [AMButton setTitleColor:[UIColor colorWithHexString:kAppRedColor] forState:UIControlStateNormal];
    
    UIImageView *gapimg=[[UIImageView alloc] initWithFrame:CGRectMake(AMButton.right, AMButton.top+18, 1, 16)];
    gapimg.backgroundColor=[UIColor colorWithHexString:kAppLineColor];
    [header addSubview:gapimg];
    UIButton *PMButton = [[UIButton alloc] initWithFrame:CGRectMake(AMButton.right+1, kGap, (kAppWidth-2*kGap)/2, 50)];
    PMButton.backgroundColor=[UIColor whiteColor];
    [header addSubview:PMButton];
    [PMButton setTitle:@"下午订单" forState:UIControlStateNormal];
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
    static NSString *cellstring=@"ordercellID";
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
// 确认订单
-(void)pdBaseTableViewCellDelegate:(PDBaseTableViewCell *)cell confirmOrderWithData:(id)data
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *kitchenid=[defaults objectForKey:@"kitchenid"];
    PDOrderModel *order=(PDOrderModel*)data;
    PDHTTPEngine *engine=[[PDHTTPEngine alloc] init];
    [engine confirmOrderWithKitchenid:kitchenid orderid:[order.order_id integerValue] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject==%@",responseObject);
//        UIAlertView *alt=[[UIAlertView alloc] initWithTitle:responseObject[@"msg"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alt show];
        order.is_confirm=@"1";
        NSIndexPath *indexpath=[self.tableView indexPathForCell:cell];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alt=[[UIAlertView alloc] initWithTitle:[error.userInfo objectForKey:@"Message"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
    }];
}

// 完成订单
-(void)pdBaseTableViewCellDelegate:(PDBaseTableViewCell *)cell finishOrderWithData:(id)data
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *kitchenid=[defaults objectForKey:@"kitchenid"];
    PDOrderModel *order=(PDOrderModel*)data;
    PDHTTPEngine *engine=[[PDHTTPEngine alloc] init];
    [engine finishOrderWithKitchenid:kitchenid orderid:[order.order_id integerValue] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject==%@",responseObject);
//        UIAlertView *alt=[[UIAlertView alloc] initWithTitle:responseObject[@"msg"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alt show];
        order.is_finish=@"1";
        [self.list removeObject:order];
        NSIndexPath *indexpath=[self.tableView indexPathForCell:cell];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationBottom];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alt=[[UIAlertView alloc] initWithTitle:[error.userInfo objectForKey:@"Message"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
    }];
}
// 取消订单
-(void)pdBaseTableViewCellDelegate:(PDBaseTableViewCell *)cell refundOrderWithData:(id)data
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *kitchenid=[defaults objectForKey:@"kitchenid"];
    PDOrderModel *order=(PDOrderModel*)data;
    PDHTTPEngine *engine=[[PDHTTPEngine alloc] init];
    [engine refundOrderWithKitchenid:kitchenid orderid:[order.order_id integerValue] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject==%@",responseObject);
        order.is_refund=@"1";
        [self.list removeObject:order];
        NSIndexPath *indexpath=[self.tableView indexPathForCell:cell];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationBottom];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alt=[[UIAlertView alloc] initWithTitle:[error.userInfo objectForKey:@"Message"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
    }];
}

@end

//
//  PDAllOrderTableViewController.m
//  PDSupplier
//
//  Created by zdf on 14/12/21.
//  Copyright (c) 2014年 Man. All rights reserved.
//

#import "PDAllOrderTableViewController.h"
#import "PDOrderModel.h"
#import "PDOrderCell.h"
#import "PDHTTPEngine.h"
#import "VRGCalendarView.h"

@interface PDAllOrderTableViewController ()<UITabBarControllerDelegate,VRGCalendarViewDelegate>
{
    UIControl *_iPCalendarControl;
    UIView *footer;
    BOOL isshowcalendar;
    VRGCalendarView *curcalendar;
    UIButton *calendarutton;
    UIButton *cancelbutton;
    UIButton *conformbutton;
}
@end

@implementation PDAllOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _list=[[NSMutableArray alloc] init];
    
    UIImageView *img=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Back"]];
    img.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction:)];
    [img addGestureRecognizer:tap];
    UIBarButtonItem *leftbar=[[UIBarButtonItem alloc] initWithCustomView:img];
    self.navigationItem.leftBarButtonItem=leftbar;
    UILabel *ttitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kAppWidth, 44)];
    ttitle.text=@"全部订单";
    ttitle.font=[UIFont systemFontOfSize:kAppFontSize];
    ttitle.textColor=[UIColor colorWithHexString:kAppNormalColor];
    ttitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=ttitle;
    
    footer=[[UIView alloc] initWithFrame:CGRectMake(0, kAppHeight-50, kAppWidth, 50)];
    footer.backgroundColor=[UIColor colorWithRed:0.4000 green:0.4000 blue:0.4000 alpha:1.0f];
    UIWindow *keywindow=[[UIApplication sharedApplication] keyWindow];
    
    isshowcalendar=NO;
    
    cancelbutton = [[UIButton alloc] initWithFrame:CGRectMake(kCellLeftGap, kCellLeftGap/2, (kAppWidth-3*kCellLeftGap)/2, 40)];
    UIImage *caimage = [UIImage imageWithColor:[UIColor colorWithHexString:kAppTitleColor] size:cancelbutton.size];
    [cancelbutton setBackgroundImage:caimage forState:UIControlStateNormal];
    [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelbutton.titleLabel setFont:[UIFont systemFontOfSize:kAppBtnSize]];
    [cancelbutton handleControlEvents:UIControlEventTouchUpInside actionBlock:^(id sender) {
        isshowcalendar=NO;
        cancelbutton.hidden=!isshowcalendar;
        conformbutton.hidden=!isshowcalendar;
        calendarutton.hidden=isshowcalendar;
        
        [_iPCalendarControl removeFromSuperview];
        NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
        //fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        fmt.dateFormat = @"yyyy-MM-dd";
        NSString* dateString = [fmt stringFromDate:curcalendar.selectedDate];
        self.start_date=dateString;
        self.end_date=dateString;
        [self.tableView triggerPullToRefresh];
        
    }];
    cancelbutton.layer.cornerRadius = kBtnCornerRadius;
    cancelbutton.layer.masksToBounds = YES;
    cancelbutton.layer.borderWidth = 1;
    cancelbutton.layer.borderColor = [[UIColor colorWithHexString:kAppTitleColor] CGColor];
    [footer addSubview:cancelbutton];
    
    
    conformbutton = [[UIButton alloc] initWithFrame:CGRectMake(cancelbutton.right+kCellLeftGap, kCellLeftGap/2, (kAppWidth-3*kCellLeftGap)/2, 40)];
    UIImage *cimage = [UIImage imageWithColor:[UIColor colorWithHexString:kAppRedColor] size:conformbutton.size];
    [conformbutton setBackgroundImage:cimage forState:UIControlStateNormal];
    [conformbutton setTitle:@"确认" forState:UIControlStateNormal];
    [conformbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [conformbutton.titleLabel setFont:[UIFont systemFontOfSize:kAppBtnSize]];
    [conformbutton handleControlEvents:UIControlEventTouchUpInside actionBlock:^(id sender) {
        isshowcalendar=NO;
        cancelbutton.hidden=!isshowcalendar;
        conformbutton.hidden=!isshowcalendar;
        calendarutton.hidden=isshowcalendar;
        [_iPCalendarControl removeFromSuperview];
    }];
    conformbutton.layer.cornerRadius = kBtnCornerRadius;
    conformbutton.layer.masksToBounds = YES;
    conformbutton.layer.borderWidth = 1;
    conformbutton.layer.borderColor = [[UIColor colorWithHexString:kAppRedColor] CGColor];
    [footer addSubview:conformbutton];
    
    
    calendarutton = [[UIButton alloc] initWithFrame:CGRectMake(kCellLeftGap, kCellLeftGap/2, kAppWidth-2*kCellLeftGap, 40)];
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithHexString:kAppRedColor] size:calendarutton.size];
    [calendarutton setBackgroundImage:image forState:UIControlStateNormal];
    [calendarutton setTitle:@"日历" forState:UIControlStateNormal];
    [calendarutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [calendarutton.titleLabel setFont:[UIFont systemFontOfSize:kAppBtnSize]];
    [calendarutton handleControlEvents:UIControlEventTouchUpInside actionBlock:^(id sender) {
        isshowcalendar=!isshowcalendar;
        cancelbutton.hidden=!isshowcalendar;
        conformbutton.hidden=!isshowcalendar;
        calendarutton.hidden=isshowcalendar;
        
        if (!_iPCalendarControl) {
            _iPCalendarControl =[[UIControl alloc] initWithFrame:(CGRect){0,0,kAppWidth,kAppHeight-40}];
            _iPCalendarControl.backgroundColor=[UIColor clearColor];
            NSLog(@"_iPCalendarControl.frame=%@",NSStringFromCGRect(_iPCalendarControl.frame));
            curcalendar =  [[VRGCalendarView alloc] initWithFrame:CGRectMake(0, kAppHeight-321, kAppWidth, 318)];
            curcalendar.tag =100;
            curcalendar.delegate =self;
            [_iPCalendarControl addSubview:curcalendar];
            [_iPCalendarControl addTarget:self action:@selector(dismissCalandar:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (!_iPCalendarControl.superview) {
            [keywindow addSubview:_iPCalendarControl];
            [(VRGCalendarView *)[_iPCalendarControl viewWithTag:100] reset];
        }
    }];
    calendarutton.layer.cornerRadius = kBtnCornerRadius;
    calendarutton.layer.masksToBounds = YES;
    calendarutton.layer.borderWidth = 1;
    calendarutton.layer.borderColor = [[UIColor colorWithHexString:kAppRedColor] CGColor];
    [footer addSubview:calendarutton];
    
    [keywindow addSubview:footer];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;

    __weak PDAllOrderTableViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        //
        weakSelf.curpage=0;
        PDHTTPEngine *engine=[[PDHTTPEngine alloc] init];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *kitchenid=[defaults objectForKey:@"kitchenid"];
        [engine allOrderWithKitchenid:kitchenid start_date:weakSelf.start_date end_date:weakSelf.start_date page:weakSelf.curpage success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        [engine allOrderWithKitchenid:kitchenid start_date:weakSelf.start_date end_date:weakSelf.end_date page:weakSelf.curpage success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIWindow *keywindow=[[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:footer];
    if (self.list.count==0) {
        [self.tableView triggerPullToRefresh];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [footer removeFromSuperview];
}
-(void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
/*-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40+kCellLeftGap*2;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, 40)];
    header.backgroundColor=[UIColor whiteColor];

    UIButton *calendar = [[UIButton alloc] initWithFrame:CGRectMake(kCellLeftGap, kCellLeftGap, kAppWidth-kCellLeftGap*2, 40)];
    calendar.backgroundColor=[UIColor whiteColor];
    [header addSubview:calendar];
    [calendar setTitle:@"日历" forState:UIControlStateNormal];
    [calendar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [calendar handleControlEvents:UIControlEventTouchUpInside actionBlock:^(id sender) {
        if (!_iPCalendarControl) {
            _iPCalendarControl =[[UIControl alloc] initWithFrame:(CGRect){0,0,kAppWidth,kAppHeight}];
            NSLog(@"%@",NSStringFromCGRect(_iPCalendarControl.frame));
            _iPCalendarControl.backgroundColor =[UIColor clearColor];
            VRGCalendarView *calendar =  [[VRGCalendarView alloc] init];
            calendar.tag =100;
            calendar.delegate =self;
            [_iPCalendarControl addSubview:calendar];
            [_iPCalendarControl addTarget:self action:@selector(dismissCalandar:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (!_iPCalendarControl.superview) {
            [self.view addSubview:_iPCalendarControl];
            [(VRGCalendarView *)[_iPCalendarControl viewWithTag:100] reset];
        }
    }];
    return header;
}*/
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated{
    
    NSLog(@"%s,%@,select date :%@,labeltitle:%@",__func__,[NSString stringWithFormat:@"%@",calendarView.currentMonth],[NSString stringWithFormat:@"%@",calendarView.selectedDate],calendarView.labelCurrentMonth.text);
    
//    if ([SCShareFunc isIPhone]) {
//        CGRect frame = [[_iPCalendarControl viewWithTag:100] frame];
//        frame.size.height =targetHeight;
//        [[_iPCalendarControl viewWithTag:100] setFrame:(CGRect){KDeviceHight-frame.size.width-10,self.topCalanderBtn.frame.origin.y+self.topCalanderBtn.frame.size.height,frame.size.width,frame.size.height}]; //;
//    }else{
//        _calendarViewController.popoverContentSize=CGSizeMake(321, targetHeight);
//    }
//    
//    // then get the active day
//    //  getMonthActiveDays //2014-01-01 eg
//    riliMonthDay =[SCShareFunc firstDayStrFromMonth:calendarView.currentMonth];
//    NSLog(@"rilimonth --%@",riliMonthDay);
//    
//    [SCNetManager getSleepActivityInfoSuccess:^(BOOL success,NSDictionary *response){
//        if (success) {
//            [calendarView reDisplayViewUse:response];
//        }
//        
//    } faileture:^(BOOL faile){
//        if (faile) {
//            [calendarView reDisplayViewUse:nil];
//        }
//        
//    } withType:KgetMonthActiveDays andWithPeroid:0];
    
}
-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date
{
    NSLog(@"date==%@",date);
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    //fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString* dateString = [fmt stringFromDate:date];
    self.start_date=dateString;
    self.end_date=dateString;
    [self.tableView triggerPullToRefresh];
}
-(void)dismissCalandar:(id)sender
{
    [_iPCalendarControl removeFromSuperview];
    isshowcalendar=NO;
    cancelbutton.hidden=!isshowcalendar;
    conformbutton.hidden=!isshowcalendar;
    calendarutton.hidden=isshowcalendar;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDOrderModel *order=[_list objectAtIndex:indexPath.row];
    order.type=OrderTypeNormal;
    return [PDOrderCell cellHeightWithData:order];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellstring=@"allOrdercellID";
    PDOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellstring];
    if (!cell) {
        cell = [[PDOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellstring];
    }
    PDOrderModel *order=[_list objectAtIndex:indexPath.row];
    order.index=indexPath.row;
    order.type=OrderTypeNormal;
    [cell setData:order];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)pdBaseTableViewCellDelegate:(PDBaseTableViewCell *)cell addOrderWithData:(id)data{
    
    
}

@end

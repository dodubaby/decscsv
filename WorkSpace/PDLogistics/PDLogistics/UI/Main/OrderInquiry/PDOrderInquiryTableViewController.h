//
//  PDOrderInquiryTableViewController.h
//  PDSupplier
//
//  Created by zdf on 14/12/21.
//  Copyright (c) 2014年 Man. All rights reserved.
//

#import "PDBaseTableViewController.h"
#import "PDBaseTableViewCell.h"

@interface PDOrderInquiryTableViewController : PDBaseTableViewController<PDBaseTableViewCellDelegate,UITextFieldDelegate>

@property(nonatomic,strong) NSMutableArray *list;
@property(nonatomic,assign) NSInteger type;//1配送的，2退款的
@property(nonatomic,assign) NSInteger curpage;//当前加载到第几页,从0开始
@property(nonatomic,strong) UITextField *input;

@end

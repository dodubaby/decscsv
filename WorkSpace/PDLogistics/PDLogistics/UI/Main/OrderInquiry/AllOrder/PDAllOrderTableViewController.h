//
//  PDAllOrderTableViewController.h
//  PDSupplier
//
//  Created by zdf on 14/12/21.
//  Copyright (c) 2014年 Man. All rights reserved.
//

#import "PDBaseTableViewController.h"
#import "PDBaseTableViewCell.h"

@interface PDAllOrderTableViewController : PDBaseTableViewController<PDBaseTableViewCellDelegate>


@property(nonatomic,strong) NSMutableArray *list;
@property(nonatomic,assign) NSInteger curpage;//当前加载到第几页,从0开始

@property(nonatomic,copy) NSString *start_date;//起始时间
@property(nonatomic,copy) NSString *end_date;//结束时间


@end

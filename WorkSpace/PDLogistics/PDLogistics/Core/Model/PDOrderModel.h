//
//  PDOrderModel.h
//  PDSupplier
//
//  Created by zdf on 14/12/21.
//  Copyright (c) 2014年 Man. All rights reserved.
//

#import "PDBaseModel.h"
typedef NS_ENUM(NSUInteger, OrderType) {
    OrderTypeToday = 1,  // 今日订单
    OrderTypeNormal,     // 普通订单
    
};
@interface PDOrderModel : PDBaseModel

@property(nonatomic,assign) OrderType type;
@property(nonatomic,assign) NSInteger index;
@property(nonatomic,copy) NSString *address;
@property(nonatomic,copy) NSString *eat_time;
@property(nonatomic,copy) NSString *food_name;
@property(nonatomic,copy) NSString *food_num;
@property(nonatomic,copy) NSString *food_price;
@property(nonatomic,copy) NSString *is_confirm;
@property(nonatomic,copy) NSString *is_eat;
@property(nonatomic,copy) NSString *is_finish;
@property(nonatomic,copy) NSString *message;
@property(nonatomic,copy) NSString *order_id;
@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *sum_price;

@end

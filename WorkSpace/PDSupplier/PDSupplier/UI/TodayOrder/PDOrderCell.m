//
//  PDOrderCell.m
//  PDSupplier
//
//  Created by zdf on 14/12/21.
//  Copyright (c) 2014年 Man. All rights reserved.
//

#import "PDOrderCell.h"
#import "PDOrderModel.h"

@interface PDOrderCell()
{
    
    UIImageView *sortimg;
    UILabel *sortlab;
    UIImageView *bgborderimg;
    UIImageView *newmarkimg;
    UILabel *totallab;
    UILabel *everyla[100];
    UILabel *msglab;
    UILabel *timelab;
    UILabel *phonelab;
    UILabel *addresslab;
    UIButton *receivebtn;
    UIButton *finishbtn;
    UIButton *cancelbtn;
    
}
@end

@implementation PDOrderCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        NSLog(@"self.width == %f",self.width);
        
        
        sortimg = [[UIImageView alloc] initWithFrame:CGRectMake(kCellLeftGap, 0, 22.5, 22.5)];
        sortimg.image=[UIImage imageNamed:@"订单号背景"];
        [self addSubview:sortimg];
        sortlab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22.5, 22.5)];
        sortlab.backgroundColor=[UIColor clearColor];
        sortlab.font=[UIFont systemFontOfSize:kAppFontSize];
        sortlab.textColor=[UIColor colorWithHexString:kAppNormalColor];
        sortlab.textAlignment=NSTextAlignmentCenter;
        
        [sortimg addSubview:sortlab];

        newmarkimg = [[UIImageView alloc] initWithFrame:CGRectMake(kAppWidth-kCellLeftGap-30, 11+5, 26, 26)];
        [self addSubview:newmarkimg];
        newmarkimg.image=[UIImage imageNamed:@"新"];
        newmarkimg.backgroundColor = [UIColor clearColor];

        
        NSInteger height=sortimg.bottom;
        for (int i=0; i<1; i++) {
            everyla[i]=[[UILabel alloc] initWithFrame:CGRectMake(kCellLeftGap*3, height+kCellLeftGap, kAppWidth-kCellLeftGap*6, 20)];
            everyla[i].font=[UIFont systemFontOfSize:kAppFontSize];
            everyla[i].textColor=[UIColor colorWithHexString:kAppTitleColor];
            height=everyla[i].bottom;
            [self addSubview:everyla[i]];
        }
        msglab=[[UILabel alloc] initWithFrame:CGRectMake(kCellLeftGap*3, height+kCellLeftGap, kAppWidth-kCellLeftGap*6, 20)];
        msglab.font=[UIFont systemFontOfSize:kAppFontSize];
        msglab.textColor=[UIColor colorWithHexString:kAppRedColor];
        [self addSubview:msglab];
        
        phonelab=[[UILabel alloc] initWithFrame:CGRectMake(kCellLeftGap*3, msglab.bottom+kCellLeftGap, kAppWidth-kCellLeftGap*6, 20)];
        phonelab.font=[UIFont systemFontOfSize:kAppFontSize];
        phonelab.textColor=[UIColor colorWithHexString:kAppTitleColor];
        [self addSubview:phonelab];
        
        timelab=[[UILabel alloc] initWithFrame:CGRectMake(kCellLeftGap*3, phonelab.bottom+kCellLeftGap, kAppWidth-kCellLeftGap*6, 20)];
        timelab.font=[UIFont systemFontOfSize:kAppFontSize];
        timelab.textColor=[UIColor colorWithHexString:kAppRedColor];
        [self addSubview:timelab];
        
        addresslab=[[UILabel alloc] initWithFrame:CGRectMake(kCellLeftGap*3, timelab.bottom+kCellLeftGap, kAppWidth-kCellLeftGap*6, 20)];
        addresslab.font=[UIFont systemFontOfSize:kAppFontSize];
        addresslab.textColor=[UIColor colorWithHexString:kAppTitleColor];
        [self addSubview:addresslab];
        
        totallab=[[UILabel alloc] initWithFrame:CGRectMake(kCellLeftGap*3, addresslab.bottom+kCellLeftGap*2, kAppWidth-kCellLeftGap*6, 20)];
        totallab.font=[UIFont systemFontOfSize:kAppFontSize];
        totallab.textColor=[UIColor colorWithHexString:kAppTitleColor];
        [self addSubview:totallab];
        
        
        receivebtn = [[UIButton alloc] initWithFrame:CGRectMake(3*kCellLeftGap, totallab.bottom+kCellLeftGap, (kAppWidth-8*kCellLeftGap)/3, 40)];
        [receivebtn setTitle:@"接单" forState:UIControlStateNormal];
        [receivebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [receivebtn handleControlEvents:UIControlEventTouchUpInside actionBlock:^(id sender) {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(pdBaseTableViewCellDelegate:confirmOrderWithData:)]) {
                [self.delegate pdBaseTableViewCellDelegate:self confirmOrderWithData:self.data];
            }
        }];
        receivebtn.backgroundColor=[UIColor colorWithHexString:kAppRedColor];
        receivebtn.titleLabel.font=[UIFont systemFontOfSize:kAppBtnSize];
        [receivebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        receivebtn.layer.cornerRadius = kBtnCornerRadius;
        receivebtn.layer.masksToBounds = YES;
        UIImage *image = [UIImage imageWithColor:[UIColor colorWithHexString:kAppRedColor] size:receivebtn.size];
        [receivebtn setBackgroundImage:image forState:UIControlStateNormal];
        [self addSubview:receivebtn];
        
        finishbtn = [[UIButton alloc] initWithFrame:CGRectMake(receivebtn.right+kCellLeftGap, totallab.bottom+kCellLeftGap, (kAppWidth-8*kCellLeftGap)/3, 40)];
        [finishbtn setTitle:@"完成" forState:UIControlStateNormal];
        [finishbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [finishbtn handleControlEvents:UIControlEventTouchUpInside actionBlock:^(id sender) {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(pdBaseTableViewCellDelegate:finishOrderWithData:)]) {
                [self.delegate pdBaseTableViewCellDelegate:self finishOrderWithData:self.data];
            }
        }];
        finishbtn.backgroundColor=[UIColor colorWithHexString:kAppRedColor];
        finishbtn.titleLabel.font=[UIFont systemFontOfSize:kAppBtnSize];
        [finishbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        finishbtn.layer.cornerRadius = kBtnCornerRadius;
        finishbtn.layer.masksToBounds = YES;
        UIImage *image1 = [UIImage imageWithColor:[UIColor colorWithHexString:kAppRedColor] size:finishbtn.size];
        [finishbtn setBackgroundImage:image1 forState:UIControlStateNormal];
        [self addSubview:finishbtn];
        
        cancelbtn = [[UIButton alloc] initWithFrame:CGRectMake(finishbtn.right+kCellLeftGap, totallab.bottom+kCellLeftGap, (kAppWidth-8*kCellLeftGap)/3, 40)];
        [cancelbtn setTitle:@"确认退单" forState:UIControlStateNormal];
        [cancelbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelbtn handleControlEvents:UIControlEventTouchUpInside actionBlock:^(id sender) {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(pdBaseTableViewCellDelegate:refundOrderWithData:)]) {
                [self.delegate pdBaseTableViewCellDelegate:self refundOrderWithData:self.data];
            }
        }];
        cancelbtn.backgroundColor=[UIColor colorWithHexString:kAppRedColor];
        cancelbtn.titleLabel.font=[UIFont systemFontOfSize:kAppBtnSize];
        [cancelbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelbtn.layer.cornerRadius = kBtnCornerRadius;
        cancelbtn.layer.masksToBounds = YES;
        UIImage *image2 = [UIImage imageWithColor:[UIColor colorWithHexString:kAppRedColor] size:cancelbtn.size];
        [cancelbtn setBackgroundImage:image2 forState:UIControlStateNormal];
        [self addSubview:cancelbtn];
        
        bgborderimg=[[UIImageView alloc] initWithFrame:CGRectMake(kCellLeftGap, 11, kAppWidth-kCellLeftGap*2, cancelbtn.bottom+kCellLeftGap)];
        bgborderimg.backgroundColor=[UIColor clearColor];
        bgborderimg.layer.cornerRadius = 0;
        bgborderimg.layer.masksToBounds = YES;
        bgborderimg.layer.borderWidth = 1;
        bgborderimg.layer.borderColor = [[UIColor colorWithHexString:kAppLineColor] CGColor];
        [self addSubview:bgborderimg];
        [self sendSubviewToBack:bgborderimg];
    }
    
    return self;
}

-(void)configData:(PDOrderModel*)data{
    sortlab.text=[NSString stringWithFormat:@"%ld",data.index+1];
    totallab.text=[NSString stringWithFormat:@"总计:%@元",data.sum_price];
    for (int i=0; i<1; i++) {
        everyla[i].text=[NSString stringWithFormat:@"%@＊%@  %@元",data.food_name,data.food_num,data.food_price];
    }
    msglab.text=[NSString stringWithFormat:@"食客留言:%@",data.message];
    timelab.text=[NSString stringWithFormat:@"就餐时间:%@",data.eat_time];
    phonelab.text=[NSString stringWithFormat:@"下单人电话:%@",data.phone];
    addresslab.text=[NSString stringWithFormat:@"配送地址:%@",data.address];
    if (data.type==OrderTypeToday) {
        receivebtn.hidden=NO;
        finishbtn.hidden=NO;
        cancelbtn.hidden=NO;
    }else{
        receivebtn.hidden=YES;
        finishbtn.hidden=YES;
        cancelbtn.hidden=YES;
        newmarkimg.hidden=YES;
        bgborderimg.frame=CGRectMake(kCellLeftGap, 11, kAppWidth-kCellLeftGap*2, 212+kCellLeftGap);
    }
    if ([data.is_eat integerValue]==1) {
        receivebtn.userInteractionEnabled=NO;
        [receivebtn setTitle:@"已接单" forState:UIControlStateNormal];
    }else{
        receivebtn.userInteractionEnabled=YES;
        [receivebtn setTitle:@"接单" forState:UIControlStateNormal];
    }
    if([data.is_finish integerValue]==1){
        finishbtn.userInteractionEnabled=NO;
        [finishbtn setTitle:@"已完成" forState:UIControlStateNormal];
    }else{
        finishbtn.userInteractionEnabled=YES;
        [finishbtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    if([data.is_confirm integerValue]==1){
        cancelbtn.userInteractionEnabled=NO;
        [cancelbtn setTitle:@"确认退单" forState:UIControlStateNormal];
    }else{
        cancelbtn.userInteractionEnabled=YES;
        [cancelbtn setTitle:@"已退单" forState:UIControlStateNormal];
    }
    //[self showDebugRect];
}

+(CGFloat )cellHeightWithData:(PDOrderModel*)data{

    if (data.type==OrderTypeToday) {
        return 272+kCellLeftGap*3;
    }else{
        return 222+kCellLeftGap*2;
    }
}

@end

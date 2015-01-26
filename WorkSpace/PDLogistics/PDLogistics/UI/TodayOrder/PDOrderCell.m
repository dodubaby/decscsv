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
    UILabel *cantingaddresslab;
    UILabel *cantingphonelab;
    UIButton *startsendbtn;
    UIButton *finishsendbtn;
    
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
        newmarkimg.hidden=YES;
        
        NSInteger height=sortimg.bottom;
        for (int i=0; i<1; i++) {
            everyla[i]=[[UILabel alloc] initWithFrame:CGRectMake(kCellLeftGap*3, height+kCellLeftGap, kAppWidth-kCellLeftGap*6, 20)];
            everyla[i].font=[UIFont systemFontOfSize:kAppFontSize];
            everyla[i].textColor=[UIColor colorWithHexString:kAppTitleColor];
            height=everyla[i].bottom;
            [self addSubview:everyla[i]];
        }
        //-------------po everyla[i].bottom=52
        
        msglab=[[UILabel alloc] initWithFrame:CGRectMake(kCellLeftGap*3, height+kCellLeftGap, kAppWidth-kCellLeftGap*6, 20)];
        msglab.font=[UIFont systemFontOfSize:kAppFontSize];
        msglab.numberOfLines=0;
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
        addresslab.numberOfLines=0;
        addresslab.font=[UIFont systemFontOfSize:kAppFontSize];
        addresslab.textColor=[UIColor colorWithHexString:kAppTitleColor];
        [self addSubview:addresslab];
        
        cantingaddresslab=[[UILabel alloc] initWithFrame:CGRectMake(kCellLeftGap*3, addresslab.bottom+kCellLeftGap, kAppWidth-kCellLeftGap*6, 20)];
        cantingaddresslab.numberOfLines=0;
        cantingaddresslab.font=[UIFont systemFontOfSize:kAppFontSize];
        cantingaddresslab.textColor=[UIColor colorWithHexString:kAppTitleColor];
        [self addSubview:cantingaddresslab];
        
        cantingphonelab=[[UILabel alloc] initWithFrame:CGRectMake(kCellLeftGap*3, cantingaddresslab.bottom+kCellLeftGap, kAppWidth-kCellLeftGap*6, 20)];
        cantingphonelab.font=[UIFont systemFontOfSize:kAppFontSize];
        cantingphonelab.textColor=[UIColor colorWithHexString:kAppTitleColor];
        [self addSubview:cantingphonelab];
        
        
        totallab=[[UILabel alloc] initWithFrame:CGRectMake(kCellLeftGap*3, cantingphonelab.bottom+kCellLeftGap*2, kAppWidth-kCellLeftGap*6, 20)];
        totallab.font=[UIFont systemFontOfSize:kAppFontSize];
        totallab.textColor=[UIColor colorWithHexString:kAppTitleColor];
        [self addSubview:totallab];
        
        
        /*receivebtn = [[UIButton alloc] initWithFrame:CGRectMake(3*kCellLeftGap, totallab.bottom+kCellLeftGap, (kAppWidth-8*kCellLeftGap)/3, 40)];
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
        [self addSubview:receivebtn];*/
        
        startsendbtn = [[UIButton alloc] initWithFrame:CGRectMake(3*kCellLeftGap, totallab.bottom+kCellLeftGap, (kAppWidth-8*kCellLeftGap)/2, 40)];
        [startsendbtn setTitle:@"开始配送" forState:UIControlStateNormal];
        [startsendbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [startsendbtn handleControlEvents:UIControlEventTouchUpInside actionBlock:^(id sender) {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(pdBaseTableViewCellDelegate:startSendOrderWithData:)]) {
                [self.delegate pdBaseTableViewCellDelegate:self startSendOrderWithData:self.data];
            }
        }];
        startsendbtn.backgroundColor=[UIColor colorWithHexString:kAppRedColor];
        startsendbtn.titleLabel.font=[UIFont systemFontOfSize:kAppBtnSize];
        [startsendbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        startsendbtn.layer.cornerRadius = kBtnCornerRadius;
        startsendbtn.layer.masksToBounds = YES;
        UIImage *image1 = [UIImage imageWithColor:[UIColor colorWithHexString:kAppRedColor] size:startsendbtn.size];
        [startsendbtn setBackgroundImage:image1 forState:UIControlStateNormal];
        UIImage *selectedimage = [UIImage imageWithColor:[UIColor colorWithHexString:kAppTitleColor] size:startsendbtn.size];
        [startsendbtn setBackgroundImage:selectedimage forState:UIControlStateSelected];
        [self addSubview:startsendbtn];
        
        finishsendbtn = [[UIButton alloc] initWithFrame:CGRectMake(startsendbtn.right+kCellLeftGap, totallab.bottom+kCellLeftGap, (kAppWidth-8*kCellLeftGap)/2, 40)];
        [finishsendbtn setTitle:@"配送完成" forState:UIControlStateNormal];
        [finishsendbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [finishsendbtn handleControlEvents:UIControlEventTouchUpInside actionBlock:^(id sender) {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(pdBaseTableViewCellDelegate:finishSendOrderWithData:)]) {
                [self.delegate pdBaseTableViewCellDelegate:self finishSendOrderWithData:self.data];
            }
        }];
        finishsendbtn.backgroundColor=[UIColor colorWithHexString:kAppRedColor];
        finishsendbtn.titleLabel.font=[UIFont systemFontOfSize:kAppBtnSize];
        [finishsendbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        finishsendbtn.layer.cornerRadius = kBtnCornerRadius;
        finishsendbtn.layer.masksToBounds = YES;
        UIImage *image2 = [UIImage imageWithColor:[UIColor colorWithHexString:kAppRedColor] size:finishsendbtn.size];
        [finishsendbtn setBackgroundImage:image2 forState:UIControlStateNormal];
        UIImage *fselectedimage = [UIImage imageWithColor:[UIColor colorWithHexString:kAppTitleColor] size:finishsendbtn.size];
        [finishsendbtn setBackgroundImage:fselectedimage forState:UIControlStateSelected];
        [self addSubview:finishsendbtn];
        
        bgborderimg=[[UIImageView alloc] initWithFrame:CGRectMake(kCellLeftGap, 11, kAppWidth-kCellLeftGap*2, finishsendbtn.bottom+kCellLeftGap)];
        bgborderimg.backgroundColor=[UIColor clearColor];
        bgborderimg.layer.cornerRadius = 0;
        bgborderimg.layer.masksToBounds = YES;
        bgborderimg.layer.borderWidth = 1;
        bgborderimg.layer.borderColor = [[UIColor colorWithHexString:kAppLineColor] CGColor];
        [self addSubview:bgborderimg];
        [self sendSubviewToBack:bgborderimg];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

-(void)configData:(PDOrderModel*)data{
    sortlab.text=[NSString stringWithFormat:@"%d",data.index+1];
    totallab.text=[NSString stringWithFormat:@"总计:%@元",data.sum_price];
    for (int i=0; i<1; i++) {
        everyla[i].text=[NSString stringWithFormat:@"%@＊%@  %@元",data.food_name,data.food_num,data.food_price];
    }
    msglab.text=[NSString stringWithFormat:@"食客留言:%@",data.message];
    timelab.text=[NSString stringWithFormat:@"就餐时间:%@",data.eat_time];
    phonelab.text=[NSString stringWithFormat:@"下单人电话:%@",data.phone];
    addresslab.text=[NSString stringWithFormat:@"配送地址:%@",data.address];
    cantingaddresslab.text=[NSString stringWithFormat:@"餐厅地址:%@",data.kitchen_address];
    cantingphonelab.text=[NSString stringWithFormat:@"餐厅电话:%@",data.kitchen_phone];
//重设位置
    msglab.frame = [msglab customsizeThatFits:20];
    phonelab.frame=CGRectMake(kCellLeftGap*3, msglab.bottom+kCellLeftGap, kAppWidth-kCellLeftGap*6, 20);
    timelab.frame=CGRectMake(kCellLeftGap*3, phonelab.bottom+kCellLeftGap, kAppWidth-kCellLeftGap*6, 20);
    addresslab.frame=CGRectMake(kCellLeftGap*3, timelab.bottom+kCellLeftGap, kAppWidth-kCellLeftGap*6, 20);
    addresslab.frame=[addresslab customsizeThatFits:20];
    cantingaddresslab.frame=CGRectMake(kCellLeftGap*3, addresslab.bottom+kCellLeftGap, kAppWidth-kCellLeftGap*6, 20);
    cantingaddresslab.frame=[cantingaddresslab customsizeThatFits:20];
    cantingphonelab.frame=CGRectMake(kCellLeftGap*3, cantingaddresslab.bottom+kCellLeftGap, kAppWidth-kCellLeftGap*6, 20);
    totallab.frame=CGRectMake(kCellLeftGap*3, cantingphonelab.bottom+kCellLeftGap*2, kAppWidth-kCellLeftGap*6, 20);
    startsendbtn.frame = CGRectMake(3*kCellLeftGap, totallab.bottom+kCellLeftGap, (kAppWidth-8*kCellLeftGap)/2, 40);
    finishsendbtn.frame =CGRectMake(startsendbtn.right+kCellLeftGap, totallab.bottom+kCellLeftGap, (kAppWidth-8*kCellLeftGap)/2, 40);
    bgborderimg.frame=CGRectMake(kCellLeftGap, 11, kAppWidth-kCellLeftGap*2, finishsendbtn.bottom+kCellLeftGap);
    
    if ([data.status integerValue]==1) {
        newmarkimg.hidden=NO;
    }else{
        newmarkimg.hidden=YES;
    }
    if (data.type==OrderTypeToday) {
        startsendbtn.hidden=NO;
        finishsendbtn.hidden=NO;
        bgborderimg.frame=CGRectMake(kCellLeftGap, 11, kAppWidth-kCellLeftGap*2, finishsendbtn.bottom+kCellLeftGap);
    }else{
        startsendbtn.hidden=YES;
        finishsendbtn.hidden=YES;
        newmarkimg.hidden=YES;
        bgborderimg.frame=CGRectMake(kCellLeftGap, 11, kAppWidth-kCellLeftGap*2, totallab.bottom+kCellLeftGap);
    }
    if([data.status integerValue]==1){
        startsendbtn.userInteractionEnabled=YES;
        startsendbtn.selected=NO;
        finishsendbtn.userInteractionEnabled=YES;
        finishsendbtn.selected=NO;
    }else if([data.status integerValue]==2){
        startsendbtn.userInteractionEnabled=NO;
        startsendbtn.selected=YES;
        finishsendbtn.userInteractionEnabled=YES;
        finishsendbtn.selected=NO;
    }else if([data.status integerValue]==3){
        startsendbtn.userInteractionEnabled=NO;
        startsendbtn.selected=YES;
        finishsendbtn.userInteractionEnabled=NO;
        finishsendbtn.selected=YES;
    }
    
    //[self showDebugRect];
}
+(CGSize)sizewithstr:(NSString*)text andwidth:(CGFloat)width
{
    //最大尺寸
    // MAXFLOAT 为可设置的最大高度
    CGSize size = CGSizeMake(width, MAXFLOAT);
    //获取当前那本属性
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:kAppFontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};
    //实际尺寸
    CGSize actualSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    if (actualSize.height<=20) {
        actualSize.height=20;
    }
    return actualSize;
}
+(CGFloat )cellHeightWithData:(PDOrderModel*)data{

    CGSize msglabsize=[PDOrderCell sizewithstr:[NSString stringWithFormat:@"食客留言:%@",data.message] andwidth:kAppWidth-kCellLeftGap*6];
    NSLog(@"data.message==%@",data.message);
    CGSize addresslabsize=[PDOrderCell sizewithstr:[NSString stringWithFormat:@"配送地址:%@",data.address] andwidth:kAppWidth-kCellLeftGap*6];
    CGSize cantingaddresslabsize=[PDOrderCell sizewithstr:[NSString stringWithFormat:@"餐厅地址:%@",data.kitchen_address] andwidth:kAppWidth-kCellLeftGap*6];
    
    if (data.type==OrderTypeToday) {
        return 52+20*4+kCellLeftGap*10+msglabsize.height+addresslabsize.height+cantingaddresslabsize.height+40+kCellLeftGap*2;//272+kCellLeftGap*3;
    }else{
        return 52+20*4+kCellLeftGap*10+msglabsize.height+addresslabsize.height+cantingaddresslabsize.height+kCellLeftGap*2;
    }
}

@end

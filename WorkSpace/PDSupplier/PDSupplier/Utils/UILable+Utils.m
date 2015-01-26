//
//  UILable+Utils.m
//  PDLogistics
//
//  Created by zdf on 15/1/25.
//  Copyright (c) 2015年 Man. All rights reserved.
//

#import "UILable+Utils.h"

@implementation UILabel(Utils)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CGRect)customsizeThatFits:(CGFloat)minheight
{
    //最大尺寸
    // MAXFLOAT 为可设置的最大高度
    CGSize size = CGSizeMake(self.frame.size.width, MAXFLOAT);
    //获取当前那本属性
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName,nil];
    //实际尺寸
    CGSize actualSize = [self.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    if (actualSize.height<=minheight) {
        actualSize.height=minheight;
    }
    CGRect mframe = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width,actualSize.height);
    return mframe;
}

@end

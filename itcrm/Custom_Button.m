//
//  Custom_Button.m
//  worldtrans
//
//  Created by itdept on 14-4-28.
//  Copyright (c) 2014年 Worldtrans Logistics Services Ltd. . All rights reserved.
//

#import "Custom_Button.h"

@implementation Custom_Button
@synthesize label;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)fn_create_label{
    label=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.frame.size.width-5, self.frame.size.height)];
    label.font=[UIFont systemFontOfSize:15];
    label.backgroundColor=[UIColor clearColor];
    [self addSubview:label];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self.layer addSublayer:[self fn_shadow_background]];
    [self fn_create_label];
    self.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.layer.cornerRadius=5;
    self.layer.borderWidth=1;
}
-(CAGradientLayer*)fn_shadow_background{
    CAGradientLayer *newShadow=[[CAGradientLayer alloc]init];
    CGRect newShadowFrame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    newShadow.frame=newShadowFrame;
    newShadow.cornerRadius=5;
    //添加渐变的颜色组合
    newShadow.colors=[NSArray arrayWithObjects:(id)[UIColor lightGrayColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor whiteColor].CGColor, nil];
    return newShadow;
}


@end

//
//  View_show_prompt.m
//  itcrm
//
//  Created by itdept on 15/2/5.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import "View_show_prompt.h"
#define HEIGHT 42
@implementation View_show_prompt

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}
- (void)fn_creat_label{
    UILabel *ilb_alert=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height/2-64, self.frame.size.width, HEIGHT)];
    ilb_alert.lineBreakMode=NSLineBreakByCharWrapping;
    ilb_alert.numberOfLines=0;
    ilb_alert.textAlignment=NSTextAlignmentCenter;
    ilb_alert.font=[UIFont systemFontOfSize:24];
    ilb_alert.textColor=[UIColor grayColor];
    ilb_alert.text=_str_msg;
    [self addSubview:ilb_alert];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self fn_creat_label];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

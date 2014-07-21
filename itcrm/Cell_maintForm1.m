//
//  Cell_maintForm1.m
//  itcrm
//
//  Created by itdept on 14-6-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Cell_maintForm1.h"
@implementation Cell_maintForm1
@synthesize is_enable;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/**
 *  UITableViewCell 出现之前会调用这个方法
 */
-(void)layoutSubviews{
    [super layoutSubviews];
    if (is_enable==0) {
        _itv_data_textview.editable=NO;
        _itv_data_textview.layer.borderWidth=0.5;
        _itv_data_textview.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        _itv_data_textview.layer.cornerRadius=4;
        _itv_data_textview.textColor=[UIColor darkGrayColor];
    }else{
        _itv_data_textview.editable=YES;
        _itv_data_textview.layer.borderColor=[COLOR_LIGHT_YELLOW2 CGColor];
        _itv_data_textview.layer.borderWidth=0.5;
        _itv_data_textview.layer.cornerRadius=4;
        _itv_data_textview.textColor=[UIColor blackColor];
    }
}

@end

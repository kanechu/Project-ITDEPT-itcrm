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
       
    }else{
        _itv_data_textview.editable=YES;
    }
}

@end

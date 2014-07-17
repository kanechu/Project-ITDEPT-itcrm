//
//  Cell_lookup.m
//  itcrm
//
//  Created by itdept on 14-6-30.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Cell_lookup.h"

@implementation Cell_lookup
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
-(void)layoutSubviews{
    [super layoutSubviews];
    if (is_enable==0) {
        _itv_edit_textview.editable=NO;
        _ibtn_lookup.enabled=NO;
        
    }else{
        _itv_edit_textview.editable=YES;
        _ibtn_lookup.enabled=YES;
    }
}
@end

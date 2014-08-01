//
//  Cell_search1.m
//  itcrm
//
//  Created by itdept on 14-6-5.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Cell_search1.h"

@implementation Cell_search1

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
    _itf_input_searchData.enabled=NO;
}
@end

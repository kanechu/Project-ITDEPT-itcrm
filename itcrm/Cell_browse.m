//
//  Cell_browse.m
//  itcrm
//
//  Created by itdept on 14-6-11.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Cell_browse.h"

@implementation Cell_browse

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
- (void)layoutSubviews{
    [super layoutSubviews];
    _ii_image.layer.borderWidth=2.5;
    _ii_image.layer.borderColor=COLOR_LIGHT_GRAY1.CGColor;
    _ii_image.layer.cornerRadius=1;
    
}

@end

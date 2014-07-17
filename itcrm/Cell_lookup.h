//
//  Cell_lookup.h
//  itcrm
//
//  Created by itdept on 14-6-30.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface Cell_lookup : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *il_remind_label;

@property (weak, nonatomic) IBOutlet UITextView *itv_edit_textview;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_lookup;
@property (assign,nonatomic)NSInteger is_enable;
@end

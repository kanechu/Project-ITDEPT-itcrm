//
//  Cell_maintForm1.h
//  itcrm
//
//  Created by itdept on 14-6-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_maintForm1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *il_remind_label;
@property (weak, nonatomic) IBOutlet UITextView *itv_data_textview;
/**
 *  is_enable 标识UITextView可编辑，或者不可编辑
 */
@property (assign,nonatomic)NSInteger is_enable;
@end

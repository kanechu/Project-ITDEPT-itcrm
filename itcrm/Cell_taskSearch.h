//
//  Cell_taskSearch.h
//  itcrm
//
//  Created by itdept on 14-6-16.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_taskSearch : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *il_prompt_label;
@property (weak, nonatomic) IBOutlet UITextField *itf_input_startDate;
@property (weak, nonatomic) IBOutlet UITextField *itf_input_endDate;

@end

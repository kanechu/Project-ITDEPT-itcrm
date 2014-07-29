//
//  MaintTaskViewController.h
//  itcrm
//
//  Created by itdept on 14-6-13.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
#import "Custom_datePicker.h"
@interface MaintTaskViewController : UIViewController<SKSTableViewDelegate,UITextViewDelegate,UIAlertViewDelegate,DatepickerDelegate>
//标识该版面是用于修改还是添加
@property (nonatomic,assign)NSInteger add_flag;
@property (nonatomic,strong)NSMutableDictionary *idic_parameter_value;
@property (nonatomic,strong)UITextView *checkTextView;
@property (weak, nonatomic) IBOutlet SKSTableView *skstableview;

- (IBAction)fn_save_edit_data:(id)sender;
- (IBAction)fn_lookup_data:(id)sender;
- (IBAction)fn_goBack:(id)sender;
- (IBAction)fn_click_checkBox:(id)sender;

@end

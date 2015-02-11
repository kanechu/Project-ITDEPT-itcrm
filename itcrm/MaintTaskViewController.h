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
//标识该版面是可以编辑，还是只能预览，1可以编辑，0只可预览
@property (nonatomic,assign)NSInteger flag_can_edit;
@property (nonatomic,strong)NSMutableDictionary *idic_parameter_value;

@property (weak, nonatomic) IBOutlet SKSTableView *skstableview;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_save;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ibtn_cancel;

- (IBAction)fn_save_edit_data:(id)sender;
- (IBAction)fn_goBack:(id)sender;
- (IBAction)fn_click_checkBox:(id)sender;

@end

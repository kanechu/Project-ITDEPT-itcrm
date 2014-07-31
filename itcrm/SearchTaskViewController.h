//
//  SearchTaskViewController.h
//  itcrm
//
//  Created by itdept on 14-6-13.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
#import "Custom_datePicker.h"
typedef void (^CallBack_task)(NSMutableArray *arr_searchData);
@interface SearchTaskViewController : UIViewController<SKSTableViewDelegate,UITextFieldDelegate,DatepickerDelegate>
@property(nonatomic,strong)CallBack_task callback_task;
@property(nonatomic,strong)UITextField *checkText;
@property (weak, nonatomic) IBOutlet UINavigationBar *inav_navigationbar;
@property (weak, nonatomic) IBOutlet SKSTableView *skstableview;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_clear;

- (IBAction)fn_search_task:(id)sender;
- (IBAction)fn_go_back:(id)sender;
- (IBAction)fn_textfield_endEdit:(id)sender;
- (IBAction)fn_clear_input_data:(id)sender;

@end

//
//  AccountViewController.h
//  itcrm
//
//  Created by itdept on 14-5-31.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
//定义回调函数
typedef void (^CallBack_acct)(NSMutableArray * arr);
@interface AccountViewController : UIViewController<SKSTableViewDelegate,UITextFieldDelegate>
//设置一个属性
@property (nonatomic,strong)CallBack_acct callback_acct;
//用来标识点击哪个textfield
@property (nonatomic,weak)UITextField *checkText;
@property (weak, nonatomic) IBOutlet UINavigationItem *i_navigationItem;
@property (weak, nonatomic) IBOutlet SKSTableView *skstableView;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_clear;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_search;

- (IBAction)fn_search_account:(id)sender;
- (IBAction)fn_go_back:(id)sender;
- (IBAction)fn_textfield_endEdit:(id)sender;
- (IBAction)fn_clear_input_data:(id)sender;

@end

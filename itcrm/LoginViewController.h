//
//  ViewController.h
//  itcrm
//
//  Created by itdept on 14-5-27.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRadioButton.h"
typedef void (^callBack_login)(void);
@interface LoginViewController : UIViewController<UITextFieldDelegate,QRadioButtonDelegate>
@property (strong,nonatomic)callBack_login callback;

@property (weak, nonatomic) IBOutlet UITextField *itf_usercode;
@property (weak, nonatomic) IBOutlet UITextField *itf_password;
@property (weak, nonatomic) IBOutlet UITextField *itf_system;
@property (weak, nonatomic) IBOutlet UIView *iv_usercode_line;
@property (weak, nonatomic) IBOutlet UIView *iv_password_line;
@property (weak, nonatomic) IBOutlet UIView *iv_system_line;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_login;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_showPassword;
@property (weak, nonatomic) IBOutlet UILabel *ilb_showPass;
@property (weak, nonatomic) IBOutlet UITextView *itv_title;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_history;
@property (weak, nonatomic) IBOutlet QRadioButton *ibtn_EN;
@property (weak, nonatomic) IBOutlet QRadioButton *ibtn_CN;
@property (weak, nonatomic) IBOutlet QRadioButton *ibtn_TCN;


- (IBAction)fn_find_history_data:(id)sender;

- (IBAction)fn_login_itcrm:(id)sender;
- (IBAction)fn_isShowPassword:(id)sender;

@end

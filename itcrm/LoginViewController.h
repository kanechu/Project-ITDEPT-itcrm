//
//  ViewController.h
//  itcrm
//
//  Created by itdept on 14-5-27.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^callBack_login)(void);
@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (strong,nonatomic)callBack_login callback;
@property (weak, nonatomic) IBOutlet UITextField *itf_usercode;
@property (weak, nonatomic) IBOutlet UITextField *itf_password;
@property (weak, nonatomic) IBOutlet UITextField *itf_system;
@property (weak, nonatomic) IBOutlet UIView *iv_usercode_line;
@property (weak, nonatomic) IBOutlet UIView *iv_password_line;
@property (weak, nonatomic) IBOutlet UIView *iv_system_line;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_login;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_showPassword;

- (IBAction)fn_login_itcrm:(id)sender;
- (IBAction)fn_isShowPassword:(id)sender;

@end

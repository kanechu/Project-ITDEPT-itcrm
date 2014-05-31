//
//  ViewController.h
//  itcrm
//
//  Created by itdept on 14-5-27.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LoginViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
//用来标识点击的textfiled
@property(nonatomic)UITextField *checkText;
@property (nonatomic,strong)NSArray *ilist_imageName;
@property (nonatomic,strong)NSArray *ilist_textfield;
@property (nonatomic , copy)NSString *is_user;
@property (nonatomic , copy)NSString *is_pass;
@property (nonatomic , copy)NSString *is_systemCode;

@property (weak, nonatomic) IBOutlet UITableView *tableview_form;
@property (weak, nonatomic) IBOutlet UIButton *ibt_loginButton;

- (IBAction)fn_login_app:(id)sender;
- (IBAction)fn_end_inputData:(id)sender;

@end

//
//  ViewController.h
//  itcrm
//
//  Created by itdept on 14-5-27.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^callBack_login)(void);
@interface LoginViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic)callBack_login callback;
@property (weak, nonatomic) IBOutlet UITableView *tableview_form;
@property (weak, nonatomic) IBOutlet UIButton *ibt_loginButton;

- (IBAction)fn_login_app:(id)sender;
- (IBAction)fn_end_inputData:(id)sender;

@end

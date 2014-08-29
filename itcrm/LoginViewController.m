//
//  ViewController.m
//  itcrm
//
//  Created by itdept on 14-5-27.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "LoginViewController.h"
#import <RestKit/RestKit.h>
#import "AuthContract.h"
#import "RequestContract.h"
#import "SearchFormContract.h"
#import "RespLogin.h"
#import "RespUsersLogin.h"
#import "Web_base.h"
#import "NSArray.h"
#import "SVProgressHUD.h"
#import "DB_RespLogin.h"
#import "DB_Login.h"
#import "DB_Com_SYS_Code.h"
#import "Web_resquestData.h"
#import "OptionViewController.h"
@interface LoginViewController ()

//用来标识点击的textfiled
@property(nonatomic)UITextField *checkText;

@end

@implementation LoginViewController
@synthesize checkText;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fn_custom_gesture];
    [self fn_custom_style];
    //注册通知
    [self fn_registKeyBoardNotification];
    _itf_password.delegate=self;
    _itf_system.delegate=self;
    _itf_usercode.delegate=self;
   	// Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated{
    [self fn_removeKeyBoarNotificaton];
}
-(void)fn_custom_gesture{
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fn_keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapgesture.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapgesture];
}
-(void)fn_keyboardHide:(UITapGestureRecognizer*)tap{
    [checkText resignFirstResponder];
}
//监听键盘隐藏和显示事件
-(void)fn_registKeyBoardNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//注销监听事件
-(void)fn_removeKeyBoarNotificaton{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)fn_custom_style{
    _ibtn_login.layer.cornerRadius=2;
    _ibtn_login.layer.borderWidth=0.5;
    _ibtn_login.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [_ibtn_showPassword setImage:[UIImage imageNamed:@"checkbox_unchecked"] forState:UIControlStateNormal];
    [_ibtn_showPassword setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateSelected];
}
#pragma mark UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField*)textField{
    checkText = textField;//设置被点击的对象
    if (_itf_usercode.editing) {
        _iv_usercode_line.backgroundColor=COLOR_DARK_GREEN;
    }else if(_itf_password.editing){
        _iv_password_line.backgroundColor=COLOR_DARK_GREEN;
    }else if(_itf_system.editing){
        _iv_system_line.backgroundColor=COLOR_DARK_GREEN;
    }

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [checkText resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    _iv_system_line.backgroundColor=[UIColor lightGrayColor];
    _iv_password_line.backgroundColor=[UIColor lightGrayColor];
    _iv_usercode_line.backgroundColor=[UIColor lightGrayColor];
}
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification*)notification {
    
    if (nil == checkText) {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];

    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    
    [animationDurationValue getValue:&animationDuration];
    
    CGRect textFrame =[checkText convertRect:checkText.bounds toView:nil];
    float textY = textFrame.origin.y + textFrame.size.height;//得到tableView下边框距离顶部的高度
    float bottomY = self.view.frame.size.height - textY;//得到下边框到底部的距离
    
    if(bottomY >=keyboardRect.size.height ){//键盘默认高度,如果大于此高度，则直接返回
        return;
        
    }
    float moveY = keyboardRect.size.height - bottomY+10;
     [self moveInputBarWithKeyboardHeight:moveY withDuration:animationDuration];

}
//键盘被隐藏的时候调用的方法
-(void)keyboardWillHide:(NSNotification*)notification {
    NSDictionary* userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    
    [animationDurationValue getValue:&animationDuration];
    
    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
    
}
#pragma mark 移动view

-(void)moveInputBarWithKeyboardHeight:(float)_CGRectHeight withDuration:(NSTimeInterval)_NSTimeInterval{
    
    CGRect rect = self.view.frame;
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:_NSTimeInterval];
    
    rect.origin.y = -_CGRectHeight;//view往上移动
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}
#pragma mark NetWork Request
- (void) fn_get_Web_addr_data
{
    [SVProgressHUD showWithStatus:@"Verifying,please wait!"];
    DB_RespLogin *db=[[DB_RespLogin alloc]init];
    [db fn_delete_all_data];
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    auth.user_code=@"anonymous";
    auth.password=@"anonymous1";
    auth.system =@"ITNEW";
    auth.version=@"1.5";
    auth.com_sys_code=_itf_system.text;
    auth.app_code=@"ITCRM";
    req_form.Auth =auth;
    
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_LOGIN_URL;
    web_base.base_url=STR_BASE_URL;
    web_base.iresp_class=[RespLogin class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespLogin class]];
    web_base.callback=^(NSMutableArray *arr_resp_result){
        DB_RespLogin *db=[[DB_RespLogin alloc]init];
        [db fn_save_data:arr_resp_result];
        NSString* base_url=nil;
        NSString* sys_name=nil;
        if (arr_resp_result!=nil && [arr_resp_result count]!=0) {
            base_url=[[arr_resp_result objectAtIndex:0] valueForKey:@"web_addr"];
            sys_name=[[arr_resp_result objectAtIndex:0]valueForKey:@"sys_name"];
        }
        [self fn_get_RespusersLogin_data:base_url sys_name:sys_name];
    };
    [web_base fn_get_data:req_form];
    
}
- (void) fn_get_RespusersLogin_data:(NSString*)base_url sys_name:(NSString*)sys_name{
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    auth.user_code=_itf_usercode.text;
    auth.password=_itf_password.text;
    auth.system =sys_name;
    auth.version=@"1.5";
    req_form.Auth =auth;
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_USERSLOGIN_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespUsersLogin class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespUsersLogin class]];
    web_base.callback=^(NSMutableArray *arr_resp_result){
        if ([[[arr_resp_result objectAtIndex:0]valueForKey:@"pass"]isEqualToString:@"true"]) {
            [SVProgressHUD dismissWithSuccess:@"Successful landing!"];
            NSUserDefaults *user_isLogin=[NSUserDefaults standardUserDefaults];
            DB_Login *dbLogin=[[DB_Login alloc]init];
            NSString *user_logo=[[arr_resp_result objectAtIndex:0]valueForKey:@"user_logo"];
            [dbLogin fn_save_data:_itf_usercode.text password:_itf_password.text system:sys_name user_logo:user_logo];
            DB_Com_SYS_Code *db_sys_code=[[DB_Com_SYS_Code alloc]init];
            [db_sys_code fn_save_com_sys_code:_itf_system.text];
            [user_isLogin setInteger:1 forKey:@"isLogin"];
            [user_isLogin synchronize];
            [self dismissViewControllerAnimated:YES completion:^{}];
            if (_callback) {
                _callback();
            }
        }
    };
    [web_base fn_get_data:req_form];
}
#pragma mark -event action
- (IBAction)fn_find_history_data:(id)sender {
    DB_Com_SYS_Code *db=[[DB_Com_SYS_Code alloc]init];
    NSMutableArray *alist_sys_code=[db fn_get_com_sys_code];
    if ([alist_sys_code count]==0) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"No Historical Data!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        OptionViewController *VC=(OptionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
        VC.alist_option=alist_sys_code;
        VC.flag=2;
        VC.callback=^(NSMutableDictionary *dic){
            _itf_system.text=[dic valueForKey:@"sys_code"];
        };
        PopViewManager *popV=[[PopViewManager alloc]init];
        [popV PopupView:VC Size:CGSizeMake(230, 300) uponView:self];
    }
}

- (IBAction)fn_login_itcrm:(id)sender{
    NSString *str_prompt=@"";
    if ([_itf_usercode.text length]==0) {
        str_prompt=@"Sorry,the user name can not be empty!";
    }else if([_itf_password.text length]==0){
        str_prompt=@"Sorry,the password can not be empty!";
    }else if ([_itf_system.text length]==0){
        str_prompt=@"Sorry,the system name can not be empty!";
    }else{
        [self fn_get_Web_addr_data];
    }
    if ([str_prompt length]!=0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:str_prompt delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }

}

- (IBAction)fn_isShowPassword:(id)sender {
    _ibtn_showPassword.selected=!_ibtn_showPassword.selected;
    if (_ibtn_showPassword.selected) {
        _itf_password.secureTextEntry=NO;
    }else{
        _itf_password.secureTextEntry=YES;
    }
}

@end

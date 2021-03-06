//
//  ViewController.m
//  itcrm
//
//  Created by itdept on 14-5-27.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "LoginViewController.h"
#import <RestKit/RestKit.h>
#import "RespLogin.h"
#import "RespUsersLogin.h"
#import "Web_base.h"
#import "SVProgressHUD.h"
#import "DB_RespLogin.h"
#import "DB_Com_SYS_Code.h"
#import "Web_resquestData.h"
#import "OptionViewController.h"
#import "CheckUpdate.h"

static NSInteger flag_first=1;
static NSString  *is_language=@"";//标识语言类型
#define DEFAULT_USERCODE @"anonymous";
#define DEFAULT_PASSWORD @"anonymous1";
#define DEFAULT_SYSTEM @"ITNEW";
typedef NS_ENUM(NSInteger, kTimeOut_stage){
    kAppconfig_stage,
    kLogin_stage
};
@interface LoginViewController ()<UIAlertViewDelegate>

//用来标识点击的textfiled
@property(nonatomic)UITextField *checkText;
@property (nonatomic, copy) NSString *lang_code;
@property (nonatomic, assign) CGRect keyboardRect;
@property (nonatomic, strong) CheckUpdate *check_obj;
@property (nonatomic, assign) kTimeOut_stage timeOut_stage;
@property (nonatomic, assign) NSInteger flag_isCompleted;

@end

@implementation LoginViewController
@synthesize checkText;
@synthesize lang_code;
@synthesize keyboardRect;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fn_custom_gesture];
    [self fn_custom_style];
    [self fn_show_different_language];
    //注册通知
    [self fn_registKeyBoardNotification];
    _itf_password.delegate=self;
    _itf_system.delegate=self;
    _itf_usercode.delegate=self;
    
    _check_obj=[[CheckUpdate alloc]init];
    _flag_isCompleted=0;
    
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
    [_ibtn_EN setTitle:@"English" forState:UIControlStateNormal];
    _ibtn_EN.delegate=self;
    [_ibtn_CN setTitle:@"简体中文" forState:UIControlStateNormal];
    _ibtn_CN.delegate=self;
    [_ibtn_TCN setTitle:@"繁体中文" forState:UIControlStateNormal];
    _ibtn_TCN.delegate=self;
    if (flag_first==1) {
        NSString *current_language=[[MYLocalizedString getshareInstance]getCurrentLanguage];
        is_language=current_language;
        flag_first++;
    }
    if ([is_language isEqualToString:@"en"]) {
        [_ibtn_EN setChecked:YES];
        lang_code=@"EN";
    }
    if ([is_language isEqualToString:@"zh-Hans"]) {
        [_ibtn_CN setChecked:YES];
        lang_code=@"CN";
    }
    if ([is_language isEqualToString:@"zh-Hant"]) {
        [_ibtn_TCN setChecked:YES];
        lang_code=@"TCN";
    }
    [[MYLocalizedString getshareInstance]fn_setLanguage_type:is_language];
    _itf_usercode.returnKeyType=UIReturnKeyNext;
    _itf_password.returnKeyType=UIReturnKeyNext;
    _itf_system.returnKeyType=UIReturnKeyDone;
}
#pragma mark -language change
-(void)fn_show_different_language{
    _itf_usercode.placeholder=MYLocalizedString(@"lbl_username", nil);
    _itf_password.placeholder=MYLocalizedString(@"lbl_pwd", nil);
    _itf_system.placeholder=MYLocalizedString(@"lbl_system", nil);
    [_ibtn_login setTitle:MYLocalizedString(@"lbl_login", nil) forState:UIControlStateNormal];
    [_ibtn_history setTitle:MYLocalizedString(@"lbl_history", nil) forState:UIControlStateNormal];
    _ilb_showPass.text=MYLocalizedString(@"lbl_show_pwd", nil);
    _itv_title.text=MYLocalizedString(@"app_name", nil);
    _itv_title.font=[UIFont systemFontOfSize:24];
    _itv_title.textColor=[UIColor darkGrayColor];
    
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
    
    CGRect keyboardRect1 = [aValue CGRectValue];
    if (keyboardRect1.size.width!=0) {
        keyboardRect=keyboardRect1;
    }
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    
    [animationDurationValue getValue:&animationDuration];
    
    CGRect textFrame =[checkText convertRect:checkText.bounds toView:self.view];
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
#pragma mark -show alert
-(void)fn_show_network_unavailable_alert{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:MYLocalizedString(@"msg_no_network", nil) message:MYLocalizedString(@"msg_network_fail", nil) delegate:nil cancelButtonTitle:MYLocalizedString(@"lbl_ok", nil) otherButtonTitles:nil, nil];
    [alertView show];
    alertView=nil;
}
-(void)fn_show_request_timeOut_alert{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:MYLocalizedString(@"msg_request_timeout", nil) delegate:self cancelButtonTitle:MYLocalizedString(@"lbl_cancel", nil) otherButtonTitles:MYLocalizedString(@"lbl_retry", nil), nil];
    [alertView show];
    alertView=nil;
}
#pragma mark -UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==[alertView firstOtherButtonIndex]) {
        if (_timeOut_stage==kAppconfig_stage) {
            [self fn_get_Web_addr_data];
        }else if (_timeOut_stage==kLogin_stage){
            DB_RespLogin *db=[[DB_RespLogin alloc]init];
            NSString *base_url=[db fn_get_field_content:kWeb_addr];
            NSString *sys_name=[db fn_get_field_content:kSys_name];
            [self fn_get_RespusersLogin_data:base_url sys_name:sys_name];
            db=nil;
            base_url=nil;
            sys_name=nil;
        }
    }
    
}

#pragma mark NetWork Request
- (void) fn_get_Web_addr_data
{
    [SVProgressHUD showWithStatus:MYLocalizedString(@"msg_identity_auth", nil)];
    DB_RespLogin *db=[[DB_RespLogin alloc]init];
    [db fn_delete_all_data];
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    auth.user_code=DEFAULT_USERCODE;
    auth.password=DEFAULT_PASSWORD;
    auth.system =DEFAULT_SYSTEM;
    auth.version=ITCRM_VERSION;
    auth.com_sys_code=_itf_system.text;
    auth.app_code=APP_CODE;
    req_form.Auth =auth;
    
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_LOGIN_URL;
    web_base.base_url=STR_BASE_URL;
    web_base.iresp_class=[RespLogin class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespLogin class]];
    web_base.callback=^(NSMutableArray *arr_resp_result,BOOL isTimeOut){
        if (isTimeOut) {
            [SVProgressHUD dismiss];
            _timeOut_stage=kAppconfig_stage;
            [self fn_show_request_timeOut_alert];
            
        }else{
            DB_RespLogin *db=[[DB_RespLogin alloc]init];
            [db fn_save_data:arr_resp_result];
            db=nil;
            NSString* base_url=nil;
            NSString* sys_name=nil;
            if (arr_resp_result!=nil && [arr_resp_result count]!=0) {
                base_url=[[arr_resp_result objectAtIndex:0] valueForKey:@"web_addr"];
                sys_name=[[arr_resp_result objectAtIndex:0]valueForKey:@"sys_name"];
            }
            if (base_url!=nil) {
                [self fn_get_RespusersLogin_data:base_url sys_name:sys_name];
            }
        }
    };
    [web_base fn_get_data:req_form];
}
- (void) fn_get_RespusersLogin_data:(NSString*)base_url sys_name:(NSString*)sys_name{
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    auth.user_code=_itf_usercode.text;
    auth.password=_itf_password.text;
    auth.system =sys_name;
    auth.version=ITCRM_VERSION;
    req_form.Auth =auth;
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_USERSLOGIN_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespUsersLogin class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespUsersLogin class]];
    web_base.callback=^(NSMutableArray *arr_resp_result,BOOL isTimeOut){
        if (isTimeOut) {
            _timeOut_stage=kLogin_stage;
            [self fn_show_request_timeOut_alert];
        }else{
            if ([[[arr_resp_result objectAtIndex:0]valueForKey:@"pass"]isEqualToString:@"true"]) {
               
                NSUserDefaults *user_isLogin=[NSUserDefaults standardUserDefaults];
                DB_Login *dbLogin=[[DB_Login alloc]init];
                NSString *user_logo=[[arr_resp_result objectAtIndex:0]valueForKey:@"user_logo"];
                [dbLogin fn_save_data:_itf_usercode.text password:_itf_password.text system:sys_name user_logo:user_logo lang_code:lang_code];
                DB_Com_SYS_Code *db_sys_code=[[DB_Com_SYS_Code alloc]init];
                [db_sys_code fn_save_com_sys_code:_itf_system.text lang_code:is_language];
                [user_isLogin setInteger:1 forKey:@"isLogin"];
                [user_isLogin synchronize];
                Web_resquestData *web_rest=[[Web_resquestData alloc]init];
                [web_rest fn_get_formatlist_data:base_url];
                [web_rest fn_get_maintForm_data:base_url];
                [web_rest fn_get_search_data:base_url];
                [web_rest fn_get_permit_data:base_url];
                [web_rest fn_get_mslookup_data:base_url];
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_complete_request_data) name:@"success_resp" object:nil];
                
                if (_callback) {
                    _callback();
                }
                
            }else{
                [SVProgressHUD dismissWithError:MYLocalizedString(@"msg_langding_failed", nil) afterDelay:2.0f];
            }
        }
    };
    [web_base fn_get_data:req_form];
}
-(void)fn_complete_request_data{
    _flag_isCompleted++;
    if (_flag_isCompleted==4) {
        [SVProgressHUD dismissWithSuccess:MYLocalizedString(@"msg_landing_success", nil)];
        [self dismissViewControllerAnimated:YES completion:^{}];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"success_resp" object:nil];
        _flag_isCompleted=0;
    }
}

#pragma mark -event action
- (IBAction)fn_userName_textField_didEndOnExit:(id)sender {
    [self.itf_password becomeFirstResponder];
    [self keyboardWillShow:nil];
}
- (IBAction)fn_pass_textField_didEndOnExit:(id)sender {
    [self.itf_system becomeFirstResponder];
    [self keyboardWillShow:nil];
}
- (IBAction)fn_sys_textField_didEndOnExit:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)fn_find_history_data:(id)sender {
    DB_Com_SYS_Code *db=[[DB_Com_SYS_Code alloc]init];
    NSMutableArray *alist_sys_code=[db fn_get_com_sys_code:is_language];
    if ([alist_sys_code count]==0) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:MYLocalizedString(@"lbl_prompt_history", nil) delegate:self cancelButtonTitle:MYLocalizedString(@"lbl_ok", nil) otherButtonTitles:nil, nil];
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
    if ([_check_obj fn_check_isNetworking]) {
        NSString *str_prompt=@"";
        if ([_itf_usercode.text length]==0) {
            str_prompt=MYLocalizedString(@"lbl_empty_username", nil);
        }else if([_itf_password.text length]==0){
            str_prompt=MYLocalizedString(@"lbl_empty_password", nil);
        }else if ([_itf_system.text length]==0){
            str_prompt=MYLocalizedString(@"lbl_empty_systemcode", nil);
        }else{
            [self fn_get_Web_addr_data];
        }
        if ([str_prompt length]!=0) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:str_prompt delegate:nil cancelButtonTitle:MYLocalizedString(@"lbl_ok", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }else{
        [self fn_show_network_unavailable_alert];
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
#pragma mark - QRadioButtonDelegate

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    if ([radio.titleLabel.text isEqualToString:@"English"]) {
        is_language=@"en";
    }
    if ([radio.titleLabel.text isEqualToString:@"简体中文"]) {
        is_language=@"zh-Hans";
    }
    if ([radio.titleLabel.text isEqualToString:@"繁体中文"]) {
        is_language=@"zh-Hant";
    }
    [[MYLocalizedString getshareInstance]fn_setLanguage_type:is_language];
    
    [self viewDidLoad];
}
@end

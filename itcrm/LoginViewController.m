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
#import "AppConstants.h"
#import "RequestContract.h"
#import "SearchFormContract.h"
#import "RespLogin.h"
#import "RespSystemIcon.h"
#import "Web_base.h"
#import "NSArray.h"
#import "NSDictionary.h"
#import "SVProgressHUD.h"
#import "Cell_login.h"
#import "DB_RespLogin.h"
#import "DB_Login.h"
#import "Custom_Color.h"
#import "Web_resquestData.h"
#import "MZFormSheetController.h"
@interface LoginViewController ()

@end
enum TEXTFIELD_TAG {
    TAG1 = 1,
    TAG2 ,TAG3
};
@implementation LoginViewController
@synthesize checkText;
@synthesize ilist_imageName;
@synthesize ilist_textfield;
@synthesize is_pass;
@synthesize is_systemCode;
@synthesize is_user;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fn_custom_gesture];
    [self fn_custom_style];
    //注册通知
    [self fn_registKeyBoardNotification];
    ilist_imageName=@[@"user",@"pass",@"systemcode"];
    ilist_textfield=@[@"user ID",@"user password",@"systemcode"];
    self.view.backgroundColor=COLOR_LIGHT_YELLOW1;
   	// Do any additional setup after loading the view, typically from a nib.
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        [self fn_get_Web_addr_data];
    }
    return self;
}

-(void)viewDidDisappear:(BOOL)animated{
    [self fn_removeKeyBoarNotificaton];
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
    _tableview_form.layer.cornerRadius=9;
    _tableview_form.delegate=self;
    _tableview_form.dataSource=self;
    
    _ibt_loginButton.layer.cornerRadius=7;
    _ibt_loginButton.layer.borderWidth=1;
    _ibt_loginButton.layer.borderColor=[UIColor whiteColor].CGColor;
}

-(void)textFieldDidBeginEditing:(UITextField*)textField{
    
    checkText = textField;//设置被点击的对象
    checkText.delegate=self;
    
}

#pragma mark -键盘弹出时调用的方法

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
    
    CGRect textFrame = _tableview_form.frame;//当前tableView的位置
    float textY = textFrame.origin.y + textFrame.size.height;//得到tableView下边框距离顶部的高度
    float bottomY = self.view.frame.size.height - textY;//得到下边框到底部的距离
    
    if(bottomY >=keyboardRect.size.height ){//键盘默认高度,如果大于此高度，则直接返回
        
        return;
        
    }
    float moveY = keyboardRect.size.height - bottomY+2;
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) fn_get_Web_addr_data
{
    DB_RespLogin *db=[[DB_RespLogin alloc]init];
    [db fn_delete_all_data];
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    auth.user_code=@"anonymous";
    auth.password=@"anonymous1";
    auth.system =@"ITNEW";
    auth.version=@"1.2";
    auth.com_sys_code=@"WTRANS/UAT";
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
    };
    [web_base fn_get_data:req_form];
    
}

- (IBAction)fn_login_app:(id)sender {
    [SVProgressHUD showWithStatus:@"Loading, please wait!"];
    DB_RespLogin *db=[[DB_RespLogin alloc]init];
    NSUserDefaults *user_isLogin=[NSUserDefaults standardUserDefaults];
    if ([[db fn_get_all_data] count]!=0) {
       [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController* formSheet){}];
        DB_Login *dbLogin=[[DB_Login alloc]init];
        [dbLogin fn_save_data:is_user password:is_pass system:is_systemCode];
        [self fn_resquestAndsave_data];
       
        [user_isLogin setInteger:1 forKey:@"isLogin"];
        [user_isLogin synchronize];
    }
}

- (IBAction)fn_end_inputData:(id)sender {
    UITextField *textfield=(UITextField*)sender;
    if (textfield.tag==TAG1) {
        is_user=textfield.text;
    }
    if (textfield.tag==TAG2) {
        is_pass=textfield.text;
    }
    if (textfield.tag==TAG3) {
        is_systemCode=textfield.text;
    }
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ilist_imageName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"Cell_login1";
    Cell_login *cell=[self.tableview_form dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[Cell_login alloc]init];
    }
    cell.image_icon.image=[UIImage imageNamed:[ilist_imageName objectAtIndex:indexPath.row]];
    cell.it_textfield.delegate=self;
    cell.it_textfield.placeholder=[ilist_textfield objectAtIndex:indexPath.row];
    if (indexPath.row==0) {
        cell.it_textfield.tag=TAG1;
        cell.it_textfield.text=@"YEN";
        is_user=cell.it_textfield.text;
    }
    if (indexPath.row==1) {
        cell.it_textfield.tag=TAG2;
        cell.it_textfield.secureTextEntry=YES;
        cell.it_textfield.text=@"392016";
        is_pass=cell.it_textfield.text;
    }
    if (indexPath.row==2) {
        cell.it_textfield.tag=TAG3;
        cell.it_textfield.text=@"ITCRM";
        is_systemCode=cell.it_textfield.text;
    }
    return cell;
}
#pragma mark UITableViewDelegate
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

#pragma mark 请求全部的数据
-(void)fn_resquestAndsave_data{
    DB_RespLogin *db=[[DB_RespLogin alloc]init];
    NSMutableArray *arr=[db fn_get_all_data];
    NSString* base_url=nil;
    if (arr!=nil && [arr count]!=0) {
        base_url=[[arr objectAtIndex:0] valueForKey:@"web_addr"];
    }
    Web_resquestData *data=[[Web_resquestData alloc]init];
    [data fn_get_search_data:base_url];
    [data fn_get_formatlist_data:base_url];
    [data fn_get_crmacct_browse_data:base_url];
    [data fn_get_mslookup_data:base_url];
    [data fn_get_crmopp_browse_data:base_url];
    [data fn_get_maintForm_data:base_url];
    [data fn_get_crmtask_browse_data:base_url];
    [data fn_get_systemIcon_data:base_url os_value:@"1400231924493"];
    [data fn_get_crmhbl_browse_data:base_url];
    
}

@end

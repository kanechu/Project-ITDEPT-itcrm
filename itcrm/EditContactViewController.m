//
//  EditContactViewController.m
//  itcrm
//
//  Created by itdept on 14-7-11.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "EditContactViewController.h"
#import "DB_MaintForm.h"
#import "SKSTableViewCell.h"
#import "Cell_maintForm1.h"
#import "Cell_lookup.h"
#import "DB_crmcontact_browse.h"
#import "DB_crmacct_browse.h"
#import "MZFormSheetController.h"
#import "OptionViewController.h"
#import "RespCrmcontact_browse.h"
#import "Web_updateData.h"
#import "Custom_BtnGraphicMixed.h"
#import "CheckUpdate.h"
#import "SVProgressHUD.h"
#define TEXT_TAG 100
typedef NSString* (^passValue_contact)(NSInteger tag);
@interface EditContactViewController ()
@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_logo;
@property(nonatomic,strong)NSMutableDictionary *idic_edited_parameter;
@property(nonatomic,strong)NSMutableDictionary *idic_parameter_contact_copy;
@property(nonatomic,strong)NSMutableArray *alist_maintContact;
//过滤后的数组
@property (nonatomic,strong)NSMutableArray *alist_filtered_contactdata;
@property (nonatomic,strong)NSMutableArray *alist_groupNameAndNum;
@property (nonatomic,strong)UITextView *checkTextView;
@property (nonatomic,strong)Format_conversion *convert;
@property (nonatomic,strong)CheckUpdate *check_obj;
@property (nonatomic,strong)passValue_contact passValue;
@property (nonatomic,strong)UITextView *checkText;
@property (nonatomic,assign)NSInteger flag_click_cancel;
@end

@implementation EditContactViewController
@synthesize alist_filtered_contactdata;
@synthesize alist_groupNameAndNum;
@synthesize alist_maintContact;
@synthesize checkTextView;
@synthesize idic_parameter_contact;
@synthesize passValue;
@synthesize idic_parameter_contact_copy;
@synthesize idic_edited_parameter;
@synthesize flag_click_cancel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fn_get_maint_crmcontact];
    [self fn_set_property];
    [self fn_custom_gesture];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_tableView_scrollTop{
    [self.skstableView setContentOffset:CGPointZero animated:YES];
}
- (void)fn_set_property{
    //深拷贝一份要修改的contact,用于还原
    idic_parameter_contact_copy=[NSMutableDictionary dictionaryWithDictionary:idic_parameter_contact];
    idic_edited_parameter=[[NSMutableDictionary alloc]initWithCapacity:1];
    
    [_ibtn_cancel setTitle:MYLocalizedString(@"lbl_cancel", nil)];
    [_ibtn_save setTitle:MYLocalizedString(@"lbl_save", nil) forState:UIControlStateNormal];
    [_ibtn_logo setTitle:MYLocalizedString(@"lbl_edit_contact", nil) forState:UIControlStateNormal];
    [_ibtn_logo setImage:[UIImage imageNamed:@"ic_itcrm_logo"] forState:UIControlStateNormal];
    if (_add_contact_flag==1) {
        [_ibtn_logo setTitle:MYLocalizedString(@"sheet_contact", nil) forState:UIControlStateNormal];
    }
     if (_flag_can_edit!=1) {
        _ibtn_save.enabled=NO;
    }else{
        _ibtn_save.enabled=YES;
    }
    
    self.skstableView.SKSTableViewDelegate=self;
    [self.skstableView fn_expandall];
    self.skstableView.showsVerticalScrollIndicator=NO;
    [expand_helper setExtraCellLineHidden:self.skstableView];
    
    _convert=[[Format_conversion alloc]init];
    _check_obj=[[CheckUpdate alloc]init];
    
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_tableView_scrollTop) name:@"touchStatusBar" object:nil];

}

#pragma mark -获取定制contact maint版面的数据
-(void)fn_get_maint_crmcontact{
    DB_MaintForm *db=[[DB_MaintForm alloc]init];
    alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmcontact"];
    alist_maintContact=[db fn_get_MaintForm_data:@"crmcontact"];
    alist_filtered_contactdata=[[NSMutableArray alloc]initWithCapacity:10];
    for (NSMutableDictionary *dic in alist_groupNameAndNum) {
        NSString *str_name=[dic valueForKey:@"group_name"];
        NSArray *arr=[expand_helper fn_filtered_criteriaData:str_name arr:alist_maintContact];
        if (arr!=nil) {
            [alist_filtered_contactdata addObject:arr];
        }
    }
    
}
-(void)fn_custom_gesture{
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fn_keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapgesture.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapgesture];
}
-(void)fn_keyboardHide:(UITapGestureRecognizer*)tap{
    [checkTextView resignFirstResponder];
}
#pragma mark SKSTableViewDelegate and datasourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [alist_groupNameAndNum count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath{
    NSString *numOfrows=[[alist_groupNameAndNum objectAtIndex:indexPath.section]valueForKey:@"COUNT(group_name)"];
    return [numOfrows integerValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [self.skstableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    { cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor=COLOR_LIGTH_GREEN;
    NSString *str_name=[[alist_groupNameAndNum objectAtIndex:indexPath.section] valueForKey:@"group_name"];
    cell.textLabel.text=str_name;
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.expandable=YES;
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    //提取每行的数据
    NSMutableDictionary *dic=alist_filtered_contactdata[indexPath.section][indexPath.subRow-1];
    //显示的提示名称
    NSString *col_label=[dic valueForKey:@"col_label"];
    NSString *col_code=[dic valueForKey:@"col_code"];
    //col_stye 类型名
    NSString *col_stye=[dic valueForKey:@"col_type"];
    //is_enable
    NSString *is_enable=[dic valueForKey:@"is_enable"];
    NSInteger is_enable_flag=[is_enable integerValue];
    if (_flag_can_edit!=1) {
        is_enable_flag=0;
    }else{
        is_enable_flag=1;
    }
    
    //blockSelf是本地变量，是弱引用，_block被retain的时候，并不会增加retain count
    __block EditContactViewController *blockSelf=self;
    passValue=^NSString*(NSInteger tag){
        return [blockSelf-> alist_filtered_contactdata [indexPath.section][tag-TEXT_TAG-indexPath.section*100] valueForKey:@"col_code"];
    };
    if ([col_stye isEqualToString:@"string"]) {
        static NSString *cellIdentifier=@"Cell_maintForm1_contact";
        Cell_maintForm1 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_maintForm1 alloc]init];
        }
        cell.is_enable=is_enable_flag;
        cell.il_remind_label.text=col_label;
        cell.itv_data_textview.delegate=self;
        cell.itv_data_textview.tag=TEXT_TAG+indexPath.section*100+indexPath.subRow-1;
        NSString *text_value=[idic_parameter_contact valueForKey:col_code];
        cell.itv_data_textview.text=text_value;
        //UITextView 上下左右有8px
        CGFloat height=[_convert fn_heightWithString:text_value font:cell.itv_data_textview.font constrainedToWidth:cell.itv_data_textview.contentSize.width-16];
        if (height<35) {
            height=20;
        }
        [cell.itv_data_textview setFrame:CGRectMake(cell.itv_data_textview.frame.origin.x, cell.itv_data_textview.frame.origin.y, cell.itv_data_textview.frame.size.width, height+14)];
        return cell;
    }
    if ([col_stye isEqualToString:@"local_lookup"]) {
        static NSString *cellIdentifier=@"Cell_lookup_contact";
        Cell_lookup *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_lookup alloc]init];
        }
        cell.is_enable=is_enable_flag;
        cell.il_remind_label.text=col_label;
        NSString *str_status=[idic_parameter_contact valueForKey:col_code];
        cell.itv_edit_textview.text=[_convert fn_convert_display_status:str_status col_option:[dic valueForKey:@"col_option"]];
        cell.itv_edit_textview.tag=TEXT_TAG+indexPath.section*100+indexPath.subRow-1;
        cell.ibtn_lookup.tag=TEXT_TAG+indexPath.section*100+indexPath.subRow-1;
        [cell.ibtn_lookup setTitle:MYLocalizedString(@"lbl_lookup", nil) forState:UIControlStateNormal];
        cell.itv_edit_textview.delegate=self;
        CGFloat height=[_convert fn_heightWithString:cell.itv_edit_textview.text font:cell.itv_edit_textview.font constrainedToWidth:cell.itv_edit_textview.contentSize.width-16];
        if (height<5) {
            height=20;
        }
        [cell.itv_edit_textview setFrame:CGRectMake(cell.itv_edit_textview.frame.origin.x, cell.itv_edit_textview.frame.origin.y, cell.itv_edit_textview.frame.size.width, height+14)];
      
        return cell;
    }
    
    // Configure the cell...
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *idic=alist_filtered_contactdata[indexPath.section][indexPath.subRow-1];
    NSString *col_code=[idic valueForKey:@"col_code"];
    NSString *col_type=[idic valueForKey:@"col_type"];
    NSString *str_value=[idic_parameter_contact valueForKey:col_code];
    CGFloat height=0;
    if ([col_type isEqualToString:@"string"]) {
        static NSString *cellIndetifier=@"Cell_maintForm1_contact";
        Cell_maintForm1 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIndetifier];
        height=[_convert fn_heightWithString:str_value font:cell.itv_data_textview.font constrainedToWidth:cell.itv_data_textview.contentSize.width-16];
        height=height+16+10;
    }
    if ([col_type isEqualToString:@"local_lookup"]) {
        static NSString *cellIdentifier=@"Cell_lookup_contact";
        Cell_lookup *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        height=[_convert fn_heightWithString:str_value font:cell.itv_edit_textview.font  constrainedToWidth:cell.itv_edit_textview.contentSize.width-16];
        if (height<5) {
            height=20;
        }
        height=height+16+10;
    }
    if (height<44) {
        height=44;
    }
    return height;
}
#pragma mark UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    checkTextView=textView;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    NSString *col_code=passValue(textView.tag);
    NSString *str_value=textView.text;
    str_value=[str_value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [idic_parameter_contact setObject:str_value forKey:col_code];
    [idic_edited_parameter setObject:str_value forKey:col_code];
}
- (IBAction)fn_save_modified_contact:(id)sender {
    NSString *str_msg=nil;
    if (_add_contact_flag==1) {
        str_msg=MYLocalizedString(@"msg_save_add", nil);
    }else{
        str_msg=MYLocalizedString(@"msg_save_edit", nil);
    }
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:str_msg delegate:self cancelButtonTitle:MYLocalizedString(@"lbl_discard", nil)otherButtonTitles:MYLocalizedString(@"lbl_save", nil) , nil];
    [alertView show];
}

- (IBAction)fn_cancel_edited_data:(id)sender {
    BOOL isSame=[idic_parameter_contact isEqualToDictionary:idic_parameter_contact_copy];
    NSString *str_msg=nil;
    if (_add_contact_flag==1) {
        str_msg=MYLocalizedString(@"msg_cancel_add", nil);
    }else{
        str_msg=MYLocalizedString(@"msg_cancel_edit", nil);
    }
    if (!isSame) {
        flag_click_cancel=1;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:str_msg delegate:self cancelButtonTitle:MYLocalizedString(@"lbl_discard", nil)otherButtonTitles:MYLocalizedString(@"lbl_save", nil) , nil];
        [alert show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)fn_lookup_data:(id)sender {
    UIButton *ibtn=(UIButton*)sender;
    OptionViewController *VC=(OptionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
    DB_crmacct_browse *db=[[DB_crmacct_browse alloc]init];
    VC.alist_option=[db fn_get_acct_nameAndid];
    VC.flag=1;
    VC.callback=^(NSMutableDictionary *dic){
        if ([dic count]!=0 && dic!=nil) {
            [idic_parameter_contact setObject:[dic valueForKey:@"acct_name"] forKey:passValue(ibtn.tag)];
            [idic_parameter_contact setObject:[dic valueForKey:@"acct_id"] forKey:@"contact_ref_id"];
            [idic_edited_parameter setObject:[dic valueForKey:@"acct_name"] forKey:passValue(ibtn.tag)];
            [idic_edited_parameter setObject:[dic valueForKey:@"acct_id"] forKey:@"contact_ref_id"];
            [self.skstableView reloadData];
        }
    };
    PopViewManager *popView=[[PopViewManager alloc]init];
    [ popView PopupView:VC Size:CGSizeMake(240, 300) uponView:self];
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==[alertView firstOtherButtonIndex]) {
        BOOL isSuccess=NO;
        DB_crmcontact_browse *db=[[DB_crmcontact_browse alloc]init];
        if (_add_contact_flag==1) {
            NSMutableArray *alist_crmcontact=[[NSMutableArray alloc]initWithObjects:[self fn_get_updateform], nil];
            isSuccess=[db fn_save_crmcontact_browse:alist_crmcontact];
            alist_crmcontact=nil;
        }else{
            [idic_edited_parameter setObject:@"1" forKey:@"is_modified"];
            isSuccess=[db fn_update_crmcontact_browse:idic_edited_parameter unique_id:[idic_parameter_contact valueForKey:@"unique_id"]];
        }
        
        if (isSuccess) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"contact_update" object:nil];
            idic_parameter_contact_copy=[NSMutableDictionary dictionaryWithDictionary:idic_parameter_contact];
            if (flag_click_cancel==1 || _add_contact_flag==1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:MYLocalizedString(@"msg_save_title", nil) message:MYLocalizedString(@"msg_save_locally", nil) delegate:nil cancelButtonTitle:MYLocalizedString(@"lbl_ok", nil) otherButtonTitles:nil, nil];
            [alertview show];
        }
       
    }
    if (buttonIndex==[alertView cancelButtonIndex]) {
        idic_parameter_contact=[NSMutableDictionary dictionaryWithDictionary:idic_parameter_contact_copy];
        [self.skstableView reloadData];
        if (flag_click_cancel==1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(RespCrmcontact_browse*)fn_get_updateform{
    RespCrmcontact_browse *updateform_contact=[[RespCrmcontact_browse alloc]init];
    [updateform_contact setValuesForKeysWithDictionary:idic_parameter_contact];
    if (_add_contact_flag==1) {
        idic_parameter_contact=[[NSDictionary dictionaryWithPropertiesOfObject:updateform_contact]mutableCopy];
        [updateform_contact setValuesForKeysWithDictionary:idic_parameter_contact];
    }
    return updateform_contact;
}
@end

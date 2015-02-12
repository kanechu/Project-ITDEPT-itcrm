//
//  EditOppViewController.m
//  itcrm
//
//  Created by itdept on 14-7-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "EditOppViewController.h"
#import "DB_MaintForm.h"
#import "SKSTableViewCell.h"
#import "Cell_maintForm1.h"
#import "DB_crmopp_browse.h"
#import "DB_crmacct_browse.h"
#import "OptionViewController.h"
#import "RegionViewController.h"
#import "RespCrmopp_browse.h"
#import "Web_updateData.h"
#import "Custom_BtnGraphicMixed.h"
#define TEXT_TAG 100
typedef NSMutableDictionary* (^passValue_opp)(NSInteger tag);
@interface EditOppViewController ()
@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_logo;
@property (nonatomic,strong)NSMutableArray *alist_maintOpp;
@property (nonatomic,strong)NSMutableArray *alist_filtered_oppdata;
@property (nonatomic,strong)NSMutableArray *alist_groupNameAndNum;
@property (nonatomic,strong)NSMutableArray *alist_option;
@property (nonatomic,strong)NSMutableDictionary *idic_parameter_opp_copy;
@property (nonatomic,strong)NSMutableDictionary *idic_edited_opp;
@property (nonatomic,strong)Format_conversion *convert;
@property (nonatomic,strong)passValue_opp pass_value;
@property (nonatomic,strong)UITextView *textViewCheck;
@property (nonatomic,assign)NSInteger flag_cancel;
@end

@implementation EditOppViewController
@synthesize alist_filtered_oppdata;
@synthesize alist_groupNameAndNum;
@synthesize alist_maintOpp;
@synthesize idic_parameter_opp;
@synthesize convert;
@synthesize pass_value;
@synthesize idic_parameter_opp_copy;
@synthesize alist_option;
@synthesize textViewCheck;
@synthesize idic_edited_opp;
@synthesize flag_cancel;
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
    [self fn_get_maint_crmopp];
    [self fn_set_property];
    [self fn_custom_gesture];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fn_set_property{
    idic_parameter_opp_copy=[NSMutableDictionary dictionaryWithDictionary:idic_parameter_opp];
    idic_edited_opp=[[NSMutableDictionary alloc]initWithCapacity:1];
    
    [_ibtn_save setTitle:MYLocalizedString(@"lbl_save", nil) forState:UIControlStateNormal];
    [_ibtn_Cancel setTitle:MYLocalizedString(@"lbl_cancel", nil)];
    [_ibtn_logo setTitle:MYLocalizedString(@"lbl_edit_opp", nil) forState:UIControlStateNormal];
    [_ibtn_logo setImage:[UIImage imageNamed:@"ic_itcrm_logo"] forState:UIControlStateNormal];
    if (_add_opp_flag==1) {
        [_ibtn_logo setTitle:MYLocalizedString(@"sheet_opp", nil) forState:UIControlStateNormal];
    }
    if (_flag_can_edit!=1) {
        _ibtn_save.enabled=NO;
    }else{
        _ibtn_save.enabled=YES;
    }
    [_ibtn_save setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    self.skstableView.SKSTableViewDelegate=self;
    [self.skstableView fn_expandall];
    self.skstableView.showsVerticalScrollIndicator=NO;
    [expand_helper setExtraCellLineHidden:self.skstableView];
    
    convert=[[Format_conversion alloc]init];
    
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_tableView_scrollTop) name:@"touchStatusBar" object:nil];
}
-(void)fn_tableView_scrollTop{
    [self.skstableView setContentOffset:CGPointZero animated:YES];
}
/**
 *  自定义一个手势，点击空白的地方，隐藏键盘
 */
-(void)fn_custom_gesture{
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fn_keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapgesture.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapgesture];
}
-(void)fn_keyboardHide:(UITapGestureRecognizer*)tap{
    [textViewCheck resignFirstResponder];
}

#pragma mark -获取定制opp maint版面的数据
-(void)fn_get_maint_crmopp{
    DB_MaintForm *db=[[DB_MaintForm alloc]init];
    alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmopp"];
    alist_maintOpp=[db fn_get_MaintForm_data:@"crmopp"];
    alist_filtered_oppdata=[[NSMutableArray alloc]initWithCapacity:10];
    alist_option=[[NSMutableArray alloc]initWithCapacity:10];
    for (NSMutableDictionary *dic in alist_groupNameAndNum) {
        NSString *str_name=[dic valueForKey:@"group_name"];
        NSArray *arr=[expand_helper fn_filtered_criteriaData:str_name arr:alist_maintOpp];
        if (arr!=nil) {
            [alist_filtered_oppdata addObject:arr];
        }
    }
}

#pragma mark SKSTableViewDelegate 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [alist_groupNameAndNum count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath{
    NSString *numofrows=[[alist_groupNameAndNum objectAtIndex:indexPath.section]valueForKey:@"COUNT(group_name)"];
    return [numofrows integerValue];
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
    NSMutableDictionary *dic=alist_filtered_oppdata[indexPath.section][indexPath.subRow-1];
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
    }
    //col_opption
    NSString *col_option=[dic valueForKey:@"col_option"];
    [self fn_get_choice_arr:col_option];
    //blockSelf是本地变量，是弱引用，_block被retain的时候，并不会增加retain count
    __block EditOppViewController *blockSelf=self;
    pass_value=^NSMutableDictionary*(NSInteger tag){
        return blockSelf-> alist_filtered_oppdata [tag/100-1][tag-TEXT_TAG-(tag/100-1)*100];
    };
    static NSString *cellIdentifier=@"Cell_maintForm1_opp";
    Cell_maintForm1 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.is_enable=is_enable_flag;
    cell.il_remind_label.text=col_label;
    cell.itv_data_textview.delegate=self;
    cell.itv_data_textview.tag=TEXT_TAG+indexPath.section*100+indexPath.subRow-1;
    NSString *text_value=[idic_parameter_opp valueForKey:col_code];
    
    if ([col_stye isEqualToString:@"int"]) {

        NSString *text_display=[convert fn_convert_display_status:text_value col_option:col_option];
        cell.itv_data_textview.text=text_display;
        cell.itv_data_textview.keyboardType=UIKeyboardTypeNumberPad;
    }else{
        
        NSString *text_display=nil;
        if ([col_stye isEqualToString:@"choice"]){
            text_display=[self fn_convert_display_status:text_value];
        }else{
            text_display=[convert fn_convert_display_status:text_value col_option:col_option];
        }
        cell.itv_data_textview.text=text_display;
    }
    //UITextView 上下左右有8px
    CGFloat height=[convert fn_heightWithString:cell.itv_data_textview.text font:[UIFont systemFontOfSize:15] constrainedToWidth:cell.itv_data_textview.contentSize.width-16];
    [cell.itv_data_textview setFrame:CGRectMake(cell.itv_data_textview.frame.origin.x, cell.itv_data_textview.frame.origin.y, cell.itv_data_textview.frame.size.width, height+16)];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    //提取每行的数据
    NSMutableDictionary *dic=alist_filtered_oppdata[indexPath.section][indexPath.subRow-1];
    NSString *col_code=[dic valueForKey:@"col_code"];
    NSString *col_option=[dic valueForKey:@"col_option"];
    NSString *text_value=[idic_parameter_opp valueForKey:col_code];
    NSString *text_display=[convert fn_convert_display_status:text_value col_option:col_option];
    CGFloat height;
    static NSString *cellIdentifier=@"Cell_maintForm1_opp";
    Cell_maintForm1 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
    height=[convert fn_heightWithString:text_display font:cell.itv_data_textview.font constrainedToWidth:cell.itv_data_textview.contentSize.width-16];
    height=height+16+10;
    if (height<44) {
        height=44;
    }
    return height;
}
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSMutableDictionary *idic=pass_value(textView.tag);
    NSString *col_type=[idic valueForKey:@"col_type"];
    NSString *col_option=[idic valueForKey:@"col_option"];
    NSString *col_code=[idic valueForKey:@"col_code"];
    NSString *str_placeholder=[idic valueForKey:@"col_label"];
    if ([col_type isEqualToString:@"int"]) {
        return YES;
    }
    if ([col_type isEqualToString:@"choice"]||[col_type isEqualToString:@"local_lookup"]) {
        OptionViewController *VC=(OptionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
        DB_crmacct_browse *db=[[DB_crmacct_browse alloc]init];
        if ([col_type isEqualToString:@"choice"]) {
            [self fn_get_choice_arr:col_option];
            VC.alist_option=alist_option;
            VC.callback=^(NSMutableDictionary *dic){
                [idic_parameter_opp setObject:[dic valueForKey:@"data"] forKey:col_code];
                [idic_edited_opp setObject:[dic valueForKey:@"data"] forKey:col_code];
                [self.skstableView reloadData];
            };
            
        }else{
            VC.alist_option=[db fn_get_acct_nameAndid];
            VC.flag=1;
            VC.callback=^(NSMutableDictionary *dic){
                if ([dic count]!=0 && dic!=nil) {
                    [idic_parameter_opp setObject:[dic valueForKey:@"acct_name"] forKey:col_code];
                    [idic_edited_opp setObject:[dic valueForKey:@"acct_name"] forKey:col_code];
                    [self.skstableView reloadData];
                }
            };
        }
        PopViewManager *popView=[[PopViewManager alloc]init];
        [ popView PopupView:VC Size:CGSizeMake(250, 300) uponView:self];
        return NO;
    }else{
        [self fn_pop_regionView:str_placeholder type:col_option key_flag:col_code];
        return NO;
    }
    return YES;

}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    textViewCheck=textView;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSMutableDictionary *dic=pass_value(textView.tag);
    NSString *col_code=[dic valueForKey:@"col_code"];
    if (textView.text!=nil) {
        NSString *str_value=textView.text;
        //去掉字符串的前后空格
        str_value=[str_value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [idic_parameter_opp setObject:str_value forKey:col_code];
        [idic_edited_opp setObject:str_value forKey:col_code];
    }
}
- (IBAction)fn_save_modified_data:(id)sender {
    BOOL isSame=[idic_parameter_opp isEqualToDictionary:idic_parameter_opp_copy];
    if (!isSame) {
        NSString *str_msg=nil;
        if (_add_opp_flag==1) {
            str_msg=MYLocalizedString(@"msg_save_add", nil);
        }else{
            str_msg=MYLocalizedString(@"msg_save_edit", nil);
        }
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:str_msg delegate:self cancelButtonTitle:MYLocalizedString(@"lbl_discard", nil)otherButtonTitles:MYLocalizedString(@"lbl_save", nil) , nil];
        [alert show];
    }else{
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:nil message:MYLocalizedString(@"msg_already_save", nil) delegate:nil cancelButtonTitle:MYLocalizedString(@"lbl_ok", nil) otherButtonTitles:nil, nil];
        [alertview show];
    }
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    if (buttonIndex==[alertView firstOtherButtonIndex]) {
        BOOL isSuccess=NO;
        DB_crmopp_browse *db_crmopp=[[DB_crmopp_browse alloc]init];
        if (_add_opp_flag==1) {
            NSMutableArray *alist_crmopp=[[NSMutableArray alloc]initWithObjects:[self fn_get_updateform], nil];
            isSuccess=[db_crmopp fn_save_crmopp_browse:alist_crmopp];
            [db_crmopp fn_update_crmopp_ismodified:@"1" opp_id:[idic_parameter_opp valueForKey:@"opp_id"]];
        }else{
            NSString *current_date=[convert fn_get_current_date_millisecond];
            [idic_edited_opp setObject:current_date forKey:@"rec_upd_date"];
            current_date=nil;
            [idic_edited_opp setObject:@"1" forKey:@"is_modified"];
            isSuccess= [db_crmopp fn_update_crmopp_data:idic_edited_opp unique_id:[idic_parameter_opp valueForKey:@"unique_id"]];
        }
        if (isSuccess) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"crmopp_update" object:nil];
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:MYLocalizedString(@"msg_save_title", nil) message:MYLocalizedString(@"msg_save_locally", nil) delegate:nil cancelButtonTitle:MYLocalizedString(@"lbl_ok", nil) otherButtonTitles:nil, nil];
            [alertview show];
            idic_parameter_opp_copy=[NSMutableDictionary dictionaryWithDictionary:idic_parameter_opp];
            if (flag_cancel==1 ||_add_opp_flag) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    }
    if (buttonIndex==[alertView cancelButtonIndex]) {
        idic_parameter_opp=[NSMutableDictionary dictionaryWithDictionary:idic_parameter_opp_copy];
        [self.skstableView reloadData];
        if (flag_cancel==1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}
-(RespCrmopp_browse*)fn_get_updateform{
    RespCrmopp_browse *updateform_contact=[[RespCrmopp_browse alloc]init];
   //使用kvc给模型数据赋值
    [updateform_contact setValuesForKeysWithDictionary:idic_parameter_opp];
    idic_parameter_opp=[[NSDictionary dictionaryWithPropertiesOfObject:updateform_contact]mutableCopy];
    [updateform_contact setValuesForKeysWithDictionary:idic_parameter_opp];
    NSString *current_date=[convert fn_get_current_date_millisecond];
    updateform_contact.rec_upd_date=current_date;
    return updateform_contact;
}
- (IBAction)fn_cancel_edited_data:(id)sender {
    BOOL isSame=[idic_parameter_opp isEqualToDictionary:idic_parameter_opp_copy];
    NSString *str_msg=nil;
    if (_add_opp_flag==1) {
        str_msg=MYLocalizedString(@"msg_cancel_add", nil);
    }else{
        str_msg=MYLocalizedString(@"msg_cancel_edit", nil);
    }
    if (!isSame) {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:nil message:str_msg delegate:self cancelButtonTitle:MYLocalizedString(@"lbl_discard", nil) otherButtonTitles:MYLocalizedString(@"lbl_save", nil), nil];
        [alertview show];
        flag_cancel=1;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)fn_get_choice_arr:(NSString*)col_option{
    [alist_option removeAllObjects];
    NSArray *arr_option=[col_option componentsSeparatedByString:@","];
    for (NSString *str_option in arr_option) {
        NSArray *arr=[str_option componentsSeparatedByString:@"/"];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        if ([arr count]==2) {
            [dic setObject:[arr objectAtIndex:0] forKey:@"data"];
            [dic setObject:[arr objectAtIndex:1] forKey:@"display"];
        }
        [alist_option addObject:dic];
    }
}
-(NSString*)fn_convert_display_status:(NSString*)data{
    NSString *display_str=nil;
    NSInteger flag=0;
    for (NSMutableDictionary *dic in alist_option) {
        if ([data isEqualToString:[dic valueForKey:@"data"]]) {
            display_str=[dic valueForKey:@"display"];
            flag=1;
            break;
        }
    }
    if (flag==0) {
        display_str=data;
    }
    return display_str;
}

-(void)fn_pop_regionView:(NSString*)placeholder type:(NSString*)is_type key_flag:(NSString*)key{
    RegionViewController *VC=(RegionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"RegionViewController"];
    VC.is_placeholder=placeholder;
    VC.type=is_type;
    VC.callback_region=^(NSMutableDictionary *dic){
        NSString *str_data=[dic valueForKey:@"data"];
        NSString *str_display=[dic valueForKey:@"display"];
        [idic_parameter_opp setObject:str_data forKey:key];
        [idic_edited_opp setObject:str_data forKey:key];
        [idic_edited_opp setObject:str_display forKey:[self fn_get_display_key:key]];
        [self.skstableView reloadData];
        str_data=nil;
        str_display=nil;
        
    };
    [self presentViewController:VC animated:YES completion:nil];
}
-(NSString*)fn_get_display_key:(NSString*)key_code{
    NSString *key_name=key_code;
    if ([key_code rangeOfString:@"_code"].location!=NSNotFound) {
        key_name=[key_code stringByReplacingOccurrencesOfString:@"_code" withString:@"_name"];
    }
    return key_name;
}
@end

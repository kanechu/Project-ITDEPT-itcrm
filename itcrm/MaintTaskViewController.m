//
//  MaintTaskViewController.m
//  itcrm
//
//  Created by itdept on 14-6-13.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "MaintTaskViewController.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "DB_MaintForm.h"
#import "Cell_maintForm1.h"
#import "Cell_maintForm2.h"
#import "Cell_lookup.h"
#import "OptionViewController.h"
#import "DB_crmtask_browse.h"
#import "Web_updateData.h"
#import "DB_Region.h"
#import "RespCrmtask_browse.h"
#import "Custom_datePicker.h"

#define TEXT_TAG 100
typedef NSMutableDictionary* (^pass_colCode)(NSInteger);
@interface MaintTaskViewController ()

@property (nonatomic,strong)NSMutableArray *alist_miantTask;
//过滤后的数组
@property (nonatomic,strong)NSMutableArray *alist_filtered_taskdata;
@property (nonatomic,strong)NSMutableArray *alist_groupNameAndNum;
@property (nonatomic,strong)Format_conversion *format;
//备份原来要修改的crmtask
@property (nonatomic,readonly)NSMutableDictionary *idic_parameter_value_copy;
@property (nonatomic,strong)NSMutableDictionary *idic_edited_parameter;
@property (nonatomic,strong)pass_colCode pass_value;
@property (nonatomic,strong)Custom_datePicker *datePicker;
@property (nonatomic,copy)NSString *select_date;
@property (nonatomic,assign)NSInteger flag;
@property (nonatomic,strong)NSDateFormatter *dateformatter;
@end

@implementation MaintTaskViewController
@synthesize alist_groupNameAndNum;
@synthesize alist_filtered_taskdata;
@synthesize alist_miantTask;
@synthesize checkTextView;
@synthesize idic_parameter_value;
@synthesize format;
@synthesize idic_parameter_value_copy;
@synthesize idic_edited_parameter;
@synthesize select_date;
@synthesize flag;//用于标识点击cancel
@synthesize datePicker;
@synthesize dateformatter;
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
    [self fn_show_different_language];
    [self fn_init_arr];
    [self fn_init_idic_parameter];
    self.skstableview.SKSTableViewDelegate=self;
    [self.skstableview fn_expandall];
    self.skstableview.showsVerticalScrollIndicator=NO;
    [expand_helper setExtraCellLineHidden:self.skstableview];
    [self fn_custom_gesture];
    format=[[Format_conversion alloc]init];
    //避免键盘挡住UITextView
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
    [self fn_create_datepick];
    flag=0;
    [self fn_set_datetime_formatter];
    /**
     *  给点击状态栏的操作添加观察者
     *
     *  @param fn_tableView_scrollTop 点击状态栏触发的方法
     *
     *  @return nil
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_tableView_scrollTop) name:@"touchStatusBar" object:nil];
    if (_add_flag==1) {
        self.title=MYLocalizedString(@"lbl_add_task", nil);
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_show_different_language{

    [_ibtn_cancel setTitle:MYLocalizedString(@"lbl_cancel", nil) forState:UIControlStateNormal];
    self.title=MYLocalizedString(@"lbl_edit_task", nil);
    [_ibtn_save setTitle:MYLocalizedString(@"lbl_save", nil) forState:UIControlStateNormal];
}
#pragma mark 点击状态栏,Tableview回滚至top
-(void)fn_tableView_scrollTop{
    [self.skstableview setContentOffset:CGPointZero animated:YES];
}

#pragma mark 设置日期的格式
-(void)fn_set_datetime_formatter{
    dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateformatter setFormatterBehavior:NSDateFormatterBehaviorDefault];
    [dateformatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}
#pragma mark 备份要修改的crmtask
-(void)fn_init_idic_parameter{
    //深拷贝，备份一份要修改的crmtask
    idic_parameter_value_copy=[NSMutableDictionary dictionaryWithDictionary:idic_parameter_value];
    idic_edited_parameter=[[NSMutableDictionary alloc]initWithCapacity:1];
}
#pragma mark -获取定制maint版面的数据
-(void)fn_init_arr{
    DB_MaintForm *db=[[DB_MaintForm alloc]init];
    alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmtask"];
    alist_miantTask=[db fn_get_MaintForm_data:@"crmtask"];
    alist_filtered_taskdata=[[NSMutableArray alloc]initWithCapacity:10];
    for (NSMutableDictionary *dic in alist_groupNameAndNum) {
        NSString *str_name=[dic valueForKey:@"group_name"];
        NSArray *arr=[expand_helper fn_filtered_criteriaData:str_name arr:alist_miantTask];
        if (arr!=nil) {
            [alist_filtered_taskdata addObject:arr];
        }
    }
}
#pragma mark create datePick
-(void)fn_create_datepick{
    datePicker=[[Custom_datePicker alloc]initWithFrame:CGRectMake(0, 0, 320, 230)];
    datePicker.delegate=self;
}
#pragma mark DatepickerDelegate
-(void)fn_Clicked_done:(NSString*)str{
    NSDate *date=[dateformatter dateFromString:str];
    NSTimeInterval timeInterval=[date timeIntervalSince1970];
    NSTimeInterval milliseconds=timeInterval*1000.0f;
    /**
     *  select_date 不能带有小数点，不然上传服务器中会失败
     */
    if (date!=nil) {
        select_date=[NSString stringWithFormat:@"%0.0lf",milliseconds];
    }else{
        select_date=@"";
    }
    [self.skstableview reloadData];
    
}
-(void)fn_Clicked_cancel{
    select_date=@"";
    [checkTextView resignFirstResponder];
    
}
-(void)fn_custom_gesture{
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fn_keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapgesture.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapgesture];
}
-(void)fn_keyboardHide:(UITapGestureRecognizer*)tap{
    select_date=@"";
    [checkTextView resignFirstResponder];
}

#pragma mark SKSTableViewDelegate and datasourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [alist_groupNameAndNum count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *numOfrow=[[alist_groupNameAndNum objectAtIndex:indexPath.section] valueForKey:@"COUNT(group_name)"];
    return [numOfrow integerValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [self.skstableview dequeueReusableCellWithIdentifier:CellIdentifier];
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
    NSMutableDictionary *dic=alist_filtered_taskdata[indexPath.section][indexPath.subRow-1];
    //显示的提示名称
    NSString *col_label=[dic valueForKey:@"col_label"];
    NSString *col_code=[dic valueForKey:@"col_code"];
    //col_stye 类型名
    NSString *col_type=[dic valueForKey:@"col_type"];
    //is_enable
    NSString *is_enable=[dic valueForKey:@"is_enable"];
    NSInteger is_enable_flag=[is_enable integerValue];
    //is_mandatory
    NSString *is_mandatory=[dic valueForKey:@"is_mandatory"];
    if ([is_mandatory isEqualToString:@"1"]) {
        col_label=[col_label stringByAppendingString:@"*"];
    }
    //blockSelf是本地变量，是弱引用，_block被retain的时候，并不会增加retain count
    __block MaintTaskViewController *blockSelf=self;
    _pass_value=^NSMutableDictionary*(NSInteger tag){
        return blockSelf-> alist_filtered_taskdata [indexPath.section][tag-TEXT_TAG-indexPath.section*100];
    };
    if ([col_type isEqualToString:@"string"] || [col_type isEqualToString:@"datetime"]) {
        static NSString *cellIdentifier=@"Cell_maintForm11";
        Cell_maintForm1 *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_maintForm1 alloc]init];
        }
        cell.is_enable=is_enable_flag;
        cell.il_remind_label.text=col_label;
        cell.itv_data_textview.delegate=self;
        cell.itv_data_textview.tag=TEXT_TAG+indexPath.section*100+indexPath.subRow-1;
        NSString *text_value=[idic_parameter_value valueForKey:col_code];
        if ([col_type isEqualToString:@"datetime"]) {
            if ([text_value length]!=0) {
                text_value=[dateformatter stringFromDate:[format dateFromUnixTimestamp:text_value]];
            }
            cell.itv_data_textview.inputView=datePicker;
        }else{
            cell.itv_data_textview.inputView=nil;
        }
        cell.itv_data_textview.text=text_value;
        //UITextView 上下左右有8px
        CGFloat height=[format fn_heightWithString:cell.itv_data_textview.text font:cell.itv_data_textview.font constrainedToWidth:cell.itv_data_textview.contentSize.width-16];
        [cell.itv_data_textview setFrame:CGRectMake(cell.itv_data_textview.frame.origin.x, cell.itv_data_textview.frame.origin.y, cell.itv_data_textview.frame.size.width, height+16)];
        return cell;
    }
    if ([col_type isEqualToString:@"lookup"]) {
        static NSString *cellIdentifier=@"Cell_lookup_taskEdit";
        Cell_lookup *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_lookup alloc]init];
        }
        cell.is_enable=is_enable_flag;
        cell.il_remind_label.text=col_label;
        NSString *str_status=[idic_parameter_value valueForKey:col_code];
        cell.itv_edit_textview.text=[format fn_convert_display_status:str_status col_option:[dic valueForKey:@"col_option"]];
        cell.itv_edit_textview.tag=TEXT_TAG+indexPath.section*100+indexPath.subRow-1;
        cell.itv_edit_textview.delegate=self;
        cell.ibtn_lookup.tag=TEXT_TAG+indexPath.section*100+indexPath.subRow-1;
        [cell.ibtn_lookup setTitle:MYLocalizedString(@"lbl_lookup", nil) forState:UIControlStateNormal];
        return cell;
    }
    if ([col_type isEqualToString:@"checkbox"]) {
        static NSString *cellIndetifier=@"Cell_maintForm2_task";
        Cell_maintForm2 *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIndetifier];
        if (!cell) {
            cell=[[Cell_maintForm2 alloc]init];
        }
        cell.is_enable=is_enable_flag;
        cell.il_remind_label.text=col_label;
        NSString *is_submit=[idic_parameter_value valueForKey:col_code];
        if ([is_submit length]==0) {
            is_submit=@"0";
        }
        if ([is_submit isEqualToString:@"0"]) {
            [cell.ibt_select setImage:[UIImage imageNamed:@"uncheckbox"] forState:UIControlStateNormal];
            [cell.ibt_select setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateSelected];
        }
        if ([is_submit isEqualToString:@"1"]) {
            [cell.ibt_select setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
            [cell.ibt_select setImage:[UIImage imageNamed:@"uncheckbox"] forState:UIControlStateSelected];
        }
        cell.ibt_select.tag=TEXT_TAG+indexPath.section*100+indexPath.subRow-1;
        return cell;
    }
    
    // Configure the cell...
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"Cell_maintForm11";
    Cell_maintForm1 *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIdentifier];
    //提取每行的数据
    NSMutableDictionary *dic=alist_filtered_taskdata[indexPath.section][indexPath.subRow-1];
    //col_code 类型名
    NSString *col_code=[dic valueForKey:@"col_code"];
    NSString *str=[idic_parameter_value valueForKey:col_code];
   CGFloat height=[format fn_heightWithString:str font:[UIFont systemFontOfSize:15] constrainedToWidth:cell.itv_data_textview.contentSize.width-16];
    height=height+16+10;
    if (height<44) {
        height=44;
    }
    return height;
}
- (IBAction)fn_save_edit_data:(id)sender {
    NSString *str=nil;
    if (_add_flag==1) {
        str=MYLocalizedString(@"msg_save_add", nil);
    }else{
        str=MYLocalizedString(@"msg_save_edit", nil);
    }
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:nil message:str delegate:self cancelButtonTitle:MYLocalizedString(@"lbl_save", nil) otherButtonTitles:MYLocalizedString(@"lbl_discard", nil), nil];
    [alertview show];
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        //还原数据
        idic_parameter_value=[NSMutableDictionary dictionaryWithDictionary:idic_parameter_value_copy];
        [self.skstableview reloadData];
        if (flag==1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if (buttonIndex==0) {
        BOOL isSuccess=0;
        DB_crmtask_browse *db=[[DB_crmtask_browse alloc]init];
        if (_add_flag==1) {
            NSMutableArray *alist_crmtask=[[NSMutableArray alloc]initWithObjects:[self fn_init_updateform], nil];
            isSuccess=[db fn_save_crmtask_browse:alist_crmtask];
        }else{
            [idic_edited_parameter setObject:@"1" forKey:@"is_modified"];
            isSuccess=[db fn_update_crmtask_browse:idic_edited_parameter unique_id:[idic_parameter_value valueForKey:@"unique_id"]];
        }
        if (isSuccess) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"update" object:nil];
        }
        if (flag==1 || _add_flag==1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        Web_updateData *web_update=[[Web_updateData alloc]init];
        [web_update fn_get_updateStatus_data:[self fn_init_updateform] path:STR_CRMTASK_UPDATE_URL :^(NSMutableArray *arr){
            NSString *status=nil;
            if ([arr count]!=0) {
                status=[[arr objectAtIndex:0]valueForKey:@"status"];
            }
            if ([status isEqualToString:@"1"]) {
                [db fn_update_crmtask_ismodified:@"0" unique_id:[idic_parameter_value valueForKey:@"unique_id"]];
            }
        }];
    }
}
- (IBAction)fn_lookup_data:(id)sender {
    UIButton *btn=(UIButton*)sender;
    NSMutableDictionary *dic=_pass_value(btn.tag);
    NSString *col_option=[dic valueForKey:@"col_option"];
    NSString *col_code=[dic valueForKey:@"col_code"];
    [self fn_pop_lookup_View:col_option key_flag:col_code];
}
-(void)fn_pop_lookup_View:(NSString*)is_type key_flag:(NSString*)key{
    DB_Region *db=[[DB_Region alloc]init];
    NSMutableArray* alist_option=[db fn_get_region_data:is_type];
    OptionViewController *VC=(OptionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
    VC.alist_option=alist_option;
    VC.callback=^(NSMutableDictionary *dic){
        [idic_parameter_value setObject:[dic valueForKey:@"data"] forKey:key];
        [idic_edited_parameter setObject:[dic valueForKey:@"data"] forKey:key];
        [self.skstableview reloadData];
    };
    PopViewManager *pop=[[PopViewManager alloc]init];
    [pop PopupView:VC Size:CGSizeMake(240,300) uponView:self];
}
-(Respcrmtask_browse*)fn_init_updateform{
    NSString *unique_id=[idic_parameter_value valueForKey:@"unique_id"];
    [idic_parameter_value removeObjectForKey:@"unique_id"];
    [idic_parameter_value removeObjectForKey:@"is_modified"];
    Respcrmtask_browse *upd_form=[[Respcrmtask_browse alloc]init];
    //使用kvc给模型数据赋值
    [upd_form setValuesForKeysWithDictionary:idic_parameter_value];
    if (_add_flag==1) {
        idic_parameter_value=[[NSDictionary dictionaryWithPropertiesOfObject:upd_form]mutableCopy];
        [upd_form setValuesForKeysWithDictionary:idic_parameter_value];
    }else{
        [idic_parameter_value setObject:unique_id forKey:@"unique_id"];
    }
    return upd_form;
}
#pragma mark UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    checkTextView=textView;
    NSDate *date=[NSDate date];
    [datePicker fn_get_current_datetime:date];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSMutableDictionary *parameter_dic=_pass_value(textView.tag);
    NSString *col_code=[parameter_dic valueForKey:@"col_code"];
    NSString *col_type=[parameter_dic valueForKey:@"col_type"];
    if ([col_type isEqualToString:@"datetime"]&&[select_date length]!=0) {
        [idic_parameter_value setObject:select_date forKey:col_code];
        [idic_edited_parameter setObject:select_date forKey:col_code];
    }else if([col_type isEqualToString:@"datetime"]&&[select_date length]==0){
        return;
    }else{
        [idic_parameter_value setObject:textView.text forKey:col_code];
        [idic_edited_parameter setObject:textView.text forKey:col_code];
    }
}

- (IBAction)fn_goBack:(id)sender {
    BOOL isSame=[idic_parameter_value isEqualToDictionary:idic_parameter_value_copy];
    NSString *str=nil;
    if (_add_flag==1) {
        str=MYLocalizedString(@"msg_cancel_add", nil);
    }else{
        str=MYLocalizedString(@"msg_cancel_edit", nil);
    }
    if (!isSame) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:str delegate:self cancelButtonTitle:MYLocalizedString(@"lbl_save", nil) otherButtonTitles:MYLocalizedString(@"lbl_discard", nil), nil];
        flag=1;
        [alert show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)fn_click_checkBox:(id)sender {
    UIButton *ibtn=(UIButton*)sender;
    NSMutableDictionary *idic=_pass_value(ibtn.tag);
    NSString *col_code=[idic valueForKey:@"col_code"];
    NSString *is_submit=[idic_parameter_value valueForKey:col_code];
    BOOL submited=[is_submit isEqualToString:@"1"];
    ibtn.selected=!ibtn.selected;
    NSString *submite_value=nil;
    if (ibtn.selected) {
        if (submited) {
            submite_value=@"0";
        }else{
            submite_value=@"1";
        }
    }else{
        if (submited) {
            submite_value=@"0";
        }else{
            submite_value=@"1";
        }
    }
    [idic_parameter_value setObject:submite_value forKey:col_code];
    [idic_edited_parameter setObject:submite_value forKey:col_code];
}
@end

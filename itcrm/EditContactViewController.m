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
enum TEXT_TAG {
    TEXT_TAG = 100
};
typedef NSString* (^passValue_contact)(NSInteger tag);
@interface EditContactViewController ()
@property(nonatomic,strong)NSMutableDictionary *idic_parameter_contact;
@property(nonatomic,strong)NSMutableDictionary *idic_edited_parameter;
@property(nonatomic,strong)NSMutableDictionary *idic_parameter_contact_copy;
@property(nonatomic,strong)NSMutableArray *alist_maintContact;
//过滤后的数组
@property (nonatomic,strong)NSMutableArray *alist_filtered_contactdata;
@property (nonatomic,strong)NSMutableArray *alist_groupNameAndNum;
@property (nonatomic,strong)UITextView *checkTextView;
@property (nonatomic,strong)Format_conversion *convert;
@property (nonatomic,strong)passValue_contact passValue;
@property (nonatomic,strong)UITextView *checkText;
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
    [self fn_get_idic_parameter];
    self.skstableView.SKSTableViewDelegate=self;
    [self.skstableView fn_expandall];
    [self fn_custom_gesture];
    [expand_helper setExtraCellLineHidden:self.skstableView];
    _convert=[[Format_conversion alloc]init];
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 获取要修改的crmcontact
-(void)fn_get_idic_parameter{
    DB_crmcontact_browse *db=[[DB_crmcontact_browse alloc]init];
    NSMutableArray *arr_crmcontact=[db fn_get_crmcontact_browse:_is_contact_id];
    if ([arr_crmcontact count]!=0) {
        idic_parameter_contact=[arr_crmcontact objectAtIndex:0];
    }
    //深拷贝一份要修改的contact,用于还原
    idic_parameter_contact_copy=[NSMutableDictionary dictionaryWithDictionary:idic_parameter_contact];
    idic_edited_parameter=[[NSMutableDictionary alloc]initWithCapacity:1];
}
#pragma mark -获取定制contact maint版面的数据
-(void)fn_get_maint_crmcontact{
    DB_MaintForm *db=[[DB_MaintForm alloc]init];
    alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmcontact"];
    alist_maintContact=[db fn_get_MaintForm_data:@"crmcontact"];
    alist_filtered_contactdata=[[NSMutableArray alloc]initWithCapacity:10];
    
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
    NSArray *arr=[expand_helper fn_filtered_criteriaData:str_name arr:alist_maintContact];
    if (arr!=nil) {
        [alist_filtered_contactdata addObject:arr];
    }
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
        cell.itv_edit_textview.delegate=self;
        CGFloat height=[_convert fn_heightWithString:cell.itv_edit_textview.text font:cell.itv_edit_textview.font constrainedToWidth:cell.itv_edit_textview.contentSize.width-16];
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
        height=height+16+28;
        
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
    [idic_parameter_contact setObject:textView.text forKey:col_code];
    [idic_edited_parameter setObject:textView.text forKey:col_code];
}
- (IBAction)fn_save_modified_contact:(id)sender {
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"whether save the modified data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"cancel", nil];
    [alertView show];
}

- (IBAction)fn_lookup_data:(id)sender {
    UIButton *ibtn=(UIButton*)sender;
    OptionViewController *VC=(OptionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
    DB_crmacct_browse *db=[[DB_crmacct_browse alloc]init];
    VC.alist_option=[db fn_get_data:@"" select_sql:@"acct_name"];
    VC.lookup_title=@"select the account name";
    VC.flag=1;
    VC.callback=^(NSMutableDictionary *dic){
        [idic_parameter_contact setObject:[dic valueForKey:@"acct_name"] forKey:passValue(ibtn.tag)];
        [idic_edited_parameter setObject:[dic valueForKey:@"acct_name"] forKey:passValue(ibtn.tag)];
        [self.skstableView reloadData];
    };
    PopViewManager *popView=[[PopViewManager alloc]init];
    [ popView PopupView:VC Size:CGSizeMake(250, 300) uponView:self];
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        Web_updateData *web_update=[[Web_updateData alloc]init];
        [web_update fn_get_updateStatus_data:[self fn_get_updateform] path:STR_CRMCONTACT_UPDATE_URL :^(NSMutableArray *arr){
            DB_crmcontact_browse *db=[[DB_crmcontact_browse alloc]init];
            BOOL isSuccess=[db fn_update_crmcontact_browse:idic_edited_parameter unique_id:[idic_parameter_contact valueForKey:@"unique_id"]];
            if (isSuccess) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"contact_update" object:nil];
            }
            
        }];
    }
    if (buttonIndex==1) {
        NSLog(@"不保存数据");
        idic_parameter_contact=[NSMutableDictionary dictionaryWithDictionary:idic_parameter_contact_copy];
        [self.skstableView reloadData];
    }
}
-(RespCrmcontact_browse*)fn_get_updateform{
    RespCrmcontact_browse *updateform_contact=[[RespCrmcontact_browse alloc]init];
    NSString *unique_id=[idic_parameter_contact valueForKey:@"unique_id"];
    [idic_parameter_contact removeObjectForKey:@"unique_id"];
    [updateform_contact setValuesForKeysWithDictionary:idic_parameter_contact];
    [idic_parameter_contact setObject:unique_id forKey:@"unique_id"];
    return updateform_contact;
}

@end

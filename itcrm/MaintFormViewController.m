//
//  MaintFormViewController.m
//  itcrm
//
//  Created by itdept on 14-6-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "MaintFormViewController.h"
#import "DB_MaintForm.h"
#import "DB_formatlist.h"
#import "DB_crmhbl_browse.h"
#import "DB_crmopp_browse.h"
#import "DB_crmtask_browse.h"
#import "DB_crmacct_browse.h"
#import "DB_crmcontact_browse.h"
#import "SKSTableViewCell.h"
#import "Cell_maintForm1.h"
#import "Cell_maintForm2.h"
#import "Cell_browse.h"
#import "Cell_lookup.h"
#import "DB_Region.h"
#import "OptionViewController.h"
#import "EditContactViewController.h"
#import "EditOppViewController.h"
#import "MaintTaskViewController.h"

@interface MaintFormViewController ()
@property(nonatomic,strong)NSMutableArray *alist_crmopp;
@property(nonatomic,strong)NSMutableArray *alist_crmtask;
@property (nonatomic,strong)NSMutableArray *alist_crmhbl;
@property (nonatomic,strong)NSMutableArray *alist_contact;
@property (nonatomic,strong)Format_conversion *format;
//标识acct_maint服务器返回的分组数
@property (nonatomic,assign)NSInteger flag_groupNum;
@property (nonatomic,strong)NSMutableDictionary *idic_lookup;
@property (nonatomic,strong)NSMutableDictionary *idic_modified_value;
@property (nonatomic,strong)EditContactViewController *editContactVC;
@property (nonatomic,strong)EditOppViewController *editOppVC;
@property (nonatomic,strong)MaintTaskViewController *maintTaskVC;
#pragma mark 根据相关id,取得的特定参数值
@property (nonatomic,strong)NSMutableArray *alist_crmtask_value;
@property (nonatomic,strong)NSMutableArray *alist_crmopp_value;
@property (nonatomic,strong)NSMutableArray *alist_crmcontact_value;
@end

@implementation MaintFormViewController
@synthesize alist_filtered_data;
@synthesize alist_groupNameAndNum;
@synthesize alist_maintForm;
@synthesize idic_modified_value;
@synthesize format;
@synthesize checkTextView;
@synthesize alist_crmhbl;
@synthesize alist_crmopp;
@synthesize alist_crmtask;
@synthesize alist_contact;
@synthesize flag_groupNum;
@synthesize idic_lookup;
@synthesize editContactVC;
@synthesize editOppVC;
@synthesize maintTaskVC;
@synthesize alist_crmcontact_value;
@synthesize alist_crmopp_value;
@synthesize alist_crmtask_value;
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
    format=[[Format_conversion alloc]init];
    [self fn_init_arr];
    //设置表的代理
    self.skstableView.SKSTableViewDelegate=self;
    //loadview的时候，打开第一个expandable
    [self.skstableView fn_expandall];
    self.skstableView.showsVerticalScrollIndicator=NO;
    //避免键盘挡住UITextView
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
    [self fn_custom_gesture];
    _ibtn_save.layer.cornerRadius=3;
    DB_crmacct_browse *db_crmacct=[[DB_crmacct_browse alloc]init];
    idic_modified_value=[[db_crmacct fn_get_data_from_id:_is_acct_id] objectAtIndex:0];;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_tableView_scrollTop) name:@"touchStatusBar" object:nil];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 点击状态栏Tableview回滚top
-(void)fn_tableView_scrollTop{
    [self.skstableView setContentOffset:CGPointZero animated:YES];
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
- (void)textViewDidBeginEditing:(UITextView *)textView{
    checkTextView=textView;
}

#pragma mark -初始化数组
-(void)fn_init_arr{
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    //获取crmtask的列表数据
    DB_crmtask_browse  *db_crmtask=[[DB_crmtask_browse alloc]init];
    alist_crmtask_value=[db_crmtask fn_get_relate_crmtask_data:_is_acct_id select_sql:[db_format fn_get_select_sql:@"crmacct_task"]];
    alist_crmtask=[self fn_format_convert:alist_crmtask_value list_id:@"crmacct_task"];
    //获取crmopp的列表数据
    DB_crmopp_browse  *db_crmopp=[[DB_crmopp_browse alloc]init];
    alist_crmopp_value=[db_crmopp fn_get_relate_crmopp_data:_is_acct_id select_sql:[db_format fn_get_select_sql:@"crmacct_opp"]];
    alist_crmopp=[self fn_format_convert:alist_crmopp_value list_id:@"crmacct_opp"];
    
    //获取crmhbl的列表数据
    DB_crmhbl_browse  *db_crmhbl=[[DB_crmhbl_browse alloc]init];
    NSMutableArray *crmhbl_arr=[db_crmhbl fn_get_relate_crmhbl_data:_is_acct_id select_sql:[db_format fn_get_select_sql:@"crmacct_hbl"]];
    alist_crmhbl=[self fn_format_convert:crmhbl_arr list_id:@"crmacct_hbl"];
    //获取crmcontact的列表数据
    DB_crmcontact_browse  *db_crmcontact=[[DB_crmcontact_browse alloc]init];
    alist_crmcontact_value=[db_crmcontact fn_get_relate_crmcontact_data:_is_acct_id select_sql:[db_format fn_get_select_sql:@"crmacct_contact"]];
    alist_contact=[self fn_format_convert:alist_crmcontact_value list_id:@"crmacct_contact"];
    
    DB_MaintForm *db=[[DB_MaintForm alloc]init];
    alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmacct"];
    flag_groupNum=[alist_groupNameAndNum count];
    NSMutableDictionary *crmtask_dic=[NSMutableDictionary dictionary];
    NSMutableDictionary *crmopp_dic=[NSMutableDictionary dictionary];
    NSMutableDictionary *crmhbl_dic=[NSMutableDictionary dictionary];
    NSMutableDictionary *crmcontact_dic=[NSMutableDictionary dictionary];
    
    if ([alist_crmtask count]!=0) {
        [crmtask_dic setObject:@"Activity" forKey:@"group_name"];
        [crmtask_dic setObject:[NSString stringWithFormat:@"%d",[alist_crmtask count]] forKey:@"COUNT(group_name)"];
        [alist_groupNameAndNum addObject:crmtask_dic];
    }
    if ([alist_contact count]!=0) {
        [crmcontact_dic setObject:@"contact" forKey:@"group_name"];
        [crmcontact_dic setObject:[NSString stringWithFormat:@"%d",[alist_contact count]] forKey:@"COUNT(group_name)"];
        [alist_groupNameAndNum addObject:crmcontact_dic];
    }
    if ([alist_crmopp count]!=0) {
        [crmopp_dic setObject:@"Opportunity" forKey:@"group_name"];
        [crmopp_dic setObject:[NSString stringWithFormat:@"%d",[alist_crmopp count]] forKey:@"COUNT(group_name)"];
        [alist_groupNameAndNum addObject:crmopp_dic];
    }
    if ([alist_crmhbl count]!=0) {
        [crmhbl_dic setObject:@"Shipment History" forKey:@"group_name"];
        [crmhbl_dic setObject:[NSString stringWithFormat:@"%d",[alist_crmhbl count]] forKey:@"COUNT(group_name)"];
        [alist_groupNameAndNum addObject:crmhbl_dic];
    }
    alist_maintForm=[db fn_get_MaintForm_data:@"crmacct"];
    alist_filtered_data=[[NSMutableArray alloc]initWithCapacity:10];
    idic_lookup=[[NSMutableDictionary alloc]initWithCapacity:10];
}
-(NSMutableArray*)fn_format_convert:(NSMutableArray*)arr_crm list_id:(NSString*)list_id; {
    //获取crm列表显示信息的格式
    NSMutableArray *arr_format=[NSMutableArray array];
    NSMutableArray *arr_browse=[NSMutableArray array];
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    arr_format=[db_format fn_get_list_data:list_id];
    if ([arr_format count]!=0) {
        //转换格式
        arr_browse=[format fn_format_conersion:arr_format browse:arr_crm];
    }
    return arr_browse;
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
    
    SKSTableViewCell *cell = [self.skstableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    { cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor=COLOR_LIGTH_GREEN;
    cell.textLabel.text=[[alist_groupNameAndNum objectAtIndex:indexPath.section]valueForKey:@"group_name"];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.expandable=YES;
    
    NSString *str=[[alist_groupNameAndNum objectAtIndex:indexPath.section] valueForKey:@"group_name"];
    NSArray *arr=[expand_helper fn_filtered_criteriaData:str arr:alist_maintForm];
    if (arr!=nil && [arr count]!=0) {
        [alist_filtered_data addObject:arr];
    }else{
        if ([str isEqualToString:@"Activity"]) {
            [alist_filtered_data addObject:alist_crmtask];
        }
        if ([str isEqualToString:@"contact"]) {
            [alist_filtered_data addObject:alist_contact];
        }
        if ([str isEqualToString:@"Opportunity"]) {
            [alist_filtered_data addObject:alist_crmopp];
        }
        if ([str isEqualToString:@"Shipment History"]) {
            [alist_filtered_data addObject:alist_crmhbl];
        }
    }
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    //提取每行的数据
    NSMutableDictionary *dic=alist_filtered_data[indexPath.section][indexPath.subRow-1];
    //显示的提示名称
    NSString *col_label=[dic valueForKey:@"col_label"];
    //col_stye 类型名
    NSString *col_stye=[dic valueForKey:@"col_type"];
    //col_code 类型名
    NSString *col_code=[dic valueForKey:@"col_code"];
    //is_enable 是否可修改
    NSString *is_enable=[dic valueForKey:@"is_enable"];
    NSInteger is_enable_flag=[is_enable integerValue];
    if ([[dic valueForKey:@"is_mandatory"] isEqualToString:@"1"]) {
        col_label=[col_label stringByAppendingString:@"*"];
    }
    if ([col_stye isEqualToString:@"string"]) {
        static NSString *cellIdentifier=@"Cell_maintForm1";
        Cell_maintForm1 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_maintForm1 alloc]init];
        }
        cell.is_enable=is_enable_flag;
        cell.il_remind_label.text=col_label;
        cell.itv_data_textview.text=[idic_modified_value valueForKey:col_code];
        CGFloat height=[format fn_heightWithString:cell.itv_data_textview.text font:[UIFont systemFontOfSize:15] constrainedToWidth:cell.itv_data_textview.contentSize.width-16];
        [cell.itv_data_textview setFrame:CGRectMake(cell.itv_data_textview.frame.origin.x, cell.itv_data_textview.frame.origin.y, cell.itv_data_textview.frame.size.width, height+16)];
        cell.itv_data_textview.delegate=self;
        return cell;
    }
    if ([col_stye isEqualToString:@"checkbox"] ) {
        static NSString *cellIdentifier=@"Cell_maintForm2";
        Cell_maintForm2 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_maintForm2 alloc]init];
        }
        cell.il_remind_label.text=col_label;
        if ([is_enable isEqualToString:@"0"]) {
        
            [cell.ibt_select setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
            cell.ibt_select.enabled=NO;
            
        }
        return cell;
    }
    if ([col_stye isEqualToString:@"lookup"]) {
        static NSString *cellIndentifier=@"Cell_lookup";
        Cell_lookup *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!cell) {
            cell=[[Cell_lookup alloc]init];
        }
        cell.itv_edit_textview.delegate=self;
        cell.il_remind_label.text=col_label;
        NSString *str_status=[idic_modified_value valueForKey:col_code];
        cell.itv_edit_textview.text=[format fn_convert_display_status:str_status col_option:[dic valueForKey:@"col_option"]];
        [idic_lookup setObject:[dic valueForKey:@"col_option"] forKey:@"status"];
        [idic_lookup setObject:col_code forKey:@"key_parameter"];
        
        return cell;
        
    }
    if (indexPath.section>flag_groupNum-1) {
        static NSString *cellIndentifier=@"Cell_browse_edit";
        Cell_browse *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!cell) {
            cell=[[Cell_browse alloc]init];
        }
        UIFont *font = [UIFont systemFontOfSize:15.0];
        cell.il_title.text=[dic valueForKey:@"title"];
        cell.il_title.font=font;
        cell.il_show_text.lineBreakMode=NSLineBreakByCharWrapping;
        cell.il_show_text.font=font;
        cell.il_show_text.text=[dic valueForKey:@"body"];
        CGFloat height=[format fn_heightWithString:cell.il_show_text.text font:font constrainedToWidth:cell.il_show_text.frame.size.width];
        [cell.il_show_text setFrame:CGRectMake(cell.il_show_text.frame.origin.x, cell.il_show_text.frame.origin.y, cell.il_show_text.frame.size.width, height)];
        if ([[[alist_groupNameAndNum objectAtIndex:indexPath.section]valueForKey:@"group_name"]isEqualToString:@"Shipment History"]==NO) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
    
    // Configure the cell...
    return nil;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(float)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    //提取每行的数据
    NSMutableDictionary *dic=alist_filtered_data[indexPath.section][indexPath.subRow-1];
    if (indexPath.section<flag_groupNum) {
        static NSString *cellIdentifier=@"Cell_maintForm1";
        Cell_maintForm1 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        //col_code 类型名
        NSString *col_code=[dic valueForKey:@"col_code"];
        NSString *str=[idic_modified_value valueForKey:col_code];
        height=[format fn_heightWithString:str font:[UIFont systemFontOfSize:15] constrainedToWidth:cell.itv_data_textview.contentSize.width-16];
        height=height+16+10;
    }else{
        static NSString *cellIdentifier=@"Cell_browse_edit";
        Cell_browse *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSString *str=[dic valueForKey:@"body"];
        height=[format fn_heightWithString:str font:[UIFont systemFontOfSize:15] constrainedToWidth:cell.il_show_text.frame.size.width];
        height=height+10+23;
    }
    if (height<44) {
        height=44;
    }
    return height;
}
#pragma mark tableView: didSelectSubRowAtIndexPath:
-(void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *groupName=[[alist_groupNameAndNum objectAtIndex:indexPath.section]valueForKey:@"group_name"];
    NSInteger selectRow=indexPath.subRow-1;
    if ([groupName isEqualToString:@"contact"]) {
        [self performSegueWithIdentifier:@"segue_acct_contactEdit" sender:self];
        editContactVC.is_contact_id=[[alist_crmcontact_value objectAtIndex:selectRow]valueForKey:@"contact_id"];
    }
    if ([groupName isEqualToString:@"Activity"]) {
        [self performSegueWithIdentifier:@"segue_acct_taskEdit" sender:self];
        maintTaskVC.is_task_id=[[alist_crmtask_value objectAtIndex:selectRow]valueForKey:@"task_id"];
    }
    if ([groupName isEqualToString:@"Opportunity"]) {
        [self performSegueWithIdentifier:@" segue_acct_oppEdit" sender:self];
        editOppVC.opp_id=[[alist_crmopp_value objectAtIndex:selectRow]valueForKey:@"opp_id"];
    }
}
#pragma mark respond prepareForSegue: sender:
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier]isEqualToString:@"segue_acct_contactEdit"]) {
        editContactVC=[segue destinationViewController];
    }
    if ([[segue identifier]isEqualToString:@"segue_acct_taskEdit"]) {
        maintTaskVC=[segue destinationViewController];
    }
    if ([[segue identifier]isEqualToString:@" segue_acct_oppEdit"]) {
        editOppVC=[segue destinationViewController];
    }
}

- (IBAction)fn_lookup_data:(id)sender {
    OptionViewController *VC=(OptionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
    DB_Region *db=[[DB_Region alloc]init];
    NSString *str_type=[idic_lookup valueForKey:@"status"];
    VC.alist_option=[db fn_get_region_data:str_type];
    VC.lookup_title=@"select the status";
    VC.callback=^(NSMutableDictionary *dic){
        [idic_modified_value setObject:[dic valueForKey:@"display"] forKey:[idic_lookup valueForKey:@"key_parameter"]];
        [self.skstableView reloadData];
    };
    PopViewManager *popView=[[PopViewManager alloc]init];
   [ popView PopupView:VC Size:CGSizeMake(250, 300) uponView:self];
}
- (IBAction)fn_save_modified_data:(id)sender {
    
}
@end

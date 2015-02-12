//
//  MaintFormViewController.m
//  itcrm
//
//  Created by itdept on 14-6-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "MaintFormViewController.h"
#import "Web_resquestData.h"
#import "DB_crmacct_browse.h"
#import "SKSTableViewCell.h"
#import "Cell_maintForm1.h"
#import "Cell_maintForm2.h"
#import "Cell_browse.h"
#import "OptionViewController.h"
#import "EditContactViewController.h"
#import "EditOppViewController.h"
#import "MaintTaskViewController.h"

@interface MaintFormViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ibtn_add_operation;
@property (nonatomic,strong)NSMutableArray *alist_maintForm;
//过滤后的数组
@property (nonatomic,strong)NSMutableArray *alist_filtered_data;
@property (nonatomic,strong)NSMutableArray *alist_groupNameAndNum;
@property(nonatomic,strong)NSMutableArray *alist_crmopp;
@property(nonatomic,strong)NSMutableArray *alist_crmtask;
@property (nonatomic,strong)NSMutableArray *alist_crmhbl;
@property (nonatomic,strong)NSMutableArray *alist_contact;
@property (nonatomic,strong)Format_conversion *format;
//标识acct_maint服务器返回的分组数
@property (nonatomic,assign)NSInteger flag_groupNum;
@property (nonatomic,strong)NSMutableDictionary *idic_lookup;
@property (nonatomic,strong)EditContactViewController *editContactVC;
@property (nonatomic,strong)EditOppViewController *editOppVC;
@property (nonatomic,strong)MaintTaskViewController *maintTaskVC;
#pragma mark 根据相关id,取得的特定参数值
@property (nonatomic,strong)NSMutableArray *alist_crmtask_value;
@property (nonatomic,strong)NSMutableArray *alist_crmopp_value;
@property (nonatomic,strong)NSMutableArray *alist_crmcontact_value;
@property (nonatomic,strong)UITextView *checkTextView;
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
    if (_flag_isDowload==1) {
        [self fn_init_arr_offline];
    }else{
        [self fn_init_arr_online];
    }
    [self fn_set_property];
    [self fn_custom_gesture];
  
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fn_save_modified_data:(id)sender {
    
}
- (void)fn_set_property{
    //设置表的代理
    self.skstableView.SKSTableViewDelegate=self;
    //loadview的时候，打开expandable
    [self.skstableView fn_expandall];
    self.skstableView.showsVerticalScrollIndicator=NO;
    [expand_helper setExtraCellLineHidden:self.skstableView];
    
    if (_flag_isDowload!=1) {
        _ibtn_add_operation.enabled=NO;
    }
    
    //避免键盘挡住UITextView
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_tableView_scrollTop) name:@"touchStatusBar" object:nil];
    //设置title
    self.title=MYLocalizedString(@"lbl_edit_account", nil);
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *ref_name=[idic_modified_value valueForKey:@"acct_name"];
    NSMutableDictionary *idic_parameter=[NSMutableDictionary dictionary];
    if (buttonIndex==[actionSheet firstOtherButtonIndex]) {
        [self performSegueWithIdentifier:@"segue_acct_taskEdit" sender:self];
        [idic_parameter setObject:ref_name forKey:@"task_ref_name"];
        [idic_parameter setObject:_is_acct_id forKey:@"task_ref_id"];
        [idic_parameter setObject:@"ACCT" forKey:@"task_ref_type"];
        [idic_parameter setObject:@"#1" forKey:@"task_id"];
        maintTaskVC.idic_parameter_value=idic_parameter;
        maintTaskVC.add_flag=1;
        maintTaskVC.flag_can_edit=1;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_update_browse) name:@"update" object:nil];
    }
    if (buttonIndex==1) {
        [self performSegueWithIdentifier:@"segue_acct_contactEdit" sender:self];
        [idic_parameter setObject:ref_name forKey:@"contact_ref_name"];
        [idic_parameter setObject:_is_acct_id forKey:@"contact_ref_id"];
        [idic_parameter setObject:@"ACCT" forKey:@"contact_type"];
        [idic_parameter setObject:@"#1" forKey:@"contact_id"];
        editContactVC.idic_parameter_contact=idic_parameter;
        editContactVC.add_contact_flag=1;
        editContactVC.flag_can_edit=1;
    }
    if (buttonIndex==2) {
        [self performSegueWithIdentifier:@" segue_acct_oppEdit" sender:self];
        [idic_parameter setObject:ref_name forKey:@"opp_ref_name"];
        [idic_parameter setObject:_is_acct_id forKey:@"opp_ref_id"];
        [idic_parameter setObject:@"ACCT" forKey:@"opp_ref_type"];
        [idic_parameter setObject:@"#1" forKey:@"opp_id"];
        editOppVC.idic_parameter_opp=idic_parameter;
        editOppVC.add_opp_flag=1;
        editOppVC.flag_can_edit=1;
    }
    idic_parameter=nil;
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
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    OptionViewController *VC=(OptionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
    DB_Region *db=[[DB_Region alloc]init];
    NSString *str_type=[idic_lookup valueForKey:@"status"];
    VC.alist_option=[db fn_get_region_data:str_type];
    VC.callback=^(NSMutableDictionary *dic){
        [idic_modified_value setObject:[dic valueForKey:@"display"] forKey:[idic_lookup valueForKey:@"key_parameter"]];
        [self.skstableView reloadData];
    };
    PopViewManager *popView=[[PopViewManager alloc]init];
    [ popView PopupView:VC Size:CGSizeMake(250, 300) uponView:self];
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    checkTextView=textView;
}

#pragma mark -初始化数组
//在线环境下初始化数组
-(void)fn_init_arr_online{
    //获取crmtask的列表数据
    NSArray *arr_crmtask=[_resp_download.ActivityResult allObjects];
    alist_crmtask_value=[[NSMutableArray alloc]init];
    NSInteger i=0;
    for (Respcrmtask_browse *resp_crmtask in arr_crmtask) {
        if (i==3) {
            break;
        }
        NSDictionary *dic=[NSDictionary dictionaryWithPropertiesOfObject:resp_crmtask];
        [alist_crmtask_value addObject:dic];
        dic=nil;
        i++;
    }
    alist_crmtask=[self fn_format_convert:alist_crmtask_value list_id:@"crmacct_task"];
    
    //获取crmopp的列表数据
    NSArray *arr_crmopp=[_resp_download.OppResult allObjects];
    alist_crmopp_value=[[NSMutableArray alloc]init];
    for (RespCrmopp_browse *resp_crmopp in arr_crmopp) {
        NSDictionary *dic=[NSDictionary dictionaryWithPropertiesOfObject:resp_crmopp];
        [alist_crmopp_value addObject:dic];
        dic=nil;
    }
    alist_crmopp=[self fn_format_convert:alist_crmopp_value list_id:@"crmacct_opp"];
    
    //获取crmhbl的列表数据
    NSArray *arr_crmhbl=[_resp_download.HblResult allObjects];
    NSMutableArray *crmhbl_arr=[[NSMutableArray alloc]init];
    NSInteger j=0;
    for (RespCrmhbl_browse *resp_crmhbl in arr_crmhbl) {
        if (j==50) {
            break;
        }
        NSDictionary *dic=[NSDictionary dictionaryWithPropertiesOfObject:resp_crmhbl];
        [crmhbl_arr addObject:dic];
        dic=nil;
        j++;
    }
    alist_crmhbl=[self fn_format_convert:crmhbl_arr list_id:@"crmacct_hbl"];
    crmhbl_arr=nil;
    
    //获取crmcontact的列表数据
    alist_crmcontact_value=[[NSMutableArray alloc]init];
    NSArray *arr_crmcontact=[_resp_download.ContactResult allObjects];
    for (RespCrmcontact_browse *resp_contact in arr_crmcontact) {
        NSDictionary *dic=[NSDictionary dictionaryWithPropertiesOfObject:resp_contact];
        [alist_crmcontact_value addObject:dic];
        dic=nil;
    }
    alist_contact=[self fn_format_convert:alist_crmcontact_value list_id:@"crmacct_contact"];
    [self fn_add_groupNameAndNum];
}
//离线环境下初始化数组
-(void)fn_init_arr_offline{
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    //获取crmtask的列表数据
    DB_crmtask_browse  *db_crmtask=[[DB_crmtask_browse alloc]init];
    alist_crmtask_value=[db_crmtask fn_get_relate_crmtask_data:_is_acct_id select_sql:[db_format fn_get_select_sql:@"crmacct_task"]];
    alist_crmtask=[self fn_format_convert:alist_crmtask_value list_id:@"crmacct_task"];
    db_crmtask=nil;
    //获取crmopp的列表数据
    DB_crmopp_browse  *db_crmopp=[[DB_crmopp_browse alloc]init];
    alist_crmopp_value=[db_crmopp fn_get_relate_crmopp_data:_is_acct_id select_sql:[db_format fn_get_select_sql:@"crmacct_opp"]];
    alist_crmopp=[self fn_format_convert:alist_crmopp_value list_id:@"crmacct_opp"];
    db_crmopp=nil;
    //获取crmhbl的列表数据
    DB_crmhbl_browse  *db_crmhbl=[[DB_crmhbl_browse alloc]init];
    NSMutableArray *crmhbl_arr=[db_crmhbl fn_get_relate_crmhbl_data:_is_acct_id select_sql:[db_format fn_get_select_sql:@"crmacct_hbl"]];
    alist_crmhbl=[self fn_format_convert:crmhbl_arr list_id:@"crmacct_hbl"];
    db_crmhbl=nil;
    //获取crmcontact的列表数据
    DB_crmcontact_browse  *db_crmcontact=[[DB_crmcontact_browse alloc]init];
    alist_crmcontact_value=[db_crmcontact fn_get_relate_crmcontact_data:_is_acct_id select_sql:[db_format fn_get_select_sql:@"crmacct_contact"]];
    alist_contact=[self fn_format_convert:alist_crmcontact_value list_id:@"crmacct_contact"];
    db_crmcontact=nil;
    [self fn_add_groupNameAndNum];
   
}
- (void)fn_add_groupNameAndNum{
    
    DB_MaintForm *db=[[DB_MaintForm alloc]init];
    alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmacct"];
    flag_groupNum=[alist_groupNameAndNum count];
    //添加活动组
    
    NSMutableDictionary *crmtask_dic=[NSMutableDictionary dictionary];
    [crmtask_dic setObject:MYLocalizedString(@"lbl_task", nil) forKey:@"group_name"];
    [crmtask_dic setObject:[NSString stringWithFormat:@"%@",@(alist_crmtask.count)] forKey:@"COUNT(group_name)"];
    [alist_groupNameAndNum addObject:crmtask_dic];
    
    //添加通讯录组
    NSMutableDictionary *crmcontact_dic=[NSMutableDictionary dictionary];
    [crmcontact_dic setObject:MYLocalizedString(@"lbl_contact", nil) forKey:@"group_name"];
    [crmcontact_dic setObject:[NSString stringWithFormat:@"%@",@(alist_contact.count)] forKey:@"COUNT(group_name)"];
    [alist_groupNameAndNum addObject:crmcontact_dic];
    
    //添加商机组
    NSMutableDictionary *crmopp_dic=[NSMutableDictionary dictionary];
    [crmopp_dic setObject:MYLocalizedString(@"lbl_opp", nil) forKey:@"group_name"];
    [crmopp_dic setObject:[NSString stringWithFormat:@"%@",@(alist_crmopp.count)] forKey:@"COUNT(group_name)"];
    [alist_groupNameAndNum addObject:crmopp_dic];
    
    //添加货运记录组
    NSMutableDictionary *crmhbl_dic=[NSMutableDictionary dictionary];
    [crmhbl_dic setObject:MYLocalizedString(@"lbl_hbl", nil) forKey:@"group_name"];
    [crmhbl_dic setObject:[NSString stringWithFormat:@"%@",@(alist_crmhbl.count)] forKey:@"COUNT(group_name)"];
    [alist_groupNameAndNum addObject:crmhbl_dic];
    
    alist_maintForm=[db fn_get_MaintForm_data:@"crmacct"];
    alist_filtered_data=[[NSMutableArray alloc]initWithCapacity:10];
    idic_lookup=[[NSMutableDictionary alloc]initWithCapacity:10];
    [self fn_get_filtered_data];
}
-(NSMutableArray*)fn_format_convert:(NSMutableArray*)arr_crm list_id:(NSString*)list_id; {
    NSMutableArray *arr_browse=[NSMutableArray array];
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    //获取crm列表显示信息的格式
    NSMutableArray *arr_format=[db_format fn_get_list_data:list_id];
    if ([arr_format count]!=0) {
        //转换格式
        arr_browse=[format fn_format_conersion:arr_format browse:arr_crm];
    }
    db_format=nil;
    return arr_browse;
}
#pragma mark 过滤数据
-(void)fn_get_filtered_data{
    for (NSMutableDictionary *dic in alist_groupNameAndNum) {
        NSString *str_groupName=[dic valueForKey:@"group_name"];
        NSArray *arr=[expand_helper fn_filtered_criteriaData:str_groupName arr:alist_maintForm];
        if (arr!=nil && [arr count]!=0) {
            NSMutableArray *arr_copy=[[NSMutableArray alloc]initWithArray:arr];
            for (NSDictionary *dic_maintform in arr) {
                NSString *col_label=[dic_maintform valueForKey:@"col_label"];
                NSString *col_code=[dic_maintform valueForKey:@"col_code"];
                NSString *col_code_value=[idic_modified_value valueForKey:col_code];
                if ([col_label length]==0&&[col_code_value length]==0) {
                    [alist_maintForm removeObject:dic_maintform];
                    [arr_copy removeObject:dic_maintform];
                }
                col_label=nil;
                col_code=nil;
                col_code_value=nil;
            }
            [dic setObject:@(arr_copy.count) forKey:@"COUNT(group_name)"];
            [alist_filtered_data addObject:arr_copy];
            arr_copy=nil;
        }else{
            if ([str_groupName isEqualToString:MYLocalizedString(@"lbl_task", nil)]) {
                [alist_filtered_data addObject:alist_crmtask];
            }
            if ([str_groupName isEqualToString:MYLocalizedString(@"lbl_contact", nil)]) {
                [alist_filtered_data addObject:alist_contact];
            }
            if ([str_groupName isEqualToString:MYLocalizedString(@"lbl_opp", nil) ]) {
                [alist_filtered_data addObject:alist_crmopp];
            }
            if ([str_groupName isEqualToString:MYLocalizedString(@"lbl_hbl", nil) ]) {
                [alist_filtered_data addObject:alist_crmhbl];
            }
        }
    }
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
    NSString *str_groupName=[[alist_groupNameAndNum objectAtIndex:indexPath.section] valueForKey:@"group_name"];
    cell.backgroundColor=COLOR_LIGTH_GREEN;
    cell.textLabel.text=str_groupName;
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.expandable=YES;
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
    if ([col_stye isEqualToString:@"string"] || [col_stye isEqualToString:@"lookup"]) {
        static NSString *cellIdentifier=@"Cell_maintForm1";
        Cell_maintForm1 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.is_enable=is_enable_flag;
        cell.il_remind_label.text=col_label;
        cell.itv_data_textview.delegate=self;
        NSString *str_status=[idic_modified_value valueForKey:col_code];
        cell.itv_data_textview.text=str_status;
        if ([col_stye isEqualToString:@"lookup"]) {
            cell.itv_data_textview.text=[format fn_convert_display_status:str_status col_option:[dic valueForKey:@"col_option"]];
            [idic_lookup setObject:[dic valueForKey:@"col_option"] forKey:@"status"];
            [idic_lookup setObject:col_code forKey:@"key_parameter"];
        }
        
        CGFloat height=[format fn_heightWithString:cell.itv_data_textview.text font:[UIFont systemFontOfSize:15] constrainedToWidth:cell.itv_data_textview.contentSize.width-16];
        [cell.itv_data_textview setFrame:CGRectMake(cell.itv_data_textview.frame.origin.x, cell.itv_data_textview.frame.origin.y, cell.itv_data_textview.frame.size.width, height+16)];
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
   
    if (indexPath.section>flag_groupNum-1) {
        static NSString *cellIndentifier=@"Cell_browse_edit";
        Cell_browse *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!cell) {
            cell=[self.skstableView dequeueReusableCellWithIdentifier:@"Cell_browse_edit" forIndexPath:indexPath];
        }
        if ((indexPath.subRow-1)%2==0) {
            cell.backgroundColor=COLOR_LIGHT_GRAY;
        }else{
            cell.backgroundColor=COLOR_LIGHT_BLUE;
        }
        UIFont *font = [UIFont systemFontOfSize:15.0];
        cell.il_title.text=[dic valueForKey:@"title"];
        cell.il_title.font=font;
        cell.il_show_text.lineBreakMode=NSLineBreakByCharWrapping;
        cell.il_show_text.font=font;
        cell.il_show_text.text=[dic valueForKey:@"body"];
        CGFloat height=[format fn_heightWithString:cell.il_show_text.text font:font constrainedToWidth:cell.il_show_text.frame.size.width];
        [cell.il_show_text setFrame:CGRectMake(cell.il_show_text.frame.origin.x, cell.il_show_text.frame.origin.y, cell.il_show_text.frame.size.width, height)];
        if ([[[alist_groupNameAndNum objectAtIndex:indexPath.section]valueForKey:@"group_name"]isEqualToString:MYLocalizedString(@"lbl_hbl", nil)]==NO) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        return cell;
    }
    
    // Configure the cell...
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
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
    if ([groupName isEqualToString:MYLocalizedString(@"lbl_contact", nil)]) {
        [self performSegueWithIdentifier:@"segue_acct_contactEdit" sender:self];
        editContactVC.idic_parameter_contact=[alist_crmcontact_value objectAtIndex:selectRow];
        editContactVC.flag_can_edit=_flag_isDowload;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_update_browse) name:@"contact_update" object:nil];
    }
    if ([groupName isEqualToString:MYLocalizedString(@"lbl_task", nil)]) {
        [self performSegueWithIdentifier:@"segue_acct_taskEdit" sender:self];
        maintTaskVC.idic_parameter_value=[alist_crmtask_value objectAtIndex:indexPath.subRow-1];
        maintTaskVC.flag_can_edit=_flag_isDowload;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_update_browse) name:@"update" object:nil];
    }
    if ([groupName isEqualToString:MYLocalizedString(@"lbl_opp", nil)]) {
        [self performSegueWithIdentifier:@" segue_acct_oppEdit" sender:self];
        editOppVC.idic_parameter_opp=[alist_crmopp_value objectAtIndex:selectRow];
        editOppVC.flag_can_edit=_flag_isDowload;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_update_browse) name:@"crmopp_update" object:nil];
    }
}
#pragma mark 修改后，更新browse
-(void)fn_update_browse{
    [alist_filtered_data removeAllObjects];
    [self fn_init_arr_offline];
    [self.skstableView refreshData];
    [self.skstableView fn_expandall];
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

- (IBAction)fn_show_actionSheet:(id)sender {
    UIActionSheet *actionsheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:MYLocalizedString(@"lbl_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:MYLocalizedString(@"sheet_task", nil), nil];
    [actionsheet showFromRect:self.view.bounds inView:self.view animated:YES];
    // UIActionSheet *actionsheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:MYLocalizedString(@"lbl_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:MYLocalizedString(@"sheet_task", nil),MYLocalizedString(@"sheet_contact", nil),MYLocalizedString(@"sheet_opp", nil), nil];

}

@end

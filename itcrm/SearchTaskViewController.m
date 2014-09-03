//
//  SearchTaskViewController.m
//  itcrm
//
//  Created by itdept on 14-6-13.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "SearchTaskViewController.h"
#import "Cell_search.h"
#import "Cell_taskSearch.h"
#import "SKSTableViewCell.h"
#import "DB_searchCriteria.h"
#import "MZFormSheetController.h"
#import "Advance_SearchData.h"


#define TEXTFIELD_TAG 100
typedef NSMutableDictionary* (^passValue_task)(NSInteger tag);
@interface SearchTaskViewController ()
//获取task搜索标准数据
@property(nonatomic,strong)NSMutableArray *alist_searchCriteria;
//按组名过滤后的搜索标准数据
@property(nonatomic,strong)NSMutableArray *alist_filtered_data;
//存储task搜索标准的组名和该组的行数
@property(nonatomic,strong)NSMutableArray *alist_groupNameAndNum;
@property(nonatomic,strong)passValue_task pass_Value;
@property(nonatomic,strong)NSMutableArray *alist_searchData;
@property(nonatomic,strong)NSMutableDictionary *idic_value;
@property(nonatomic,strong)NSMutableDictionary *idic_parameter;
#pragma mark 存储必填项的col_code
@property(nonatomic,strong)NSMutableArray *alist_code;
@property(nonatomic,copy) NSString *select_date;
@property(nonatomic,strong) Custom_datePicker *datePicker;
@property(nonatomic,strong)NSDateFormatter *dateformatter;
@end

@implementation SearchTaskViewController
@synthesize alist_filtered_data;
@synthesize alist_groupNameAndNum;
@synthesize alist_searchCriteria;
@synthesize idic_value;
@synthesize idic_parameter;
@synthesize checkText;
@synthesize pass_Value;
@synthesize alist_searchData;
@synthesize alist_code;
@synthesize select_date;
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
    //设置表的代理
    self.skstableview.SKSTableViewDelegate=self;
    [self fn_init_arr];
    //loadview的时候，打开所有expandable
    [self.skstableview fn_expandall];
    self.skstableview.showsVerticalScrollIndicator=NO;
    [expand_helper setExtraCellLineHidden:self.skstableview];
    [self fn_custom_gesture];
    //避免键盘挡住UITextField
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
    _ibtn_clear.layer.cornerRadius=3;
    [self fn_create_datepickerview];
    [self fn_set_datetime_formatter];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_show_different_language{
    _i_navigationItem.title=MYLocalizedString(@"lbl_advance_title", nil);
    [_ibtn_clear setTitle:MYLocalizedString(@"lbl_clear", nil) forState:UIControlStateNormal];
    [_ibtn_search setTitle:MYLocalizedString(@"lbl_search", nil) forState:UIControlStateNormal];
}
-(void)fn_create_datepickerview{
    datePicker=[[Custom_datePicker alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    datePicker.delegate=self;
}
#pragma mark DatepickerDelegate
-(void)fn_Clicked_done:(NSString*)str{
    NSDate *date=[dateformatter dateFromString:str];
    NSTimeInterval timeInterval=[date timeIntervalSince1970];
    NSTimeInterval milliseconds=timeInterval*1000.0f;
    if (date!=nil) {
        select_date=[NSString stringWithFormat:@"%0.0lf",milliseconds];
    }else{
        select_date=@"";
    }
    
    [self.skstableview reloadData];
    
}
-(void)fn_Clicked_cancel{
    select_date=@"";
    [checkText resignFirstResponder];
}
#pragma mark 设置日期的格式
-(void)fn_set_datetime_formatter{
    dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateformatter setFormatterBehavior:NSDateFormatterBehaviorDefault];
    [dateformatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

#pragma mark UItextfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    checkText = textField;//设置被点击的对象
    NSDate *date=[NSDate date];
    [datePicker fn_get_current_datetime:date];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [checkText resignFirstResponder];
    return YES;
}
-(void)fn_init_arr{
    DB_searchCriteria *db=[[DB_searchCriteria alloc]init];
    alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmtask"];
    alist_searchCriteria=[db fn_get_srchType_data:@"crmtask"];
    alist_filtered_data=[[NSMutableArray alloc]initWithCapacity:1];
    idic_value=[[NSMutableDictionary alloc]initWithCapacity:1];
    idic_parameter=[[NSMutableDictionary alloc]initWithCapacity:1];
    alist_searchData=[[NSMutableArray alloc]initWithCapacity:1];
    alist_code=[[NSMutableArray alloc]initWithCapacity:1];
    for (NSMutableDictionary *dic in alist_groupNameAndNum) {
        NSString *str_name=[dic valueForKey:@"group_name"];
        NSArray *arr=[expand_helper fn_filtered_criteriaData:str_name arr:alist_searchCriteria];
        if (arr!=nil) {
            [alist_filtered_data addObject:arr];
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
    select_date=@"";
    [checkText resignFirstResponder];
}
#pragma mark - UITableViewDataSource

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
    SKSTableViewCell *cell =[self.skstableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    NSMutableDictionary *dic=alist_filtered_data[indexPath.section][indexPath.subRow-1];
    //显示的提示名称
    NSString *col_label=[dic valueForKey:@"col_label"];
    //col_stye 类型名
    NSString *col_stye=[dic valueForKey:@"col_type"];
    //是否为空
    NSString *is_mandatory=[dic valueForKey:@"is_mandatory"];
    //相关联的参数
    NSString *col_code=[dic valueForKey:@"col_code"];
    if ([is_mandatory isEqualToString:@"1"]) {
        col_label=[col_label stringByAppendingString:@"*"];
        [self fn_isExist:col_code];
    }
    __block SearchTaskViewController *blockSelf=self;
    pass_Value=^NSMutableDictionary*(NSInteger tag){
        return blockSelf->alist_filtered_data[indexPath.section][tag-TEXTFIELD_TAG-indexPath.section*100];
    };
    if ([col_stye isEqualToString:@"string"]||[col_stye isEqualToString:@"date"]) {
        static NSString *cellIdentifier=@"Cell_search";
        Cell_search *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[self.skstableview dequeueReusableCellWithIdentifier:@"Cell_search" forIndexPath:indexPath];
        }
        cell.il_prompt_label.text=col_label;
        cell.il_prompt_label.textColor=COLOR_DARK_JUNGLE_GREEN;
        cell.itf_searchData.delegate=self;
        cell.itf_searchData.tag=TEXTFIELD_TAG+indexPath.section*100+indexPath.subRow-1;
        NSString *str_value=[idic_value valueForKey:col_code];
        
        if ([col_stye isEqualToString:@"date"]) {
            cell.itf_searchData.inputView=datePicker;
            Format_conversion *convert=[[Format_conversion alloc]init];
            NSDate *date=[convert dateFromUnixTimestamp:str_value];
            if ([str_value length]!=0) {
                str_value=[dateformatter stringFromDate:date];
            }
        }else{
            cell.itf_searchData.inputView=nil;
        }
        cell.itf_searchData.text=str_value;
        return cell;
    }
       // Configure the cell...
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(void)fn_isExist:(NSString*)col_code{
    NSMutableArray *alist_code_copy=[NSMutableArray arrayWithArray:alist_code];
    for (NSString *str in alist_code_copy) {
        if ([str isEqualToString:col_code]) {
            [alist_code removeObject:str];
        }
    }
    [alist_code addObject:col_code];
}

#pragma mark advance search
- (IBAction)fn_search_task:(id)sender {
    BOOL isfill=YES;
    for (NSString *col_code in alist_code) {
        if ([[idic_value valueForKey:col_code]length]==0) {
            isfill=NO;
        }
    }
    if (isfill) {
        if (_callback_task) {
            _callback_task(alist_searchData);
        }
        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController* formSheet){}];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Items with * is required" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
}

- (IBAction)fn_go_back:(id)sender {
     [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController* formSheet){}];
}

- (IBAction)fn_textfield_endEdit:(id)sender {
    UITextField *textfield=(UITextField*)sender;
    NSMutableDictionary *dic=pass_Value(textfield.tag);
    NSString *col_code=[dic valueForKey:@"col_code"];
    NSString *col_type=[dic valueForKey:@"col_type"];
    [self fn_save_searchData:col_code text_value:textfield.text col_type:col_type];
}
-(void)fn_save_searchData:(NSString*)col_code text_value:(NSString*)text_value col_type:(NSString*)col_type{
    NSMutableArray *alist_searchData_copy=[NSMutableArray arrayWithArray:alist_searchData];
    for (Advance_SearchData *searchData in alist_searchData_copy) {
        if ([searchData.is_parameter isEqualToString:col_code]) {
            [alist_searchData removeObject:searchData];
        }
    }
    if (text_value!=0 && [col_type isEqualToString:@"date"]==NO) {
        [idic_value setObject:text_value forKey:col_code];
    }else if([select_date length]==0){
        return;
    }else{
        [idic_value setObject:select_date forKey:col_code];
    }
    [idic_parameter setObject:col_code forKey:col_code];
    [alist_searchData addObject:[expand_helper fn_get_searchData:col_code idic_value:idic_value idic_parameter:idic_parameter]];
}

- (IBAction)fn_clear_input_data:(id)sender {
    [idic_value removeAllObjects];
    [alist_searchData removeAllObjects];
    [self.skstableview reloadData];
}
@end

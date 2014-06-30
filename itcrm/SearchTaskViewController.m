//
//  SearchTaskViewController.m
//  itcrm
//
//  Created by itdept on 14-6-13.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "SearchTaskViewController.h"
#import "Cell_search.h"
#import "Custom_Color.h"
#import "Cell_taskSearch.h"
#import "SKSTableViewCell.h"
#import "DB_searchCriteria.h"
#import "PopViewManager.h"
#import "MZFormSheetController.h"
#import "Advance_SearchData.h"

@interface SearchTaskViewController ()

@end

@implementation SearchTaskViewController
@synthesize alist_filtered_data;
@synthesize alist_groupNameAndNum;
@synthesize alist_searchCriteria;
@synthesize idic_value;
@synthesize idic_parameter;
@synthesize checkText;
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
    //设置表的代理
    self.skstableview.SKSTableViewDelegate=self;
    [self fn_init_arr];
    //loadview的时候，打开所有expandable
    [self.skstableview fn_expandall];
    self.skstableview.backgroundColor=COLOR_LIGHT_YELLOW;
    self.view.backgroundColor=COLOR_LIGHT_YELLOW;
    [_inav_navigationbar setBarTintColor:COLOR_LIGHT_YELLOW];
    [self setExtraCellLineHidden:self.skstableview];
    [self fn_custom_gesture];
    //避免键盘挡住UITextField
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UItextfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    checkText = textField;//设置被点击的对象
}

-(void)fn_init_arr{
    DB_searchCriteria *db=[[DB_searchCriteria alloc]init];
    alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmtask"];
    alist_searchCriteria=[db fn_get_srchType_data:@"crmtask"];
    alist_filtered_data=[[NSMutableArray alloc]initWithCapacity:10];
    idic_value=[[NSMutableDictionary alloc]initWithCapacity:10];
    idic_parameter=[[NSMutableDictionary alloc]initWithCapacity:10];
}
#pragma mark 将额外的cell的线隐藏
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
    
    SKSTableViewCell *cell = [self.skstableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.backgroundColor=COLOR_LIGTH_GREEN;
    cell.textLabel.text=[[alist_groupNameAndNum objectAtIndex:indexPath.section]valueForKey:@"group_name"];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.expandable=YES;
    
    NSString *str=[[alist_groupNameAndNum objectAtIndex:indexPath.section] valueForKey:@"group_name"];
    NSArray *arr=[self fn_filtered_criteriaData:str];
    if (arr!=nil) {
        [alist_filtered_data addObject:arr];
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
    //是否为空
    NSString *is_mandatory=[dic valueForKey:@"is_mandatory"];
    //相关联的参数
    NSString *col_code=[dic valueForKey:@"col_code"];
    if ([is_mandatory isEqualToString:@"1"]) {
        col_label=[col_label stringByAppendingString:@"*"];
    }
    
    if ([col_stye isEqualToString:@"string"]) {
        static NSString *cellIdentifier=@"Cell_search";
        Cell_search *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_search alloc]init];
        }
        cell.il_prompt_label.text=col_label;
        cell.il_prompt_label.textColor=COLOR_DARK_JUNGLE_GREEN;
        cell.backgroundColor=COLOR_LIGHT_YELLOW;
        cell.itf_searchData.delegate=self;
        if ([col_code isEqualToString:@"task_title"]) {
            cell.itf_searchData.tag=100;
            cell.itf_searchData.text=[idic_value valueForKey:@"title_value"];
            [idic_parameter setObject:col_code forKey:@"task_title"];
        }
        if ([col_label isEqualToString:@"Task Description"]) {
            cell.itf_searchData.tag=101;
            cell.itf_searchData.text=[idic_value valueForKey:@"desc_value"];
            [idic_parameter setObject:col_code forKey:@"task_desc"];
        }
        
        return cell;
    }
    if ([col_stye isEqualToString:@"datetimerange"]) {
        static NSString *cellIndetifier=@"Cell_taskSearch";
        Cell_taskSearch *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIndetifier];
        if (cell==nil) {
            cell=[[Cell_taskSearch alloc]init];
        }
        cell.itf_input_endDate.delegate=self;
        cell.itf_input_startDate.delegate=self;
        cell.il_prompt_label.textColor=COLOR_DARK_JUNGLE_GREEN;
        cell.backgroundColor=COLOR_LIGHT_YELLOW;
        cell.il_prompt_label.text=col_label;
        NSArray *arr=[col_code componentsSeparatedByString:@","];
        if ([[arr objectAtIndex:0] isEqualToString:@"task_start_date"]) {
            cell.itf_input_startDate.text=[idic_value valueForKey:@"start_date_value"];
            [idic_parameter setObject:[arr objectAtIndex:0] forKey:@"task_start_date"];
        }
        if ([[arr objectAtIndex:1] isEqualToString:@"task_end_date"]) {
            cell.itf_input_endDate.text=[idic_value valueForKey:@"end_date_value"];
            [idic_parameter setObject:[arr objectAtIndex:1] forKey:@"task_end_date"];
        }        return cell;
    }
       // Configure the cell...
    return nil;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

#pragma mark 对数组进行过滤
-(NSArray*)fn_filtered_criteriaData:(NSString*)key{
    NSArray *filtered=[alist_searchCriteria filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(group_name==%@)",key]];
    return filtered;
}
#pragma mark advance search
- (IBAction)fn_search_task:(id)sender {
    NSMutableArray *alist_searchData=[[NSMutableArray alloc]initWithCapacity:10];
    [alist_searchData addObject:[self fn_get_searchData:@"title_value" :@"task_title"]];
    [alist_searchData addObject:[self fn_get_searchData:@"desc_value" :@"task_desc"]];
    [alist_searchData addObject:[self fn_get_searchData:@"start_date_value" :@"task_start_date"]];
    [alist_searchData addObject:[self fn_get_searchData:@"end_date_value" :@"task_end_date"]];
    if ([[idic_value valueForKey:@"title_value"]length]!=0) {
        if (_callback_task) {
            _callback_task(alist_searchData);
        }
        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController* formSheet){}];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Items with * is required" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
}
-(Advance_SearchData*)fn_get_searchData:(NSString*)value_key :(NSString*)parameter_key{
    Advance_SearchData *searchData=[[Advance_SearchData alloc]init];
    if ([[idic_value valueForKey:value_key] length]!=0) {
        searchData.is_searchValue=[idic_value valueForKey:value_key];
        searchData.is_parameter=[idic_parameter valueForKey:parameter_key];
    }
    return searchData;
}

- (IBAction)fn_go_back:(id)sender {
     [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController* formSheet){}];
}

- (IBAction)fn_textfield_endEdit:(id)sender {
    UITextField *textfield=(UITextField*)sender;
    if (textfield.tag==100) {
        [idic_value setObject:textfield.text forKey:@"title_value"];
    }
    if (textfield.tag==101) {
        [idic_value setObject:textfield.text forKey:@"desc_value"];
    }
}

- (IBAction)fn_startDate_endEdit:(id)sender {
    UITextField *textfield=(UITextField*)sender;
    [idic_value setObject:textfield.text forKey:@"start_date_value"];
}

- (IBAction)fn_endDate_endEdit:(id)sender {
    UITextField *textfield=(UITextField*)sender;
    [idic_value setObject:textfield.text forKey:@"end_date_value"];
    
}

- (IBAction)fn_clear_input_data:(id)sender {
    idic_value=nil;
    idic_value=[[NSMutableDictionary alloc]init];
    [self.skstableview reloadData];
}
@end

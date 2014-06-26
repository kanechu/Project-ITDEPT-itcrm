//
//  MaintFormViewController.m
//  itcrm
//
//  Created by itdept on 14-6-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "MaintFormViewController.h"
#import "DB_MaintForm.h"
#import "SKSTableViewCell.h"
#import "Cell_maintForm1.h"
#import "Cell_maintForm2.h"
#import "Custom_Color.h"

@interface MaintFormViewController ()

@end

@implementation MaintFormViewController
@synthesize alist_filtered_data;
@synthesize alist_groupNameAndNum;
@synthesize alist_maintForm;
@synthesize idic_modified_value;
@synthesize format;
@synthesize checkTextView;

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
    [self fn_init_arr];
    //设置表的代理
    self.skstableView.SKSTableViewDelegate=self;
    //loadview的时候，打开第一个expandable
    [self.skstableView fn_expandall];
    //避免键盘挡住UITextView
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
    [self fn_custom_gesture];
    format=[[Format_conversion alloc]init];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    DB_MaintForm *db=[[DB_MaintForm alloc]init];
    alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmacct"];
    alist_maintForm=[db fn_get_MaintForm_data:@"crmacct"];
    alist_filtered_data=[[NSMutableArray alloc]initWithCapacity:10];
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
    //col_code 类型名
    NSString *col_code=[dic valueForKey:@"col_code"];
    NSString *is_enable=[dic valueForKey:@"is_enable"];
    if ([col_stye isEqualToString:@"string"] || [col_stye isEqualToString:@"date"]) {
        static NSString *cellIdentifier=@"Cell_maintForm1";
        Cell_maintForm1 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_maintForm1 alloc]init];
        }
        cell.il_remind_label.text=col_label;
        cell.itv_data_textview.text=[idic_modified_value valueForKey:col_code];
        CGFloat height=[format fn_heightWithString:cell.itv_data_textview.text font:[UIFont systemFontOfSize:15] constrainedToWidth:cell.itv_data_textview.contentSize.width-16];
        [cell.itv_data_textview setFrame:CGRectMake(cell.itv_data_textview.frame.origin.x, cell.itv_data_textview.frame.origin.y, cell.itv_data_textview.frame.size.width, height+16)];
        cell.itv_data_textview.delegate=self;
        cell.itv_data_textview.layer.cornerRadius=5;
        return cell;
    }
    if ([col_stye isEqualToString:@"checkbox"] ||[col_stye isEqualToString:@"lookup"]) {
        static NSString *cellIdentifier=@"Cell_maintForm2";
        Cell_maintForm2 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_maintForm2 alloc]init];
        }
        cell.il_remind_label.text=col_label;
        if ([is_enable isEqualToString:@"1"]) {
        
            [cell.ibt_select setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        }else{
            [cell.ibt_select setImage:[UIImage imageNamed:@"uncheckbox"] forState:UIControlStateNormal];
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
    static NSString *cellIdentifier=@"Cell_maintForm1";
    Cell_maintForm1 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //提取每行的数据
    NSMutableDictionary *dic=alist_filtered_data[indexPath.section][indexPath.subRow-1];
    //col_code 类型名
    NSString *col_code=[dic valueForKey:@"col_code"];
    NSString *str=[idic_modified_value valueForKey:col_code];
    CGFloat height=[format fn_heightWithString:str font:[UIFont systemFontOfSize:15] constrainedToWidth:cell.itv_data_textview.contentSize.width-16];
    return height+16+10;
}
#pragma mark 对数组进行过滤
-(NSArray*)fn_filtered_criteriaData:(NSString*)key{
    NSArray *filtered=[alist_maintForm filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(group_name==%@)",key]];
    return filtered;
}

- (IBAction)fn_save_modified_data:(id)sender {
}
@end

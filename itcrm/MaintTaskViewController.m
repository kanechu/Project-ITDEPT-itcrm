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
#import "Cell_lookup.h"
#import "Custom_Color.h"
#import "OptionViewController.h"

@interface MaintTaskViewController ()
@property(nonatomic,strong)NSMutableDictionary *idic_lookup_type;
@end
enum LOOKUP_TAG {
    TAG = 1,
    TAG1 = 2
};
@implementation MaintTaskViewController
@synthesize alist_groupNameAndNum;
@synthesize alist_filtered_taskdata;
@synthesize alist_miantTask;
@synthesize checkTextView;
@synthesize idic_parameter_value;
@synthesize format;
@synthesize idic_lookup_type;
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
    self.skstableview.SKSTableViewDelegate=self;
    self.skstableview.backgroundColor=COLOR_LIGHT_YELLOW1;
    [self fn_init_arr];
    [self.skstableview fn_expandall];
    [self setExtraCellLineHidden:self.skstableview];
    [self fn_custom_gesture];
    format=[[Format_conversion alloc]init];
    //避免键盘挡住UITextView
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    checkTextView=textView;
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

#pragma mark 将额外的cell的线隐藏
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
#pragma mark -初始化数组
-(void)fn_init_arr{
    DB_MaintForm *db=[[DB_MaintForm alloc]init];
    alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmtask"];
    alist_miantTask=[db fn_get_MaintForm_data:@"crmtask"];
    alist_filtered_taskdata=[[NSMutableArray alloc]initWithCapacity:10];
    idic_lookup_type=[[NSMutableDictionary alloc]initWithCapacity:10];
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
    cell.textLabel.text=[[alist_groupNameAndNum objectAtIndex:indexPath.section]valueForKey:@"group_name"];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.expandable=YES;
    
    NSString *str=[[alist_groupNameAndNum objectAtIndex:indexPath.section] valueForKey:@"group_name"];
    NSArray *arr=[self fn_filtered_criteriaData:str];
    if (arr!=nil) {
        [alist_filtered_taskdata addObject:arr];
    }
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
    NSString *col_stye=[dic valueForKey:@"col_type"];
    if ([col_stye isEqualToString:@"string"] || [col_stye isEqualToString:@"date"]) {
        static NSString *cellIdentifier=@"Cell_maintForm11";
        Cell_maintForm1 *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_maintForm1 alloc]init];
        }
        cell.il_remind_label.text=col_label;
        cell.backgroundColor=COLOR_LIGHT_YELLOW1;
        cell.itv_data_textview.delegate=self;
        cell.itv_data_textview.text=[idic_parameter_value valueForKey:col_code];
        //UITextView 上下左右有8px
        CGFloat height=[format fn_heightWithString:cell.itv_data_textview.text font:[UIFont systemFontOfSize:15] constrainedToWidth:cell.itv_data_textview.contentSize.width-16];
         [cell.itv_data_textview setFrame:CGRectMake(cell.itv_data_textview.frame.origin.x, cell.itv_data_textview.frame.origin.y, cell.itv_data_textview.frame.size.width, height+16)];
        cell.itv_data_textview.layer.cornerRadius=5;
        return cell;
    }
    if ([col_stye isEqualToString:@"lookup"]) {
        static NSString *cellIdentifier=@"Cell_lookup1";
        Cell_lookup *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_lookup alloc]init];
        }
        cell.il_remind_label.text=col_label;
        cell.itv_edit_textview.text=[idic_parameter_value valueForKey:col_code];
        cell.itv_edit_textview.layer.cornerRadius=5;
        cell.itv_edit_textview.delegate=self;
        if ([col_code isEqualToString:@"task_status"]) {
            cell.ibtn_lookup.tag=TAG;
            [idic_lookup_type setObject:[dic valueForKey:@"col_option"] forKey:@"status"];
        }
        if ([col_code isEqualToString:@"task_type"]) {
            cell.ibtn_lookup.tag=TAG1;
            [idic_lookup_type setObject:[dic valueForKey:@"col_option"] forKey:@"type"];
        }
        cell.backgroundColor=COLOR_LIGHT_YELLOW1;
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
   
    return height+16+10;
}

#pragma mark 对数组进行过滤
-(NSArray*)fn_filtered_criteriaData:(NSString*)key{
    NSArray *filtered=[alist_miantTask filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(group_name==%@)",key]];
    return filtered;
}




- (IBAction)fn_lookup_data:(id)sender {
    UIButton *btn=(UIButton*)sender;
    if (btn.tag==TAG) {
        NSString *str_type=[idic_lookup_type valueForKey:@"status"];
        [self fn_pop_lookup_View:str_type key_flag:@"status" lookup_title:@"select the task_status"];
    }
    if (btn.tag==TAG1) {
       NSString *str_type=[idic_lookup_type valueForKey:@"type"];
        [self fn_pop_lookup_View:str_type key_flag:@"type" lookup_title:@"select the task_type"];
    }
}
-(void)fn_pop_lookup_View:(NSString*)is_type key_flag:(NSString*)key lookup_title:(NSString*)title{
    OptionViewController *VC=(OptionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
    VC.lookup_title=title;
    VC.lookup_type=is_type;
    VC.callback=^(NSMutableDictionary *dic){
        if ([key isEqualToString:@"country"]) {
           
        }
        if ([key isEqualToString:@"region"]) {
           
        }
        
        [self.skstableview reloadData];
        
    };
    PopViewManager *pop=[[PopViewManager alloc]init];
    [pop PopupView:VC Size:CGSizeMake(250,300) uponView:self];
}
@end

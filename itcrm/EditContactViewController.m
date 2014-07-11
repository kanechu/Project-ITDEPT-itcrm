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
#import "Custom_Color.h"
#import "DB_crmcontact_browse.h"
#import "Format_conversion.h"

enum TEXT_TAG {
    TEXT_TAG = 100
};
@interface EditContactViewController ()
@property(nonatomic,strong)NSMutableDictionary *idic_parameter_contact;
@property(nonatomic,strong)NSMutableArray *alist_maintContact;
//过滤后的数组
@property (nonatomic,strong)NSMutableArray *alist_filtered_taskdata;
@property (nonatomic,strong)NSMutableArray *alist_groupNameAndNum;
@property (nonatomic,strong)UITextView *checkTextView;
@property (nonatomic,strong)Format_conversion *convert;
@end

@implementation EditContactViewController
@synthesize alist_filtered_taskdata;
@synthesize alist_groupNameAndNum;
@synthesize alist_maintContact;
@synthesize checkTextView;
@synthesize idic_parameter_contact;
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
    [self setExtraCellLineHidden:self.skstableView];
    _convert=[[Format_conversion alloc]init];
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
}
#pragma mark -获取定制contact maint版面的数据
-(void)fn_get_maint_crmcontact{
    DB_MaintForm *db=[[DB_MaintForm alloc]init];
    alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmcontact"];
    alist_maintContact=[db fn_get_MaintForm_data:@"crmcontact"];
    alist_filtered_taskdata=[[NSMutableArray alloc]initWithCapacity:10];
    
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
    
    NSArray *arr=[self fn_filtered_criteriaData:str_name];
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
    //blockSelf是本地变量，是弱引用，_block被retain的时候，并不会增加retain count
   /* __block MaintTaskViewController *blockSelf=self;
    _pass_value=^NSString*(NSInteger tag){
        return [blockSelf-> alist_filtered_taskdata [indexPath.section][tag-TEXT_TAG-indexPath.section*100] valueForKey:@"col_code"];
    };*/
    if ([col_stye isEqualToString:@"string"]) {
        static NSString *cellIdentifier=@"Cell_maintForm1_contact";
        Cell_maintForm1 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_maintForm1 alloc]init];
        }
        cell.il_remind_label.text=col_label;
        cell.itv_data_textview.delegate=self;
        cell.itv_data_textview.tag=TEXT_TAG+indexPath.section*100+indexPath.subRow-1;
        NSString *text_value=[idic_parameter_contact valueForKey:col_code];
        cell.itv_data_textview.text=text_value;
        //UITextView 上下左右有8px
        CGFloat height=[_convert fn_heightWithString:cell.itv_data_textview.text font:[UIFont systemFontOfSize:15] constrainedToWidth:cell.itv_data_textview.contentSize.width-16];
        [cell.itv_data_textview setFrame:CGRectMake(cell.itv_data_textview.frame.origin.x, cell.itv_data_textview.frame.origin.y, cell.itv_data_textview.frame.size.width, height+16)];
        cell.itv_data_textview.layer.cornerRadius=5;
        return cell;
    }
    if ([col_stye isEqualToString:@"local_lookup"]) {
        static NSString *cellIdentifier=@"Cell_lookup_contact";
        Cell_lookup *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_lookup alloc]init];
        }
        cell.il_remind_label.text=col_label;
        NSString *str_status=[idic_parameter_contact valueForKey:col_code];
        cell.itv_edit_textview.text=[_convert fn_convert_display_status:str_status col_option:[dic valueForKey:@"col_option"]];
        cell.itv_edit_textview.tag=TEXT_TAG+indexPath.section*100+indexPath.subRow-1;
        cell.itv_edit_textview.layer.cornerRadius=5;
        cell.itv_edit_textview.delegate=self;
       /* if ([col_code isEqualToString:@"task_status"]) {
            cell.ibtn_lookup.tag=TAG;
            [idic_lookup_type setObject:[dic valueForKey:@"col_option"] forKey:@"status"];
        }
        if ([col_code isEqualToString:@"task_type"]) {
            cell.ibtn_lookup.tag=TAG1;
            [idic_lookup_type setObject:[dic valueForKey:@"col_option"] forKey:@"type"];
        }*/
        return cell;
    }
    
    
    // Configure the cell...
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}


#pragma mark 对数组进行过滤
-(NSArray*)fn_filtered_criteriaData:(NSString*)key{
    NSArray *filtered=[alist_maintContact filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(group_name==%@)",key]];
    return filtered;
}
- (IBAction)fn_save_modified_contact:(id)sender {
}
@end
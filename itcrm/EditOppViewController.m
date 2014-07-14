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
#import "Custom_Color.h"
#import "Cell_maintForm1.h"
#import "DB_crmopp_browse.h"
#import "Format_conversion.h"
enum TEXT_TAG{
    TEXT_TAG=100
};

@interface EditOppViewController ()
@property(nonatomic,strong)NSMutableArray *alist_maintOpp;
@property (nonatomic,strong)NSMutableArray *alist_filtered_oppdata;
@property (nonatomic,strong)NSMutableArray *alist_groupNameAndNum;
@property (nonatomic,strong)NSMutableDictionary *idic_parameter_opp;
@property (nonatomic,strong)Format_conversion *convert;
@end

@implementation EditOppViewController
@synthesize opp_id;
@synthesize alist_filtered_oppdata;
@synthesize alist_groupNameAndNum;
@synthesize alist_maintOpp;
@synthesize idic_parameter_opp;
@synthesize convert;
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
    [self fn_get_idic_parameter];
    self.skstableView.SKSTableViewDelegate=self;
    [expand_helper setExtraCellLineHidden:self.skstableView];
    [self.skstableView fn_expandall];
    convert=[[Format_conversion alloc]init];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -获取要修改的opp数据
-(void)fn_get_idic_parameter{
    DB_crmopp_browse *db=[[DB_crmopp_browse alloc]init];
    NSMutableArray *arr_crmcontact=[db fn_get_crmopp_with_id:opp_id];
    if ([arr_crmcontact count]!=0) {
        idic_parameter_opp=[arr_crmcontact objectAtIndex:0];
    }
}
#pragma mark -获取定制opp maint版面的数据
-(void)fn_get_maint_crmopp{
    DB_MaintForm *db=[[DB_MaintForm alloc]init];
    alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmopp"];
    alist_maintOpp=[db fn_get_MaintForm_data:@"crmopp"];
    alist_filtered_oppdata=[[NSMutableArray alloc]initWithCapacity:10];
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
    NSArray *arr=[expand_helper fn_filtered_criteriaData:str_name arr:alist_maintOpp];
    if (arr!=nil) {
        [alist_filtered_oppdata addObject:arr];
    }
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
    //col_opption
    NSString *col_option=[dic valueForKey:@"col_option"];
    //blockSelf是本地变量，是弱引用，_block被retain的时候，并不会增加retain count
    /* __block MaintTaskViewController *blockSelf=self;
     _pass_value=^NSString*(NSInteger tag){
     return [blockSelf-> alist_filtered_taskdata [indexPath.section][tag-TEXT_TAG-indexPath.section*100] valueForKey:@"col_code"];
     };*/
        static NSString *cellIdentifier=@"Cell_maintForm1_opp";
        Cell_maintForm1 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_maintForm1 alloc]init];
        }
    cell.il_remind_label.text=col_label;
    cell.itv_data_textview.delegate=self;
    cell.itv_data_textview.tag=TEXT_TAG+indexPath.section*100+indexPath.subRow-1;
    NSString *text_value=[idic_parameter_opp valueForKey:col_code];
    NSString *text_display=[convert fn_convert_display_status:text_value col_option:col_option];
    cell.itv_data_textview.text=text_display;
    //UITextView 上下左右有8px
    CGFloat height=[convert fn_heightWithString:cell.itv_data_textview.text font:[UIFont systemFontOfSize:15] constrainedToWidth:cell.itv_data_textview.contentSize.width-16];
        [cell.itv_data_textview setFrame:CGRectMake(cell.itv_data_textview.frame.origin.x, cell.itv_data_textview.frame.origin.y, cell.itv_data_textview.frame.size.width, height+16)];
        cell.itv_data_textview.layer.cornerRadius=5;
        return cell;
   
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"Cell_maintForm1_opp";
    Cell_maintForm1 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //提取每行的数据
    NSMutableDictionary *dic=alist_filtered_oppdata[indexPath.section][indexPath.subRow-1];
    NSString *col_code=[dic valueForKey:@"col_code"];
    NSString *col_option=[dic valueForKey:@"col_option"];
    NSString *text_value=[idic_parameter_opp valueForKey:col_code];
    NSString *text_display=[convert fn_convert_display_status:text_value col_option:col_option];
    CGFloat height=[convert fn_heightWithString:text_display font:cell.itv_data_textview.font constrainedToWidth:cell.itv_data_textview.contentSize.width-16];
    height=height+16+10;
    if (height<44) {
        height=44;
    }
    return height;
}
#pragma mark UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    
}
- (IBAction)fn_save_modified_data:(id)sender {
}
@end

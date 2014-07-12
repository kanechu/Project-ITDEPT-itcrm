//
//  SearchCrmOppViewController.m
//  itcrm
//
//  Created by itdept on 14-7-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "SearchCrmOppViewController.h"
#import "MZFormSheetController.h"
#import "SKSTableViewCell.h"
#import "Cell_opp_search.h"
#import "Custom_Color.h"
#import "DB_searchCriteria.h"
enum IBTN_TAG{
    IBTN_TAG=100
};
@interface SearchCrmOppViewController ()
@property(nonatomic,strong)NSMutableArray *alist_filtered_data;
@property(nonatomic,strong)NSMutableArray * alist_groupNameAndNum;
@property(nonatomic,strong)NSMutableArray * alist_searchCriteria;
@end

@implementation SearchCrmOppViewController
@synthesize alist_filtered_data;
@synthesize alist_groupNameAndNum;
@synthesize alist_searchCriteria;

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
   // [self fn_custom_gesture];
    self.skstableView.SKSTableViewDelegate=self;
    [self setExtraCellLineHidden:self.skstableView];
    [self.skstableView fn_expandall];
    [_inav_bar setBarTintColor:COLOR_LIGHT_YELLOW];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_init_arr{
    DB_searchCriteria *db=[[DB_searchCriteria alloc]init];
    alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmopp"];
    alist_searchCriteria=[db fn_get_srchType_data:@"crmopp"];
    alist_filtered_data=[[NSMutableArray alloc]initWithCapacity:10];
}

#pragma mark 将额外的cell的线隐藏
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
#pragma mark SKSTableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [alist_groupNameAndNum count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath{
    NSString *numOfrows=[[alist_groupNameAndNum objectAtIndex:indexPath.section]valueForKey:@"COUNT(group_name)"];
    return [numOfrows integerValue];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [self.skstableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.backgroundColor=COLOR_LIGTH_GREEN;
    NSString *str_name=[[alist_groupNameAndNum objectAtIndex:indexPath.section] valueForKey:@"group_name"];
    cell.textLabel.text=str_name;
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.expandable=YES;
    NSArray *arr=[self fn_filtered_criteriaData:str_name];
    if (arr!=nil) {
        [alist_filtered_data addObject:arr];
    }
    return cell;
}
-(UITableViewCell*)tableView:(SKSTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    //提取每行的数据
    NSMutableDictionary *dic=alist_filtered_data[indexPath.section][indexPath.subRow-1];
    //显示的提示名称
    NSString *col_label=[dic valueForKey:@"col_label"];
    //是否为必填项
    NSString *is_mandatory=[dic valueForKey:@"is_mandatory"];
    //相关联的参数
    NSString *col_code=[dic valueForKey:@"col_code"];
    if ([is_mandatory isEqualToString:@"1"]) {
        col_label=[col_label stringByAppendingString:@"*"];
    }
    static NSString *cellIndentifier=@"Cell_opp_search";
    Cell_opp_search *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell==nil) {
        cell=[[Cell_opp_search alloc]init];
    }
    cell.il_remind_label.text=col_label;
    cell.il_remind_label.textColor=COLOR_DARK_JUNGLE_GREEN;
    cell.ibtn_lookup_label.tag=IBTN_TAG+indexPath.section*100+indexPath.subRow-1;
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
#pragma mark 对数组进行过滤
-(NSArray*)fn_filtered_criteriaData:(NSString*)key{
    NSArray *filtered=[alist_searchCriteria filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(group_name==%@)",key]];
    return filtered;
}
- (IBAction)fn_go_back:(id)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *FormSheet){}];
}

- (IBAction)fn_search_opp:(id)sender {
    
     [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *FormSheet){}];
}

- (IBAction)fn_lookup_opp:(id)sender {
    Custom_Button *ibtn=(Custom_Button*)sender;
    NSLog(@"%d",ibtn.tag);
}
@end

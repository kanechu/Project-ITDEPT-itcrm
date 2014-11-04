//
//  SearchCrmOppViewController.m
//  itcrm
//
//  Created by itdept on 14-7-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "SearchCrmOppViewController.h"
#import "SKSTableViewCell.h"
#import "Cell_opp_search.h"
#import "DB_searchCriteria.h"
#import "RegionViewController.h"
#import "Advance_SearchData.h"

enum IBTN_TAG{
    IBTN_TAG=100
};
typedef NSMutableDictionary* (^opp_passValue)(NSInteger tag);
@interface SearchCrmOppViewController ()
@property(nonatomic,strong)NSMutableArray *alist_filtered_data;
@property(nonatomic,strong)NSMutableArray * alist_groupNameAndNum;
@property(nonatomic,strong)NSMutableArray * alist_searchCriteria;
@property(nonatomic,strong)NSMutableDictionary *idic_opp_parameter;
@property(nonatomic,strong)NSMutableDictionary *idic_opp_value;
@property(nonatomic,strong)opp_passValue pass_value;
@property(nonatomic,strong)NSMutableArray *alist_searchData;
@end

@implementation SearchCrmOppViewController
@synthesize alist_filtered_data;
@synthesize alist_groupNameAndNum;
@synthesize alist_searchCriteria;
@synthesize idic_opp_parameter;
@synthesize idic_opp_value;
@synthesize pass_value;
@synthesize alist_searchData;
@synthesize callBack;

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
    self.skstableView.SKSTableViewDelegate=self;
    //将额外的cell的线隐藏
    [expand_helper setExtraCellLineHidden:self.skstableView];
    [self.skstableView fn_expandall];
    /**
     *  隐藏表格的滚动条
     */
    self.skstableView.showsVerticalScrollIndicator=NO;
    [self fn_show_different_language];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fn_show_different_language{
    [_ibtn_search setTitle:MYLocalizedString(@"lbl_search", nil) forState:UIControlStateNormal];
    _i_navigationItem.title=MYLocalizedString(@"lbl_advance_title", nil);
}
-(void)fn_init_arr{
    DB_searchCriteria *db=[[DB_searchCriteria alloc]init];
    alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmopp"];
    alist_searchCriteria=[db fn_get_srchType_data:@"crmopp"];
    idic_opp_parameter=[[NSMutableDictionary alloc]initWithCapacity:10];
    idic_opp_value=[[NSMutableDictionary alloc]initWithCapacity:10];
    alist_searchData=[[NSMutableArray alloc]init];
    alist_filtered_data=[[NSMutableArray alloc]initWithCapacity:10];
    for (NSMutableDictionary *dic in alist_groupNameAndNum) {
        NSString *str_name=[dic valueForKey:@"group_name"];
        NSArray *arr=[expand_helper fn_filtered_criteriaData:str_name arr:alist_searchCriteria];
        if (arr!=nil) {
            [alist_filtered_data addObject:arr];
        }
    }
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
    return cell;
}
-(UITableViewCell*)tableView:(SKSTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    //提取每行的数据
    NSMutableDictionary *dic=alist_filtered_data[indexPath.section][indexPath.subRow-1];
    //显示的提示名称
    NSString *col_label=[dic valueForKey:@"col_label"];
    //是否为必填项
    NSString *is_mandatory=[dic valueForKey:@"is_mandatory"];
    NSString *col_code=[dic valueForKey:@"col_code"];
    NSString *col_option=[dic valueForKey:@"col_option"];
    //blockSelf是本地变量，是弱引用，_block被retain的时候，并不会增加retain count
    __block SearchCrmOppViewController *blockSelf=self;
    pass_value=^NSMutableDictionary*(NSInteger tag){
        return blockSelf-> alist_filtered_data [tag/100-1][tag-IBTN_TAG-(tag/100-1)*100];
    };
    
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
    Format_conversion *convert=[[Format_conversion alloc]init];
    NSString *str_data=[idic_opp_value valueForKey:col_code];
    NSString *str_display=[convert fn_convert_display_status:str_data col_option:col_option];
    cell.ibtn_lookup_label.label.text=str_display;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (IBAction)fn_go_back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)fn_search_opp:(id)sender {
    if (callBack) {
        callBack(alist_searchData);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)fn_lookup_opp:(id)sender {
    Custom_Button *ibtn=(Custom_Button*)sender;
    NSMutableDictionary *idic=pass_value(ibtn.tag);
    NSString *col_code=[idic valueForKey:@"col_code"];
    NSString *col_option=[idic valueForKey:@"col_option"];
    NSString *str_placeholder=[NSString stringWithFormat:@"please input %@",col_code];
    [self fn_pop_regionView:str_placeholder type:col_option key_flag:col_code];
}
-(void)fn_pop_regionView:(NSString*)placeholder type:(NSString*)is_type key_flag:(NSString*)key{
    RegionViewController *VC=(RegionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"RegionViewController"];
    VC.is_placeholder=placeholder;
    VC.type=is_type;
    VC.callback_region=^(NSMutableDictionary *dic){
        NSMutableArray *alist_searchData_copy=[NSMutableArray arrayWithArray:alist_searchData];
        for (Advance_SearchData *searchData in alist_searchData_copy) {
            if ([searchData.is_parameter isEqualToString:key]) {
                [alist_searchData removeObject:searchData];
            }
        }
        NSString *str_data=[dic valueForKey:@"data"];
        [idic_opp_parameter setObject:key forKey:key];
        [idic_opp_value setObject:str_data forKey:key];
        
        [alist_searchData addObject:[expand_helper fn_get_searchData:key idic_value:idic_opp_value idic_parameter:idic_opp_parameter]];
        [self.skstableView reloadData];
        
    };
    PopViewManager *pop=[[PopViewManager alloc]init];
    [pop PopupView:VC Size:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) uponView:self];
}
@end

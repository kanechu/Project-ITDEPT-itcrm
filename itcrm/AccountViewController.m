//
//  AccountViewController.m
//  itcrm
//
//  Created by itdept on 14-5-31.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "AccountViewController.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "Cell_search.h"
#import "Cell_search1.h"
#import "DB_searchCriteria.h"
@interface AccountViewController ()

@end

@implementation AccountViewController

@synthesize alist_groupNameAndNum;
@synthesize alist_searchCriteria;
@synthesize alist_filtered_data;

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
    //loadview的时候，打开所有expandable
    [self.skstableView fn_expandall];
    
// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -初始化数组
-(void)fn_init_arr{
    DB_searchCriteria *db=[[DB_searchCriteria alloc]init];
    alist_groupNameAndNum=[db fn_get_groupNameAndNum:@"crmacct"];
    alist_searchCriteria=[db fn_get_srchType_data:@"crmacct"];
    NSLog(@"%@",alist_searchCriteria);
    alist_filtered_data=[[NSMutableArray alloc]initWithCapacity:10];
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
    
    SKSTableViewCell *cell = [self.skstableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    if ([col_stye isEqualToString:@"string"]) {
        static NSString *cellIdentifier=@"Cell_search1";
        Cell_search *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_search alloc]init];
        }
         cell.il_prompt_label.text=col_label;
        return cell;
    }
    if ([col_stye isEqualToString:@"lookup"]) {
        static NSString *cellIdentifier=@"Cell_search11";
        Cell_search1 *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[Cell_search1 alloc]init];
        }
        cell.il_prompt_label.text=col_label;
        return cell;
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
- (IBAction)fn_search_account:(id)sender {
}
@end

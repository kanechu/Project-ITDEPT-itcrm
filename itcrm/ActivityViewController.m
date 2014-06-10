//
//  ActivityViewController.m
//  itcrm
//
//  Created by itdept on 14-5-31.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "ActivityViewController.h"
#import "DB_formatlist.h"
#import "DB_crmtask_browse.h"
#import "Cell_armtask_browse.h"
#import "Format_conversion.h"
@interface ActivityViewController ()

@end

@implementation ActivityViewController
@synthesize alist_crmtask;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fn_init_crmtask_arr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_init_crmtask_arr{
    Format_conversion *format=[[Format_conversion alloc]init];
    //获取crmtask列表显示信息的格式
    NSMutableArray *arr_format=[NSMutableArray array];
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    arr_format=[db_format fn_get_list_data:@"crmtask"];
    //获取crmtask的参数
    NSMutableArray *arr_crmtask=[NSMutableArray array];
    DB_crmtask_browse *db_crmtask=[[DB_crmtask_browse alloc]init];
    arr_crmtask=[db_crmtask fn_get_crmtask_data];
    //转换格式
    alist_crmtask=[format fn_format_conersion:arr_format browse:arr_crmtask];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [alist_crmtask count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell_armtask_browse";
    Cell_armtask_browse *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"Cell_armtask_browse" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    cell.il_title.text=[[alist_crmtask objectAtIndex:indexPath.row]valueForKey:@"t_title"];
    cell.il_desc1.text=[[alist_crmtask objectAtIndex:indexPath.row]valueForKey:@"t_desc1"];
    cell.il_desc2.text=[[alist_crmtask objectAtIndex:indexPath.row]valueForKey:@"t_desc2"];
    cell.il_desc3.text=[[alist_crmtask objectAtIndex:indexPath.row]valueForKey:@"t_desc3"];
    // Configure the cell...
    
    return cell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}

@end

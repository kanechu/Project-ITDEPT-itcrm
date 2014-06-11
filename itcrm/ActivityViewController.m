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
#import "Cell_browse.h"
#import "Format_conversion.h"
@interface ActivityViewController ()

@end

@implementation ActivityViewController
@synthesize alist_crmtask;
@synthesize format;
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
    format=[[Format_conversion alloc]init];
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
    static NSString *CellIdentifier = @"Cell_browse";
    Cell_browse *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"Cell_browse" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    UILabel *il_title=[[UILabel alloc]initWithFrame:CGRectMake(58, 0, 260, 21)];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:15.0];
    il_title.lineBreakMode=NSLineBreakByCharWrapping;
    il_title.numberOfLines=0;
    il_title.font=font;
    il_title.text=[alist_crmtask objectAtIndex:indexPath.row];
    CGFloat height=[format fn_heightWithString:il_title.text font:font constrainedToWidth:il_title.frame.size.width];
    [il_title setFrame:CGRectMake(il_title.frame.origin.x, il_title.frame.origin.y+2, il_title.frame.size.width, height)];
    [cell addSubview:il_title];
    // Configure the cell...
    
    return cell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellText = [alist_crmtask objectAtIndex:indexPath.row];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15.0];
    CGFloat height=[format fn_heightWithString:cellText font:cellFont constrainedToWidth:260.0f];
    return height+10;
}


@end

//
//  OpportunitiesViewController.m
//  itcrm
//
//  Created by itdept on 14-6-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "OpportunitiesViewController.h"
#import "DB_crmopp_browse.h"
#import "DB_formatlist.h"
#import "Cell_browse.h"
#import "Format_conversion.h"
#import "Custom_Color.h"
@interface OpportunitiesViewController ()

@end

@implementation OpportunitiesViewController
@synthesize alist_crmopp_browse;
@synthesize format;
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
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    [self fn_init_crmopp_browse_arr];
    self.tableview.backgroundColor=COLOR_LIGHT_YELLOW;
  
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_init_crmopp_browse_arr{
   format=[[Format_conversion alloc]init];
    //获取crmopp列表显示信息的格式
    NSMutableArray *arr_format=[NSMutableArray array];
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    arr_format=[db_format fn_get_list_data:@"crmacct_opp"];
    //获取crmopp的参数数据
    NSMutableArray *arr_crmopp=[NSMutableArray array];
    DB_crmopp_browse *db_crmopp=[[DB_crmopp_browse alloc]init];
    arr_crmopp=[db_crmopp fn_get_data];
    alist_crmopp_browse=[format fn_format_conersion:arr_format browse:arr_crmopp];
   
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [alist_crmopp_browse count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_browse";
    Cell_browse *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell=[[Cell_browse alloc]init];
    }
    cell.backgroundColor=COLOR_LIGHT_YELLOW;
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:15.0];
    cell.il_show_text.lineBreakMode=NSLineBreakByCharWrapping;
    cell.il_show_text.numberOfLines=0;
    cell.il_show_text.font=font;
    cell.il_show_text.text=[alist_crmopp_browse objectAtIndex:indexPath.row];
    CGFloat height=[format fn_heightWithString:cell.il_show_text.text font:font constrainedToWidth:cell.il_show_text.frame.size.width];
    cell.il_show_text.frame=CGRectMake(cell.il_show_text.frame.origin.x, cell.il_show_text.frame.origin.y, cell.il_show_text.frame.size.width, height);
    return cell;
}
#pragma mark UITableViewDelegate
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellText = [alist_crmopp_browse objectAtIndex:indexPath.row];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15.0];
    CGFloat height=[format fn_heightWithString:cellText font:cellFont constrainedToWidth:260.0f];
    return height+10;
}

@end

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
#import "Cell_opportunities.h"
#import "Format_conversion.h"
@interface OpportunitiesViewController ()

@end

@implementation OpportunitiesViewController
@synthesize alist_crmopp_browse;
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
  
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_init_crmopp_browse_arr{
    Format_conversion *convert=[[Format_conversion alloc]init];
    //获取crmopp列表显示信息的格式
    NSMutableArray *arr_format=[NSMutableArray array];
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    arr_format=[db_format fn_get_list_data:@"crmacct_opp"];
    //获取crmopp的参数数据
    NSMutableArray *arr_crmopp=[NSMutableArray array];
    DB_crmopp_browse *db_crmopp=[[DB_crmopp_browse alloc]init];
    arr_crmopp=[db_crmopp fn_get_data];
    alist_crmopp_browse=[convert fn_format_conersion:arr_format browse:arr_crmopp];
   
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [alist_crmopp_browse count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_opportunities";
    Cell_opportunities *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell=[[Cell_opportunities alloc]init];
    }
    cell.il_title.text=[[alist_crmopp_browse objectAtIndex:indexPath.row]valueForKey:@"t_title"];
    cell.il_desc1.text=[[alist_crmopp_browse objectAtIndex:indexPath.row]valueForKey:@"t_desc1"];
    cell.il_desc2.text=[[alist_crmopp_browse objectAtIndex:indexPath.row]valueForKey:@"t_desc2"];
    cell.il_desc3.text=[[alist_crmopp_browse objectAtIndex:indexPath.row]valueForKey:@"t_desc3"];
    
    return cell;
}
#pragma mark UITableViewDelegate
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}

@end

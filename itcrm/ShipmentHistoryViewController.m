//
//  ShipmentHistoryViewController.m
//  itcrm
//
//  Created by itdept on 14-6-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "ShipmentHistoryViewController.h"
#import "DB_crmhbl_browse.h"
#import "DB_formatlist.h"
#import "DB_systemIcon.h"
#import "Format_conversion.h"
#import "Cell_browse.h"

@interface ShipmentHistoryViewController ()

@property (nonatomic,strong) Format_conversion *convert;
@property (nonatomic,strong) DB_crmhbl_browse *db_crmhbl;
@property (nonatomic,strong) UIImage *hbl_image;

@end

@implementation ShipmentHistoryViewController
@synthesize alist_crmhbl;
@synthesize convert;
@synthesize db_crmhbl;
@synthesize hbl_image;

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
    convert=[[Format_conversion alloc]init];
    db_crmhbl=[[DB_crmhbl_browse alloc]init];
    [self fn_init_crmhbl_browse:[db_crmhbl fn_get_crmhbl_data:_is_searchbar.text]];
    _is_searchbar.delegate=self;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_init_crmhbl_browse:(NSMutableArray*)crmhbl_browse{
    // 获取crmhbl列表显示信息的格式
    NSMutableArray *arr_format=[NSMutableArray array];
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    arr_format=[db_format fn_get_list_data:@"crmacct_hbl"];
    if ([arr_format count]!=0) {
        //转换格式
        alist_crmhbl=[convert fn_format_conersion:arr_format browse:crmhbl_browse];
        
        NSString *iconName=[[arr_format objectAtIndex:0]valueForKey:@"icon"];
        NSString *binary_str=[convert fn_get_binaryData:iconName];
        hbl_image=[convert fn_binaryData_convert_image:binary_str];
    }
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  [alist_crmhbl count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_browse1";
    Cell_browse *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell=[[Cell_browse alloc]init];
    }
    UIFont *font=[UIFont systemFontOfSize:15.0f];
    cell.il_title.text=[[alist_crmhbl objectAtIndex:indexPath.row]valueForKey:@"title"];
    cell.il_title.font=font;
    cell.il_show_text.text=[[alist_crmhbl objectAtIndex:indexPath.row]valueForKey:@"body"];
    cell.il_show_text.lineBreakMode=NSLineBreakByWordWrapping;
    cell.il_show_text.font=font;
    CGFloat height=[convert fn_heightWithString:cell.il_show_text.text font:font constrainedToWidth:cell.il_show_text.frame.size.width];
    [cell.il_show_text setFrame:CGRectMake(cell.il_show_text.frame.origin.x,cell.il_show_text.frame.origin.y, cell.il_show_text.frame.size.width, height)];
    cell.ii_image.image=hbl_image;
    return cell;
}
#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_browse1";
    Cell_browse *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier];
    UIFont *font=[UIFont systemFontOfSize:15.0f];
    NSString *contentText=[[alist_crmhbl objectAtIndex:indexPath.row]valueForKey:@"body"];
    CGFloat height=[convert fn_heightWithString:contentText font:font constrainedToWidth:cell.il_show_text.frame.size.width];
    return height+10+23;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
#pragma mark UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self fn_init_crmhbl_browse:[db_crmhbl fn_get_crmhbl_data:searchBar.text]];
    [self.tableview reloadData];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [_is_searchbar resignFirstResponder];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self fn_init_crmhbl_browse:[db_crmhbl fn_get_crmhbl_data:searchText]];
    [self.tableview reloadData];
}
@end

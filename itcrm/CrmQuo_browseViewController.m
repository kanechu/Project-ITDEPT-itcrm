//
//  CrmQuo_browseViewController.m
//  itcrm
//
//  Created by itdept on 14-7-11.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "CrmQuo_browseViewController.h"
#import "DB_crmquo_browse.h"
#import "DB_formatlist.h"
#import "Cell_browse.h"
#import "QuoWebViewController.h"

@interface CrmQuo_browseViewController ()
@property(nonatomic,strong)Format_conversion *convert;
@property(nonatomic,strong)DB_crmquo_browse *db_crmquo;
@property(nonatomic,strong)NSMutableArray *alist_crmquo;
@property(nonatomic,strong)NSMutableArray *alist_crmquo_parameter;
@property(nonatomic,strong)NSMutableArray *alist_format;
@property(nonatomic,copy)NSString *select_sql;
@property(nonatomic,strong)UIImage *crmquo_icon;
@end

@implementation CrmQuo_browseViewController
@synthesize alist_crmquo;
@synthesize alist_crmquo_parameter;
@synthesize db_crmquo;
@synthesize alist_format;
@synthesize convert;
@synthesize select_sql;
@synthesize crmquo_icon;
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
    _is_searchBar.delegate=self;
    
    db_crmquo=[[DB_crmquo_browse alloc]init];
    convert=[[Format_conversion alloc]init];
    [self fn_get_formatlist];
    
    alist_crmquo_parameter=[db_crmquo fn_get_crmquo_browse_data:_is_searchBar.text select_sql:select_sql];
    [self fn_init_crmquo_arr:alist_crmquo_parameter];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//获取crmquo版面的显示格式
-(void)fn_get_formatlist{
    //获取crmcontact列表显示信息的格式
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    alist_format=[db_format fn_get_list_data:@"crmquo"];
    if ([alist_format count]!=0) {
        select_sql=[[alist_format objectAtIndex:0]valueForKey:@"select_sql"];
        NSString *iconName=[[alist_format objectAtIndex:0]valueForKey:@"icon"];
        NSString *binary_str=[convert fn_get_binaryData:iconName];
        crmquo_icon=[convert fn_binaryData_convert_image:binary_str];
    }
}
-(void)fn_init_crmquo_arr:(NSMutableArray*)arr_crmquo{
    
    if ([alist_format count]!=0) {
        //转换格式
        alist_crmquo=[convert fn_format_conersion:alist_format browse:arr_crmquo];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [alist_crmquo count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_browse_quo";
    Cell_browse *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell=[[Cell_browse alloc]init];
    }
    cell.ii_image.image=crmquo_icon;
    cell.il_title.text=[[alist_crmquo objectAtIndex:indexPath.row]valueForKey:@"title"];
    cell.il_show_text.lineBreakMode=NSLineBreakByWordWrapping;
    NSString *body_str=[[alist_crmquo objectAtIndex:indexPath.row]valueForKey:@"body"];
    cell.il_show_text.text=body_str;
    CGFloat height=[convert fn_heightWithString:body_str font:cell.il_show_text.font constrainedToWidth:cell.il_show_text.frame.size.width];
    [cell.il_show_text setFrame:CGRectMake(cell.il_show_text.frame.origin.x, cell.il_show_text.frame.origin.y, cell.il_show_text.frame.size.width, height)];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_browse_quo";
    Cell_browse *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier];
    NSString *cellText = [[alist_crmquo objectAtIndex:indexPath.row]valueForKey:@"body"];
    CGFloat height=[convert fn_heightWithString:cellText font:cell.il_show_text.font constrainedToWidth:cell.il_show_text.frame.size.width];
    return height+10+23;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"segue_quoweb" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"segue_quoweb"]) {
        QuoWebViewController *VC=[segue destinationViewController];
        VC.url=@"http://192.168.1.28:81/itcrm.php/login/login_sub";
    VC.post=@"usrname=SA&usrpass=BUGFREE07&external=1&sysname=FSI.ITCRM";
    }
}
#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    alist_crmquo_parameter=[db_crmquo fn_get_crmquo_browse_data:searchText select_sql:select_sql];
    [self fn_init_crmquo_arr:alist_crmquo_parameter];
    [self.tableview reloadData];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [_is_searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    alist_crmquo_parameter=[db_crmquo fn_get_crmquo_browse_data:searchBar.text select_sql:select_sql];
    [self fn_init_crmquo_arr:alist_crmquo_parameter];
    [self.tableview reloadData];
    [_is_searchBar resignFirstResponder];
}
@end

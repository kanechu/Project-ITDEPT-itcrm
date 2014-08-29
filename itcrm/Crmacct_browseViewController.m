//
//  Crmacct_browseViewController.m
//  itcrm
//
//  Created by itdept on 14-6-5.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Crmacct_browseViewController.h"
#import "DB_formatlist.h"
#import "DB_crmacct_browse.h"
#import "Cell_browse.h"
#import "AccountViewController.h"
#import "MaintFormViewController.h"
@interface Crmacct_browseViewController ()

@property (nonatomic,strong) Format_conversion *format;
@property (nonatomic,strong) DB_crmacct_browse *db_acct;
@property (nonatomic,strong) NSMutableArray *alist_account_parameter;
@property (nonatomic,strong) NSMutableArray *ilist_account;
@property (nonatomic,strong) NSMutableArray *alist_format;
@property (nonatomic,strong)NSString *select_sql;
@property (nonatomic,strong) UIImage *acct_icon;

@end

@implementation Crmacct_browseViewController
@synthesize format;
@synthesize db_acct;
@synthesize alist_account_parameter;
@synthesize ilist_account;
@synthesize alist_format;
@synthesize acct_icon;
@synthesize select_sql;

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
    self.tableView_acct.delegate=self;
    self.tableView_acct.dataSource=self;
    _searchBar.delegate=self;
    db_acct=[[DB_crmacct_browse alloc]init];
    format=[[Format_conversion alloc]init];
    [self fn_get_acct_formatlist];
    //获取account_browse的参数
    alist_account_parameter=[db_acct fn_get_data:_searchBar.text select_sql:select_sql];
    [self fn_init_account:alist_account_parameter];
   
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_get_acct_formatlist{
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    alist_format=[db_format fn_get_list_data:@"crmacct"];
    if ([alist_format count]!=0) {
        select_sql=[db_format fn_get_select_sql:@"crmacct"];
        NSString *iconName=[[alist_format objectAtIndex:0]valueForKey:@"icon"];
        NSString *binary_str=[format fn_get_binaryData:iconName];
        acct_icon=[format fn_binaryData_convert_image:binary_str];
    }
}
-(void)fn_init_account:(NSMutableArray*)arr_account{
    if ([alist_format count]!=0) {
        
        ilist_account=[format fn_format_conersion:alist_format browse:arr_account];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [ilist_account count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_browse";
    Cell_browse *cell=[self.tableView_acct dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell==nil) {
        cell=[[Cell_browse alloc]init];
    }
    if (indexPath.row%2==0) {
        cell.backgroundColor=COLOR_LIGHT_GRAY;
    }else{
        cell.backgroundColor=COLOR_LIGHT_BLUE;
    }
    
    cell.ii_image.image=acct_icon;
    cell.il_title.text=[[ilist_account objectAtIndex:indexPath.row]valueForKey:@"title"];
    
    cell.il_show_text.text=[[ilist_account objectAtIndex:indexPath.row] valueForKey:@"body"];
    CGFloat height=[format fn_heightWithString:cell.il_show_text.text font:cell.il_show_text.font constrainedToWidth:cell.il_show_text.frame.size.width];
    [cell.il_show_text setFrame:CGRectMake(cell.il_show_text.frame.origin.x, cell.il_show_text.frame.origin.y, cell.il_show_text.frame.size.width, height)];
    //cell选中时的无背景色
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_browse";
    Cell_browse *cell=[self.tableView_acct dequeueReusableCellWithIdentifier:cellIndentifier];
    NSString *cellText = [[ilist_account objectAtIndex:indexPath.row]valueForKey:@"body"];
    CGFloat height=[format fn_heightWithString:cellText font:cell.il_show_text.font constrainedToWidth:cell.il_show_text.frame.size.width];
    return height+10+23;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"segue_maintForm" sender:self];
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    alist_account_parameter=[db_acct fn_get_data:_searchBar.text select_sql:select_sql];
    [self fn_init_account:alist_account_parameter];
    [self.tableView_acct reloadData];
    [_searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [_searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    alist_account_parameter=[db_acct fn_get_data:_searchBar.text select_sql:select_sql];
    [self fn_init_account:alist_account_parameter];
    [self.tableView_acct reloadData];
}

- (IBAction)fn_advance_search:(id)sender {
    AccountViewController *VC=(AccountViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AccountViewController"];
    VC.callback_acct=^(NSMutableArray *arr){
        alist_account_parameter=[db_acct fn_get_detail_crmacct_data:arr select_sql:select_sql];
        [self fn_init_account:alist_account_parameter];
        [self.tableView_acct reloadData];
    };
    PopViewManager *popV=[[PopViewManager alloc]init];
    [popV PopupView:VC Size:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) uponView:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *selectedRowIndex=[self.tableView_acct indexPathForSelectedRow];
    if ([[segue identifier] isEqualToString:@"segue_maintForm"]) {
        MaintFormViewController *maintVC=[segue destinationViewController];
        maintVC.is_acct_id=[[alist_account_parameter objectAtIndex:selectedRowIndex.row] valueForKey:@"acct_id"];
    }
}
@end

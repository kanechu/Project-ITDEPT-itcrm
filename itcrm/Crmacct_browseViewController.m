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
#import "PopViewManager.h"
#import "AccountViewController.h"
#import "Format_conversion.h"
#import "Custom_Color.h"
#import "DB_systemIcon.h"
#import "MaintFormViewController.h"
@interface Crmacct_browseViewController ()

@end

@implementation Crmacct_browseViewController
@synthesize ilist_account;
@synthesize format;
@synthesize db_acct;
@synthesize acct_icon;
@synthesize alist_account_parameter;


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
    [_searchBar resignFirstResponder];
    self.tableView_acct.backgroundColor=COLOR_LIGHT_YELLOW;
    db_acct=[[DB_crmacct_browse alloc]init];
    format=[[Format_conversion alloc]init];
    alist_account_parameter=[db_acct fn_get_data:_searchBar.text];
    [self fn_init_account:alist_account_parameter];
    [self init_acct_icon];
   
	// Do any additional setup after loading the view.
}

-(void)fn_init_account:(NSMutableArray*)arr_account{
    //获取acct 列表显示信息的格式
    NSMutableArray *arr_format=[NSMutableArray array];
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    arr_format=[db_format fn_get_list_data:@"crmacct"];
    ilist_account=[format fn_format_conersion:arr_format browse:arr_account];
}
-(void)init_acct_icon{
    //获取acct 列表显示信息的格式
    NSMutableArray *arr_format=[NSMutableArray array];
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    arr_format=[db_format fn_get_list_data:@"crmacct"];  DB_systemIcon *db_icon=[[DB_systemIcon alloc]init];
    NSString *iconName=[[arr_format objectAtIndex:0]valueForKey:@"icon"];
    NSMutableArray *arr_icon=[db_icon fn_get_systemIcon_data:iconName];
    NSString *str=nil;
    if ([arr_icon count]!=0) {
        str=[[arr_icon objectAtIndex:0]valueForKey:@"ic_content"];
    }
    if (str!=nil || [str length]!=0) {
        NSData *data=[[NSData alloc]initWithBase64EncodedString:str options:0];
        acct_icon=[UIImage imageWithData:data];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.backgroundColor=COLOR_LIGHT_YELLOW;
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:15.0];
    
    cell.il_title.text=[[ilist_account objectAtIndex:indexPath.row]valueForKey:@"title"];
    cell.il_show_text.text=[[ilist_account objectAtIndex:indexPath.row] valueForKey:@"body"];
    cell.il_title.font=font;
    cell.il_show_text.lineBreakMode=NSLineBreakByCharWrapping;
    cell.il_show_text.numberOfLines=0;
    cell.il_show_text.font=font;
    
    cell.ii_image.image=acct_icon;
    
    CGFloat height=[format fn_heightWithString:cell.il_show_text.text font:font constrainedToWidth:cell.il_show_text.frame.size.width];
    [cell.il_show_text setFrame:CGRectMake(cell.il_show_text.frame.origin.x, cell.il_show_text.frame.origin.y, cell.il_show_text.frame.size.width, height)];
    //改变cell选中时的背景色
    cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor=COLOR_LIGHT_YELLOW2;
    return cell;
    
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellText = [[ilist_account objectAtIndex:indexPath.row]valueForKey:@"body"];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15.0];
    CGFloat height=[format fn_heightWithString:cellText font:cellFont constrainedToWidth:260.0f];
    return height+10+23;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"segue_maintForm" sender:self];
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    alist_account_parameter=[db_acct fn_get_data:searchBar.text];
    [self fn_init_account:alist_account_parameter];
    [self.tableView_acct reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [_searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    alist_account_parameter=[db_acct fn_get_data:searchText];
    [self fn_init_account:alist_account_parameter];
    [self.tableView_acct reloadData];
}

- (IBAction)fn_advance_search:(id)sender {
    AccountViewController *VC=(AccountViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AccountViewController"];
    VC.iobj_target=self;
    VC.isel_action1=@selector(fn_save_arr:);
    PopViewManager *popV=[[PopViewManager alloc]init];
    [popV PopupView:VC Size:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) uponView:self];
}
-(void)fn_save_arr:(NSMutableArray*)alist_searchData{
    NSMutableArray *arr_account=[NSMutableArray array];
    DB_crmacct_browse *db_crmacct=[[DB_crmacct_browse alloc]init];
    arr_account=[db_crmacct fn_get_detail_crmacct_data:alist_searchData];
    alist_account_parameter=arr_account;
    [self fn_init_account:arr_account];
    [self.tableView_acct reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *selectedRowIndex=[self.tableView_acct indexPathForSelectedRow];
    if ([[segue identifier] isEqualToString:@"segue_maintForm"]) {
        MaintFormViewController *maintVC=[segue destinationViewController];
        maintVC.idic_modified_value=[alist_account_parameter objectAtIndex:selectedRowIndex.row];
    }
}
@end

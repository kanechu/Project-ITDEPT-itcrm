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
@interface Crmacct_browseViewController ()

@end

@implementation Crmacct_browseViewController
@synthesize ilist_account;
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
    
    self.tableView_acct.delegate=self;
    self.tableView_acct.dataSource=self;
    _searchBar.delegate=self;
    [_searchBar resignFirstResponder];
    [self fn_init_account];
    self.tableView_acct.backgroundColor=COLOR_LIGHT_YELLOW;
   
	// Do any additional setup after loading the view.
}

-(void)fn_init_account{
    format=[[Format_conversion alloc]init];
    //获取acct 列表显示信息的格式
    NSMutableArray *arr_format=[NSMutableArray array];
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    arr_format=[db_format fn_get_list_data:@"crmacct"];
    //获取crmacct的参数数据
    NSMutableArray *arr_account=[NSMutableArray array];
    DB_crmacct_browse *db_crmacct=[[DB_crmacct_browse alloc]init];
    arr_account=[db_crmacct fn_get_data:_searchBar.text];
   ilist_account=[format fn_format_conersion:arr_format browse:arr_account];
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
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:15.0];
    cell.il_show_text.lineBreakMode=NSLineBreakByCharWrapping;
    cell.il_show_text.textColor=[UIColor whiteColor];
    cell.il_show_text.font=font;
    cell.il_show_text.text=[ilist_account objectAtIndex:indexPath.row];
    
    CGFloat height=[format fn_heightWithString:cell.il_show_text.text font:font constrainedToWidth:cell.il_show_text.frame.size.width];
    [cell.il_show_text setFrame:CGRectMake(cell.il_show_text.frame.origin.x, cell.il_show_text.frame.origin.y, cell.il_show_text.frame.size.width, height)];
    return cell;
    
}


#pragma mark UITableViewDelegate
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"segue_maintForm" sender:self];
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self fn_init_account];
    [self.tableView_acct reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [_searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self fn_init_account];
    [self.tableView_acct reloadData];
}

- (IBAction)fn_advance_search:(id)sender {
    AccountViewController *VC=(AccountViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AccountViewController"];
    PopViewManager *popV=[[PopViewManager alloc]init];
    [popV PopupView:VC Size:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) uponView:self];
}
@end

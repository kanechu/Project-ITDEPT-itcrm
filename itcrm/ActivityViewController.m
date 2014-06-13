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
#import "Custom_Color.h"
#import "PopViewManager.h"
#import "SearchTaskViewController.h"
@interface ActivityViewController ()

@end

@implementation ActivityViewController
@synthesize alist_crmtask;
@synthesize format;
@synthesize db_crmtask;
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
    self.view.backgroundColor=COLOR_LIGHT_YELLOW;
    _is_searchbar.delegate=self;
    //获取crmtask的参数
    NSMutableArray *arr_crmtask=[NSMutableArray array];
    db_crmtask=[[DB_crmtask_browse alloc]init];
    arr_crmtask=[db_crmtask fn_get_search_crmtask_data:_is_searchbar.text];
    [self fn_init_crmtask_arr:arr_crmtask];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_init_crmtask_arr:(NSMutableArray*)arr_crmtask{
    format=[[Format_conversion alloc]init];
    //获取crmtask列表显示信息的格式
    NSMutableArray *arr_format=[NSMutableArray array];
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    arr_format=[db_format fn_get_list_data:@"crmtask"];
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
    cell.backgroundColor=COLOR_LIGHT_YELLOW;
    UIFont *font = [UIFont systemFontOfSize:15.0];
    cell.il_show_text.lineBreakMode=NSLineBreakByCharWrapping;
    cell.il_show_text.font=font;
    cell.il_show_text.text=[alist_crmtask objectAtIndex:indexPath.row];
     CGFloat height=[format fn_heightWithString:cell.il_show_text.text font:font constrainedToWidth:cell.il_show_text.frame.size.width];
    [cell.il_show_text setFrame:CGRectMake(cell.il_show_text.frame.origin.x, cell.il_show_text.frame.origin.y, cell.il_show_text.frame.size.width, height)];
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
#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self fn_init_crmtask_arr:[db_crmtask fn_get_search_crmtask_data:searchBar.text]];
    [self.tableView reloadData];
    [_is_searchbar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self fn_init_crmtask_arr:[db_crmtask fn_get_search_crmtask_data:searchText]];
    [self.tableView reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [_is_searchbar resignFirstResponder];
}
- (IBAction)fn_advance_search_task:(id)sender {
    SearchTaskViewController *VC=(SearchTaskViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SearchTaskViewController"];
    PopViewManager *popV=[[PopViewManager alloc]init];
    [popV PopupView:VC Size:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) uponView:self];
}
@end

//
//  CrmTask_browseViewController.m
//  itcrm
//
//  Created by itdept on 14-6-23.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "CrmTask_browseViewController.h"
#import "DB_formatlist.h"
#import "DB_crmtask_browse.h"
#import "Cell_browse.h"
#import "Format_conversion.h"
#import "Custom_Color.h"
#import "PopViewManager.h"
#import "SearchTaskViewController.h"
#import "DB_systemIcon.h"
#import "MaintTaskViewController.h"
@interface CrmTask_browseViewController ()

@end

@implementation CrmTask_browseViewController
@synthesize alist_crmtask;
@synthesize format;
@synthesize db_crmtask;
@synthesize task_icon;
@synthesize alist_crmtask_parameter;
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
    //设置代理
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _is_searchbar.delegate=self;
    self.view.backgroundColor=COLOR_LIGHT_YELLOW;
    self.tableview.backgroundColor=COLOR_LIGHT_YELLOW;
    //获取crmtask的参数
    db_crmtask=[[DB_crmtask_browse alloc]init];
    alist_crmtask_parameter=[db_crmtask fn_get_search_crmtask_data:_is_searchbar.text];
    format=[[Format_conversion alloc]init];
    [self fn_init_crmtask_arr:alist_crmtask_parameter];
    [self init_task_icon];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_init_crmtask_arr:(NSMutableArray*)arr_crmtask{
    //获取crmtask列表显示信息的格式
    NSMutableArray *arr_format=[NSMutableArray array];
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    arr_format=[db_format fn_get_list_data:@"crmtask"];
    //转换格式
    alist_crmtask=[format fn_format_conersion:arr_format browse:arr_crmtask];
}
-(void)init_task_icon{
    //获取task 列表显示信息的格式
    NSMutableArray *arr_format=[NSMutableArray array];
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    arr_format=[db_format fn_get_list_data:@"crmtask"];  DB_systemIcon *db_icon=[[DB_systemIcon alloc]init];
    NSString *iconName=[[arr_format objectAtIndex:0]valueForKey:@"icon"];
    NSMutableArray *arr_icon=[db_icon fn_get_systemIcon_data:iconName];
    NSString *str=nil;
    if ([arr_icon count]!=0) {
        str=[[arr_icon objectAtIndex:0]valueForKey:@"ic_content"];
    }
    if (str!=nil || [str length]!=0) {
        NSData *data=[[NSData alloc]initWithBase64EncodedString:str options:0];
        task_icon=[UIImage imageWithData:data];
        
    }
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
        cell=[[Cell_browse alloc]init];
    }
    cell.backgroundColor=COLOR_LIGHT_YELLOW;
    UIFont *font = [UIFont systemFontOfSize:15.0];
    cell.il_title.text=[[alist_crmtask objectAtIndex:indexPath.row]valueForKey:@"title"];
    cell.il_title.font=font;
    cell.il_show_text.lineBreakMode=NSLineBreakByCharWrapping;
    cell.il_show_text.font=font;
    cell.il_show_text.text=[[alist_crmtask objectAtIndex:indexPath.row]valueForKey:@"body"];
    cell.ii_image.image=task_icon;
    CGFloat height=[format fn_heightWithString:cell.il_show_text.text font:font constrainedToWidth:cell.il_show_text.frame.size.width];
    [cell.il_show_text setFrame:CGRectMake(cell.il_show_text.frame.origin.x, cell.il_show_text.frame.origin.y, cell.il_show_text.frame.size.width, height)];
    // Configure the cell...
    //设置选中cell的背景颜色
    cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor=COLOR_LIGHT_YELLOW2;
    //示意标识
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellText = [[alist_crmtask objectAtIndex:indexPath.row]valueForKey:@"body"];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15.0];
    CGFloat height=[format fn_heightWithString:cellText font:cellFont constrainedToWidth:260.0f];
    return height+10+23;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"segue_maintTask" sender:self];
}
#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    alist_crmtask_parameter=[db_crmtask fn_get_search_crmtask_data:searchBar.text];
    [self fn_init_crmtask_arr:alist_crmtask_parameter];
    [self.tableview reloadData];
    [_is_searchbar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    alist_crmtask_parameter=[db_crmtask fn_get_search_crmtask_data:searchText];
    [self fn_init_crmtask_arr:alist_crmtask_parameter];
    [self.tableview reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [_is_searchbar resignFirstResponder];
}
-(void)fn_save_task:(NSMutableArray*)alist_searchData{
    NSMutableArray *arr_task=[NSMutableArray array];
    DB_crmtask_browse *db_crmacct=[[DB_crmtask_browse alloc]init];
    arr_task=[db_crmacct fn_get_detail_crmtask_data:alist_searchData ];
    alist_crmtask_parameter=arr_task;
    [self fn_init_crmtask_arr:arr_task];
    [self.tableview reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *selectedRowIndex=[self.tableview indexPathForSelectedRow];
    if([[segue identifier] isEqualToString:@"segue_maintTask"]){
        MaintTaskViewController *taskVC=[segue destinationViewController];
        taskVC.idic_parameter_value=[alist_crmtask_parameter objectAtIndex:selectedRowIndex.row];
        
    }
}
- (IBAction)fn_advance_search_task:(id)sender {
    SearchTaskViewController *VC=(SearchTaskViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SearchTaskViewController"];
    VC.iobj_target=self;
    VC.isel_action1=@selector(fn_save_task:);
    PopViewManager *popV=[[PopViewManager alloc]init];
    [popV PopupView:VC Size:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) uponView:self];
}
@end

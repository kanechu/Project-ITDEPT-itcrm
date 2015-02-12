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
#import "SearchTaskViewController.h"
#import "MaintTaskViewController.h"
@interface CrmTask_browseViewController ()

@property(nonatomic,strong)Format_conversion *format;
@property(nonatomic,strong)DB_crmtask_browse *db_crmtask;
@property(nonatomic,strong)NSMutableArray *alist_crmtask_parameter;
@property(nonatomic,strong)NSMutableArray *alist_format;
@property(nonatomic,strong)NSMutableArray *alist_crmtask;
@property(nonatomic,strong)UIImage *task_icon;
@property(nonatomic,copy) NSString *select_sql;

@end

@implementation CrmTask_browseViewController
@synthesize alist_crmtask;
@synthesize alist_format;
@synthesize format;
@synthesize db_crmtask;
@synthesize task_icon;
@synthesize alist_crmtask_parameter;
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
    
    [self fn_get_formatlist];
    [self fn_set_property];
    
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
     [self.tableview deselectRowAtIndexPath:[self.tableview indexPathForSelectedRow] animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_set_property{
    //设置代理
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _is_searchbar.delegate=self;
    
    db_crmtask=[[DB_crmtask_browse alloc]init];
    //获取crmtask的参数
    alist_crmtask_parameter=[db_crmtask fn_get_search_crmtask_data:_is_searchbar.text select_sql:select_sql];
    [self fn_init_crmtask_arr:alist_crmtask_parameter];
    
    [_ibtn_advance setTitle:MYLocalizedString(@"lbl_advance", nil)];
    self.title=MYLocalizedString(@"lbl_task", nil);
    _is_searchbar.placeholder=MYLocalizedString(@"lbl_activity_search", nil);
}
-(void)fn_get_formatlist{
    format=[[Format_conversion alloc]init];
    //获取crmtask列表显示信息的格式
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    alist_format=[db_format fn_get_list_data:@"crmtask"];
    if ([alist_format count]!=0) {
        select_sql=[db_format fn_get_select_sql:@"crmtask"];
        NSString *iconName=[[alist_format objectAtIndex:0]valueForKey:@"icon"];
        NSString *binary_str=[format fn_get_binaryData:iconName];
        task_icon=[format fn_binaryData_convert_image:binary_str];
        if (task_icon==nil) {
            task_icon=[UIImage imageNamed:@"ic_task"];
        }
    }
}
-(void)fn_init_crmtask_arr:(NSMutableArray*)arr_crmtask{
    if ([alist_format count]!=0) {
        //转换格式
        alist_crmtask=[format fn_format_conersion:alist_format browse:arr_crmtask];
        if ([alist_crmtask count]!=0) {
            [self.tableview setTableFooterView:nil];
            [self.tableview setScrollEnabled:YES];
        }else{
            View_show_prompt *footView=[[View_show_prompt alloc]initWithFrame:self.tableview.frame];
            footView.str_msg=MYLocalizedString(@"no_task_prompt", nil);
            [self.tableview setTableFooterView:footView];
            [self.tableview setScrollEnabled:NO];
        }
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
    if (indexPath.row%2==0) {
        cell.backgroundColor=COLOR_LIGHT_GRAY;
    }else{
        cell.backgroundColor=COLOR_LIGHT_BLUE;
    }
    cell.ii_image.image=task_icon;
    cell.il_title.text=[[alist_crmtask objectAtIndex:indexPath.row]valueForKey:@"title"];
    cell.il_show_text.lineBreakMode=NSLineBreakByCharWrapping;
    cell.il_show_text.text=[[alist_crmtask objectAtIndex:indexPath.row]valueForKey:@"body"];
    CGFloat height=[format fn_heightWithString:cell.il_show_text.text font:cell.il_show_text.font constrainedToWidth:cell.il_show_text.frame.size.width];
    [cell.il_show_text setFrame:CGRectMake(cell.il_show_text.frame.origin.x, cell.il_show_text.frame.origin.y, cell.il_show_text.frame.size.width, height)];
    // Configure the cell...
    //示意标识
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell_browse";
    Cell_browse *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString *cellText = [[alist_crmtask objectAtIndex:indexPath.row]valueForKey:@"body"];
    CGFloat height=[format fn_heightWithString:cellText font:cell.il_show_text.font constrainedToWidth:cell.il_show_text.frame.size.width];
    
    return height+10+25;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"segue_maintTask" sender:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_update_crmtask_browse) name:@"update" object:nil];
}
-(void)fn_update_crmtask_browse{
    alist_crmtask_parameter=[db_crmtask fn_get_search_crmtask_data:@"" select_sql:select_sql];
    [self fn_init_crmtask_arr:alist_crmtask_parameter];
    [self.tableview reloadData];
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    alist_crmtask_parameter=[db_crmtask fn_get_search_crmtask_data:searchBar.text select_sql:select_sql];
    [self fn_init_crmtask_arr:alist_crmtask_parameter];
    [self.tableview reloadData];
    [_is_searchbar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    alist_crmtask_parameter=[db_crmtask fn_get_search_crmtask_data:searchText select_sql:select_sql];
    [self fn_init_crmtask_arr:alist_crmtask_parameter];
    [self.tableview reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [_is_searchbar resignFirstResponder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *selectedRowIndex=[self.tableview indexPathForSelectedRow];
    if([[segue identifier] isEqualToString:@"segue_maintTask"]){
        MaintTaskViewController *taskVC=[segue destinationViewController];
        taskVC.idic_parameter_value=[alist_crmtask_parameter objectAtIndex:selectedRowIndex.row];
        taskVC.flag_can_edit=1;
    }
}
- (IBAction)fn_advance_search_task:(id)sender {
    SearchTaskViewController *VC=(SearchTaskViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SearchTaskViewController"];
    VC.callback_task=^(NSMutableArray *arr_searchData){
        alist_crmtask_parameter=[db_crmtask fn_get_detail_crmtask_data:arr_searchData select_sql:select_sql];
        [self fn_init_crmtask_arr:alist_crmtask_parameter];
        [self.tableview reloadData];
    };
    [self presentViewController:VC animated:YES completion:nil];
}
@end

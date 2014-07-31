//
//  CrmContact_browseViewController.m
//  itcrm
//
//  Created by itdept on 14-7-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "CrmContact_browseViewController.h"
#import "Cell_browse.h"
#import "DB_crmcontact_browse.h"
#import "DB_formatlist.h"
#import "SearchCrmContactViewController.h"
#import "EditContactViewController.h"

@interface CrmContact_browseViewController ()
@property(nonatomic,strong)Format_conversion *convert;
@property(nonatomic,strong)DB_crmcontact_browse *db_crmcontact;
@property(nonatomic,strong)NSMutableArray *alist_crmcontact;
@property(nonatomic,readonly)NSMutableArray *alist_contact_parameter;
@property(nonatomic,strong)NSMutableArray *arr_format;
@property(nonatomic,strong)UIImage *contact_icon;
@property(nonatomic,copy) NSString *select_sql;
@end

@implementation CrmContact_browseViewController
@synthesize alist_crmcontact;
@synthesize convert;
@synthesize db_crmcontact;
@synthesize alist_contact_parameter;
@synthesize contact_icon;
@synthesize select_sql;
@synthesize arr_format;
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
    convert=[[Format_conversion alloc]init];
    db_crmcontact=[[DB_crmcontact_browse alloc]init];
    [self fn_get_formatlist];
    alist_contact_parameter=[db_crmcontact fn_get_crmcontact_browse_data:_is_searchBar.text select_sql:select_sql];
    [self fn_init_crmcontact_arr:alist_contact_parameter];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_get_formatlist{
    //获取crmcontact列表显示信息的格式
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    arr_format=[db_format fn_get_list_data:@"crmcontact"];
    if ([arr_format count]!=0) {
         select_sql=[[arr_format objectAtIndex:0]valueForKey:@"select_sql"];
        NSString *iconName=[[arr_format objectAtIndex:0]valueForKey:@"icon"];
        NSString *binary_str=[convert fn_get_binaryData:iconName];
        contact_icon=[convert fn_binaryData_convert_image:binary_str];
    }
}
-(void)fn_init_crmcontact_arr:(NSMutableArray*)arr_crmcontact{
  
    if ([arr_format count]!=0) {
        //转换格式
        alist_crmcontact=[convert fn_format_conersion:arr_format browse:arr_crmcontact];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [alist_crmcontact count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndetifier=@"Cell_browse_contact";
    Cell_browse *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndetifier];
    if (!cell) {
        cell=[[Cell_browse alloc]init];
    }
    cell.ii_image.image=contact_icon;
    cell.il_title.text=[[alist_crmcontact objectAtIndex:indexPath.row]valueForKey:@"title"];
    cell.il_show_text.lineBreakMode=NSLineBreakByWordWrapping;
    NSString *str_body=[[alist_crmcontact objectAtIndex:indexPath.row]valueForKey:@"body"];
    cell.il_show_text.text=str_body;
    CGFloat height=[convert fn_heightWithString:str_body font:cell.il_show_text.font constrainedToWidth:cell.il_show_text.frame.size.width];
    [cell.il_show_text setFrame:CGRectMake(cell.il_show_text.frame.origin.x,cell.il_show_text.frame.origin.y, cell.il_show_text.frame.size.width, height)];
    //设置选中cell的背景颜色
    cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor=COLOR_LIGHT_YELLOW1;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_browse_contact";
    Cell_browse *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier];
    NSString *cellText = [[alist_crmcontact objectAtIndex:indexPath.row]valueForKey:@"body"];
    CGFloat height=[convert fn_heightWithString:cellText font:cell.il_show_text.font constrainedToWidth:cell.il_show_text.frame.size.width];
    return height+10+23;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"Segue_editContact" sender:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_update_crmcontact_browse) name:@"contact_update" object:nil];
}
-(void)fn_update_crmcontact_browse{
    alist_contact_parameter=[db_crmcontact fn_get_crmcontact_browse_data:_is_searchBar.text select_sql:select_sql];
    [self fn_init_crmcontact_arr:alist_contact_parameter];
    [self.tableview reloadData];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *selectedRowIndex=[self.tableview indexPathForSelectedRow];
    if([[segue identifier] isEqualToString:@"Segue_editContact"]){
        EditContactViewController *VC=[segue destinationViewController];
        VC.is_contact_id=[[alist_contact_parameter objectAtIndex:selectedRowIndex.row]valueForKey:@"contact_id"];
        
    }
}

#pragma mark UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [_is_searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    alist_contact_parameter=[db_crmcontact fn_get_crmcontact_browse_data:searchText select_sql:select_sql];
    [self fn_init_crmcontact_arr:alist_contact_parameter];
    [self.tableview reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    alist_contact_parameter=[db_crmcontact fn_get_crmcontact_browse_data:searchBar.text select_sql:select_sql];
    [self fn_init_crmcontact_arr:alist_contact_parameter];
    [self.tableview reloadData];
    [_is_searchBar resignFirstResponder];
}
- (IBAction)fn_advance_search:(id)sender {
    SearchCrmContactViewController *crm_contact=[self.storyboard instantiateViewControllerWithIdentifier:@"SearchCrmContactViewController"];
    crm_contact.callback=^(NSMutableArray *alist_conditions){
        alist_contact_parameter=[db_crmcontact fn_get_detail_crmcontact_data:alist_conditions select_sql:select_sql];
        [self fn_init_crmcontact_arr:alist_contact_parameter];
        [self.tableview reloadData];
    };
    PopViewManager *popVC=[[PopViewManager alloc]init];
    [popVC PopupView:crm_contact Size:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) uponView:self];
}
@end

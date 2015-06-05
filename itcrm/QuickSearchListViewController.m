//
//  QuickSearchListViewController.m
//  itcrm
//
//  Created by itdept on 15/3/11.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import "QuickSearchListViewController.h"
#import "MaintFormViewController.h"
#import "MaintTaskViewController.h"
#import "EditContactViewController.h"
#import "EditOppViewController.h"
#import "DB_crmacct_browse.h"
#import "DB_crmcontact_browse.h"
#import "DB_crmopp_browse.h"
#import "DB_crmtask_browse.h"
#import "Cell_browse.h"
@interface QuickSearchListViewController ()
@property (nonatomic,strong) Format_conversion *format_obj;
@end

@implementation QuickSearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _format_obj=[[Format_conversion alloc]init];
    [self fn_refresh_listView];
    self.tableView.backgroundColor=COLOR_LIGHT_GRAY;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_alist_browse_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *idic_result=[_alist_browse_data objectAtIndex:indexPath.row];
    static NSString *cellIdentifier=@"cell_quick_search_list";
    Cell_browse *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.row%2==0) {
        cell.backgroundColor=COLOR_LIGHT_GRAY;
    }else{
        cell.backgroundColor=COLOR_LIGHT_BLUE;
    }
    UIImage *image_type=[UIImage imageNamed:@"ic_acct"];
    NSString *str_type=[idic_result valueForKey:@"type"];
    if ([str_type isEqualToString:@"ACCT"]) {
        image_type=[UIImage imageNamed:@"ic_acct"];
    }else if ([str_type isEqualToString:@"TASK"]){
        image_type=[UIImage imageNamed:@"ic_task"];
    }else if ([str_type isEqualToString:@"CONTACT"]){
        image_type=[UIImage imageNamed:@"ic_contact"];
        
    }else if ([str_type isEqualToString:@"OPP"]){
        image_type=[UIImage imageNamed:@"ic_opp"];
    }
    cell.ii_image.image=image_type;
    cell.il_title.text=[idic_result valueForKey:@"title"];
    cell.il_show_text.text=@"";
    CGFloat height=[_format_obj fn_heightWithString:cell.il_title.text font:cell.il_show_text.font constrainedToWidth:cell.il_title.frame.size.width];
    [cell.il_title setFrame:CGRectMake(cell.il_title.frame.origin.x, cell.il_title.frame.origin.y, cell.il_title.frame.size.width, height)];
    CGFloat height1=[_format_obj fn_heightWithString:cell.il_show_text.text font:cell.il_show_text.font constrainedToWidth:cell.il_show_text.frame.size.width];
    if (height1<21) {
        height1=21;
    }
    [cell.il_show_text setFrame:CGRectMake(cell.il_show_text.frame.origin.x, cell.il_title.frame.origin.y+cell.il_title.frame.size.height, cell.il_show_text.frame.size.width, height1)];
    // Configure the cell...
    
    return cell;
}
#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"cell_quick_search_list";
    Cell_browse *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    NSString *cellText = [[_alist_browse_data objectAtIndex:indexPath.row]valueForKey:@"title"];
    CGFloat height=[_format_obj fn_heightWithString:cellText font:cell.il_title.font constrainedToWidth:cell.il_title.frame.size.width];
    
    NSString *str_body=[[_alist_browse_data objectAtIndex:indexPath.row]valueForKey:@""];
    CGFloat height1=[_format_obj fn_heightWithString:str_body font:cell.il_show_text.font constrainedToWidth:cell.il_show_text.frame.size.width];
    if (height1<21) {
        height1=21;
    }
    
    height=height1+height;
    if (SYSTEM_VERSION_GREATER_THAN_IOS8) {
        if (height<70) {
            return 70;
        }
        return height;
    }
    if (height<70) {
        return 70;
    }
    return height+5;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *idic_result=[_alist_browse_data objectAtIndex:indexPath.row];
    NSString *str_uid=[idic_result valueForKey:@"uid"];
    NSString *str_type=[idic_result valueForKey:@"type"];
    MaintFormViewController *maintFormVC=[self.storyboard instantiateViewControllerWithIdentifier:@"MaintFormViewController"];
   
    MaintTaskViewController *maintTaskVC=[self.storyboard instantiateViewControllerWithIdentifier:@"MaintTaskViewController"];
    EditContactViewController *editContactVC=[self.storyboard instantiateViewControllerWithIdentifier:@"EditContactViewController"];
    EditOppViewController *editOppVC=[self.storyboard instantiateViewControllerWithIdentifier:@"EditOppViewController"];
    
    if ([str_type isEqualToString:@"ACCT"]) {
        DB_crmacct_browse *db_crmacct=[[DB_crmacct_browse alloc]init];
        NSMutableArray *alist_crmaccts=[db_crmacct fn_get_data_from_id:str_uid];
        db_crmacct=nil;
        maintFormVC.flag_isDowload=1;
        maintFormVC.is_acct_id=str_uid;
        maintFormVC.idic_modified_value=[alist_crmaccts objectAtIndex:0];
        alist_crmaccts=nil;
        [self.navigationController pushViewController:maintFormVC animated:YES];
    }else if ([str_type isEqualToString:@"TASK"]){
        DB_crmtask_browse *db_crmtask=[[DB_crmtask_browse alloc]init];
        NSMutableArray *alist_crmtasks=[db_crmtask fn_get_crmtask_data_from_id:str_uid];
        db_crmtask=nil;
        maintTaskVC.idic_parameter_value=[alist_crmtasks objectAtIndex:0];
        maintTaskVC.flag_can_edit=1;
        alist_crmtasks=nil;
        [self.navigationController pushViewController:maintTaskVC animated:YES];
       
    }else if ([str_type isEqualToString:@"CONTACT"]){
        DB_crmcontact_browse *db_crmcontact=[[DB_crmcontact_browse alloc]init];
        NSMutableArray *alist_crmcontact=[db_crmcontact fn_get_crmcontact_browse:str_uid];
        db_crmcontact=nil;
        editContactVC.idic_parameter_contact=[alist_crmcontact firstObject];
        editContactVC.flag_can_edit=1;
        alist_crmcontact=nil;
        [self.navigationController pushViewController:editContactVC animated:YES];
        
    }else if ([str_type isEqualToString:@"OPP"]){
        DB_crmopp_browse *db_crmopp=[[DB_crmopp_browse alloc]init];
        NSMutableArray *alist_crmopp=[db_crmopp fn_get_crmopp_with_id:str_uid];
        db_crmopp=nil;
        editOppVC.idic_parameter_opp=[alist_crmopp firstObject];
        editOppVC.flag_can_edit=1;
        alist_crmopp=nil;
        [self.navigationController pushViewController:editOppVC animated:YES];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_callback) {
        _callback();
    }
}
#pragma mark -refresh listview after search
- (void)fn_refresh_listView{
    if ([_alist_browse_data count]==0) {
        View_show_prompt *footView=[[View_show_prompt alloc]initWithFrame:self.tableView.frame];
        footView.str_msg=MYLocalizedString(@"no_record_prompt", nil);
        [self.tableView setTableFooterView:footView];
        [self.tableView setScrollEnabled:NO];
    }else{
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=[UIColor clearColor];
        [self.tableView setTableFooterView:view];
        [self.tableView setScrollEnabled:YES];
        view=nil;
    }
    [self.tableView reloadData];
}
@end

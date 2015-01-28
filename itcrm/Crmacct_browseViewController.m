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
#import "DB_RespLogin.h"
#import "Cell_browse.h"
#import "AccountViewController.h"
#import "MaintFormViewController.h"
#import "Web_resquestData.h"
#import "RespCrmacct_browse.h"
#import "SVProgressHUD.h"
#import "CheckUpdate.h"

@interface Crmacct_browseViewController ()
/*These outlets to the buttons use a 'strong' reference instead of 'weak' because we want to keep the buttons around even if they're not inside a view.*/
@property (strong, nonatomic) IBOutlet UIBarButtonItem *ibtn_download;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *ibtn_cancel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *ibtn_advance;
@property (nonatomic, strong) Format_conversion *format;
@property (nonatomic, strong) DB_crmacct_browse *db_acct;
@property (nonatomic, strong) CheckUpdate *check_obj;
//存储local（offline)
@property (nonatomic, strong) NSMutableArray *alist_account_parameter;
//存储online,在线搜索回来的数据
@property (nonatomic, strong) NSMutableArray *alist_temp_acct;
@property (nonatomic, strong) NSMutableArray *ilist_account;
//存储acct browse显示格式
@property (nonatomic, strong) NSMutableArray *alist_format;
//tableview编辑状态下，存储点选的acct
@property (nonatomic, strong) NSMutableArray *alist_multi_acct;
@property (nonatomic, strong)NSString *select_sql;
@property (nonatomic, strong) UIImage *acct_icon;
@property (nonatomic, copy) NSString *base_url;
@property (nonatomic, assign) kOperation_type flag_opration_type;
@property (nonatomic, assign) NSInteger flag_longPress_state;
@end

@implementation Crmacct_browseViewController
@synthesize format;
@synthesize db_acct;
@synthesize alist_account_parameter;
@synthesize alist_temp_acct;
@synthesize ilist_account;
@synthesize alist_format;
@synthesize alist_multi_acct;
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
    [self fn_set_property];
    [self fn_get_acct_formatlist];
    [self fn_updateButtonsToMatchState];
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [self.tableView_acct deselectRowAtIndexPath:[self.tableView_acct indexPathForSelectedRow] animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fn_set_property{
    self.tableView_acct.delegate=self;
    self.tableView_acct.dataSource=self;
    self.tableView_acct.allowsMultipleSelectionDuringEditing=YES;
    _searchBar.delegate=self;
    
    db_acct=[[DB_crmacct_browse alloc]init];
    format=[[Format_conversion alloc]init];
    _check_obj=[[CheckUpdate alloc]init];
    DB_RespLogin *db=[[DB_RespLogin alloc]init];
    
    _base_url=[db fn_get_field_content:kWeb_addr];
    if ([_check_obj fn_check_isNetworking]==NO) {
        alist_account_parameter=[db_acct fn_get_data:_searchBar.text select_sql:select_sql];
        [self fn_init_account:alist_account_parameter];
    }
    alist_multi_acct=[[NSMutableArray alloc]init];
    _searchBar.placeholder=MYLocalizedString(@"lbl_account_search", nil);
    self.navigationItem.backBarButtonItem.title=MYLocalizedString(@"lbl_back", nil);
    [_ibtn_advance setTitle:MYLocalizedString(@"lbl_advance", nil)];
    [_ibtn_download setTitle:MYLocalizedString(@"lbl_download", nil)];
    [_ibtn_cancel setTitle:MYLocalizedString(@"lbl_cancel", nil)];
    self.title=MYLocalizedString(@"lbl_browse", nil);
    
}
-(void)fn_get_acct_formatlist{
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    alist_format=[db_format fn_get_list_data:@"crmacct"];
    if ([alist_format count]!=0) {
        select_sql=[db_format fn_get_select_sql:@"crmacct"];
        NSString *iconName=[[alist_format objectAtIndex:0]valueForKey:@"icon"];
        NSString *binary_str=[format fn_get_binaryData:iconName];
        acct_icon=[format fn_binaryData_convert_image:binary_str];
        if (acct_icon==nil) {
            acct_icon=[UIImage imageNamed:@"ic_acct"];
        }
    }
    db_format=nil;
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
    if (indexPath.row%2==0) {
        cell.backgroundColor=COLOR_LIGHT_GRAY;
    }else{
        cell.backgroundColor=COLOR_LIGHT_BLUE;
    }
    UITapGestureRecognizer *tapGesture_imgV=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fn_operation_single_crmacct:)];
    cell.ii_image.tag=indexPath.row;
    [cell.ii_image addGestureRecognizer:tapGesture_imgV];
    tapGesture_imgV=nil;
    NSMutableDictionary *dic_acct=[alist_account_parameter objectAtIndex:indexPath.row];
    NSString *acct_id=[dic_acct valueForKey:@"acct_id"];
    NSString *rec_upd_date=[dic_acct valueForKey:@"rec_upd_date"];
    _flag_opration_type=[db_acct fn_get_operation_type:rec_upd_date acct_id:acct_id];
    if (_flag_opration_type==kDownload_acct) {
        cell.ii_image.image=[UIImage imageNamed:@"ic_download"];
    }else if(_flag_opration_type==kUpdate_acct){
        cell.ii_image.image=[UIImage imageNamed:@"ic_update"];
    }else{
        cell.ii_image.image=acct_icon;
    }
    acct_id=nil;
    rec_upd_date=nil;
    dic_acct=nil;
    
    UILongPressGestureRecognizer *longGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(fn_multiple_download_crmacct:)];
    cell.tag=indexPath.row;
    [cell addGestureRecognizer:longGesture];
    
    cell.il_title.text=[[ilist_account objectAtIndex:indexPath.row]valueForKey:@"title"];
    
    cell.il_show_text.text=[[ilist_account objectAtIndex:indexPath.row] valueForKey:@"body"];
    CGFloat height=[format fn_heightWithString:cell.il_show_text.text font:cell.il_show_text.font constrainedToWidth:cell.il_show_text.frame.size.width];
    [cell.il_show_text setFrame:CGRectMake(cell.il_show_text.frame.origin.x, cell.il_show_text.frame.origin.y, cell.il_show_text.frame.size.width, height)];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([_check_obj fn_check_isNetworking]) {
        return 25;
    }
    return 0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *ilb_header=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableView_acct.frame.size.width,25)];
    ilb_header.text=MYLocalizedString(@"msg_online", nil);
    ilb_header.textAlignment=NSTextAlignmentCenter;
    ilb_header.textColor=[UIColor whiteColor];
    ilb_header.backgroundColor=COLOR_LIGTH_GREEN;
    return ilb_header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_browse";
    Cell_browse *cell=[self.tableView_acct dequeueReusableCellWithIdentifier:cellIndentifier];
    NSString *cellText = [[ilist_account objectAtIndex:indexPath.row]valueForKey:@"body"];
    CGFloat height=[format fn_heightWithString:cellText font:cell.il_show_text.font constrainedToWidth:cell.il_show_text.frame.size.width];
     height=height+21;
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
    if (_flag_longPress_state==1) {
        RespCrmacct_browse *resp_result=[alist_temp_acct objectAtIndex:indexPath.row];
        [alist_multi_acct addObject:resp_result];
        [self fn_updateButtonsToMatchState];
    }else{
        [self performSegueWithIdentifier:@"segue_maintForm" sender:self];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_flag_longPress_state==1) {
        RespCrmacct_browse *resp_result=[alist_temp_acct objectAtIndex:indexPath.row];
        [alist_multi_acct removeObject:resp_result ];
        [self fn_updateButtonsToMatchState];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete;
}
#pragma mark -Updating button state
- (void)fn_updateButtonsToMatchState{
    if (self.tableView_acct.editing) {
        //Show the option to Cancel the edit.
        self.navigationItem.leftBarButtonItem=self.ibtn_cancel;
        
        //Show the download button,but disable the download button if there's not select
        if (self.alist_multi_acct.count>0){
            self.ibtn_download.enabled=YES;
        }else{
            self.ibtn_download.enabled=NO;
        }
        self.navigationItem.rightBarButtonItem=self.ibtn_download;
    }else{
        //Not in editing mode.
        self.navigationItem.leftBarButtonItem=nil;
        
        self.navigationItem.rightBarButtonItem=self.ibtn_advance;
    }
}
#pragma mark -event action
- (IBAction)fn_download_multi_acct:(id)sender {
    [SVProgressHUD showWithStatus:MYLocalizedString(@"msg_get_crmData", nil)];
    [db_acct fn_save_crmacct_browse:alist_multi_acct];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(fn_hiden_hud) userInfo:nil repeats:NO];
}
- (IBAction)fn_cancel_multi_select_acct:(id)sender {
    _flag_longPress_state=0;
    [alist_multi_acct removeAllObjects];
    [self.tableView_acct setEditing:NO animated:YES];
    [self fn_updateButtonsToMatchState];
}
- (IBAction)fn_advance_search:(id)sender {
    AccountViewController *VC=(AccountViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AccountViewController"];
    VC.callback_acct=^(NSMutableArray *arr){
        if([_check_obj fn_check_isNetworking]){
            [SVProgressHUD showWithStatus:MYLocalizedString(@"dialog_prompt", nil)];
            NSMutableArray *alist_searchs=[NSMutableArray array];
            for (Advance_SearchData *advance_obj in arr) {
                SearchFormContract *searchForm=[[SearchFormContract alloc]init];
                searchForm.os_column=advance_obj.is_parameter;
                BOOL isHas=[format fn_isContain_a_character:advance_obj.is_parameter substring:@","];
                if (isHas) {
                    NSArray *arr_parameter=[advance_obj.is_parameter componentsSeparatedByString:@","];
                    searchForm.os_column=[arr_parameter firstObject];
                }
                searchForm.os_value=advance_obj.is_searchValue;
                [alist_searchs addObject:searchForm];
                searchForm=nil;
            }
            [self fn_online_search_crmacct:[NSSet setWithArray:alist_searchs]];
            alist_searchs=nil;
            
        }else{
            alist_account_parameter=[db_acct fn_get_detail_crmacct_data:arr select_sql:select_sql];
            [self fn_init_account:alist_account_parameter];
            [self.tableView_acct reloadData];
        }
    };
    [self presentViewController:VC animated:YES completion:nil];
}
-(void)fn_operation_single_crmacct:(UITapGestureRecognizer*)tapGesture{
    UIImageView *imag_view =(UIImageView*)[tapGesture view];
    RespCrmacct_browse *resp=[alist_temp_acct objectAtIndex:imag_view.tag];
    NSMutableArray *alist_acct=[[NSMutableArray alloc]initWithObjects:resp, nil];
    NSMutableDictionary *dic_acct=[alist_account_parameter objectAtIndex:imag_view.tag];
    NSString *acct_id=[dic_acct valueForKey:@"acct_id"];
    NSString *rec_upd_date=[dic_acct valueForKey:@"rec_upd_date"];
    _flag_opration_type=[db_acct fn_get_operation_type:rec_upd_date acct_id:acct_id];
    if (_flag_opration_type==kDownload_acct&&_flag_longPress_state!=1) {
        [SVProgressHUD showWithStatus:MYLocalizedString(@"msg_get_crmData", nil)];
        [db_acct fn_save_crmacct_browse:alist_acct];
        
    }else if(_flag_opration_type==kUpdate_acct&&_flag_longPress_state!=1){
        [SVProgressHUD showWithStatus:MYLocalizedString(@"msg_update_crmData", nil)];
        [db_acct fn_delete_single_acct_data:acct_id];
        [db_acct fn_save_crmacct_browse:alist_acct];
    }
    if (_flag_opration_type!=kNon_operation && _flag_longPress_state!=1) {
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(fn_hiden_hud) userInfo:nil repeats:NO];
    }
    alist_acct=nil;
}
- (void)fn_multiple_download_crmacct:(UILongPressGestureRecognizer*)gesture{
     _flag_longPress_state=1;
    if ([gesture state]==UIGestureRecognizerStateBegan) {
        //显示多选圆圈
        [self.tableView_acct setEditing:YES animated:YES];
    }
    [self fn_updateButtonsToMatchState];
}
- (void)fn_hiden_hud{
    if (_flag_opration_type==kDownload_acct) {
        [SVProgressHUD dismissWithSuccess:[NSString stringWithFormat:@"1%@",MYLocalizedString(@"msg_download_success", nil)]];
    }
    if (_flag_opration_type==kUpdate_acct) {
        [SVProgressHUD dismissWithSuccess:MYLocalizedString(@"msg_upd_success", nil)];
        
    }
    if (_flag_longPress_state==1) {
        //Exit download mode after download acct
        [self.tableView_acct setEditing:NO animated:YES];
        [self fn_updateButtonsToMatchState];
        [SVProgressHUD dismissWithSuccess:[NSString stringWithFormat:@"%@%@",@(alist_multi_acct.count),MYLocalizedString(@"msg_download_success", nil)]];
        _flag_longPress_state=0;
        [alist_multi_acct removeAllObjects];
    }
    [self.tableView_acct reloadData];
}

- (void)fn_online_search_crmacct:(NSSet*)iSet_searchForms{
    Web_resquestData *web_obj=[[Web_resquestData alloc]init];
    [web_obj fn_get_crmacct_browse_data:_base_url searchForms:iSet_searchForms];
    web_obj.callBack=^(NSMutableArray *alist_result){
        alist_temp_acct=alist_result;
        //把RespCrmacct_browse对象转成字典，再存储在alist_acct上
        NSMutableArray *alist_acct=[[NSMutableArray alloc]init];
        for (RespCrmacct_browse *resp in alist_result) {
            NSDictionary *dic=[NSDictionary dictionaryWithPropertiesOfObject:resp];
            [alist_acct addObject:dic];
            
        }
        alist_account_parameter=alist_acct;
        [self fn_init_account:alist_account_parameter];
        [self.tableView_acct reloadData];
        [SVProgressHUD dismiss];
    };
    web_obj=nil;
}
#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [SVProgressHUD showWithStatus:MYLocalizedString(@"dialog_prompt", nil)];
    SearchFormContract *searchForm=[[SearchFormContract alloc]init];
    searchForm.os_column=@"acct_name";
    searchForm.os_value=searchBar.text;
    [self fn_online_search_crmacct:[NSSet setWithObject:searchForm]];
    searchForm=nil;
    [_searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [_searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([_check_obj fn_check_isNetworking]==NO) {
        alist_account_parameter=[db_acct fn_get_data:_searchBar.text select_sql:select_sql];
        [self fn_init_account:alist_account_parameter];
        [self.tableView_acct reloadData];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *selectedRowIndex=[self.tableView_acct indexPathForSelectedRow];
    if ([[segue identifier] isEqualToString:@"segue_maintForm"]) {
        MaintFormViewController *maintVC=[segue destinationViewController];
        maintVC.is_acct_id=[[alist_account_parameter objectAtIndex:selectedRowIndex.row] valueForKey:@"acct_id"];
        maintVC.idic_modified_value=[alist_account_parameter objectAtIndex:selectedRowIndex.row];
    }
}
@end

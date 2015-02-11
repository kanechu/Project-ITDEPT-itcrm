//
//  Crmacct_browseViewController.m
//  itcrm
//
//  Created by itdept on 14-6-5.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Crmacct_browseViewController.h"
#import "DB_RespLogin.h"
#import "DB_crmacct_browse.h"
#import "Cell_browse.h"
#import "AccountViewController.h"
#import "MaintFormViewController.h"
#import "Web_resquestData.h"
#import "RespCrmacct_browse.h"
#import "Resp_crmacct_dowload.h"
#import "SVProgressHUD.h"
#import "CheckUpdate.h"

static NSInteger flag_complete_upload=0;

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
//存储关联的数据
@property (nonatomic, strong) NSMutableArray *alist_acct_download;
@property (nonatomic, strong)NSString *select_sql;
@property (nonatomic, strong) UIImage *acct_icon;
@property (nonatomic, copy) NSString *base_url;
@property (nonatomic, assign) kOperation_type flag_opration_type;
//标识是否处于长按状态
@property (nonatomic, assign) NSInteger flag_longPress_state;
//标识数据是否已经下载
@property (nonatomic, assign) NSInteger flag_isDownload;
//选取更新的行
@property (nonatomic, assign) NSInteger flag_SelectRow;
@end

@implementation Crmacct_browseViewController
@synthesize format;
@synthesize db_acct;
@synthesize alist_account_parameter;
@synthesize alist_temp_acct;
@synthesize ilist_account;
@synthesize alist_format;
@synthesize alist_multi_acct;
@synthesize alist_acct_download;
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
    [self fn_get_acct_formatlist];
    [self fn_set_property];
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
    if (![_check_obj fn_check_isNetworking]) {
        alist_account_parameter=[db_acct fn_get_data:_searchBar.text select_sql:select_sql];
        [self fn_init_account:alist_account_parameter];
    }
    alist_multi_acct=[[NSMutableArray alloc]init];
    alist_acct_download=[[NSMutableArray alloc]init];
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
        if ([ilist_account count]!=0) {
            [self.tableView_acct setScrollEnabled:YES];
            [self.tableView_acct setTableFooterView:nil];
        }else{
            View_show_prompt *footView=[[View_show_prompt alloc]initWithFrame:self.tableView_acct.frame];
            footView.str_msg=MYLocalizedString(@"no_account_prompt", nil);
            [self.tableView_acct setTableFooterView:footView];
            [self.tableView_acct setScrollEnabled:NO];
        }
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
    NSString *max_upd_date=[dic_acct valueForKey:@"max_upd_date"];
    _flag_opration_type=[db_acct fn_is_need_sync:max_upd_date acct_id:acct_id];
    if (_flag_opration_type==kDownload_acct) {
        cell.ii_image.image=[UIImage imageNamed:@"ic_download"];
    }else if(_flag_opration_type==kUpdate_acct){
        cell.ii_image.image=[UIImage imageNamed:@"ic_update"];
    }else{
        cell.ii_image.image=acct_icon;
    }
    acct_id=nil;
    max_upd_date=nil;
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
        if ( [_check_obj fn_check_isNetworking] && [alist_temp_acct count]!=0) {
            RespCrmacct_browse *resp_result=[alist_temp_acct objectAtIndex:indexPath.row];
            [alist_multi_acct addObject:resp_result];
            [self fn_updateButtonsToMatchState];
            
        }
    }else{
        NSMutableDictionary *dic_acct=[alist_account_parameter objectAtIndex:indexPath.row];
        NSString *acct_id=[dic_acct valueForKey:@"acct_id"];
        NSString *max_upd_date=[dic_acct valueForKey:@"max_upd_date"];
        _flag_opration_type=[db_acct fn_is_need_sync:max_upd_date acct_id:acct_id];
        if (_flag_opration_type==kNon_operation || _flag_opration_type==kUpdate_acct) {
            _flag_isDownload=1;
            [self performSegueWithIdentifier:@"segue_maintForm" sender:self];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_update_browse) name:@"update" object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_update_browse) name:@"contact_update" object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_update_browse) name:@"crmopp_update" object:nil];
        }else{
            _flag_isDownload=0;
            if ([self fn_get_crmacct_download_data:acct_id]!=nil) {
                [self performSegueWithIdentifier:@"segue_maintForm" sender:self];
            }else{
                if ([_check_obj fn_check_isNetworking]) {
                    [SVProgressHUD showWithStatus:@"Loading......"];
                    Web_resquestData *web_obj=[[Web_resquestData alloc]init];
                    [web_obj fn_get_crmacct_relate_data:_base_url alist_acc_id:[NSArray arrayWithObject:acct_id]];
                    web_obj.callBack=^(NSMutableArray *alist_resp_result,BOOL isTimeOut){
                        if (isTimeOut) {
                            [self fn_show_request_timeOut_alert];
                        }else{
                            [alist_acct_download addObjectsFromArray:alist_resp_result];
                            [SVProgressHUD dismiss];
                            [self performSegueWithIdentifier:@"segue_maintForm" sender:self];
                        }
                    };
                }else{
                   
                    [self fn_show_network_unavailable_alert];
                }
            }
        }
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_flag_longPress_state==1 && [_check_obj fn_check_isNetworking]&& [alist_temp_acct count]!=0) {
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
    [db_acct fn_save_crmacct_browse:alist_multi_acct];
    //Exit download mode after download acct
    [self.tableView_acct setEditing:NO animated:YES];
    [self fn_updateButtonsToMatchState];
    NSMutableArray *alist_acct_id=[NSMutableArray array];
    for (NSDictionary *dic in alist_multi_acct) {
        NSString *acct_id=[dic valueForKey:@"acct_id"];
        [alist_acct_id addObject:acct_id];
    }
    [SVProgressHUD showWithStatus:MYLocalizedString(@"msg_get_crmData", nil)];
    [self fn_crmacct_download_relate_data:alist_acct_id];
    alist_acct_id=nil;
    
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
    _flag_SelectRow=imag_view.tag;
    NSMutableDictionary *dic_acct=[alist_account_parameter objectAtIndex:imag_view.tag];
    NSString *acct_id=[dic_acct valueForKey:@"acct_id"];
    NSString *max_upd_date=[dic_acct valueForKey:@"max_upd_date"];
    _flag_opration_type=[db_acct fn_is_need_sync:max_upd_date acct_id:acct_id];
    CheckUpdate *check_obj=[[CheckUpdate alloc]init];
    if ([check_obj fn_check_isNetworking]) {
        
        if (_flag_opration_type==kDownload_acct&&_flag_longPress_state!=1) {
            [db_acct fn_save_crmacct_browse:alist_acct];
            [SVProgressHUD showWithStatus:MYLocalizedString(@"msg_get_crmData", nil)];
            [self fn_crmacct_download_relate_data:[NSArray arrayWithObject:acct_id]];
        }else if(_flag_opration_type==kUpdate_acct&&_flag_longPress_state!=1){
            [SVProgressHUD showWithStatus:MYLocalizedString(@"msg_update_crmData", nil)];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_isComplete_upload_relate_data:) name:@"complete_upload_task" object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_isComplete_upload_relate_data:) name:@"complete_upload_contact" object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_isComplete_upload_relate_data:) name:@"complete_upload_opp" object:nil];
            [check_obj fn_checkUpdate_all_db:acct_id];
            
        }
        alist_acct=nil;
    }else{
        [self fn_show_network_unavailable_alert];
    }
}
- (void)fn_multiple_download_crmacct:(UILongPressGestureRecognizer*)gesture{
     _flag_longPress_state=1;
    if ([gesture state]==UIGestureRecognizerStateBegan) {
        //显示多选圆圈
        [self.tableView_acct setEditing:YES animated:YES];
    }
    [self fn_updateButtonsToMatchState];
    if (![_check_obj fn_check_isNetworking]) {
        _ibtn_download.enabled=NO;
    }else{
        _ibtn_download.enabled=YES;
    }
}

- (void)fn_online_search_crmacct:(NSSet*)iSet_searchForms{
    Web_resquestData *web_obj=[[Web_resquestData alloc]init];
    [web_obj fn_get_crmacct_browse_data:_base_url searchForms:iSet_searchForms];
    web_obj.callBack=^(NSMutableArray *alist_result,BOOL isTimeOut){
        if (isTimeOut) {
            [self fn_show_request_timeOut_alert];
        }else{
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
        }
    };
    web_obj=nil;
}
- (void)fn_crmacct_download_relate_data:(NSArray*)alist_acct_id{
    Web_resquestData *web_obj=[[Web_resquestData alloc]init];
    [web_obj fn_get_crmacct_relate_data:_base_url alist_acc_id:alist_acct_id];
    web_obj.callBack=^(NSMutableArray *alist_resp_result,BOOL isTimeOut){
        if (isTimeOut) {
            
        }else{
            DB_crmcontact_browse *db_contact=[[DB_crmcontact_browse alloc]init];
            DB_crmhbl_browse *db_hbl=[[DB_crmhbl_browse alloc]init];
            DB_crmopp_browse *db_opp=[[DB_crmopp_browse alloc]init];
            DB_crmquo_browse *db_quo=[[DB_crmquo_browse alloc]init];
            DB_crmtask_browse *db_task=[[DB_crmtask_browse alloc]init];
            [alist_acct_download addObjectsFromArray:alist_resp_result];
            if (_flag_longPress_state==1 || _flag_opration_type==kDownload_acct) {
                if (_flag_longPress_state==1) {
                    [SVProgressHUD dismissWithSuccess:[NSString stringWithFormat:@"%@%@",@(alist_multi_acct.count),MYLocalizedString(@"msg_download_success", nil)]];
                    _flag_longPress_state=0;
                    [alist_multi_acct removeAllObjects];
                }else{
                    
                    [SVProgressHUD dismissWithSuccess:[NSString stringWithFormat:@"1%@",MYLocalizedString(@"msg_download_success", nil)]];
                }
                
            }else if (_flag_opration_type==kUpdate_acct){
                [SVProgressHUD dismissWithSuccess:MYLocalizedString(@"msg_upd_success", nil)];
                
            }
            for (Resp_crmacct_dowload *resp_crmacct_obj in alist_resp_result) {
                NSString *acct_id=resp_crmacct_obj.acct_id;
                NSMutableArray *alist_acct=[[resp_crmacct_obj.AccountResult allObjects]mutableCopy];
                if ([alist_acct count]!=0) {
                    [db_acct fn_delete_single_acct_data:acct_id];
                    [db_acct fn_save_crmacct_browse:alist_acct];
                    RespCrmacct_browse *resp_obj=[alist_acct objectAtIndex:0];
                    NSDictionary *dic_acct=[NSDictionary dictionaryWithPropertiesOfObject:resp_obj];
                    [alist_account_parameter removeObjectAtIndex:_flag_SelectRow];
                    [alist_account_parameter insertObject:dic_acct atIndex:_flag_SelectRow];
                }
                
                NSMutableArray *alist_contact=[[resp_crmacct_obj.ContactResult allObjects]mutableCopy];
                [db_contact fn_delete_relate_crmcontact_data:acct_id];
                [db_contact fn_save_crmcontact_browse:alist_contact];
                
                NSMutableArray *alist_hbl=[[resp_crmacct_obj.HblResult allObjects]mutableCopy];
                [db_hbl fn_delete_relate_hbl_data:acct_id];
                [db_hbl fn_save_crmhbl_browse:alist_hbl];
                
                NSMutableArray *alist_opp=[[resp_crmacct_obj.OppResult allObjects]mutableCopy];
                [db_opp fn_delete_relate_crmopp_data:acct_id];
                [db_opp fn_save_crmopp_browse:alist_opp];
                
                NSMutableArray *alist_quo=[[resp_crmacct_obj.QuoResult allObjects]mutableCopy];
                [db_quo fn_delete_relate_crmquo_data:acct_id];
                [db_quo fn_save_crmquo_browse_data:alist_quo];
                
                NSMutableArray *alist_activity=[[resp_crmacct_obj.ActivityResult allObjects]mutableCopy];
                [db_task fn_delete_relate_crmtask_data:acct_id];
                [db_task fn_save_crmtask_browse:alist_activity];
                
            }
            
            [self.tableView_acct reloadData];
            db_contact=nil;
            db_hbl=nil;
            db_opp=nil;
            db_quo=nil;
            db_task=nil;
        }
    };
    web_obj=nil;
}
-(void)fn_isComplete_upload_relate_data:(NSNotification*)notification{
    NSString *acct_id=[notification object];
    flag_complete_upload++;
    if (flag_complete_upload==3) {
        flag_complete_upload=0;
        [self fn_crmacct_download_relate_data:[NSArray arrayWithObject:acct_id]];
    }
    
}
-(void)fn_update_browse{
    [self.tableView_acct reloadData];
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if ([_check_obj fn_check_isNetworking]) {
        [SVProgressHUD showWithStatus:MYLocalizedString(@"dialog_prompt", nil)];
        SearchFormContract *searchForm=[[SearchFormContract alloc]init];
        searchForm.os_column=@"acct_name";
        searchForm.os_value=searchBar.text;
        [self fn_online_search_crmacct:[NSSet setWithObject:searchForm]];
        searchForm=nil;
    }else{
        alist_account_parameter=[db_acct fn_get_data:_searchBar.text select_sql:select_sql];
        [self fn_init_account:alist_account_parameter];
        [self.tableView_acct reloadData];
    }
    
    [_searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [_searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (![_check_obj fn_check_isNetworking]) {
        alist_account_parameter=[db_acct fn_get_data:_searchBar.text select_sql:select_sql];
        [self fn_init_account:alist_account_parameter];
        [self.tableView_acct reloadData];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *selectedRowIndex=[self.tableView_acct indexPathForSelectedRow];
    if ([[segue identifier] isEqualToString:@"segue_maintForm"]) {
        MaintFormViewController *maintVC=[segue destinationViewController];
        NSString *acct_id=[[alist_account_parameter objectAtIndex:selectedRowIndex.row] valueForKey:@"acct_id"];
        maintVC.is_acct_id=acct_id;
        maintVC.idic_modified_value=[alist_account_parameter objectAtIndex:selectedRowIndex.row];
        maintVC.resp_download=[self fn_get_crmacct_download_data:acct_id];
        maintVC.flag_isDowload=_flag_isDownload;
    }
}
#pragma mark -other handle
-(void)fn_show_network_unavailable_alert{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:MYLocalizedString(@"msg_network_fail", nil) delegate:nil cancelButtonTitle:MYLocalizedString(@"lbl_ok", nil) otherButtonTitles:nil, nil];
    [alertView show];
}
-(void)fn_show_request_timeOut_alert{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:MYLocalizedString(@"msg_request_timeout", nil) delegate:self cancelButtonTitle:MYLocalizedString(@"lbl_ok", nil) otherButtonTitles:MYLocalizedString(@"lbl_retry", nil), nil];
    [alertView show];
}
- (Resp_crmacct_dowload*)fn_get_crmacct_download_data:(NSString*)acct_id{
    Resp_crmacct_dowload *resp_acct_download;
    for (Resp_crmacct_dowload *resp_obj in alist_acct_download) {
        NSString *str_acct_id=resp_obj.acct_id;
        if ([str_acct_id isEqualToString:acct_id]) {
            resp_acct_download=resp_obj;
            break;
        }
    }
    return resp_acct_download;
}
@end

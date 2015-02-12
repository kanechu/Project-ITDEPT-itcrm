//
//  CrmQuo_browseViewController.m
//  itcrm
//
//  Created by itdept on 14-7-11.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "CrmQuo_browseViewController.h"
#import "DB_crmquo_browse.h"
#import "DB_formatlist.h"
#import "DB_RespLogin.h"
#import "Cell_browse.h"
#import "QuoWebViewController.h"
#import "DB_Login.h"
@interface CrmQuo_browseViewController ()
@property(nonatomic,strong)Format_conversion *convert;
@property(nonatomic,strong)DB_crmquo_browse *db_crmquo;
@property(nonatomic,strong)NSMutableArray *alist_crmquo;
@property(nonatomic,strong)NSMutableArray *alist_crmquo_parameter;
@property(nonatomic,strong)NSMutableArray *alist_format;
@property(nonatomic,copy)NSString *select_sql;
@property(nonatomic,strong)UIImage *crmquo_icon;
@end

@implementation CrmQuo_browseViewController
@synthesize alist_crmquo;
@synthesize alist_crmquo_parameter;
@synthesize db_crmquo;
@synthesize alist_format;
@synthesize convert;
@synthesize select_sql;
@synthesize crmquo_icon;
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
    
    db_crmquo=[[DB_crmquo_browse alloc]init];
    convert=[[Format_conversion alloc]init];
    [self fn_get_formatlist];
    
    alist_crmquo_parameter=[db_crmquo fn_get_crmquo_browse_data:_is_searchBar.text select_sql:select_sql];
    [self fn_init_crmquo_arr:alist_crmquo_parameter];
    [self fn_show_different_language];
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
- (void)fn_show_different_language{
    self.title=MYLocalizedString(@"lbl_quo", nil);
    _is_searchBar.placeholder=MYLocalizedString(@"lbl_Quotation_search", nil);
}
//获取crmquo版面的显示格式
-(void)fn_get_formatlist{
    //获取crmcontact列表显示信息的格式
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    alist_format=[db_format fn_get_list_data:@"crmquo"];
    if ([alist_format count]!=0) {
        select_sql=[[alist_format objectAtIndex:0]valueForKey:@"select_sql"];
        NSString *iconName=[[alist_format objectAtIndex:0]valueForKey:@"icon"];
        NSString *binary_str=[convert fn_get_binaryData:iconName];
        crmquo_icon=[convert fn_binaryData_convert_image:binary_str];
        if (crmquo_icon==nil) {
            crmquo_icon=[UIImage imageNamed:@"ic_quo"];
        }
    }
}
-(void)fn_init_crmquo_arr:(NSMutableArray*)arr_crmquo{
    
    if ([alist_format count]!=0) {
        //转换格式
        alist_crmquo=[convert fn_format_conersion:alist_format browse:arr_crmquo];
        if ([alist_crmquo count]!=0) {
            [self.tableview setScrollEnabled:YES];
            [self.tableview setTableFooterView:nil];
        }else{
            View_show_prompt *footView=[[View_show_prompt alloc]initWithFrame:self.tableview.frame];
            footView.str_msg=MYLocalizedString(@"no_quo_prompt", nil);
            [self.tableview setTableFooterView:footView];
            [self.tableview setScrollEnabled:NO];
        }
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [alist_crmquo count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_browse_quo";
    Cell_browse *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell=[[Cell_browse alloc]init];
    }
    if (indexPath.row%2==0) {
        cell.backgroundColor=COLOR_LIGHT_GRAY;
    }else{
        cell.backgroundColor=COLOR_LIGHT_BLUE;
    }
    cell.ii_image.image=crmquo_icon;
    cell.il_title.text=[[alist_crmquo objectAtIndex:indexPath.row]valueForKey:@"title"];
    cell.il_show_text.lineBreakMode=NSLineBreakByWordWrapping;
    NSString *body_str=[[alist_crmquo objectAtIndex:indexPath.row]valueForKey:@"body"];
    cell.il_show_text.text=body_str;
    CGFloat height=[convert fn_heightWithString:body_str font:cell.il_show_text.font constrainedToWidth:cell.il_show_text.frame.size.width];
    [cell.il_show_text setFrame:CGRectMake(cell.il_show_text.frame.origin.x, cell.il_show_text.frame.origin.y, cell.il_show_text.frame.size.width, height)];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_browse_quo";
    Cell_browse *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier];
    NSString *cellText = [[alist_crmquo objectAtIndex:indexPath.row]valueForKey:@"body"];
    CGFloat height=[convert fn_heightWithString:cellText font:cell.il_show_text.font constrainedToWidth:cell.il_show_text.frame.size.width];
    return height+10+23;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"segue_quoweb" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexpath=[self.tableview indexPathForSelectedRow];
    NSMutableDictionary *dic=[alist_crmquo_parameter objectAtIndex:indexpath.row];
    NSString *quo_uid=[dic valueForKey:@"quo_uid"];
    DB_RespLogin *db_login=[[DB_RespLogin alloc]init];
    NSMutableArray *arr_login=[db_login fn_get_all_data];
    NSString *baseUrl=nil;
    if ([arr_login count]!=0) {
        baseUrl=[[arr_login objectAtIndex:0]valueForKey:@"php_addr"];
    }
    DB_Login *db=[[DB_Login alloc]init];
    NSMutableArray *arr_userLogin=[db fn_get_allData];
    NSString *userName=nil;
    NSString *userPass=nil;
    if ([arr_userLogin count]!=0) {
        userName=[[arr_userLogin objectAtIndex:0]valueForKey:@"user_code"];
        userPass=[[arr_userLogin objectAtIndex:0]valueForKey:@"password"];
    }
    if ([[segue identifier] isEqualToString:@"segue_quoweb"]) {
        QuoWebViewController *VC=[segue destinationViewController];
        VC.php_addr=baseUrl;
        VC.skip_url=[NSString stringWithFormat:@"%@/ctrl_crm_quotation?view=%@",baseUrl,quo_uid];
        VC.post=[NSString stringWithFormat:@"usrname=%@&usrpass=%@&external=1",userName,userPass];
    }
}
#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    alist_crmquo_parameter=[db_crmquo fn_get_crmquo_browse_data:searchText select_sql:select_sql];
    [self fn_init_crmquo_arr:alist_crmquo_parameter];
    [self.tableview reloadData];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [_is_searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    alist_crmquo_parameter=[db_crmquo fn_get_crmquo_browse_data:searchBar.text select_sql:select_sql];
    [self fn_init_crmquo_arr:alist_crmquo_parameter];
    [self.tableview reloadData];
    [_is_searchBar resignFirstResponder];
}
@end

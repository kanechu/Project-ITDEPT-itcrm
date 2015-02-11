//
//  OpportunitiesViewController.m
//  itcrm
//
//  Created by itdept on 14-6-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "OpportunitiesViewController.h"
#import "DB_crmopp_browse.h"
#import "DB_formatlist.h"
#import "Cell_browse.h"
#import "SearchCrmOppViewController.h"
#import "EditOppViewController.h"
#import "DB_formatlist.h"
@interface OpportunitiesViewController ()

@property (nonatomic,strong)DB_crmopp_browse *db_crmopp;
@property(nonatomic,strong)Format_conversion *format;
@property (nonatomic,strong) NSMutableArray *alist_opp_parameter;
@property (nonatomic,strong)NSMutableArray *alist_crmopp_browse;
@property (nonatomic,strong) NSMutableArray *arr_format;
@property (nonatomic,copy)  NSString *select_sql;
@property (nonatomic,strong) UIImage *opp_image;

@end

@implementation OpportunitiesViewController
@synthesize alist_crmopp_browse;
@synthesize format;
@synthesize opp_image;
@synthesize alist_opp_parameter;
@synthesize select_sql;
@synthesize arr_format;
@synthesize db_crmopp;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fn_set_property{
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    _is_searchBar.delegate=self;
    
    db_crmopp=[[DB_crmopp_browse alloc]init];
    
    //获取crmopp的参数数据
    alist_opp_parameter=[db_crmopp fn_get_crmopp_data:_is_searchBar.text select_sql:select_sql];
    [self fn_init_crmopp_browse_arr:alist_opp_parameter];
    
    _is_searchBar.placeholder=MYLocalizedString(@"lbl_opp_search", nil);
    self.title=MYLocalizedString(@"lbl_browse_opp", nil);
    [_ibtn_advance setTitle:MYLocalizedString(@"lbl_advance", nil)];
    
    self.navigationItem.backBarButtonItem.title=MYLocalizedString(@"lbl_back", nil);
}
-(void)fn_get_formatlist{
    format=[[Format_conversion alloc]init];
    //获取crmopp列表显示信息的格式
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    arr_format=[db_format fn_get_list_data:@"crmopp"];
    if ([arr_format count]!=0) {
        select_sql=[[arr_format objectAtIndex:0]valueForKey:@"select_sql"];
        NSString *iconName=[[arr_format objectAtIndex:0]valueForKey:@"icon"];
        NSString *binary_str=[format fn_get_binaryData:iconName];
        opp_image=[format fn_binaryData_convert_image:binary_str];
        if (opp_image==nil) {
            opp_image=[UIImage imageNamed:@"ic_opp"];
        }
    }
}

-(void)fn_init_crmopp_browse_arr:(NSMutableArray*)arr_crmopp{
    if ([arr_format count]!=0) {
        alist_crmopp_browse=[format fn_format_conersion:arr_format browse:arr_crmopp];
        if ([alist_crmopp_browse count]==0) {
            View_show_prompt *footView=[[View_show_prompt alloc]initWithFrame:self.tableview.frame];
            footView.str_msg=MYLocalizedString(@"no_opp_prompt", nil);
            [self.tableview setTableFooterView:footView];
            [self.tableview setScrollEnabled:NO];
        }else{
            [self.tableview setTableFooterView:nil];
            [self.tableview setScrollEnabled:YES];
        }
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [alist_crmopp_browse count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_browse";
    Cell_browse *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell=[[Cell_browse alloc]init];
    }
    if (indexPath.row%2==0) {
        cell.backgroundColor=COLOR_LIGHT_GRAY;
    }else{
        cell.backgroundColor=COLOR_LIGHT_BLUE;
    }
    cell.ii_image.image=opp_image;
    cell.il_title.text=[[alist_crmopp_browse objectAtIndex:indexPath.row]valueForKey:@"title"];
    cell.il_show_text.lineBreakMode=NSLineBreakByCharWrapping;
    cell.il_show_text.numberOfLines=0;
    cell.il_show_text.text=[[alist_crmopp_browse objectAtIndex:indexPath.row]valueForKey:@"body"];
    CGFloat height=[format fn_heightWithString:cell.il_show_text.text font:cell.il_show_text.font constrainedToWidth:cell.il_show_text.frame.size.width];
    cell.il_show_text.frame=CGRectMake(cell.il_show_text.frame.origin.x, cell.il_show_text.frame.origin.y, cell.il_show_text.frame.size.width, height);
    //设置选中cell时无背景颜色
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_browse";
    Cell_browse *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier];
    NSString *cellText = [[alist_crmopp_browse objectAtIndex:indexPath.row]valueForKey:@"body"];
    CGFloat height=[format fn_heightWithString:cellText font:cell.il_show_text.font constrainedToWidth:cell.il_show_text.frame.size.width];
    return height+5+23;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"segue_editopp" sender:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_update_crmopp_browse) name:@"crmopp_update" object:nil];
}
-(void)fn_update_crmopp_browse{
    alist_opp_parameter=[db_crmopp fn_get_crmopp_data:_is_searchBar.text select_sql:select_sql];
    [self fn_init_crmopp_browse_arr:alist_opp_parameter];
    [self.tableview reloadData];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexpath=[self.tableview indexPathForSelectedRow];
    if ([[segue identifier]isEqualToString:@"segue_editopp"]) {
        EditOppViewController *VC=[segue destinationViewController];
        VC.idic_parameter_opp=[alist_opp_parameter objectAtIndex:indexpath.row ];
        VC.flag_can_edit=1;
    }
}
#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    alist_opp_parameter=[db_crmopp fn_get_crmopp_data:searchText select_sql:select_sql];
    [self fn_init_crmopp_browse_arr:alist_opp_parameter];
    [self.tableview reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    alist_opp_parameter=[db_crmopp fn_get_crmopp_data:searchBar.text select_sql:select_sql];
    [self fn_init_crmopp_browse_arr:alist_opp_parameter];
    [self.tableview reloadData];
    [_is_searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [_is_searchBar resignFirstResponder];
}
- (IBAction)fn_advance_search_opp:(id)sender {
    SearchCrmOppViewController *VC=[self.storyboard instantiateViewControllerWithIdentifier:@"SearchCrmOppViewController"];
    VC.callBack=^(NSMutableArray *alist_back){
        alist_opp_parameter=[db_crmopp fn_get_detail_crmopp_data:alist_back select_sql:select_sql];
        [self fn_init_crmopp_browse_arr:alist_opp_parameter];
        [self.tableview reloadData];
    };
    [self presentViewController:VC animated:YES completion:nil];
}
@end

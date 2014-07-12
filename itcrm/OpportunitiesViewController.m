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
#import "Format_conversion.h"
#import "Custom_Color.h"
#import "SearchCrmOppViewController.h"
#import "EditOppViewController.h"
@interface OpportunitiesViewController ()

@property(nonatomic,strong)Format_conversion *format;
@property(nonatomic,strong)DB_crmopp_browse *db_crmopp;
@property (nonatomic,strong) UIImage *opp_image;

@end

@implementation OpportunitiesViewController
@synthesize alist_crmopp_browse;
@synthesize format;
@synthesize db_crmopp;
@synthesize opp_image;
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
    self.tableview.backgroundColor=COLOR_LIGHT_YELLOW;
    _is_searchBar.delegate=self;
    format=[[Format_conversion alloc]init];
    db_crmopp=[[DB_crmopp_browse alloc]init];
    //获取crmopp的参数数据
    NSMutableArray *arr_crmopp=[NSMutableArray array];
    arr_crmopp=[db_crmopp fn_get_crmopp_data:_is_searchBar.text];
    [self fn_init_crmopp_browse_arr:arr_crmopp];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_init_crmopp_browse_arr:(NSMutableArray*)arr_crmopp{
    //获取crmopp列表显示信息的格式
    NSMutableArray *arr_format=[NSMutableArray array];
    DB_formatlist *db_format=[[DB_formatlist alloc]init];
    arr_format=[db_format fn_get_list_data:@"crmacct_opp"];
    if ([arr_format count]!=0) {
        alist_crmopp_browse=[format fn_format_conersion:arr_format browse:arr_crmopp];
        NSString *iconName=[[arr_format objectAtIndex:0]valueForKey:@"icon"];
        NSString *binary_str=[format fn_get_binaryData:iconName];
        opp_image=[format fn_binaryData_convert_image:binary_str];
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
    cell.backgroundColor=COLOR_LIGHT_YELLOW;
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:15.0];
    cell.il_title.text=[[alist_crmopp_browse objectAtIndex:indexPath.row]valueForKey:@"title"];
    cell.il_title.font=font;
    cell.il_show_text.lineBreakMode=NSLineBreakByCharWrapping;
    cell.il_show_text.numberOfLines=0;
    cell.il_show_text.font=font;
    cell.il_show_text.text=[[alist_crmopp_browse objectAtIndex:indexPath.row]valueForKey:@"body"];
    CGFloat height=[format fn_heightWithString:cell.il_show_text.text font:font constrainedToWidth:cell.il_show_text.frame.size.width];
    cell.il_show_text.frame=CGRectMake(cell.il_show_text.frame.origin.x, cell.il_show_text.frame.origin.y, cell.il_show_text.frame.size.width, height);
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma mark UITableViewDelegate
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellText = [[alist_crmopp_browse objectAtIndex:indexPath.row]valueForKey:@"body"];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15.0];
    CGFloat height=[format fn_heightWithString:cellText font:cellFont constrainedToWidth:260.0f];
    return height+10+23;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"segue_editopp" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexpath=[self.tableview indexPathForSelectedRow];
    if ([[segue identifier]isEqualToString:@"segue_editopp"]) {
        EditOppViewController *VC=[segue destinationViewController];
        VC.opp_id=[[[db_crmopp fn_get_crmopp_data:_is_searchBar.text]objectAtIndex:indexpath.row]valueForKey:@"opp_id"];
    }
}
#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self fn_init_crmopp_browse_arr:[db_crmopp fn_get_crmopp_data:searchText]];
    [self.tableview reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self fn_init_crmopp_browse_arr:[db_crmopp fn_get_crmopp_data:searchBar.text]];
    [self.tableview reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [_is_searchBar resignFirstResponder];
}
- (IBAction)fn_advance_search_opp:(id)sender {
    SearchCrmOppViewController *VC=[self.storyboard instantiateViewControllerWithIdentifier:@"SearchCrmOppViewController"];
    PopViewManager *pop=[[PopViewManager alloc]init];
    [pop PopupView:VC Size:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) uponView:self];
}
@end

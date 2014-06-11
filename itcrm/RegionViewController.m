//
//  RegionViewController.m
//  itcrm
//
//  Created by itdept on 14-6-6.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "RegionViewController.h"
#import "DB_Region.h"
#import "Cell_region.h"
#import "MZFormSheetController.h"
#import "AppConstants.h"
#import "Custom_Color.h"
@interface RegionViewController ()

@end

@implementation RegionViewController
@synthesize ilist_region;
@synthesize isel_action;
@synthesize iobj_target;
@synthesize is_placeholder;
@synthesize type;
@synthesize db;
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
    _is_searchBar.placeholder=is_placeholder;
    db=[[DB_Region alloc]init];
    ilist_region=[db fn_get_region_data:type];
    self.tableview.backgroundColor=COLOR_LIGHT_YELLOW1;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [ilist_region count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell_region";
    Cell_region *cell=(Cell_region*)[self.tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"Cell_region" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    cell.il_display.text=[[ilist_region objectAtIndex:indexPath.row]valueForKey:@"display"];
    cell.il_data.text=[[ilist_region objectAtIndex:indexPath.row]valueForKey:@"data"];
    //  cell.image.image=[[ilist_region objectAtIndex:indexPath.row]valueForKey:@"image"];
    // Configure the cell...
    cell.backgroundColor=COLOR_LIGHT_YELLOW1;
    return cell;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dic=[ilist_region objectAtIndex:indexPath.row];
    SuppressPerformSelectorLeakWarning([iobj_target performSelector:isel_action withObject:dic];);
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController* formSheet){}];
}
#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    ilist_region=[db fn_get_lookup_data:searchText type:type];
    
    [_tableview reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [_is_searchBar resignFirstResponder];
}

- (IBAction)fn_return_acctSearch:(id)sender{
     [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController* formSheet){}];
}
@end

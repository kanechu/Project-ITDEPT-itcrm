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
@interface RegionViewController ()

@end

@implementation RegionViewController
@synthesize ilist_region;
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
    
    return cell;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController* formSheet){}];
}
#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    
}


- (IBAction)fn_return_acctSearch:(id)sender{
     [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController* formSheet){}];
}
@end

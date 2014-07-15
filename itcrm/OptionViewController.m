//
//  OptionViewController.m
//  itcrm
//
//  Created by itdept on 14-7-1.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "OptionViewController.h"
#import "Cell_Option.h"
#import "MZFormSheetController.h"
@interface OptionViewController ()

@end

@implementation OptionViewController
@synthesize alist_option;
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
    self.tableview.layer.cornerRadius=5;
    _ibtn_cancel.layer.cornerRadius=5;
    self.view.backgroundColor=[UIColor clearColor];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [alist_option count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_Option_item";
    Cell_Option *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell=[[Cell_Option alloc]init];
    }
    if (_flag==1) {
        cell.il_option_label.text=[[alist_option objectAtIndex:indexPath.row]valueForKey:@"acct_name"];
    }else{
        cell.il_option_label.text=[[alist_option objectAtIndex:indexPath.row]valueForKey:@"display"];
    }
    return cell;
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_callback) {
        _callback([alist_option objectAtIndex:indexPath.row]);
    }
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheet){}];
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier = @"Cell_Option_title";
    Cell_Option *headerView = [self.tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    headerView.il_option_label.text=_lookup_title;
    if (headerView == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (IBAction)fn_Cancel_selection:(id)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheet){}];
}
@end

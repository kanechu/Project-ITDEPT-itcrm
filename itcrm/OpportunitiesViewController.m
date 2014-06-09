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
#import "Cell_opportunities.h"
@interface OpportunitiesViewController ()

@end

@implementation OpportunitiesViewController
@synthesize ilist_accopp_browse;
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
    DB_crmopp_browse *db=[[DB_crmopp_browse alloc]init];
   ilist_accopp_browse=[db fn_get_data];
    NSLog(@"%@",ilist_accopp_browse);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ilist_accopp_browse count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"dfd";
    Cell_opportunities *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell=[[Cell_opportunities alloc]init];
    }
    return cell;
}
#pragma mark UITableViewDelegate

@end

//
//  AccountViewController.m
//  itcrm
//
//  Created by itdept on 14-5-31.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "AccountViewController.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "Cell_search.h"
#import "DB_searchCriteria.h"
@interface AccountViewController ()

@end

@implementation AccountViewController
@synthesize groudarr;
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
    groudarr=@[@"account",@"address"];
    self.skstableView.SKSTableViewDelegate=self;
    //loadview的时候，打开所有expandable
    [self.skstableView fn_expandall];
    DB_searchCriteria *db=[[DB_searchCriteria alloc]init];
    NSLog(@"%@",[db fn_get_all_data]);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
   
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [self.skstableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.text=[groudarr objectAtIndex:indexPath.section];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.expandable=YES;
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"Cell_search1";
    Cell_search *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[Cell_search alloc]init];
    }
    cell.il_prompt_label.text=@"fdlkfjdlfkjdl";
    
   
    // Configure the cell...
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
@end

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
    self.tableview.layer.cornerRadius=1;
    
    _ibtn_cancel.layer.cornerRadius=2;
    _ibtn_cancel.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _ibtn_cancel.layer.borderWidth=0.5;
    
    _ilb_title.layer.cornerRadius=2;
    [self fn_show_different_language];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fn_show_different_language{
    [_ibtn_cancel setTitle:MYLocalizedString(@"lbl_cancel", nil) forState:UIControlStateNormal];
    _ilb_title.text=MYLocalizedString(@"lbl_select", nil);
    
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
    if (indexPath.row%2==0) {
        cell.backgroundColor=COLOR_LIGHT_BLUE;
    }else{
        cell.backgroundColor=COLOR_LIGHT_GRAY;
    }
    if (_flag==1) {
        cell.il_option_label.text=[[alist_option objectAtIndex:indexPath.row]valueForKey:@"acct_name"];
    }else if(_flag==2){
        cell.il_option_label.text=[[alist_option objectAtIndex:indexPath.row]valueForKey:@"sys_code"];
    }else
    {
        cell.il_option_label.text=[[alist_option objectAtIndex:indexPath.row]valueForKey:@"display"];
    }
    return cell;
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *idic_option=[alist_option objectAtIndex:indexPath.row];
    if (_callback) {
        _callback(idic_option);
    }
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheet){}];
}

- (IBAction)fn_Cancel_selection:(id)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheet){}];
}
@end

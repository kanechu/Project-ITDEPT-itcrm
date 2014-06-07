//
//  RegionViewController.h
//  itcrm
//
//  Created by itdept on 14-6-6.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DB_Region;
@interface RegionViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property(nonatomic,strong)NSMutableArray *ilist_region;

@property (strong,nonatomic) id iobj_target;
@property (nonatomic, assign) SEL isel_action;
@property (nonatomic,copy)NSString *is_placeholder;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,strong)DB_Region *db;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)fn_return_acctSearch:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *is_searchBar;

@end

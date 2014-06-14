//
//  OpportunitiesViewController.h
//  itcrm
//
//  Created by itdept on 14-6-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Format_conversion;
@class DB_crmopp_browse;
@interface OpportunitiesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property(nonatomic,strong)Format_conversion *format;
@property(nonatomic,strong)DB_crmopp_browse *db_crmopp;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *alist_crmopp_browse;
@property (weak, nonatomic) IBOutlet UISearchBar *is_searchBar;

@end

//
//  ShipmentHistoryViewController.h
//  itcrm
//
//  Created by itdept on 14-6-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ShipmentHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,strong)NSMutableArray *alist_crmhbl;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISearchBar *is_searchbar;

@end

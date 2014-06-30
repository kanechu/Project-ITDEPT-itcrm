//
//  RegionViewController.h
//  itcrm
//
//  Created by itdept on 14-6-6.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CallBack_region)(NSMutableDictionary* dic);
@interface RegionViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property(nonatomic,strong)CallBack_region callback_region;
@property(nonatomic,strong)NSMutableArray *ilist_region;

@property (nonatomic,copy)NSString *is_placeholder;
@property (nonatomic,copy)NSString *type;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UINavigationBar *inav_navigationbar;
- (IBAction)fn_return_acctSearch:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *is_searchBar;

@end

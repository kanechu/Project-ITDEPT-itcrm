//
//  SearchCrmOppViewController.h
//  itcrm
//
//  Created by itdept on 14-7-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
typedef void (^callBack_opp)(NSMutableArray *alist_searchData);
@interface SearchCrmOppViewController : UIViewController<SKSTableViewDelegate>
@property (nonatomic,strong)callBack_opp callBack;
@property (weak, nonatomic) IBOutlet UINavigationItem *i_navigationItem;

@property (weak, nonatomic) IBOutlet SKSTableView *skstableView;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_search;
- (IBAction)fn_go_back:(id)sender;
- (IBAction)fn_search_opp:(id)sender;
- (IBAction)fn_lookup_opp:(id)sender;

@end

//
//  SearchCrmOppViewController.h
//  itcrm
//
//  Created by itdept on 14-7-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
@interface SearchCrmOppViewController : UIViewController<SKSTableViewDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *inav_bar;
@property (weak, nonatomic) IBOutlet SKSTableView *skstableView;
- (IBAction)fn_go_back:(id)sender;
- (IBAction)fn_search_opp:(id)sender;
- (IBAction)fn_lookup_opp:(id)sender;

@end

//
//  SearchCrmContactViewController.h
//  itcrm
//
//  Created by itdept on 14-7-11.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
typedef void (^callBack_contact)(NSMutableArray *);
@interface SearchCrmContactViewController : UIViewController<SKSTableViewDelegate,UITextFieldDelegate>
@property (strong,nonatomic)callBack_contact callback;

@property (weak, nonatomic) IBOutlet UINavigationItem *i_navigationItem;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_search;
@property (weak, nonatomic) IBOutlet SKSTableView *skstableView;
- (IBAction)fn_go_back:(id)sender;

- (IBAction)fn_textfield_endEdit:(id)sender;
- (IBAction)fn_search_crmContact:(id)sender;

@end

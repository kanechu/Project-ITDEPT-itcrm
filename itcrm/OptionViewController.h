//
//  OptionViewController.h
//  itcrm
//
//  Created by itdept on 14-7-1.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CallBack_option)(NSMutableDictionary *idic_option_value);
@interface OptionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) CallBack_option callback;
@property (strong,nonatomic) NSMutableArray *alist_option;
@property (assign,nonatomic)NSInteger flag;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_cancel;
@property (weak, nonatomic) IBOutlet UILabel *ilb_title;

- (IBAction)fn_Cancel_selection:(id)sender;
@end

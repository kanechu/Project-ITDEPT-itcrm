//
//  MaintFormViewController.h
//  itcrm
//
//  Created by itdept on 14-6-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
@interface MaintFormViewController : UIViewController<SKSTableViewDelegate,UITextViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet SKSTableView *skstableView;
@property (nonatomic,strong)NSMutableArray *alist_maintForm;
//过滤后的数组
@property (nonatomic,strong)NSMutableArray *alist_filtered_data;
@property (nonatomic,strong)NSMutableArray *alist_groupNameAndNum;
@property (nonatomic,strong)NSString *is_acct_id;
- (IBAction)fn_show_actionSheet:(id)sender;

- (IBAction)fn_lookup_data:(id)sender;
@end

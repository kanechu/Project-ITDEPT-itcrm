//
//  EditOppViewController.h
//  itcrm
//
//  Created by itdept on 14-7-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
@interface EditOppViewController : UIViewController<SKSTableViewDelegate,UITextViewDelegate,UIAlertViewDelegate>
@property (nonatomic,copy) NSString *opp_id;
@property (weak, nonatomic) IBOutlet SKSTableView *skstableView;
- (IBAction)fn_save_modified_data:(id)sender;
- (IBAction)fn_lookup_data:(id)sender;

@end

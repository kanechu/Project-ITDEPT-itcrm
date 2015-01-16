//
//  EditContactViewController.h
//  itcrm
//
//  Created by itdept on 14-7-11.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
@interface EditContactViewController : UIViewController<SKSTableViewDelegate,UITextViewDelegate,UIAlertViewDelegate>

@property(nonatomic,copy)NSString *is_contact_id;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_save;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *ibtn_cancel;
@property (weak, nonatomic) IBOutlet SKSTableView *skstableView;

- (IBAction)fn_save_modified_contact:(id)sender;
- (IBAction)fn_cancel_edited_data:(id)sender;

- (IBAction)fn_lookup_data:(id)sender;
@end

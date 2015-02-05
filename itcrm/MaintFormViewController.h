//
//  MaintFormViewController.h
//  itcrm
//
//  Created by itdept on 14-6-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
#import "Resp_crmacct_dowload.h"

@interface MaintFormViewController : UIViewController<SKSTableViewDelegate,UITextViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet SKSTableView *skstableView;
@property (nonatomic,assign) NSInteger flag_isDowload;
@property (nonatomic,strong)NSString *is_acct_id;
@property (nonatomic,strong)NSMutableDictionary *idic_modified_value;
@property (nonatomic,strong)Resp_crmacct_dowload *resp_download;

- (IBAction)fn_show_actionSheet:(id)sender;

- (IBAction)fn_lookup_data:(id)sender;

@end

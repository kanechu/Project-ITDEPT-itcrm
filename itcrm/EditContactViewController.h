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

//标识该版面是用于修改还是添加
@property (nonatomic,assign)NSInteger add_contact_flag;
//标识该版面是用于编辑还是只能预览 1表示可以编辑，0只能预览
@property (nonatomic,assign)NSInteger flag_can_edit;
@property(nonatomic,strong)NSMutableDictionary *idic_parameter_contact;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_save;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *ibtn_cancel;
@property (weak, nonatomic) IBOutlet SKSTableView *skstableView;

- (IBAction)fn_save_modified_contact:(id)sender;
- (IBAction)fn_cancel_edited_data:(id)sender;

@end

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

//标识该版面是用于修改还是添加
@property (nonatomic,assign)NSInteger add_opp_flag;
//标识该版面是用于编辑还是预览
@property (nonatomic,assign)NSInteger flag_can_edit;
@property (nonatomic,strong)NSMutableDictionary *idic_parameter_opp;

@property (weak, nonatomic) IBOutlet SKSTableView *skstableView;

@end

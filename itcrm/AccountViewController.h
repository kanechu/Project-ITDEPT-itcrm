//
//  AccountViewController.h
//  itcrm
//
//  Created by itdept on 14-5-31.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
//定义回调函数
typedef void (^CallBack_acct)(NSMutableArray * arr);
@interface AccountViewController : UIViewController<SKSTableViewDelegate,UITextFieldDelegate>
//设置一个属性
@property (nonatomic,strong)CallBack_acct callback_acct;
//获取搜索标准数据
@property(nonatomic,strong)NSMutableArray *alist_searchCriteria;
//按组名过滤后的搜索标准数据
@property(nonatomic,strong)NSMutableArray *alist_filtered_data;
//存储搜索标准的组名和该组的行数
@property(nonatomic,strong)NSMutableArray *alist_groupNameAndNum;
//存储搜索条件的数据
@property(nonatomic,strong)NSMutableDictionary *idic_search_value;
//存储搜索条件的参数
@property(nonatomic,strong)NSMutableDictionary *idic_parameter;
//用来标识点击哪个uitextfield
@property (nonatomic,weak)UITextField *checkText;

@property (weak, nonatomic) IBOutlet UINavigationBar *inav_navBar;
@property (weak, nonatomic) IBOutlet SKSTableView *skstableView;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_clear;

- (IBAction)fn_search_account:(id)sender;
- (IBAction)fn_go_back:(id)sender;
- (IBAction)fn_skip_region:(id)sender;
- (IBAction)fn_textfield_endEdit:(id)sender;
- (IBAction)fn_clear_input_data:(id)sender;

@end

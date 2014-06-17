//
//  AccountViewController.h
//  itcrm
//
//  Created by itdept on 14-5-31.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
@interface AccountViewController : UIViewController<SKSTableViewDelegate,UITextFieldDelegate>
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
//用来记录选择的countryname
@property (strong,nonatomic)NSMutableDictionary *idic_countryname;
//用来记录选择的regionname
@property (strong,nonatomic)NSMutableDictionary *idic_regionname;
//用来记录选择的territoryname
@property (strong,nonatomic)NSMutableDictionary *idic_territoryname;
//用来标识点击哪个uitextfield
@property (nonatomic,weak)UITextField *checkText;

@property (strong,nonatomic) id iobj_target;
@property (nonatomic, assign) SEL isel_action1;

@property (weak, nonatomic) IBOutlet SKSTableView *skstableView;
- (IBAction)fn_search_account:(id)sender;
- (IBAction)fn_go_back:(id)sender;
- (IBAction)fn_skip_region:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *inav_navBar;
- (IBAction)fn_textfield_endEdit:(id)sender;

@end

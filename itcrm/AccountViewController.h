//
//  AccountViewController.h
//  itcrm
//
//  Created by itdept on 14-5-31.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
@interface AccountViewController : UIViewController<SKSTableViewDelegate>
//获取搜索标准数据
@property(nonatomic,strong)NSMutableArray *alist_searchCriteria;
//按组名过滤后的搜索标准数据
@property(nonatomic,strong)NSMutableArray *alist_filtered_data;
//存储搜索标准的组名和该组的行数
@property(nonatomic,strong)NSMutableArray *alist_groupNameAndNum;
//用来记录选择的countryname
@property (copy,nonatomic)NSMutableDictionary *idic_countryname;
//用来记录选择的regionname
@property (copy,nonatomic)NSMutableDictionary *idic_regionname;
//用来记录选择的territoryname
@property (copy,nonatomic)NSMutableDictionary *idic_territoryname;

@property (weak, nonatomic) IBOutlet SKSTableView *skstableView;
- (IBAction)fn_search_account:(id)sender;
- (IBAction)fn_go_back:(id)sender;
- (IBAction)fn_skip_region:(id)sender;

@end

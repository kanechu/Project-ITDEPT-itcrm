//
//  SearchTaskViewController.h
//  itcrm
//
//  Created by itdept on 14-6-13.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
@interface SearchTaskViewController : UIViewController<SKSTableViewDelegate>

//获取task搜索标准数据
@property(nonatomic,strong)NSMutableArray *alist_searchCriteria;
//按组名过滤后的搜索标准数据
@property(nonatomic,strong)NSMutableArray *alist_filtered_data;
//存储task搜索标准的组名和该组的行数
@property(nonatomic,strong)NSMutableArray *alist_groupNameAndNum;
@property (weak, nonatomic) IBOutlet SKSTableView *skstableview;

- (IBAction)fn_search_task:(id)sender;
- (IBAction)fn_go_back:(id)sender;

@end

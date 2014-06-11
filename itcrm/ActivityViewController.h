//
//  ActivityViewController.h
//  itcrm
//
//  Created by itdept on 14-5-31.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Format_conversion;
@interface ActivityViewController : UITableViewController
@property(nonatomic,strong)Format_conversion *format;
@property(nonatomic,strong)NSMutableArray *alist_crmtask;

@end

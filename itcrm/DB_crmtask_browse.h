//
//  DB_crmtask_browse.h
//  itcrm
//
//  Created by itdept on 14-6-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBManager;
@interface DB_crmtask_browse : NSObject

@property(nonatomic,strong)DBManager *idb;

-(BOOL)fn_save_crmtask_browse:(NSMutableArray*)alist_result;
-(NSMutableArray*)fn_get_crmtask_data;
-(BOOL)fn_delete_all_data;

@end

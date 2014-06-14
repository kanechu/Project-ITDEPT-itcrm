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

-(NSMutableArray*)fn_get_search_crmtask_data:(NSString*)task_ref_name;

-(BOOL)fn_delete_all_data;

-(NSMutableArray*)fn_get_detail_crmtask_data:(NSMutableArray*)arr_parameter value:(NSMutableArray*)arr_value;
@end

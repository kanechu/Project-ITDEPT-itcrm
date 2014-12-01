//
//  DB_crmtask_browse.h
//  itcrm
//
//  Created by itdept on 14-6-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatabaseQueue;
@interface DB_crmtask_browse : NSObject

@property(nonatomic,strong)DatabaseQueue *queue;

-(BOOL)fn_save_crmtask_browse:(NSMutableArray*)alist_result;

-(BOOL)fn_update_crmtask_browse:(NSMutableDictionary*)idic_update unique_id:(NSString*)unique_id;

-(BOOL)fn_update_crmtask_ismodified:(NSString*)is_modified unique_id:(NSString*)unique_id;

-(NSMutableArray*)fn_get_search_crmtask_data:(NSString*)task_ref_name select_sql:(NSString *)select_sql;

-(NSMutableArray*)fn_get_detail_crmtask_data:(NSMutableArray*)alist_searchData select_sql:(NSString *)select_sql;

-(NSMutableArray*)fn_get_relate_crmtask_data:(NSString *)task_ref_id select_sql:(NSString *)select_sql;

-(NSMutableArray*)fn_get_crmtask_data_from_id:(NSString*)task_id;

-(NSMutableArray*)fn_get_all_crmtask_data;

-(BOOL)fn_delete_all_data;

@end

//
//  DB_crmcontact_browse.h
//  itcrm
//
//  Created by itdept on 14-7-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatabaseQueue;
@interface DB_crmcontact_browse : NSObject
@property(nonatomic,strong)DatabaseQueue *queue;

-(BOOL)fn_save_crmcontact_browse:(NSMutableArray*)alist_result;

-(BOOL)fn_update_crmcontact_browse:(NSMutableDictionary*)idic_update unique_id:(NSString*)unique_id;

-(BOOL)fn_update_crmcontact_ismodified:(NSString*)is_modified contact_id:(NSString*)contact_id;

-(NSMutableArray*)fn_get_crmcontact_browse_data:(NSString*)contact_name select_sql:(NSString *)select_sql;

-(NSMutableArray*)fn_get_detail_crmcontact_data:(NSMutableArray*)alist_searchData select_sql:(NSString*)select_sql;

-(NSMutableArray*)fn_get_crmcontact_browse:(NSString*)contact_id;

-(NSMutableArray*)fn_get_relate_crmcontact_data:(NSString *)contact_ref_id select_sql:(NSString *)select_sql;

-(NSMutableArray*)fn_get_need_sync_crmcontact:(NSString*)acct_id;

-(BOOL)fn_delete_relate_crmcontact_data:(NSString*)acct_id;

-(BOOL)fn_delete_all_crmcontact_data;

@end

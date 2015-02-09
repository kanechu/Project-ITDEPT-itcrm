//
//  DB_crmacct_browse.h
//  itcrm
//
//  Created by itdept on 14-6-4.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatabaseQueue;
typedef NS_ENUM(NSInteger, kOperation_type){
    kDownload_acct,
    kUpdate_acct,
    kNon_operation
};
@interface DB_crmacct_browse : NSObject
@property(nonatomic,strong)DatabaseQueue *queue;

-(BOOL)fn_save_crmacct_browse:(NSMutableArray*)alist_result;

-(NSMutableArray*)fn_get_data:(NSString*)acct_name select_sql:(NSString*)select_sql;

-(NSMutableArray*)fn_get_detail_crmacct_data:(NSMutableArray*)alist_searchData select_sql:(NSString*)select_sql;

-(NSMutableArray*)fn_get_data_from_id:(NSString*)acct_id;

-(NSMutableArray*)fn_get_acct_nameAndid;

-(BOOL)fn_delete_all_data;

-(BOOL)fn_delete_single_acct_data:(NSString*)acct_id;

-(kOperation_type)fn_is_need_sync:(NSString*)max_upd_date acct_id:(NSString*)acct_id;

@end

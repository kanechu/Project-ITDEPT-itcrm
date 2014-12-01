//
//  DB_crmhbl_browse.h
//  itcrm
//
//  Created by itdept on 14-6-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatabaseQueue;
@interface DB_crmhbl_browse : NSObject
@property(nonatomic,strong)DatabaseQueue *queue;

-(BOOL)fn_save_crmhbl_browse:(NSMutableArray*)alist_result;

-(NSMutableArray*)fn_get_crmhbl_data:(NSString*)acct_name;

-(NSMutableArray*)fn_get_relate_crmhbl_data:(NSString *)acct_id select_sql:(NSString *)select_sql;

-(BOOL)fn_delete_all_data;

@end

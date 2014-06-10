//
//  DB_crmtask_browse.m
//  itcrm
//
//  Created by itdept on 14-6-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_crmtask_browse.h"
#import "DBManager.h"
#import "FMDatabaseAdditions.h"
#import "RespCrmtask_browse.h"
#import "NSDictionary.h"
@implementation DB_crmtask_browse
@synthesize idb;
-(id)init{
    idb=[DBManager getSharedInstance];
    return self;
}

-(BOOL)fn_save_crmtask_browse:(NSMutableArray*)alist_result{
    if ([[idb fn_get_db] open]) {
        for (Respcrmtask_browse *lmap_data in alist_result) {
            NSMutableDictionary *ldict_row=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
         
            BOOL ib_updated =[[idb fn_get_db] executeUpdate:@"insert into crmtask_browse (uid, task_id, task_ref_id, task_ref_type, task_ref_code,task_ref_name, contact_id, contact_code, contact_name, contact_email, contact_mobile, contact_tel, task_ref_addr, task_ref_addr_01, task_ref_addr_02, task_ref_addr_03, task_ref_addr_04, task_title,task_desc, task_start_date, task_end_date, task_report, task_sm_report, duration_ttl, duration_hr, duration_min, duration_str, assign_to, assign_to_name, voided, rec_crt_user, rec_upd_user,rec_crt_date, rec_upd_date, rec_upd_type, rec_savable, rec_deletable, task_type, task_type_desc, task_status, task_status_desc, task_date_period,report_mail, report_submit) values (:uid, :task_id, :task_ref_id, :task_ref_type, :task_ref_code,:task_ref_name, :contact_id, :contact_code, :contact_name, :contact_email, :contact_mobile, :contact_tel, :task_ref_addr, :task_ref_addr_01, :task_ref_addr_02, :task_ref_addr_03, :task_ref_addr_04, :task_title,:task_desc, :task_start_date, :task_end_date, :task_report, :task_sm_report, :duration_ttl, :duration_hr, :duration_min, :duration_str, :assign_to, :assign_to_name, :voided, :rec_crt_user, :rec_upd_user,:rec_crt_date, :rec_upd_date, :rec_upd_type, :rec_savable, :rec_deletable, :task_type, :task_type_desc, :task_status, :task_status_desc, :task_date_period,:report_mail, :report_submit)" withParameterDictionary:ldict_row];
            if (! ib_updated)
                return NO;
        }
        [[idb fn_get_db] close];
        return  YES;
    }
    return NO;
}
-(NSMutableArray*)fn_get_crmtask_data{
    NSMutableArray *arr=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *lfmdb_result=[[idb fn_get_db]executeQuery:@"select * from crmtask_browse"];
        while ([lfmdb_result next]) {
            [arr addObject:[lfmdb_result resultDictionary]];
        }
        [[idb fn_get_db]close];
    }
      return arr;
}
-(BOOL)fn_delete_all_data{
    if ([[idb fn_get_db]open]) {
        BOOL isSuccess=[[idb fn_get_db]executeUpdate:@"delete from crmtask_browse"];
        if (!isSuccess) {
            return NO;
        }
        [[idb fn_get_db]close];
        return YES;
    }
    return NO;
}

@end

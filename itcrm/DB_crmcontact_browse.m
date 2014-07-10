//
//  DB_crmcontact_browse.m
//  itcrm
//
//  Created by itdept on 14-7-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_crmcontact_browse.h"
#import "DBManager.h"
#import "NSDictionary.h"
#import "FMDatabaseAdditions.h"
#import "RespCrmcontact_browse.h"
@implementation DB_crmcontact_browse
@synthesize idb;
-(id)init{
    idb=[DBManager getSharedInstance];
    return self;
};
-(BOOL)fn_save_crmcontact_browse:(NSMutableArray*)alist_result{
    if ([[idb fn_get_db]open]) {
        for (RespCrmcontact_browse *lmap_data in alist_result) {
            NSMutableDictionary *idic_contact=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
            BOOL ib_updated =[[idb fn_get_db] executeUpdate:@"insert into crmcontact_browse (uid,contact_id,contact_code,contact_type,contact_ref_id,contact_ref_name,contact_ref_code,contact_name,contact_title,contact_dept,contact_mobile,contact_tel,contact_fax,contact_email,contact_language,lang_desc,assign_to,assign_to_name,voided,rec_crt_user,rec_upd_user,rec_crt_date,rec_upd_date,rec_upd_type,rec_savable,rec_deletable) values (:uid,:contact_id,:contact_code,:contact_type,:contact_ref_id,:contact_ref_name,:contact_ref_code,:contact_name,:contact_title,:contact_dept,:contact_mobile,:contact_tel,:contact_fax,:contact_email,:contact_language,:lang_desc,:assign_to,:assign_to_name,:voided,:rec_crt_user,:rec_upd_user,:rec_crt_date,:rec_upd_date,:rec_upd_type,:rec_savable,:rec_deletable)" withParameterDictionary:idic_contact];
            if (!ib_updated) {
                return NO;
            }
        }
        [[idb fn_get_db]close];
        return YES;
    }
    return NO;
}
-(NSMutableArray*)fn_get_crmcontact_browse_data:(NSString*)contact_ref_name select_sql:(NSString *)select_sql{
    NSString *sql=[NSString stringWithFormat:@"select %@ from crmcontact_browse where contact_ref_name like ?",select_sql];
    NSMutableArray *arr_crmcontact=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *lfmdb_result=[[idb fn_get_db]executeQuery:sql,[NSString stringWithFormat:@"%%%@%%",contact_ref_name]];
        while ([lfmdb_result next]) {
            [arr_crmcontact addObject:[lfmdb_result resultDictionary]];
        }
    }
    return arr_crmcontact;
}
-(BOOL)fn_delete_all_crmcontact_data{
    if ([[idb fn_get_db]open]) {
        BOOL isSuccess=[[idb fn_get_db]executeUpdate:@"delete from crmcontact_browse"];
        if (!isSuccess) {
            return NO;
        }
        [[idb fn_get_db]close];
        return YES;
    }
    return NO;
}

@end

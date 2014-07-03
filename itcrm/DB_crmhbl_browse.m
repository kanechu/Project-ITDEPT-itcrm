//
//  DB_crmhbl_browse.m
//  itcrm
//
//  Created by itdept on 14-6-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_crmhbl_browse.h"
#import "DBManager.h"
#import "FMDatabaseAdditions.h"
#import "RespCrmhbl_browse.h"
#import "NSDictionary.h"

@implementation DB_crmhbl_browse
@synthesize idb;
-(id)init{
    idb=[DBManager getSharedInstance];
    return self;
}
-(BOOL)fn_save_crmhbl_browse:(NSMutableArray*)alist_result{
    if ([[idb fn_get_db] open]) {
        for (RespCrmhbl_browse *lmap_data in alist_result) {
            NSMutableDictionary *ldict_row=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
            BOOL ib_delete =[[idb fn_get_db] executeUpdate:@"delete from crmhbl_browse where acct_id = :acct_id and hbl_uid = :hbl_uid and acct_name = :acct_name and op_type = :op_type and desc = :desc " withParameterDictionary:ldict_row];
            if (! ib_delete)
                return NO;
            BOOL ib_updated =[[idb fn_get_db] executeUpdate:@"insert into crmhbl_browse (acct_id, hbl_uid, acct_name,op_type,desc) values (:acct_id, :hbl_uid, :acct_name,:op_type,:desc)" withParameterDictionary:ldict_row];
            if (! ib_updated)
                return NO;
            
        }
        [[idb fn_get_db] close];
        return  YES;
    }
    return NO;
}

-(BOOL)fn_delete_all_data{
    if ([[idb fn_get_db]open]) {
        BOOL isSuccess=[[idb fn_get_db]executeUpdate:@"delete from  crmhbl_browse"];
        if (!isSuccess) {
            return NO;
        }
        [[idb fn_get_db]close];
        return YES;
    }
    return NO;
}

-(NSMutableArray*)fn_get_crmhbl_data:(NSString*)acct_name{
    NSMutableArray *arr=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *fmdb_result=[[idb fn_get_db]executeQuery:@"select * from crmhbl_browse where acct_name like ?",[NSString stringWithFormat:@"%@%%",acct_name]];
        while ([fmdb_result next]) {
            [arr addObject:[fmdb_result resultDictionary]];
        }
        [[idb fn_get_db]close];
    }
    return arr;
}
-(NSMutableArray*)fn_get_relate_crmhbl_data:(NSString *)acct_id select_sql:(NSString *)select_sql{
    NSString *is_sql=[NSString stringWithFormat:@"select %@ from crmhbl_browse where acct_id like ?",select_sql];
    NSMutableArray *arr=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *fmdb_result=[[idb fn_get_db]executeQuery:is_sql,[NSString stringWithFormat:@"%@",acct_id]];
        while ([fmdb_result next]) {
            [arr addObject:[fmdb_result resultDictionary]];
        }
        [[idb fn_get_db]close];
    }
    return arr;
}


@end

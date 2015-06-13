//
//  DB_crmhbl_browse.m
//  itcrm
//
//  Created by itdept on 14-6-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_crmhbl_browse.h"
#import "DatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "RespCrmhbl_browse.h"

@implementation DB_crmhbl_browse
@synthesize queue;
-(id)init{
    self=[super init];
    if (self) {
        queue=[DatabaseQueue fn_sharedInstance];
    }
    return self;
}
-(BOOL)fn_save_crmhbl_browse:(NSMutableArray*)alist_result{
    __block BOOL ib_updated=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            [db beginTransaction];
            BOOL isRollBack=NO;
            @try {
                for (RespCrmhbl_browse *lmap_data in alist_result) {
                    NSMutableDictionary *ldict_row=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
                    ib_updated =[db executeUpdate:@"delete from crmhbl_browse where acct_id = :acct_id and hbl_uid = :hbl_uid and acct_name = :acct_name and op_type = :op_type and desc = :desc and hbl_update_date = :hbl_update_date" withParameterDictionary:ldict_row];
                    ib_updated =[db executeUpdate:@"insert into crmhbl_browse (acct_id, hbl_uid, acct_name,op_type,desc,hbl_update_date) values (:acct_id, :hbl_uid, :acct_name,:op_type,:desc,:hbl_update_date)" withParameterDictionary:ldict_row];
                }
                
            }
            @catch (NSException *exception) {
                isRollBack=YES;
                [db rollback];
            }
            @finally {
                if (!isRollBack) {
                    [db commit];
                }
            }
            [db close];
        }
        
    }];
    return ib_updated;
    
}

-(BOOL)fn_delete_all_data{
    __block BOOL ib_deleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            ib_deleted=[db executeUpdate:@"delete from  crmhbl_browse"];
            [db close];
        }
        
    }];
    return ib_deleted;
}
-(BOOL)fn_delete_relate_hbl_data:(NSString*)acct_id{
    __block BOOL ib_deleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            ib_deleted=[db executeUpdate:@"delete from  crmhbl_browse  where acct_id like ?",acct_id];
            [db close];
        }
        
    }];
    return ib_deleted;
}

-(NSMutableArray*)fn_get_crmhbl_data:(NSString*)acct_name{
    __block NSMutableArray *arr=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *fmdb_result=[db executeQuery:@"select * from crmhbl_browse where acct_name like ?",[NSString stringWithFormat:@"%@%%",acct_name]];
            while ([fmdb_result next]) {
                [arr addObject:[fmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return arr;
}
-(NSMutableArray*)fn_get_relate_crmhbl_data:(NSString *)acct_id select_sql:(NSString *)select_sql{
    NSString *is_sql=[NSString stringWithFormat:@"select %@ from crmhbl_browse where acct_id like ? limit 50",select_sql];
    __block NSMutableArray *arr=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *fmdb_result=[db executeQuery:is_sql,[NSString stringWithFormat:@"%@",acct_id]];
            while ([fmdb_result next]) {
                [arr addObject:[fmdb_result resultDictionary]];
            }
            [db close];
        }
        
    }];
    return arr;
}


@end

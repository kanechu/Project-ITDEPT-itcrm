//
//  DB_systemIcon.m
//  itcrm
//
//  Created by itdept on 14-6-6.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_systemIcon.h"
#import "DatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "RespSystemIcon.h"
@implementation DB_systemIcon
@synthesize queue;
-(id)init{
    self=[super init];
    if (self) {
        queue=[DatabaseQueue fn_sharedInstance];
    }
    return self;
}
-(BOOL)fn_save_systemIcon_data:(NSMutableArray*)ilist_result{
    __block BOOL ib_updated=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            for (RespSystemIcon *lmap_data in ilist_result) {
                NSMutableDictionary *ldict_row=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
                ib_updated =[db executeUpdate:@"delete from systemIcon where ic_name = :ic_name and ic_content = :ic_content and upd_date = :upd_date " withParameterDictionary:ldict_row];
                ib_updated =[db executeUpdate:@"insert into systemIcon (ic_name, ic_content, upd_date) values (:ic_name, :ic_content, :upd_date)" withParameterDictionary:ldict_row];
            }
            [db close];
        }
        
    }];
    return ib_updated;
}
-(BOOL)fn_update_systemIcon_data:(NSString*)ic_content ic_name:(NSString*)ic_name{
    __block BOOL ib_updated=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            ib_updated=[db executeUpdate:@"update systemIcon set ic_content=? where ic_name=?",[NSString stringWithFormat:@"%@",ic_content],[NSString stringWithFormat:@"%@",ic_name]];
            [db close];
        }
    }];
    return ib_updated;
    
}
-(NSMutableArray*)fn_get_systemIcon_data:(NSString*)ic_name{
    __block NSMutableArray *arr=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from systemIcon where ic_name like ?",ic_name];
            while ([lfmdb_result next]) {
                [arr addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
        
    }];
    return arr;
}
-(BOOL)fn_delete_systemIcon_data{
    __block BOOL ib_deleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            ib_deleted=[db executeUpdate:@"delete from systemIcon"];
            [db close];
        }
        
    }];
    return ib_deleted;
}
-(NSMutableArray*)fn_get_last_update_time{
    __block NSMutableArray *arr=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *fmdb_result=[db executeQuery:@"select MAX(upd_date)  as recent_date from systemIcon"];
            while ([fmdb_result next]) {
                [arr addObject:[fmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return arr;
}
@end

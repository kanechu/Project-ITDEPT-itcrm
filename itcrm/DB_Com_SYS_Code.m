//
//  DB_Com_SYS_Code.m
//  itcrm
//
//  Created by itdept on 14-8-29.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_Com_SYS_Code.h"
#import "DatabaseQueue.h"
#import "FMDatabaseAdditions.h"
@implementation DB_Com_SYS_Code
@synthesize queue;

-(id)init{
    self=[super init];
    if (self) {
        queue=[DatabaseQueue fn_sharedInstance];
    }
    return self;
}
-(BOOL)fn_save_com_sys_code:(NSString*)sys_code lang_code:(NSString*)lang_code{
    __block BOOL ib_updated=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            ib_updated=[db executeUpdate:@"delete from com_sys_code where sys_code =? and lang_code=?",sys_code,lang_code];
            
            NSString *insertSql=[NSString stringWithFormat:@"insert into com_sys_code(sys_code,lang_code)values(\"%@\",\"%@\")",sys_code,lang_code];
            ib_updated=[db executeUpdate:insertSql];
            [db close];
        }
        
    }];
    return ib_updated;
}
-(NSMutableArray*)fn_get_com_sys_code:(NSString*)lang_code{
    __block NSMutableArray *arr_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from com_sys_code where lang_code like ?",lang_code];
            while ([lfmdb_result next]) {
                [arr_result addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    
    return arr_result;
}

-(BOOL)fn_delete_all_com_sys_code{
    __block BOOL ib_deleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            ib_deleted=[db executeUpdate:@"delete from com_sys_code"];
            [db close];
        }
    }];
    return ib_deleted;
}
@end

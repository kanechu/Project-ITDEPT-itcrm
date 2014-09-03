//
//  DB_Com_SYS_Code.m
//  itcrm
//
//  Created by itdept on 14-8-29.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_Com_SYS_Code.h"
#import "DBManager.h"
#import "FMDatabaseAdditions.h"
@implementation DB_Com_SYS_Code
@synthesize idb;

-(id)init{
    idb=[DBManager getSharedInstance];
    return self;
}
-(BOOL)fn_save_com_sys_code:(NSString*)sys_code lang_code:(NSString*)lang_code{
    if ([[idb fn_get_db]open]) {
        BOOL isDelete=[[idb fn_get_db]executeUpdate:@"delete from com_sys_code where sys_code =? and lang_code=?",sys_code,lang_code];
        if (!isDelete) {
            return NO;
        }
        NSString *insertSql=[NSString stringWithFormat:@"insert into com_sys_code(sys_code,lang_code)values(\"%@\",\"%@\")",sys_code,lang_code];
        BOOL isSuccess=[[idb fn_get_db]executeUpdate:insertSql];
        if (!isSuccess) {
            return NO;
        }
        [[idb fn_get_db]close];
        return YES;
    }
    return NO;
}
-(NSMutableArray*)fn_get_com_sys_code:(NSString*)lang_code{
    NSMutableArray *arr_result=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *lfmdb_result=[[idb fn_get_db]executeQuery:@"select * from com_sys_code where lang_code like ?",lang_code];
        while ([lfmdb_result next]) {
            [arr_result addObject:[lfmdb_result resultDictionary]];
        }
        [[idb fn_get_db]close];
    }
    return arr_result;
}

-(BOOL)fn_delete_all_com_sys_code{
    if ([[idb fn_get_db]open]) {
        BOOL isDelete=[[idb fn_get_db]executeUpdate:@"delete from com_sys_code"];
        if (!isDelete) {
            return NO;
        }
        [[idb fn_get_db]close];
        return YES;
    }
    return NO;
}
@end

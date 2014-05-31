//
//  DB_RespLogin.m
//  itcrm
//
//  Created by itdept on 14-5-30.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_RespLogin.h"
#import "DBManager.h"
#import "FMDatabaseAdditions.h"
#import "RespLogin.h"
#import "NSDictionary.h"
@implementation DB_RespLogin
@synthesize idb;

-(id)init{
    idb=[DBManager getSharedInstance];
    return self;
}
-(BOOL)fn_save_data:(NSMutableArray*)arr{
    if ([[idb fn_get_db] open]) {
        for (RespLogin *lmap_data in arr) {
            NSMutableDictionary *ldict_row=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
            BOOL ib_delete =[[idb fn_get_db] executeUpdate:@"delete from Resplogin where company_code = :company_code and sys_name = :sys_name and env = :env and web_addr =:web_addr" withParameterDictionary:ldict_row];
            if (! ib_delete)
                return NO;
            BOOL ib_updated =[[idb fn_get_db] executeUpdate:@"insert into Resplogin (company_code, sys_name, env, web_addr) values (:company_code, :sys_name, :env, :web_addr)" withParameterDictionary:ldict_row];
            if (! ib_updated)
                return NO;
            
        }
        [[idb fn_get_db] close];
        return  YES;
    }
    return NO;
}

-(NSMutableArray*)fn_get_all_data{
    NSMutableArray *llist_result=[NSMutableArray array];
    if ([[idb fn_get_db] open]) {
        FMResultSet *lfmdb_result=[[idb fn_get_db] executeQuery:@"SELECT * FROM Resplogin"];
        while ([lfmdb_result next]) {
            [llist_result addObject:[lfmdb_result resultDictionary]];
        }
        [[idb fn_get_db] close];
    }
    return llist_result;
}
-(BOOL)fn_delete_all_data{
    if ([[idb fn_get_db]open]) {
      BOOL isSuccess=[[idb fn_get_db]executeUpdate:@"delete from Resplogin"];
        if (!isSuccess) {
            return NO;
        }
        return YES;
        [[idb fn_get_db]close];
    }
    return NO;
}
@end

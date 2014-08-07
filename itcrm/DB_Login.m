//
//  DB_Login.m
//  itcrm
//
//  Created by itdept on 14-5-31.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_Login.h"
#import "AuthContract.h"
#import "DBManager.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
@implementation DB_Login
@synthesize idb;
-(id)init{
    idb=[DBManager getSharedInstance];
    return self;
}
-(BOOL)fn_save_data:(NSString*)user_id password:(NSString*)user_pass system:(NSString*)systemCode user_logo:(NSString*)user_logo{
    [self fn_delete_data];
    if ([[idb fn_get_db]open]) {
        NSString *insertSql=[NSString stringWithFormat:@"insert into loginInfo(user_code,password,system,user_logo)values(\"%@\",\"%@\",\"%@\",\"%@\")",user_id,user_pass,systemCode,user_logo];
        BOOL ib_updated=[[idb fn_get_db]executeUpdate:insertSql];
        if (!ib_updated) {
            return NO;
        }
         [[idb fn_get_db]close];
        return YES;
    }
    return NO;
}
-(NSMutableArray*)fn_get_allData{
    NSMutableArray *resultArr=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *lfmdb_result=[[idb fn_get_db]executeQuery:@"select * from loginInfo"];
        while ([lfmdb_result next]) {
            [resultArr addObject:[lfmdb_result resultDictionary]];
        }
        [[idb fn_get_db] close];
    }
    return resultArr;
}
-(BOOL)fn_delete_data{
    if ([[idb fn_get_db]open]) {
        NSString *delete=[NSString stringWithFormat:@"delete from loginInfo"];
        BOOL ib_deleted=[[idb fn_get_db]executeUpdate:delete];
        if (!ib_deleted) {
            return NO;
        }
        [[idb fn_get_db]close];
        return YES;
    }
    return NO;
}
-(AuthContract*)fn_request_auth{
    AuthContract *auth=[[AuthContract alloc]init];
    if ([[self fn_get_allData]count]!=0) {
        NSMutableArray *userInfo=[self fn_get_allData];
        NSMutableDictionary *dic=[userInfo objectAtIndex:0];
        auth.user_code=[dic valueForKey:@"user_code"];
        auth.password=[dic valueForKey:@"password"];
        auth.system=[dic valueForKey:@"system"];
    }
    auth.version=@"1.5";
    return auth;
}


@end

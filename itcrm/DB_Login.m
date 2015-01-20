//
//  DB_Login.m
//  itcrm
//
//  Created by itdept on 14-5-31.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_Login.h"
#import "AuthContract.h"
#import "DatabaseQueue.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
@implementation DB_Login
@synthesize queue;
-(id)init{
    self=[super init];
    if (self) {
        queue=[DatabaseQueue fn_sharedInstance];
    }
    return self;
}
-(BOOL)fn_save_data:(NSString*)user_id password:(NSString*)user_pass system:(NSString*)systemCode user_logo:(NSString*)user_logo lang_code:(NSString*)lang_code{
    [self fn_delete_data];
    __block BOOL ib_updated=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            NSString *insertSql=[NSString stringWithFormat:@"insert into loginInfo(user_code,password,system,user_logo,lang_code)values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",user_id,user_pass,systemCode,user_logo,lang_code];
            ib_updated=[db executeUpdate:insertSql];
            [db close];
            
        }
    }];
    return ib_updated;
}
-(NSMutableArray*)fn_get_allData{
    __block  NSMutableArray *resultArr=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from loginInfo"];
            while ([lfmdb_result next]) {
                [resultArr addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return resultArr;
}
-(BOOL)fn_delete_data{
    __block BOOL ib_deleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            NSString *delete=[NSString stringWithFormat:@"delete from loginInfo"];
            ib_deleted=[db executeUpdate:delete];
            
            [db close];
        }
    }];
    return  ib_deleted;
}
-(AuthContract*)fn_request_auth{
    AuthContract *auth=[[AuthContract alloc]init];
    if ([[self fn_get_allData]count]!=0) {
        NSMutableArray *userInfo=[self fn_get_allData];
        NSMutableDictionary *dic=[userInfo objectAtIndex:0];
        auth.user_code=[dic valueForKey:@"user_code"];
        auth.password=[dic valueForKey:@"password"];
        auth.system=[dic valueForKey:@"system"];
        auth.lang_code=[dic valueForKey:@"lang_code"];
    }
    auth.version=ITCRM_VERSION;
    return auth;
}


@end

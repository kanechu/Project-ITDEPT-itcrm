//
//  DB_RespLogin.m
//  itcrm
//
//  Created by itdept on 14-5-30.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_RespLogin.h"
#import "DatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "RespLogin.h"

@implementation DB_RespLogin
@synthesize queue;

-(id)init{
    self=[super init];
    if (self) {
        queue=[DatabaseQueue fn_sharedInstance];
    }
    return self;
}
-(BOOL)fn_save_data:(NSMutableArray*)arr{
    __block BOOL ib_updated=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            for (RespLogin *lmap_data in arr) {
                NSMutableDictionary *ldict_row=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
                ib_updated =[db executeUpdate:@"delete from Resplogin where company_code = :company_code and sys_name = :sys_name and env = :env and web_addr =:web_addr and php_addr =:php_addr" withParameterDictionary:ldict_row];
                
                ib_updated =[db executeUpdate:@"insert into Resplogin (company_code, sys_name, env, web_addr,php_addr) values (:company_code, :sys_name, :env, :web_addr,:php_addr)" withParameterDictionary:ldict_row];
            }
            [db close];
        }
    }];
    return ib_updated;
}

-(NSMutableArray*)fn_get_all_data{
    __block NSMutableArray *llist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"SELECT * FROM Resplogin"];
            while ([lfmdb_result next]) {
                [llist_result addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    
    return llist_result;
}
-(BOOL)fn_delete_all_data{
    __block BOOL ib_deleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            ib_deleted=[db executeUpdate:@"delete from Resplogin"];
            [db close];
        }
    }];
    return ib_deleted;
}
-(NSString*)fn_get_field_content:(kAppConfig_field)field_name{
    NSMutableArray *alist_appconfig=[self fn_get_all_data];
    NSString *str_field_content;
    NSString *str_key;
    if (field_name==kWeb_addr) {
        str_key=@"web_addr";
    }else if (field_name==kPhp_addr){
        str_key=@"php_addr";
    }else if (field_name==kCompany_code){
        str_key=@"company_code";
    }else if (field_name==kSys_name){
        str_key=@"sys_name";
    }
    if ([alist_appconfig count]!=0) {
        str_field_content=[[alist_appconfig objectAtIndex:0]valueForKey:str_key];
        str_field_content=[str_field_content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    str_key=nil;
    alist_appconfig=nil;
    return str_field_content;
}
@end

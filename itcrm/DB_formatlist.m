//
//  DB_formatlist.m
//  itcrm
//
//  Created by itdept on 14-6-4.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_formatlist.h"
#import "DatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "RespFormatlist.h"
@implementation DB_formatlist
@synthesize queue;

-(id)init{
    self=[super init];
    if (self) {
        queue=[DatabaseQueue fn_sharedInstance];
    }
    return self;
}
-(BOOL)fn_save_formatlist_data:(NSMutableArray*)arr{
    __block BOOL ib_updated=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            for (RespFormatlist *lmap_data in arr) {
                NSMutableDictionary *ldict_row=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
                ib_updated=[db executeUpdate:@"delete from formatlist where list_id = :list_id and list_size = :list_size and uid = :uid and t_title = :t_title and v_title =:v_title and t_desc1=:t_desc1 and t_desc2=:t_desc2 and t_desc3=:t_desc3 and t_desc4=:t_desc4 and t_desc5=:t_desc5 and v_desc1=:v_desc1 and v_desc2=:v_desc2 and v_desc3=:v_desc3 and v_desc4=:v_desc4 and v_desc5=:v_desc5 and icon=:icon and select_sql=:select_sql" withParameterDictionary:ldict_row];
                
                ib_updated =[db executeUpdate:@"insert into formatlist (list_id,list_size, uid, t_title, v_title, t_desc1, t_desc2, t_desc3, t_desc4, t_desc5, v_desc1, v_desc2, v_desc3, v_desc4, v_desc5,icon,select_sql) values (:list_id,:list_size, :uid, :t_title, :v_title, :t_desc1, :t_desc2, :t_desc3, :t_desc4, :t_desc5, :v_desc1, :v_desc2, :v_desc3, :v_desc4, :v_desc5, :icon, :select_sql)" withParameterDictionary:ldict_row];
            }
            [db close];
        }
        
    }];
    return ib_updated;
}
-(NSMutableArray*)fn_get_list_data:(NSString*)list_id{
    __block NSMutableArray *arr=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"SELECT * FROM formatlist where list_id like ?",list_id];
            while ([lfmdb_result next]) {
                [arr addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return arr;
}
-(BOOL)fn_delete_all_data{
    __block BOOL ib_deleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            ib_deleted=[db executeUpdate:@"delete  from formatlist"];
            
            [db close];
        }
    }];
    return ib_deleted;
    
}
-(NSString*)fn_get_select_sql:(NSString*)list_id{
    NSMutableArray *alist_format=[self fn_get_list_data:list_id];
    NSString *select_sql=nil;
    if ([alist_format count]!=0) {
        select_sql=[[alist_format objectAtIndex:0]valueForKey:@"select_sql"];
    }
    return select_sql;
}
@end

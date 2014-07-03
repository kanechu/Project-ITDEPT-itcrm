//
//  DB_formatlist.m
//  itcrm
//
//  Created by itdept on 14-6-4.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_formatlist.h"
#import "DBManager.h"
#import "FMDatabaseAdditions.h"
#import "RespFormatlist.h"
#import "NSDictionary.h"
@implementation DB_formatlist
@synthesize idb;

-(id)init{
    idb=[DBManager getSharedInstance];
    return self;
}
-(BOOL)fn_save_formatlist_data:(NSMutableArray*)arr{
    if ([[idb fn_get_db] open]) {
        for (RespFormatlist *lmap_data in arr) {
            NSMutableDictionary *ldict_row=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
            BOOL ib_delete =[[idb fn_get_db] executeUpdate:@"delete from formatlist where list_id = :list_id and list_size = :list_size and uid = :uid and t_title = :t_title and v_title =:v_title and t_desc1=:t_desc1 and t_desc2=:t_desc2 and t_desc3=:t_desc3 and t_desc4=:t_desc4 and t_desc5=:t_desc5 and v_desc1=:v_desc1 and v_desc2=:v_desc2 and v_desc3=:v_desc3 and v_desc4=:v_desc4 and v_desc5=:v_desc5 and icon=:icon and select_sql=:select_sql" withParameterDictionary:ldict_row];
            if (! ib_delete)
                return NO;
            BOOL ib_updated =[[idb fn_get_db] executeUpdate:@"insert into formatlist (list_id,list_size, uid, t_title, v_title, t_desc1, t_desc2, t_desc3, t_desc4, t_desc5, v_desc1, v_desc2, v_desc3, v_desc4, v_desc5,icon,select_sql) values (:list_id,:list_size, :uid, :t_title, :v_title, :t_desc1, :t_desc2, :t_desc3, :t_desc4, :t_desc5, :v_desc1, :v_desc2, :v_desc3, :v_desc4, :v_desc5, :icon, :select_sql)" withParameterDictionary:ldict_row];
            if (! ib_updated)
                return NO;
        }
        [[idb fn_get_db] close];
        return  YES;
    }
    return NO;
}
-(NSMutableArray*)fn_get_list_data:(NSString*)list_id{
    NSMutableArray *arr=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *lfmdb_result=[[idb fn_get_db] executeQuery:@"SELECT * FROM formatlist where list_id like ?",list_id];
        while ([lfmdb_result next]) {
            [arr addObject:[lfmdb_result resultDictionary]];
        }
        [[idb fn_get_db] close];
    }
    return arr;
}
-(BOOL)fn_delete_all_data{
    if ([[idb fn_get_db]open]) {
        BOOL isSuccess=[[idb fn_get_db]executeUpdate:@"delete  from formatlist"];
        if (!isSuccess) {
            return NO;
        }
        [[idb fn_get_db]close];
        return YES;
        
    }
    return NO;
}

@end

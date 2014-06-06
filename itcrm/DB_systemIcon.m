//
//  DB_systemIcon.m
//  itcrm
//
//  Created by itdept on 14-6-6.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_systemIcon.h"
#import "DBManager.h"
#import "FMDatabaseAdditions.h"
#import "RespSystemIcon.h"
#import "NSDictionary.h"
@implementation DB_systemIcon
@synthesize idb;
-(id)init{
    idb=[DBManager getSharedInstance];
    return self;
}
-(BOOL)fn_save_systemIcon_data:(NSMutableArray*)ilist_result{
    if ([[idb fn_get_db] open]) {
        for (RespSystemIcon *lmap_data in ilist_result) {
            NSMutableDictionary *ldict_row=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
            BOOL ib_delete =[[idb fn_get_db] executeUpdate:@"delete from systemIcon where ic_name = :ic_name and ic_content = :ic_content and upd_date = :upd_date " withParameterDictionary:ldict_row];
            if (! ib_delete)
                return NO;
            BOOL ib_updated =[[idb fn_get_db] executeUpdate:@"insert into systemIcon (ic_name, ic_content, upd_date) values (:ic_name, :ic_content, :upd_date)" withParameterDictionary:ldict_row];
            if (! ib_updated)
                return NO;
            
        }
        [[idb fn_get_db] close];
        return  YES;
    }
    return NO;
}
-(NSMutableArray*)fn_get_systemIcon_data{
    NSMutableArray *arr=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *lfmdb_result=[[idb fn_get_db]executeQuery:@"select * from systemIcon"];
        while ([lfmdb_result next]) {
            [arr addObject:[lfmdb_result resultDictionary]];
        }
        [[idb fn_get_db]close];
        
    }
     return arr;
}
-(BOOL)fn_delete_systemIcon_data{
    if ([[idb fn_get_db]open]) {
        BOOL isSuccess=[[idb fn_get_db]executeUpdate:@"delete from systemIcon"];
        if (!isSuccess) {
            return NO;
        }
        [[idb fn_get_db]close];
        return YES;
    }
    return NO;
}

@end

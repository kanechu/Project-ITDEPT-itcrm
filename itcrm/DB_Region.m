//
//  DB_Region.m
//  itcrm
//
//  Created by itdept on 14-6-5.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_Region.h"
#import "DBManager.h"
#import "FMDatabaseAdditions.h"
#import "RespRegion.h"
#import "NSDictionary.h"
@implementation DB_Region
@synthesize idb;
-(id)init{
    idb=[DBManager getSharedInstance];
    return self;
}
-(BOOL)fn_save_region_data:(NSMutableArray*)ilist_result{
    if ([[idb fn_get_db] open]) {
        for (RespRegion *lmap_data in ilist_result) {
            NSMutableDictionary *ldict_row=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
            BOOL ib_delete =[[idb fn_get_db] executeUpdate:@"delete from region where display = :display and data = :data and desc = :desc and image =:image" withParameterDictionary:ldict_row];
            if (! ib_delete)
                return NO;
            BOOL ib_updated =[[idb fn_get_db] executeUpdate:@"insert into region (display, data, desc, image) values (:display, :data, :desc, :image)" withParameterDictionary:ldict_row];
            if (! ib_updated)
                return NO;
            
        }
        [[idb fn_get_db] close];
        return  YES;
    }
    return NO;
}
-(NSMutableArray*)fn_get_region_data{
    NSMutableArray *arr=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *lfmdb_result=[[idb fn_get_db]executeQuery:@"select * from region"];
        while ([lfmdb_result next]) {
            [arr addObject:[lfmdb_result resultDictionary]];
        }
        [[idb fn_get_db]close];
    }
    return arr;
}
-(BOOL)fn_delete_region_data{
    if ([[idb fn_get_db]open]) {
        BOOL isSuccess=[[idb fn_get_db] executeUpdate:@"delete from region"];
        if (!isSuccess) {
            return NO;
        }
        [[idb fn_get_db]close];
        return YES;
    }
    return NO;
}
@end

//
//  DB_Region.m
//  itcrm
//
//  Created by itdept on 14-6-5.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_Region.h"
#import "DatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "RespRegion.h"
@implementation DB_Region
@synthesize queue;
-(id)init{
    self=[super init];
    if (self) {
        queue=[DatabaseQueue fn_sharedInstance];
    }
    return self;
}
-(BOOL)fn_save_region_data:(NSMutableArray*)ilist_result{
    __block BOOL ib_updated=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            [db beginTransaction];
            BOOL isRollBack=NO;
            @try {
                for (RespRegion *lmap_data in ilist_result) {
                    NSMutableDictionary *ldict_row=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
                    ib_updated=[db executeUpdate:@"delete from crmms where type =:type and display = :display and data = :data and desc = :desc and image =:image" withParameterDictionary:ldict_row];
                    
                    ib_updated =[db executeUpdate:@"insert into crmms (type,display, data, desc, image) values (:type,:display, :data, :desc, :image)" withParameterDictionary:ldict_row];
                }
            }
            @catch (NSException *exception) {
                isRollBack=YES;
                [db rollback];
            }
            @finally {
                if(!isRollBack){
                    [db commit];
                }
            }
            [db close];
        }
    }];
    return ib_updated;
}
-(NSMutableArray*)fn_get_region_data:(NSString*)type{
    __block NSMutableArray *arr=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from crmms where type like ?",type];
            while ([lfmdb_result next]) {
                [arr addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
        
    }];
    return arr;
}
-(NSMutableArray*)fn_get_lookup_data:(NSString*)display type:(NSString*)type{
    
    __block NSMutableArray *arr=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from (select * from crmms where type like ?) where display like ?",type,[NSString stringWithFormat:@"%@%%",display]];
            while ([lfmdb_result next]) {
                [arr addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
        
    }];
    return arr;
}

-(BOOL)fn_delete_region_data{
    __block BOOL ib_deleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            ib_deleted=[db executeUpdate:@"delete from crmms"];
            [db close];
        }
    }];
    return ib_deleted;
}
@end

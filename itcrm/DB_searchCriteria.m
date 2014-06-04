//
//  DB_searchCriteria.m
//  itcrm
//
//  Created by itdept on 14-6-3.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_searchCriteria.h"
#import "RespSearchCriteria.h"
#import "FMDatabaseAdditions.h"
#import "DBManager.h"
#import "NSDictionary.h"
@implementation DB_searchCriteria
@synthesize idb;
-(id)init{
    idb=[DBManager getSharedInstance];
    return self;
}
-(BOOL)fn_save_searchCriteria_data:(NSMutableArray*)ilist_result{
    if ([[idb fn_get_db] open]) {
        for (RespSearchCriteria *lmap_data in ilist_result) {
            NSMutableDictionary *ldict_row=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
            BOOL ib_delete =[[idb fn_get_db] executeUpdate:@"delete from searchCriteria where srch_type = :srch_type and seq = :seq and col_code = :col_code and col_label = :col_label and col_type =:col_type and col_option=:col_option and col_def=:col_def and group_name=:group_name and is_mandatory=:is_mandatory and icon_name=:icon_name" withParameterDictionary:ldict_row];
            if (! ib_delete)
                return NO;
            BOOL ib_updated =[[idb fn_get_db] executeUpdate:@"insert into searchCriteria (srch_type,seq, col_code, col_label, col_type, col_option, col_def, group_name, is_mandatory, icon_name) values (:srch_type,:seq, :col_code, :col_label, :col_type, :col_option, :col_def, :group_name, :is_mandatory, :icon_name)" withParameterDictionary:ldict_row];
            if (! ib_updated)
                return NO;
        }
        [[idb fn_get_db] close];
        return  YES;
    }
    return NO;
}

-(NSMutableArray*)fn_get_srchType_data:(NSString*)srch_type{
    NSMutableArray *arr=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *lfmdb_result=[[idb fn_get_db] executeQuery:@"SELECT * FROM searchCriteria where srch_type like ?",srch_type];
        while ([lfmdb_result next]) {
            [arr addObject:[lfmdb_result resultDictionary]];
        }
        [[idb fn_get_db] close];
    }
    return arr;
}
-(BOOL)fn_delete_all_data{
    if ([[idb fn_get_db]open]) {
        NSString *sql=@"delete from searchCriteria";
        BOOL isSuccess=[[idb fn_get_db]executeUpdate:sql];
        if (!isSuccess) {
            return NO;
        }
        [[idb fn_get_db]close];
        return YES;
        
    }
    return NO;
}
-(NSMutableArray*)fn_get_groupNameAndNum:(NSString*)srch_type{
    NSMutableArray *arr=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *lfmdb_result= [[idb fn_get_db] executeQuery:@"SELECT group_name,COUNT(group_name) FROM searchCriteria where srch_type like ? group by group_name",srch_type];
        while ([lfmdb_result next]) {
            
            [arr addObject:[lfmdb_result resultDictionary]];
        }
        [[idb fn_get_db]close];
    }
    return arr;
}
@end

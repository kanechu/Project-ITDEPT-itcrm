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
#import "DatabaseQueue.h"
#import "Format_conversion.h"
@implementation DB_searchCriteria
@synthesize queue;
-(id)init{
    self=[super init];
    if (self) {
        queue=[DatabaseQueue fn_sharedInstance];
    }
    return self;
}
-(BOOL)fn_save_searchCriteria_data:(NSMutableArray*)ilist_result{
    __block BOOL ib_updated=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            for (RespSearchCriteria *lmap_data in ilist_result) {
                NSMutableDictionary *ldict_row=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
                ib_updated=[db executeUpdate:@"delete from searchCriteria where srch_type = :srch_type and seq = :seq and col_code = :col_code and col_label = :col_label and col_type =:col_type and col_option=:col_option and col_def=:col_def and group_name=:group_name and is_mandatory=:is_mandatory and icon_name=:icon_name" withParameterDictionary:ldict_row];
                
                ib_updated =[db executeUpdate:@"insert into searchCriteria (srch_type,seq, col_code, col_label, col_type, col_option, col_def, group_name, is_mandatory, icon_name) values (:srch_type,:seq, :col_code, :col_label, :col_type, :col_option, :col_def, :group_name, :is_mandatory, :icon_name)" withParameterDictionary:ldict_row];
            }
            [db close];
        }
    }];
    return ib_updated;
    
}

-(NSMutableArray*)fn_get_srchType_data:(NSString*)srch_type{
    __block NSMutableArray *arr=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"SELECT * FROM searchCriteria where srch_type like ?",srch_type];
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
            NSString *sql=@"delete from searchCriteria";
            ib_deleted=[db executeUpdate:sql];
            [db close];
            
        }
    }];
    return ib_deleted;
}
-(NSMutableArray*)fn_get_groupNameAndNum:(NSString*)srch_type{
    __block NSMutableArray *arr=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result= [db executeQuery:@"SELECT group_name,COUNT(group_name),seq FROM searchCriteria where srch_type like ? group by group_name",srch_type,srch_type];
            while ([lfmdb_result next]) {
                
                [arr addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    for (NSMutableDictionary *dic in arr) {
        NSString *seq=[dic valueForKey:@"seq"];
        NSNumber *seq_num=[NSNumber numberWithInteger:[seq integerValue]];
        if (seq_num!=nil) {
            [dic setObject:seq_num forKey:@"seq"];
        }
    }
    Format_conversion *convert_obj=[[Format_conversion alloc]init];
    arr=[convert_obj fn_sort_the_array:arr key:@"seq"];
    return arr;
}
@end

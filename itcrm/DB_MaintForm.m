//
//  DB_MaintForm.m
//  itcrm
//
//  Created by itdept on 14-6-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_MaintForm.h"
#import "DBManager.h"
#import "FMDatabaseAdditions.h"
#import "NSDictionary.h"
#import "RespMaintForm.h"
@implementation DB_MaintForm
@synthesize idb;
-(id)init{
    idb=[DBManager getSharedInstance];
    return self;
}
-(BOOL)fn_save_MaintForm_data:(NSMutableArray*)ilist_result{
    if ([[idb fn_get_db] open]) {
        for (RespMaintForm *lmap_data in ilist_result) {
            NSMutableDictionary *ldict_row=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
            BOOL ib_delete =[[idb fn_get_db] executeUpdate:@"delete from maintForm where form_id = :form_id and seq = :seq and col_code = :col_code and col_label = :col_label and col_type =:col_type and col_option=:col_option and col_def=:col_def and group_name=:group_name and is_mandatory=:is_mandatory and is_enable=:is_enable and icon_name=:icon_name" withParameterDictionary:ldict_row];
            if (! ib_delete)
                return NO;
            BOOL ib_updated =[[idb fn_get_db] executeUpdate:@"insert into maintForm (form_id,seq, col_code, col_label, col_type, col_option, col_def, group_name, is_mandatory,is_enable,icon_name) values (:form_id,:seq, :col_code, :col_label, :col_type, :col_option, :col_def, :group_name, :is_mandatory,:is_enable,:icon_name)" withParameterDictionary:ldict_row];
            if (! ib_updated)
                return NO;
        }
        [[idb fn_get_db] close];
        return  YES;
    }
    return NO;
}
-(NSMutableArray*)fn_get_MaintForm_data:(NSString*)form_id{
    NSMutableArray *arr=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *lfmdb_result=[[idb fn_get_db] executeQuery:@"SELECT * FROM maintForm where form_id like ?",[NSString stringWithFormat:@"%@",form_id]];
        while ([lfmdb_result next]) {
            [arr addObject:[lfmdb_result resultDictionary]];
        }
        [[idb fn_get_db] close];
    }
    return arr;
}
-(BOOL)fn_delete_all_data{
    if ([[idb fn_get_db]open]) {
        NSString *sql=@"delete from maintForm";
        BOOL isSuccess=[[idb fn_get_db]executeUpdate:sql];
        if (!isSuccess) {
            return NO;
        }
        [[idb fn_get_db]close];
        return YES;
        
    }
    return NO;
}
-(NSMutableArray*)fn_get_groupNameAndNum:(NSString*)form_id{
    NSMutableArray *arr=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *lfmdb_result= [[idb fn_get_db] executeQuery:@"SELECT group_name,COUNT(group_name) FROM maintForm where form_id like ? group by group_name",form_id];
        while ([lfmdb_result next]) {
            
            [arr addObject:[lfmdb_result resultDictionary]];
        }
        [[idb fn_get_db]close];
    }
    return arr;
}
@end

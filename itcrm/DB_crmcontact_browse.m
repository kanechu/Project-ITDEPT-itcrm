//
//  DB_crmcontact_browse.m
//  itcrm
//
//  Created by itdept on 14-7-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_crmcontact_browse.h"
#import "DBManager.h"
#import "FMDatabaseAdditions.h"
#import "RespCrmcontact_browse.h"
#import "Advance_SearchData.h"
@implementation DB_crmcontact_browse
@synthesize idb;
-(id)init{
    idb=[DBManager getSharedInstance];
    return self;
};
-(BOOL)fn_save_crmcontact_browse:(NSMutableArray*)alist_result{
    if ([[idb fn_get_db]open]) {
        for (RespCrmcontact_browse *lmap_data in alist_result) {
            NSMutableDictionary *idic_contact=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
            [idic_contact setObject:@"0" forKey:@"is_modified"];
            BOOL ib_updated =[[idb fn_get_db] executeUpdate:@"insert into crmcontact (uid,contact_id,contact_code,contact_type,contact_ref_id,contact_ref_name,contact_ref_code,contact_name,contact_title,contact_dept,contact_mobile,contact_tel,contact_fax,contact_email,contact_language,lang_desc,assign_to,assign_to_name,voided,rec_crt_user,rec_upd_user,rec_crt_date,rec_upd_date,rec_upd_type,rec_savable,rec_deletable,is_modified) values (:uid,:contact_id,:contact_code,:contact_type,:contact_ref_id,:contact_ref_name,:contact_ref_code,:contact_name,:contact_title,:contact_dept,:contact_mobile,:contact_tel,:contact_fax,:contact_email,:contact_language,:lang_desc,:assign_to,:assign_to_name,:voided,:rec_crt_user,:rec_upd_user,:rec_crt_date,:rec_upd_date,:rec_upd_type,:rec_savable,:rec_deletable,:is_modified)" withParameterDictionary:idic_contact];
            if (!ib_updated) {
                return NO;
            }
        }
        [[idb fn_get_db]close];
        return YES;
    }
    return NO;
}
-(BOOL)fn_update_crmcontact_browse:(NSMutableDictionary*)idic_update unique_id:(NSString*)unique_id{
    //得到词典中所有key值
    NSEnumerator *enumeratorkey=[idic_update keyEnumerator];
    NSString *sql=[NSString string];
    NSInteger flag=0;
    //快速枚举遍历所有的key的值
    for (NSString *key in enumeratorkey) {
        if (flag==0) {
            sql=[sql stringByAppendingFormat:@"update crmcontact set %@=:%@",key,key];
        }else{
            sql=[sql stringByAppendingFormat:@",%@=:%@",key,key];
        }
        flag=1;
    }
    sql=[sql stringByAppendingFormat:@" where unique_id=%@",unique_id];
    if ([[idb fn_get_db]open]) {
        BOOL ib_updated =[[idb fn_get_db] executeUpdate:sql withParameterDictionary:idic_update];
        if (!ib_updated)
            return NO;
        [[idb fn_get_db] close];
        return  YES;
    }
    return NO;
}
-(BOOL)fn_update_crmcontact_ismodified:(NSString*)is_modified unique_id:(NSString*)unique_id{
    if ([[idb fn_get_db]open]) {
        BOOL ib_updated =[[idb fn_get_db]executeUpdate:@"update crmcontact set is_modified=? where unique_id=?",[NSString stringWithFormat:@"%@",is_modified],[NSString stringWithFormat:@"%@",unique_id]];
        if (!ib_updated)
            return NO;
        [[idb fn_get_db] close];
        return  YES;
    }
    return NO;
}
-(NSMutableArray*)fn_get_crmcontact_browse_data:(NSString*)contact_name select_sql:(NSString *)select_sql{
    NSString *sql=[NSString stringWithFormat:@"select %@ from crmcontact where contact_name like ?",select_sql];
    NSMutableArray *arr_crmcontact=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *lfmdb_result=[[idb fn_get_db]executeQuery:sql,[NSString stringWithFormat:@"%%%@%%",contact_name]];
        while ([lfmdb_result next]) {
            [arr_crmcontact addObject:[lfmdb_result resultDictionary]];
        }
    }
    return arr_crmcontact;
}
-(NSMutableArray*)fn_get_detail_crmcontact_data:(NSMutableArray*)alist_searchData select_sql:(NSString*)select_sql{
    NSString *sql=[NSString stringWithFormat:@"select %@ from crmcontact",select_sql];
    NSInteger flag=0;
    NSMutableArray *arr_value=[[NSMutableArray alloc]initWithCapacity:10];
    for (Advance_SearchData *acct in alist_searchData) {
        NSString *sql_value=nil;
        if (flag==0 && [acct.is_searchValue length]!=0 ) {
            sql=[sql stringByAppendingFormat:@" where %@ like ?",acct.is_parameter];
            sql_value=[NSString stringWithFormat:@"%%%@%%",acct.is_searchValue];
            [arr_value addObject:sql_value];
        }
        if (flag==1 && [acct.is_searchValue length]!=0 ) {
            sql=[sql stringByAppendingFormat:@" and %@ like ?",acct.is_parameter];
            sql_value=[NSString stringWithFormat:@"%%%@%%",acct.is_searchValue];
            [arr_value addObject:sql_value];
        }
       
        flag=1;
    }
    NSMutableArray *arr=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *lfmdb_result=[[idb fn_get_db]executeQuery:sql withArgumentsInArray:arr_value];
        while ([lfmdb_result next]) {
            [arr addObject:[lfmdb_result resultDictionary]];
        }
        [[idb fn_get_db]close];
    }
    return arr;
}
-(NSMutableArray*)fn_get_crmcontact_browse:(NSString*)contact_id{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    if ([[idb fn_get_db]open]) {
        FMResultSet *lfmdb_result=[[idb fn_get_db]executeQuery:@"select * from crmcontact where contact_id like ?",[NSString stringWithFormat:@"%@",contact_id]];
        while ([lfmdb_result next]) {
            [arr addObject:[lfmdb_result resultDictionary]];
        }
    }
    return arr;
}
-(NSMutableArray*)fn_get_relate_crmcontact_data:(NSString *)contact_ref_id select_sql:(NSString *)select_sql{
    select_sql=[select_sql stringByAppendingString:@",contact_id"];
    NSString *is_sql=[NSString stringWithFormat:@"select %@ from crmcontact where contact_ref_id like ?",select_sql];
    NSMutableArray *arr=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *fmdb_result=[[idb fn_get_db]executeQuery:is_sql,[NSString stringWithFormat:@"%@",contact_ref_id]];
        while ([fmdb_result next]) {
            [arr addObject:[fmdb_result resultDictionary]];
        }
        [[idb fn_get_db]close];
    }
    return arr;
}
-(NSMutableArray*)fn_get_all_crmcontact_data{
    NSMutableArray *arr_result=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *lfmdb_result=[[idb fn_get_db]executeQuery:@"select * from crmcontact"];
        while ([lfmdb_result next]) {
            [arr_result addObject:[lfmdb_result resultDictionary]];
        }
        [[idb fn_get_db]close];
    }
    return arr_result;
}

-(BOOL)fn_delete_all_crmcontact_data{
    if ([[idb fn_get_db]open]) {
        BOOL isSuccess=[[idb fn_get_db]executeUpdate:@"delete from crmcontact"];
        if (!isSuccess) {
            return NO;
        }
        [[idb fn_get_db]close];
        return YES;
    }
    return NO;
}

@end

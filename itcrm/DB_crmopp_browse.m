//
//  DB_crmopp_browse.m
//  itcrm
//
//  Created by itdept on 14-6-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_crmopp_browse.h"
#import "DatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "RespCrmopp_browse.h"
#import "Advance_SearchData.h"
@implementation DB_crmopp_browse
@synthesize queue;
-(id)init{
    self=[super init];
    if (self) {
        queue=[DatabaseQueue fn_sharedInstance];
    }
    return self;
}
-(BOOL)fn_save_crmopp_browse:(NSMutableArray*)alist_result{
    __block BOOL ib_updated=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            for (RespCrmopp_browse *lmap_data in alist_result) {
                NSMutableDictionary *ldict_row=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
                [ldict_row setObject:@"0" forKey:@"is_modified"];
                ib_updated =[db executeUpdate:@"insert into crmopp_browse (uid,opp_id,opp_code,opp_ref_type,opp_ref_id,opp_ref_code,opp_ref_name,opp_ref_addr,opp_ref_addr_01,opp_ref_addr_02,opp_ref_addr_03,opp_ref_addr_04,opp_name,contact_id,contact_code,contact_name,contact_tel,contact_email,contact_mobile,opp_stage,opp_stage_desc,opp_stage_lang,exp_close_date,opp_remark,opp_probability,assign_to,assign_to_name,campaign_id,campaign_name,op_type,load_main_region_code,load_main_region_name,load_main_region_lang,load_sub_region_code,load_sub_region_name,load_sub_region_lang,load_region_code,load_region_name,load_code,load_name,dish_main_region_code,dish_main_region_name,dish_main_region_lang,dish_sub_region_code,dish_sub_region_name,dish_sub_region_lang,dish_region_code,dish_region_name,dish_code,dish_name,dest_code,dest_name,srvc_code,srvc_desc,movement_code,movement_desc,inco_term,inco_term_desc,inco_term_lang,brand,competitor_rmk,volume,cbm_annual,teu_annual,kgs_annual,fcl_lcl,voided,rec_crt_user,rec_upd_user,rec_crt_date,rec_upd_date,rec_upd_type,rec_savable,rec_deletable,is_modified) values (:uid,:opp_id,:opp_code,:opp_ref_type,:opp_ref_id,:opp_ref_code,:opp_ref_name,:opp_ref_addr,:opp_ref_addr_01,:opp_ref_addr_02,:opp_ref_addr_03,:opp_ref_addr_04,:opp_name,:contact_id,:contact_code,:contact_name,:contact_tel,:contact_email,:contact_mobile,:opp_stage,:opp_stage_desc,:opp_stage_lang,:exp_close_date,:opp_remark,:opp_probability,:assign_to,:assign_to_name,:campaign_id,:campaign_name,:op_type,:load_main_region_code,:load_main_region_name,:load_main_region_lang,:load_sub_region_code,:load_sub_region_name,:load_sub_region_lang,:load_region_code,:load_region_name,:load_code,:load_name,:dish_main_region_code,:dish_main_region_name,:dish_main_region_lang,:dish_sub_region_code,:dish_sub_region_name,:dish_sub_region_lang,:dish_region_code,:dish_region_name,:dish_code,:dish_name,:dest_code,:dest_name,:srvc_code,:srvc_desc,:movement_code,:movement_desc,:inco_term,:inco_term_desc,:inco_term_lang,:brand,:competitor_rmk,:volume,:cbm_annual,:teu_annual,:kgs_annual,:fcl_lcl,:voided,:rec_crt_user,:rec_upd_user,:rec_crt_date,:rec_upd_date,:rec_upd_type,:rec_savable,:rec_deletable,:is_modified)" withParameterDictionary:ldict_row];
            }
            [db close];
        }
        
    }];
    return ib_updated;
}
-(BOOL)fn_update_crmopp_data:(NSMutableDictionary*)idic_opp unique_id:(NSString*)unique_id{
    NSEnumerator *enumerator=[idic_opp keyEnumerator];
    NSString *sql=[NSString string];
    NSInteger flag=0;
    for (NSString *key in enumerator) {
        if (flag==0) {
            sql=[sql stringByAppendingFormat:@"update crmopp_browse set %@=:%@",key,key];
        }else{
            sql=[sql stringByAppendingFormat:@", %@=:%@",key,key];
        }
        flag=1;
    }
    if (flag==1) {
        sql=[sql stringByAppendingFormat:@" where unique_id=%@",unique_id];
    }
    __block BOOL ib_updated=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open] && [sql length]!=0) {
            ib_updated=[db executeUpdate:sql withParameterDictionary:idic_opp];
            [db close];
        }
    }];
    return ib_updated;
}
-(BOOL)fn_update_crmopp_ismodified:(NSString*)is_modified opp_id:(NSString*)opp_id{
    __block BOOL ib_updated=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            ib_updated =[db executeUpdate:@"update crmopp_browse set is_modified=? where opp_id=?",[NSString stringWithFormat:@"%@",is_modified],[NSString stringWithFormat:@"%@",opp_id]];
            [db close];
        }
    }];
    return ib_updated;
}
-(NSMutableArray*)fn_get_crmopp_data:(NSString*)opp_name select_sql:(NSString*)select_sql{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM crmopp_browse where opp_name like ?"];
    __block NSMutableArray *arr=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:sql,[NSString stringWithFormat:@"%%%@%%",opp_name]];
            while ([lfmdb_result next]) {
                [arr addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return arr;
}
-(NSMutableArray*)fn_get_relate_crmopp_data:(NSString *)opp_ref_id select_sql:(NSString *)select_sql{
    NSString *is_sql=[NSString stringWithFormat:@"select * from crmopp_browse where opp_ref_type = 'ACCT' and opp_ref_id like ? ORDER BY rec_upd_date,rec_crt_date DESC"];
    __block NSMutableArray *arr=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *fmdb_result=[db executeQuery:is_sql,[NSString stringWithFormat:@"%@",opp_ref_id]];
            while ([fmdb_result next]) {
                [arr addObject:[fmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return arr;
}
-(NSMutableArray*)fn_get_crmopp_with_id:(NSString*)opp_id{
    __block NSMutableArray *arr_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from crmopp_browse where opp_id like ?",[NSString stringWithFormat:@"%@",opp_id]];
            while ([lfmdb_result next]) {
                [arr_result addObject:[lfmdb_result resultDictionary]];
            }
        }
    }];
    return arr_result;
}
-(NSMutableArray*)fn_get_detail_crmopp_data:(NSMutableArray*)alist_searchData select_sql:(NSString*)select_sql{
    NSString *sql=[NSString stringWithFormat:@"select %@ from crmopp_browse",select_sql];
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
    __block NSMutableArray *arr=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:sql withArgumentsInArray:arr_value];
            while ([lfmdb_result next]) {
                [arr addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return arr;
}
-(NSMutableArray*)fn_get_need_sync_crmopp_data:(NSString*)acct_id{
    __block NSMutableArray *arr=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from crmopp_browse where opp_ref_type = 'ACCT' and opp_ref_id like ? and is_modified= '1' ",acct_id];
            while ([lfmdb_result next]) {
                [arr addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return arr;
}
-(BOOL)fn_delete_relate_crmopp_data:(NSString*)acct_id{
    __block BOOL ib_deleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            ib_deleted=[db executeUpdate:@"delete from crmopp_browse where opp_ref_type = 'ACCT' and opp_ref_id like ?",acct_id];
            [db close];
        }
    }];
    return ib_deleted;
}
-(BOOL)fn_delete_all_data{
    __block BOOL ib_deleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            ib_deleted=[db executeUpdate:@"delete from crmopp_browse"];
            [db close];
        }
    }];
    return ib_deleted;
    
}
@end

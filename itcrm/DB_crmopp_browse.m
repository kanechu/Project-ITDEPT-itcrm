//
//  DB_crmopp_browse.m
//  itcrm
//
//  Created by itdept on 14-6-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_crmopp_browse.h"
#import "DBManager.h"
#import "FMDatabaseAdditions.h"
#import "NSDictionary.h"
#import "RespCrmopp_browse.h"
#import "Advance_SearchData.h"
@implementation DB_crmopp_browse
@synthesize idb;
-(id)init{
    idb=[DBManager getSharedInstance];
    return self;
}
-(BOOL)fn_save_crmopp_browse:(NSMutableArray*)alist_result{
    if ([[idb fn_get_db] open]) {
        for (RespCrmopp_browse *lmap_data in alist_result) {
            NSMutableDictionary *ldict_row=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
            BOOL ib_updated =[[idb fn_get_db] executeUpdate:@"insert into crmopp_browse (uid,opp_id,opp_code,opp_ref_type,opp_ref_id,opp_ref_code,opp_ref_name,opp_ref_addr,opp_ref_addr_01,opp_ref_addr_02,opp_ref_addr_03,opp_ref_addr_04,opp_name,contact_id,contact_code,contact_name,contact_tel,contact_email,contact_mobile,opp_stage,opp_stage_desc,opp_stage_lang,exp_close_date,opp_remark,opp_probability,assign_to,assign_to_name,campaign_id,campaign_name,op_type,load_main_region_code,load_main_region_name,load_main_region_lang,load_sub_region_code,load_sub_region_name,load_sub_region_lang,load_region_code,load_region_name,load_code,load_name,dish_main_region_code,dish_main_region_name,dish_main_region_lang,dish_sub_region_code,dish_sub_region_name,dish_sub_region_lang,dish_region_code,dish_region_name,dish_code,dish_name,dest_code,dest_name,srvc_code,srvc_desc,movement_code,movement_desc,inco_term,inco_term_desc,inco_term_lang,brand,competitor_rmk,volume,cbm_annual,teu_annual,kgs_annual,fcl_lcl,voided,rec_crt_user,rec_upd_user,rec_crt_date,rec_upd_date,rec_upd_type,rec_savable,rec_deletable) values (:uid,:opp_id,:opp_code,:opp_ref_type,:opp_ref_id,:opp_ref_code,:opp_ref_name,:opp_ref_addr,:opp_ref_addr_01,:opp_ref_addr_02,:opp_ref_addr_03,:opp_ref_addr_04,:opp_name,:contact_id,:contact_code,:contact_name,:contact_tel,:contact_email,:contact_mobile,:opp_stage,:opp_stage_desc,:opp_stage_lang,:exp_close_date,:opp_remark,:opp_probability,:assign_to,:assign_to_name,:campaign_id,:campaign_name,:op_type,:load_main_region_code,:load_main_region_name,:load_main_region_lang,:load_sub_region_code,:load_sub_region_name,:load_sub_region_lang,:load_region_code,:load_region_name,:load_code,:load_name,:dish_main_region_code,:dish_main_region_name,:dish_main_region_lang,:dish_sub_region_code,:dish_sub_region_name,:dish_sub_region_lang,:dish_region_code,:dish_region_name,:dish_code,:dish_name,:dest_code,:dest_name,:srvc_code,:srvc_desc,:movement_code,:movement_desc,:inco_term,:inco_term_desc,:inco_term_lang,:brand,:competitor_rmk,:volume,:cbm_annual,:teu_annual,:kgs_annual,:fcl_lcl,:voided,:rec_crt_user,:rec_upd_user,:rec_crt_date,:rec_upd_date,:rec_upd_type,:rec_savable,:rec_deletable)" withParameterDictionary:ldict_row];
            if (! ib_updated)
                return NO;
        }
        [[idb fn_get_db] close];
        return  YES;
    }
    return NO;
}
-(NSMutableArray*)fn_get_crmopp_data:(NSString*)op_type select_sql:(NSString*)select_sql{
    NSString *sql=[NSString stringWithFormat:@"SELECT %@ FROM crmopp_browse where op_type like ?",select_sql];
    NSMutableArray *arr=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *lfmdb_result=[[idb fn_get_db] executeQuery:sql,[NSString stringWithFormat:@"%@%%",op_type]];
        while ([lfmdb_result next]) {
            [arr addObject:[lfmdb_result resultDictionary]];
        }
        [[idb fn_get_db] close];
    }
    return arr;
}
-(NSMutableArray*)fn_get_relate_crmopp_data:(NSString *)opp_ref_id select_sql:(NSString *)select_sql{
    NSString *is_sql=[NSString stringWithFormat:@"select %@ from crmopp_browse where opp_ref_id like ?",select_sql];
    NSMutableArray *arr=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *fmdb_result=[[idb fn_get_db]executeQuery:is_sql,[NSString stringWithFormat:@"%@",opp_ref_id]];
        while ([fmdb_result next]) {
            [arr addObject:[fmdb_result resultDictionary]];
        }
        [[idb fn_get_db]close];
    }
    return arr;
}
-(NSMutableArray*)fn_get_crmopp_with_id:(NSString*)opp_id{
    NSMutableArray *arr_result=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *lfmdb_result=[[idb fn_get_db]executeQuery:@"select * from crmopp_browse where opp_id like ?",[NSString stringWithFormat:@"%@",opp_id]];
        while ([lfmdb_result next]) {
            [arr_result addObject:[lfmdb_result resultDictionary]];
        }
    }
    return arr_result;
}
-(NSMutableArray*)fn_get_detail_crmopp_data:(NSMutableArray*)alist_searchData select_sql:(NSString*)select_sql{
    NSString *sql=[NSString stringWithFormat:@"select %@ from crmopp_browse",select_sql];
    NSInteger flag=0;
    NSMutableArray *arr_value=[[NSMutableArray alloc]initWithCapacity:10];
    for (Advance_SearchData *acct in alist_searchData) {
        NSString *sql_value=[NSString string];
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
-(BOOL)fn_delete_all_data{
    if ([[idb fn_get_db]open]) {
        BOOL isSuccess=[[idb fn_get_db]executeUpdate:@"delete from crmopp_browse"];
        if (!isSuccess) {
            return NO;
        }
        [[idb fn_get_db]close];
        return YES;
        
    }
    return NO;
}
@end

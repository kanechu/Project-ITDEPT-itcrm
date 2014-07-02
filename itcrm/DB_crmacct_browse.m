//
//  DB_crmacct_browse.m
//  itcrm
//
//  Created by itdept on 14-6-4.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_crmacct_browse.h"
#import "DBManager.h"
#import "FMDatabaseAdditions.h"
#import "NSDictionary.h"
#import "RespCrmacct_browse.h"
#import "Advance_SearchData.h"
@implementation DB_crmacct_browse
@synthesize idb;

-(id)init{
    idb=[DBManager getSharedInstance];
    return self;
}

-(BOOL)fn_save_crmacct_browse:(NSMutableArray*)alist_result{
    if ([[idb fn_get_db] open]) {
        for (RespCrmacct_browse *lmap_data in alist_result) {
            NSMutableDictionary *ldict_row=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
            BOOL ib_updated =[[idb fn_get_db] executeUpdate:@"insert into crmacct_browse (uid,acct_id, accttgt_id, acct_code, acct_name, acct_addr_01, acct_addr_02, acct_addr_03, acct_addr_04, city, state, postal_code, acct_tel, acct_fax, acct_email,acct_website,assign_to,assign_to_name, acct_refer_by, acct_remark, rec_crt_user, rec_upd_user, rec_crt_date, rec_upd_date, rec_upd_type, rec_savable, rec_deletable, acct_status, acct_status_desc, acct_type, acct_type_desc,country_code,country_name, region_code, region_name, acct_main_region_code, acct_main_region_name, acct_sub_region_code, acct_sub_region_name, acct_language, lang_desc, acct_src, acct_src_desc, acct_industry, acct_industry_desc, inco_term,acct_inco_term_desc,no_of_staff, nomin_agent_list, freehand_region_list, coload_region_list, commodity_list, handle_sales_list, is_svc_customs, is_svc_truck, is_svc_fob, is_svc_cnf, is_svc_dap, is_svc_other, is_nomin_by, is_freehand,is_co_loader,accttgt_probability, accttgt_desc, accttgt_load_code, accttgt_load_name, accttgt_dest_code, accttgt_dest_name, accttgt_vol) values (:uid,:acct_id, :accttgt_id, :acct_code, :acct_name, :acct_addr_01, :acct_addr_02, :acct_addr_03, :acct_addr_04, :city, :state, :postal_code, :acct_tel, :acct_fax, :acct_email,:acct_website,:assign_to,:assign_to_name, :acct_refer_by, :acct_remark, :rec_crt_user, :rec_upd_user, :rec_crt_date, :rec_upd_date, :rec_upd_type, :rec_savable, :rec_deletable, :acct_status, :acct_status_desc, :acct_type, :acct_type_desc,:country_code,:country_name, :region_code, :region_name, :acct_main_region_code, :acct_main_region_name, :acct_sub_region_code, :acct_sub_region_name, :acct_language, :lang_desc, :acct_src, :acct_src_desc, :acct_industry, :acct_industry_desc, :inco_term,:acct_inco_term_desc,:no_of_staff, :nomin_agent_list, :freehand_region_list, :coload_region_list, :commodity_list, :handle_sales_list, :is_svc_customs, :is_svc_truck, :is_svc_fob, :is_svc_cnf, :is_svc_dap, :is_svc_other, :is_nomin_by, :is_freehand,:is_co_loader,:accttgt_probability, :accttgt_desc, :accttgt_load_code, :accttgt_load_name, :accttgt_dest_code, :accttgt_dest_name, :accttgt_vol)" withParameterDictionary:ldict_row];
            if (! ib_updated)
                return NO;
        }
        [[idb fn_get_db] close];
        return  YES;
    }
    return NO;
}
-(NSMutableArray*)fn_get_data:(NSString*)acct_name{
    NSMutableArray *arr=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *lfmdb_result=[[idb fn_get_db] executeQuery:@"SELECT * FROM crmacct_browse where acct_name like ?",[NSString stringWithFormat:@"%@%%",acct_name]];
        while ([lfmdb_result next]) {
            [arr addObject:[lfmdb_result resultDictionary]];
        }
        [[idb fn_get_db] close];
    }
    return arr;
}
-(BOOL)fn_delete_all_data{
    if ([[idb fn_get_db]open]) {
        BOOL isSuccess=[[idb fn_get_db]executeUpdate:@"delete from crmacct_browse"];
        if (!isSuccess) {
            return NO;
        }
        [[idb fn_get_db]close];
        return YES;
        
    }
    return NO;
}
-(NSMutableArray*)fn_get_detail_crmacct_data:(NSMutableArray*)alist_searchData{
    NSString *sql=@"select * from crmacct_browse";
    NSInteger flag=0;
    NSMutableArray *arr_value=[[NSMutableArray alloc]initWithCapacity:10];
    for (Advance_SearchData *acct in alist_searchData) {
        NSString *sql_value=[NSString string];
        BOOL isHas=[self fn_isContain_a_character:acct.is_parameter substring:@","];
        if (flag==0 && [acct.is_searchValue length]!=0 && !isHas) {
            sql=[sql stringByAppendingFormat:@" where %@ like ?",acct.is_parameter];
            sql_value=[NSString stringWithFormat:@"%@%%",acct.is_searchValue];
            [arr_value addObject:sql_value];
        }
        if (flag==1 && [acct.is_searchValue length]!=0 && !isHas) {
            sql=[sql stringByAppendingFormat:@" and %@ like ?",acct.is_parameter];
            sql_value=[NSString stringWithFormat:@"%@%%",acct.is_searchValue];
            [arr_value addObject:sql_value];
        }
        if (flag==0 && [acct.is_searchValue length]!=0 && isHas) {
            
            NSArray *arr_parameter=[acct.is_parameter componentsSeparatedByString:@","];
            NSString *str_parameter=[self fn_joint_string_from_array:arr_parameter];
            sql=[sql stringByAppendingFormat:@" where %@ like ?",str_parameter];
            sql_value=[NSString stringWithFormat:@"%@%%",acct.is_searchValue];
            [arr_value addObject:sql_value];
        }
        if (flag==1 && [acct.is_searchValue length]!=0 && isHas) {
            
            NSArray *arr_parameter=[acct.is_parameter componentsSeparatedByString:@","];
            NSString *str_parameter=[self fn_joint_string_from_array:arr_parameter];
            sql=[sql stringByAppendingFormat:@" and %@ like ?",str_parameter];
            sql_value=[NSString stringWithFormat:@"%@%%",acct.is_searchValue];
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
//把一个数组元素串成一个字符串
-(NSString*)fn_joint_string_from_array:(NSArray*)arr_parameter{
    NSString *str_parameter=[NSString string];
    NSInteger str_flag=0;
    for (NSString *str in arr_parameter) {
        if (str_flag==0) {
            str_parameter=[str_parameter stringByAppendingString:str];
        }
        if (str_flag==1) {
            str_parameter=[str_parameter stringByAppendingFormat:@"+%@",str];
        }
        str_flag=1;
    }
    return str_parameter;
}
//检测一个字符串中是否含有某个字符
-(BOOL)fn_isContain_a_character:(NSString*)_parentString substring:(NSString*)_substring{
    if ([_parentString rangeOfString:_substring].location!=NSNotFound) {
        return YES;
    }else{
        return NO;
    }
}

@end

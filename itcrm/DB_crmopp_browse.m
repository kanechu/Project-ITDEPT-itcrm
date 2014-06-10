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
#import "RespOpportunities.h"
@implementation DB_crmopp_browse
@synthesize idb;
-(id)init{
    idb=[DBManager getSharedInstance];
    return self;
}
-(BOOL)fn_save_crmopp_browse:(NSMutableArray*)alist_result{
    if ([[idb fn_get_db] open]) {
        for (RespOpportunities *lmap_data in alist_result) {
            NSMutableDictionary *ldict_row=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
            BOOL ib_updated =[[idb fn_get_db] executeUpdate:@"insert into crmopp_browse (uid,opp_id,opp_code,opp_ref_type,opp_ref_id,opp_ref_code,opp_ref_name,opp_ref_addr,opp_ref_addr_01,opp_ref_addr_02,opp_ref_addr_03,opp_ref_addr_04,opp_name,contact_id,contact_code,contact_name,contact_tel,contact_email,contact_mobile,opp_stage,opp_stage_desc,opp_remark,opp_probability,assign_to,assign_to_name,campaign_id,campaign_name,op_type,load_main_region_code,load_main_region_name,load_sub_region_code,load_sub_region_name,load_region_code,load_region_name,load_code,load_name,dish_main_region_code,dish_main_region_name,dish_sub_region_code,dish_sub_region_name,dish_region_code,dish_region_name,dish_code,dish_name,dest_code,dest_name,srvc_code,srvc_desc,movement_code,movement_desc,inco_term,inco_term_desc,brand,competitor_rmk,volume,cbm_annual,teu_annual,kgs_annual,fcl_lcl,voided,rec_crt_user,rec_upd_user,rec_crt_date,rec_upd_date,rec_upd_type,rec_savable,rec_deletable) values (:uid,:opp_id,:opp_code,:opp_ref_type,:opp_ref_id,:opp_ref_code,:opp_ref_name,:opp_ref_addr,:opp_ref_addr_01,:opp_ref_addr_02,:opp_ref_addr_03,:opp_ref_addr_04,:opp_name,:contact_id,:contact_code,:contact_name,:contact_tel,:contact_email,:contact_mobile,:opp_stage,:opp_stage_desc,:opp_remark,:opp_probability,:assign_to,:assign_to_name,:campaign_id,:campaign_name,:op_type,:load_main_region_code,:load_main_region_name,:load_sub_region_code,:load_sub_region_name,:load_region_code,:load_region_name,:load_code,:load_name,:dish_main_region_code,:dish_main_region_name,:dish_sub_region_code,:dish_sub_region_name,:dish_region_code,:dish_region_name,:dish_code,:dish_name,:dest_code,:dest_name,:srvc_code,:srvc_desc,:movement_code,:movement_desc,:inco_term,:inco_term_desc,:brand,:competitor_rmk,:volume,:cbm_annual,:teu_annual,:kgs_annual,:fcl_lcl,:voided,:rec_crt_user,:rec_upd_user,:rec_crt_date,:rec_upd_date,:rec_upd_type,:rec_savable,:rec_deletable)" withParameterDictionary:ldict_row];
            if (! ib_updated)
                return NO;
        }
        [[idb fn_get_db] close];
        return  YES;
    }
    return NO;
}
-(NSMutableArray*)fn_get_data{
    NSMutableArray *arr=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *lfmdb_result=[[idb fn_get_db] executeQuery:@"SELECT * FROM crmopp_browse"];
        while ([lfmdb_result next]) {
            [arr addObject:[lfmdb_result resultDictionary]];
        }
        [[idb fn_get_db] close];
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

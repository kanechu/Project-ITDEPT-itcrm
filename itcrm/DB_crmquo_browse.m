//
//  DB_crmquo_browse.m
//  itcrm
//
//  Created by itdept on 14-7-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_crmquo_browse.h"
#import "FMDatabaseAdditions.h"
#import "DBManager.h"
#import "RespCrmquo_browse.h"

@implementation DB_crmquo_browse
@synthesize idb;
-(id)init{
    idb=[DBManager getSharedInstance];
    return self;
}
-(BOOL)fn_save_crmquo_browse_data:(NSMutableArray*)alist_result{
    if ([[idb fn_get_db]open]) {
        for (RespCrmquo_browse *lmap_data in alist_result) {
            NSMutableDictionary *idic_quo=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
            BOOL ib_updated =[[idb fn_get_db] executeUpdate:@"insert into crmquo_browse (uid,quo_uid,quo_no,nature,issue_date,cst_id,cst_code,cst_name,addr_01,addr_02,addr_03,addr_04,addr_05,acct_id,acct_code,acct_name,cst_attn,cst_tel,cst_fax,remark,ft_remark,credit_remark,header_remark,min_amt,load_code,load_name,dish_code,dish_name,dest_code,dest_name,via_port,via_port_name,load_region_name,load_region_code,dest_region_name,dest_region_code,confirm,min_curr,min_curr_name,effective_date,expiry_date,place_of_receipt,salesman_code,salesman_name,one_time,info_uid,fcl_lcl,cntr_p1,cntr_p2,cntr_p3,cntr_p4,pkg_unit_code,pkg,cbm,kgs,charge_desc,rec_crt_user,rec_upd_user,rec_crt_date,rec_upd_date,rec_upd_type,rec_savable,rec_deletable) values (:uid,:quo_uid,:quo_no,:nature,:issue_date,:cst_id,:cst_code,:cst_name,:addr_01,:addr_02,:addr_03,:addr_04,:addr_05,:acct_id,:acct_code,:acct_name,:cst_attn,:cst_tel,:cst_fax,:remark,:ft_remark,:credit_remark,:header_remark,:min_amt,:load_code,:load_name,:dish_code,:dish_name,:dest_code,:dest_name,:via_port,:via_port_name,:load_region_name,:load_region_code,:dest_region_name,:dest_region_code,:confirm,:min_curr,:min_curr_name,:effective_date,:expiry_date,:place_of_receipt,:salesman_code,:salesman_name,:one_time,:info_uid,:fcl_lcl,:cntr_p1,:cntr_p2,:cntr_p3,:cntr_p4,:pkg_unit_code,:pkg,:cbm,:kgs,:charge_desc,:rec_crt_user,:rec_upd_user,:rec_crt_date,:rec_upd_date,:rec_upd_type,:rec_savable,:rec_deletable)" withParameterDictionary:idic_quo];
            if (!ib_updated) {
                return NO;
            }
        }
        [[idb fn_get_db]close];
        return YES;
    }
    return NO;
}
-(NSMutableArray*)fn_get_crmquo_browse_data:(NSString*)quo_no select_sql:(NSString *)select_sql{
    NSString *sql=[NSString stringWithFormat:@"select %@ from crmquo_browse where quo_no like ?",select_sql];
    NSMutableArray *arr_crmquo=[NSMutableArray array];
    if ([[idb fn_get_db]open]) {
        FMResultSet *lfmdb_result=[[idb fn_get_db]executeQuery:sql,[NSString stringWithFormat:@"%%%@%%",quo_no]];
        while ([lfmdb_result next]) {
            [arr_crmquo addObject:[lfmdb_result resultDictionary]];
        }
    }
    return arr_crmquo;
}
-(BOOL)fn_delete_all_crmquo_data{
    if ([[idb fn_get_db]open]) {
        BOOL isSuccess=[[idb fn_get_db]executeUpdate:@"delete from crmquo_browse"];
        if (!isSuccess) {
            return NO;
        }
        [[idb fn_get_db]close];
        return YES;
    }
    return NO;
}


@end

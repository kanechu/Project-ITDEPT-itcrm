//
//  RespCrmacct_browse.h
//  itcrm
//
//  Created by itdept on 14-6-4.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RespCrmacct_browse : NSObject

@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *acct_id;
@property(nonatomic,copy)NSString *accttgt_id;
@property(nonatomic,copy)NSString *acct_code;
@property(nonatomic,copy)NSString *acct_name;
@property(nonatomic,copy)NSString *acct_addr_01;
@property(nonatomic,copy)NSString *acct_addr_02;
@property(nonatomic,copy)NSString *acct_addr_03;
@property(nonatomic,copy)NSString *acct_addr_04;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *postal_code;
@property(nonatomic,copy)NSString *acct_tel;
@property(nonatomic,copy)NSString *acct_fax;
@property(nonatomic,copy)NSString *acct_email;
@property(nonatomic,copy)NSString *acct_website;
@property(nonatomic,copy)NSString *assign_to;
@property(nonatomic,copy)NSString *assign_to_name;
@property(nonatomic,copy)NSString *acct_refer_by;
@property(nonatomic,copy)NSString *acct_remark;
@property(nonatomic,copy)NSString *rec_crt_user;
@property(nonatomic,copy)NSString *rec_upd_user;
@property(nonatomic,copy)NSString *rec_crt_date;
@property(nonatomic,copy)NSString *rec_upd_date;
@property(nonatomic,copy)NSString *rec_upd_type;
@property(nonatomic,copy)NSString *rec_savable;
@property(nonatomic,copy)NSString *rec_deletable;
@property(nonatomic,copy)NSString *acct_status;
@property(nonatomic,copy)NSString *acct_status_desc;
@property(nonatomic,copy)NSString *acct_type;
@property(nonatomic,copy)NSString *acct_type_desc;
@property(nonatomic,copy)NSString *country_code;
@property(nonatomic,copy)NSString *country_name;
@property(nonatomic,copy)NSString *region_code;
@property(nonatomic,copy)NSString *region_name;
@property(nonatomic,copy)NSString *acct_main_region_code;
@property(nonatomic,copy)NSString *acct_main_region_name;
@property(nonatomic,copy)NSString *acct_sub_region_code;
@property(nonatomic,copy)NSString *acct_sub_region_name;
@property(nonatomic,copy)NSString *acct_language;
@property(nonatomic,copy)NSString *lang_desc;
@property(nonatomic,copy)NSString *acct_src;
@property(nonatomic,copy)NSString *acct_src_desc;
@property(nonatomic,copy)NSString *acct_industry;
@property(nonatomic,copy)NSString *acct_industry_desc;
@property(nonatomic,copy)NSString *inco_term;
@property(nonatomic,copy)NSString *acct_inco_term_desc;
@property(nonatomic,copy)NSString *no_of_staff;
@property(nonatomic,copy)NSString *nomin_agent_list;
@property(nonatomic,copy)NSString *freehand_region_list;
@property(nonatomic,copy)NSString *coload_region_list;
@property(nonatomic,copy)NSString *commodity_list;
@property(nonatomic,copy)NSString *handle_sales_list;
@property(nonatomic,copy)NSString *is_svc_customs;
@property(nonatomic,copy)NSString *is_svc_truck;
@property(nonatomic,copy)NSString *is_svc_fob;
@property(nonatomic,copy)NSString *is_svc_cnf;
@property(nonatomic,copy)NSString *is_svc_dap;
@property(nonatomic,copy)NSString *is_svc_other;
@property(nonatomic,copy)NSString *is_nomin_by;
@property(nonatomic,copy)NSString *is_freehand;
@property(nonatomic,copy)NSString *is_co_loader;
@property(nonatomic,copy)NSString *accttgt_probability;
@property(nonatomic,copy)NSString *accttgt_desc;
@property(nonatomic,copy)NSString *accttgt_load_code;
@property(nonatomic,copy)NSString *accttgt_load_name;
@property(nonatomic,copy)NSString *accttgt_dest_code;
@property(nonatomic,copy)NSString *accttgt_dest_name;
@property(nonatomic,copy)NSString *accttgt_vol;
@property(nonatomic,copy)NSString *max_upd_date;

@end

//
//  UpdateFormContract.h
//  itcrm
//
//  Created by itdept on 14-7-7.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateFormContract : NSObject
@property(nonatomic,copy)NSString *anrd_upd_date;
@property(nonatomic,copy)NSString *assign_to;
@property(nonatomic,copy)NSString *assign_to_name;
@property(nonatomic,copy)NSString *contact_id;
@property(nonatomic,copy)NSString *contact_code;
@property(nonatomic,copy)NSString *contact_name;
@property(nonatomic,copy)NSString *contact_email;
@property(nonatomic,copy)NSString *contact_mobile;
@property(nonatomic,copy)NSString *contact_tel;
@property(nonatomic,copy)NSString *duration_ttl;
@property(nonatomic,copy)NSString *duration_hr;
@property(nonatomic,copy)NSString *duration_min;
@property(nonatomic,copy)NSString *duration_str;
@property(nonatomic,copy)NSString *quo_uid;
@property(nonatomic,copy)NSString *quo_no;
@property(nonatomic,copy)NSString *rec_crt_user;
@property(nonatomic,copy)NSString *rec_upd_user;
@property(nonatomic,copy)NSString *rec_crt_date;
@property(nonatomic,copy)NSString *rec_upd_date;
@property(nonatomic,copy)NSString *rec_upd_type;
@property(nonatomic,copy)NSString *rec_savable;
@property(nonatomic,copy)NSString *rec_deletable;
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *task_id;
@property(nonatomic,copy)NSString *task_ref_id;
@property(nonatomic,copy)NSString *task_ref_type;
@property(nonatomic,copy)NSString *task_ref_code;
@property(nonatomic,copy)NSString *task_ref_name;
@property(nonatomic,copy)NSString *task_ref_addr;
@property(nonatomic,copy)NSString *task_ref_addr_01;
@property(nonatomic,copy)NSString *task_ref_addr_02;
@property(nonatomic,copy)NSString *task_ref_addr_03;
@property(nonatomic,copy)NSString *task_ref_addr_04;
@property(nonatomic,copy)NSString *task_title;
@property(nonatomic,copy)NSString *task_desc;
@property(nonatomic,copy)NSString *task_start_date;
@property(nonatomic,copy)NSString *task_end_date;
@property(nonatomic,copy)NSString *task_report;
@property(nonatomic,copy)NSString *task_sm_report;
@property(nonatomic,copy)NSString *voided;
@property(nonatomic,copy)NSString *task_type;
@property(nonatomic,copy)NSString *task_type_desc;
@property(nonatomic,copy)NSString *task_type_lang;
@property(nonatomic,copy)NSString *task_status;
@property(nonatomic,copy)NSString *task_status_desc;
@property(nonatomic,copy)NSString *task_status_lang;
@property(nonatomic,copy)NSString *task_date_period;
@property(nonatomic,copy)NSString *report_submit;
@property(nonatomic,copy)NSString *report_mail;
@property(nonatomic,copy)NSString *unique_id;
@end

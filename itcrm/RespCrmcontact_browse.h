//
//  RespCrmcontact_browse.h
//  itcrm
//
//  Created by itdept on 14-7-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RespCrmcontact_browse : NSObject
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *contact_id;
@property(nonatomic,copy)NSString *contact_code;
@property(nonatomic,copy)NSString *contact_type;
@property(nonatomic,copy)NSString *contact_ref_id;
@property(nonatomic,copy)NSString *contact_ref_name;
@property(nonatomic,copy)NSString *contact_ref_code;
@property(nonatomic,copy)NSString *contact_name;
@property(nonatomic,copy)NSString *contact_title;
@property(nonatomic,copy)NSString *contact_dept;
@property(nonatomic,copy)NSString *contact_mobile;
@property(nonatomic,copy)NSString *contact_tel;
@property(nonatomic,copy)NSString *contact_fax;
@property(nonatomic,copy)NSString *contact_email;
@property(nonatomic,copy)NSString *contact_language;
@property(nonatomic,copy)NSString *lang_desc;
@property(nonatomic,copy)NSString *assign_to;
@property(nonatomic,copy)NSString *assign_to_name;
@property(nonatomic,copy)NSString *voided;
@property(nonatomic,copy)NSString *rec_crt_user;
@property(nonatomic,copy)NSString *rec_upd_user;
@property(nonatomic,copy)NSString *rec_crt_date;
@property(nonatomic,copy)NSString *rec_upd_date;
@property(nonatomic,copy)NSString *rec_upd_type;
@property(nonatomic,copy)NSString *rec_savable;
@property(nonatomic,copy)NSString *rec_deletable;

@end

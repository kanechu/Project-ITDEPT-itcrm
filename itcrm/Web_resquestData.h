//
//  Web_resquestData.h
//  itcrm
//
//  Created by itdept on 14-6-4.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Web_base.h"
#import "DB_searchCriteria.h"
#import "DB_Login.h"
#import "DB_formatlist.h"
#import "DB_Region.h"
#import "DB_systemIcon.h"
#import "DB_crmopp_browse.h"
#import "DB_crmtask_browse.h"
#import "DB_MaintForm.h"
#import "DB_crmhbl_browse.h"
#import "DB_crmcontact_browse.h"
#import "DB_crmquo_browse.h"
#import "RespCrmopp_browse.h"
#import "RespCrmtask_browse.h"
#import "RespCrmhbl_browse.h"
#import "RespCrmcontact_browse.h"
#import "RespCrmquo_browse.h"
@interface Web_resquestData : NSObject
@property (strong, nonatomic) CallBack_resp_result callBack;
- (void) fn_get_permit_data:(NSString*)base_url;
- (void) fn_get_search_data:(NSString*)base_url;
- (void) fn_get_formatlist_data:(NSString*)base_url;
- (void) fn_get_crmacct_browse_data:(NSString*)base_url searchForms:(NSSet*)iSet_searchForms;
- (void) fn_get_mslookup_data:(NSString*)base_url;
- (void) fn_get_systemIcon_data:(NSString*)base_url os_value:(NSString*)value isUpdate:(NSInteger)flag_isUpdate;
- (void) fn_get_maintForm_data:(NSString*)base_url;
/*
- (void) fn_get_crmopp_browse_data:(NSString*)base_url;
- (void) fn_get_crmtask_browse_data:(NSString*)base_url;
- (void) fn_get_crmhbl_browse_data:(NSString*)base_url;
- (void) fn_get_crmcontact_browse_data:(NSString*)base_url;
- (void) fn_get_crmquo_browse_data:(NSString*)base_url;
 */
- (void) fn_get_crmacct_relate_data:(NSString*)base_url alist_acc_id:(NSArray*)alist_acc_id;
@end

//
//  Web_resquestData.h
//  itcrm
//
//  Created by itdept on 14-6-4.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Web_resquestData : NSObject

- (void) fn_get_permit_data:(NSString*)base_url;
- (void) fn_get_search_data:(NSString*)base_url;
- (void) fn_get_formatlist_data:(NSString*)base_url;
- (void) fn_get_crmacct_browse_data:(NSString*)base_url;
- (void) fn_get_mslookup_data:(NSString*)base_url;
- (void) fn_get_systemIcon_data:(NSString*)base_url os_value:(NSString*)value;
- (void) fn_get_crmopp_browse_data:(NSString*)base_url;
- (void) fn_get_maintForm_data:(NSString*)base_url;
- (void) fn_get_crmtask_browse_data:(NSString*)base_url;
- (void) fn_get_crmhbl_browse_data:(NSString*)base_url;
- (void) fn_get_crmcontact_browse_data:(NSString*)base_url;
- (void) fn_get_crmquo_browse_data:(NSString*)base_url;
@end

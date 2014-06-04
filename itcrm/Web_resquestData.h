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
@end

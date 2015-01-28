//
//  AppConstants.h
//  worldtrans
//
//  Created by itdept on 2/27/14.
//  Copyright (c) 2014 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
#define APP_CODE @"MOB_ITCRM"
#define ITCRM_VERSION [[[NSBundle mainBundle]infoDictionary]valueForKey:@"CFBundleShortVersionString"]!=nil ? [[[NSBundle mainBundle]infoDictionary]valueForKey:@"CFBundleShortVersionString"] : @"1.0"
#define IS_ENCRYPTED @"0"
#define SYSTEM_VERSION_GREATER_THAN_IOS8 ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )

@interface AppConstants : NSObject

extern NSString* const STR_BASE_URL;
extern NSString* const STR_SERVER_URL;
extern NSString* const STR_LOGIN_URL;
extern NSString* const STR_PERMIT_URL;
extern NSString* const STR_SEARCHCRITERIA_URL;
extern NSString* const STR_FORMATLIST_URL;
extern NSString* const STR_CRMACCT_BROWSE_URL;
extern NSString* const STR_REGION_URL;
extern NSString* const STR_SYSTEMICON_URL;
extern NSString* const STR_CRMOOP_BROWSE_URL;
extern NSString* const STR_MAINTFORM_URL;
extern NSString* const STR_CRMTASK_BROWSE_URL;
extern NSString* const STR_CRMHBL_BROWSE_URL;
extern NSString* const STR_CRMTASK_UPDATE_URL;
extern NSString* const STR_CRMCONTACT_BROWSE_URL;
extern NSString* const STR_CRMQUO_BROWSE_URL;
extern NSString* const STR_CRMCONTACT_UPDATE_URL;
extern NSString* const STR_CRMOPP_UPDATE_URL;
extern NSString* const STR_USERSLOGIN_URL;
@end

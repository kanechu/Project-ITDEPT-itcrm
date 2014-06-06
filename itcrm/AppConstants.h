//
//  AppConstants.h
//  worldtrans
//
//  Created by itdept on 2/27/14.
//  Copyright (c) 2014 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
#define DEFAULT_SYSTEM @"ITNEW"
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
@end

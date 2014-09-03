//
//  MYLocalizedString.h
//  LocalizationDemo
//
//  Created by itdept on 14-9-1.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MYLocalizedString(key, comment) \
[[MYLocalizedString getshareInstance] get:(key) alter:(comment)]
@interface MYLocalizedString : NSObject

+(MYLocalizedString*)getshareInstance;
- (void)fn_setLanguage_type:(NSString *)language;
- (NSString*)getCurrentLanguage;
- (NSString *)get:(NSString *)key alter:(NSString *)alternate;
@end

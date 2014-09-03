//
//  MYLocalizedString.m
//  LocalizationDemo
//
//  Created by itdept on 14-9-1.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "MYLocalizedString.h"
static NSBundle *bundle = nil;
@implementation MYLocalizedString
+(MYLocalizedString*)getshareInstance{
    static dispatch_once_t pred=0;
    __strong static MYLocalizedString* Localize=nil;
    dispatch_once(&pred, ^{
        Localize=[[self alloc]init];
        
    });
    return Localize;
}
- (NSString*)getCurrentLanguage
{
    NSArray *langArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"AppleLanguages"];
    return langArray[0];
}

- (void)fn_setLanguage_type:(NSString *)language {
   
    NSString *path = [[ NSBundle mainBundle ] pathForResource:language ofType:@"lproj" ];
    if (!path) {
        path = [[ NSBundle mainBundle ] pathForResource:@"en" ofType:@"lproj" ];
        //[self resetLocalization];
    }
    bundle = [NSBundle bundleWithPath:path];
    
}

- (NSString *)get:(NSString *)key alter:(NSString *)alternate{
   
    return [bundle localizedStringForKey:key value:alternate table:@"Local"];
}
@end

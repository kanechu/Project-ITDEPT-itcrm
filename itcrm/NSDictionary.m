//
//  Help_obj_2_dictionary.m
//  worldtrans
//
//  Created by itdept on 3/6/14.
//  Copyright (c) 2014 itdept. All rights reserved.
//

#import "NSDictionary.h"

@implementation NSDictionary(dictionaryWithObject)

+(NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        if ([obj valueForKey:key]==nil) {
            [dict setObject:@"" forKey:key];
        }else{
            [dict setObject:[obj valueForKey:key] forKey:key];
        }
    }
    
    free(properties);
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end
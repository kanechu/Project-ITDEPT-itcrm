//
//  NSArray.m
//  worldtrans
//
//  Created by itdept on 14-3-26.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "NSArray.h"

@implementation NSArray(ArrayWithObject)
+(NSArray *) arrayWithPropertiesOfObject:(id) obj{
    NSMutableArray *arr=[NSMutableArray array];
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [arr addObject:key];
    }
    
    free(properties);
    
    return [NSArray arrayWithArray:arr];
}
@end

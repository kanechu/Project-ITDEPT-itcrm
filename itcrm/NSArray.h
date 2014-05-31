//
//  NSArray.h
//  worldtrans
//
//  Created by itdept on 14-3-26.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <objc/runtime.h>

@interface NSArray(ArrayWithObject)

+(NSArray *) arrayWithPropertiesOfObject:(id) obj;

@end

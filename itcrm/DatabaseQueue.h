//
//  DatabaseQueue.h
//  fmdbDemo
//
//  Created by itdept on 14-10-6.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
@interface DatabaseQueue : NSObject
+(DatabaseQueue*)fn_sharedInstance;
-(void)inDataBase:(void(^)(FMDatabase*))block;
@end

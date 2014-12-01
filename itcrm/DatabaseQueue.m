//
//  DatabaseQueue.m
//  fmdbDemo
//
//  Created by itdept on 14-10-6.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DatabaseQueue.h"

#import "DBManager.h"
#import "FMDatabase.h"
@implementation DatabaseQueue{
    FMDatabaseQueue *queue;
}
-(id)init{
    self=[super init];
    if (self) {
        DBManager *idb=[DBManager getSharedInstance];
        queue=[FMDatabaseQueue databaseQueueWithPath:[idb fn_get_databaseFilePath]];
    }
    return self;
}
+(DatabaseQueue*)fn_sharedInstance{
    __strong static id _shareObj=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareObj=[[self alloc]init];
    });
    return _shareObj;
}
-(void)inDataBase:(void(^)(FMDatabase*))block{
    [queue inDatabase:^(FMDatabase *db){
        block(db);
    }];
}

@end

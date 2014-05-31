//
//  DBManager.h
//  worldtrans
//
//  Created by itdept on 2/26/14.
//  Copyright (c) 2014 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FMDatabase.h"


@interface DBManager : NSObject
{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;
-(FMDatabase*) fn_get_db;
-(BOOL) fn_create_db;
-(BOOL)fn_create_table;
- (int) fn_get_version;
- (void)fn_set_version:(int)ai_version;
- (BOOL)fn_chk_need_migration;
- (void) fn_db_migrate;


@end

//
//  DBManager.m
//  worldtrans
//
//  Created by itdept on 2/26/14.
//  Copyright (c) 2014 itdept. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"

static DBManager *sharedInstance = nil;
static FMDatabase *database = nil;
static int DB_VERSION = 1;

#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }


@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance fn_create_db];
    } else {
        if (![database openWithFlags:SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FILEPROTECTION_COMPLETE]) {
            database = nil;
        }
    }
    return sharedInstance;
}


-(FMDatabase*) fn_get_db{
    return database;
}

-(BOOL)fn_create_db{
    NSArray *llist_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *ls_documentDirectory = [llist_paths objectAtIndex:0];
    NSString *ls_dbPath = [ls_documentDirectory stringByAppendingPathComponent:@"itdept.db"];
    
    BOOL lb_Success = YES;
    database= [FMDatabase databaseWithPath:ls_dbPath] ;
    if (![database open]) {
        lb_Success = NO;
        NSLog(@"Failed to open/create database");
    } else {
        return  [self fn_create_table];
    }
    return lb_Success;
}


-(BOOL)fn_create_table{
    BOOL lb_Success = YES;
    if (![database open]) {
        lb_Success = NO;
        NSLog(@"Failed to open/create database");
    } else {
       
        NSString *ls_sql_Resplogin = @"CREATE TABLE IF NOT EXISTS Resplogin( unique_id INTEGER PRIMARY KEY,company_code TEXT NOT NULL DEFAULT '',sys_name TEXT NOT NULL DEFAULT '',env TEXT NOT NULL DEFAULT '',web_addr TEXT)";
        NSString *ls_sql_loginInfo = @"CREATE TABLE IF NOT EXISTS loginInfo( unique_id INTEGER PRIMARY KEY,user_code TEXT NOT NULL DEFAULT '',password TEXT NOT NULL DEFAULT '',system TEXT NOT NULL DEFAULT '')";
        [database executeUpdate:ls_sql_Resplogin];
        [database executeUpdate:ls_sql_loginInfo];
        [database close];
        return  lb_Success;
    }
    return lb_Success;
}

- (int) fn_get_version {
    FMResultSet *resultSet = [database executeQuery:@"PRAGMA user_version"];
    int li_version = 0;
    if ([resultSet next]) {
        li_version = [resultSet intForColumnIndex:0];
    }
    return li_version;
}

- (void)fn_set_version:(int)ai_version {
    // FMDB cannot execute this query because FMDB tries to use prepared statements
    sqlite3_exec(database.sqliteHandle, [[NSString stringWithFormat:@"PRAGMA user_version = %d", ai_version] UTF8String], NULL, NULL, NULL);
}

- (BOOL)fn_chk_need_migration {
    return [self fn_get_version] < DB_VERSION;
}

- (void) fn_db_migrate {
    int version = [self fn_get_version];
    if (version >= DB_VERSION)
        return;
    
    NSLog(@"Migrating database schema from version %d to version %d", version, DB_VERSION);
    
    // ...the actual migration code...
    /*if (version < 1) {
        [[self database] executeUpdate:@"CREATE TABLE foo (...)"];
    }*/
    
    [self fn_set_version:DB_VERSION];
    NSLog(@"Database schema version after migration is %d", [self fn_get_version]);
}

@end

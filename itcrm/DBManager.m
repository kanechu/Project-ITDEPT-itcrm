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
        NSString *ls_sql_searchCriteria = @"CREATE TABLE IF NOT EXISTS searchCriteria( unique_id INTEGER PRIMARY KEY,srch_type TEXT NOT NULL DEFAULT '',seq TEXT NOT NULL DEFAULT '',col_code TEXT NOT NULL DEFAULT '',col_label TEXT NOT NULL DEFAULT '',col_type TEXT NOT NULL DEFAULT '',col_option TEXT NOT NULL DEFAULT '',col_def TEXT NOT NULL DEFAULT '',group_name TEXT NOT NULL DEFAULT '',is_mandatory TEXT NOT NULL DEFAULT '',icon_name TEXT NOT NULL DEFAULT '')";
        
         NSString *ls_sql_formatlist = @"CREATE TABLE IF NOT EXISTS formatlist( unique_id INTEGER PRIMARY KEY,list_id TEXT NOT NULL DEFAULT '',list_size TEXT NOT NULL DEFAULT '',uid TEXT NOT NULL DEFAULT '',t_title TEXT NOT NULL DEFAULT '',v_title TEXT NOT NULL DEFAULT '',t_desc1 TEXT NOT NULL DEFAULT '',t_desc2 TEXT NOT NULL DEFAULT '',t_desc3 TEXT NOT NULL DEFAULT '',t_desc4 TEXT NOT NULL DEFAULT '',t_desc5 TEXT NOT NULL DEFAULT '',v_desc1 TEXT NOT NULL DEFAULT '',v_desc2 TEXT NOT NULL DEFAULT '',v_desc3 TEXT NOT NULL DEFAULT '',v_desc4 TEXT NOT NULL DEFAULT '',v_desc5 TEXT NOT NULL DEFAULT '',icon TEXT NOT NULL DEFAULT '',select_sql TEXT NOT NULL DEFAULT '')";
         NSString *ls_sql_crmacct_browse = @"CREATE TABLE IF NOT EXISTS crmacct_browse( unique_id INTEGER PRIMARY KEY,uid TEXT NOT NULL DEFAULT '',acct_id TEXT NOT NULL DEFAULT '',accttgt_id TEXT NOT NULL DEFAULT '',acct_code TEXT NOT NULL DEFAULT '',acct_name TEXT NOT NULL DEFAULT '',acct_addr_01 TEXT NOT NULL DEFAULT '',acct_addr_02 TEXT NOT NULL DEFAULT '',acct_addr_03 TEXT NOT NULL DEFAULT '',acct_addr_04 TEXT NOT NULL DEFAULT '',city TEXT NOT NULL DEFAULT '',state TEXT NOT NULL DEFAULT '',postal_code TEXT NOT NULL DEFAULT '',acct_tel TEXT NOT NULL DEFAULT '',acct_fax TEXT NOT NULL DEFAULT '',acct_email TEXT NOT NULL DEFAULT '',acct_website TEXT NOT NULL DEFAULT '',assign_to TEXT NOT NULL DEFAULT '',assign_to_name TEXT NOT NULL DEFAULT '',acct_refer_by TEXT NOT NULL DEFAULT '',acct_remark TEXT NOT NULL DEFAULT '',rec_crt_user TEXT NOT NULL DEFAULT '',rec_upd_user TEXT NOT NULL DEFAULT '',rec_crt_date TEXT NOT NULL DEFAULT '',rec_upd_date TEXT NOT NULL DEFAULT '',rec_upd_type TEXT NOT NULL DEFAULT '',rec_savable TEXT NOT NULL DEFAULT '',rec_deletable TEXT NOT NULL DEFAULT '',acct_status TEXT NOT NULL DEFAULT '',acct_status_desc TEXT NOT NULL DEFAULT '',acct_type TEXT NOT NULL DEFAULT '',acct_type_desc TEXT NOT NULL DEFAULT '',country_code TEXT NOT NULL DEFAULT '',country_name TEXT NOT NULL DEFAULT '',region_code TEXT NOT NULL DEFAULT '',region_name TEXT NOT NULL DEFAULT '',acct_main_region_code TEXT NOT NULL DEFAULT '',acct_main_region_name TEXT NOT NULL DEFAULT '',acct_sub_region_code TEXT NOT NULL DEFAULT '',acct_sub_region_name TEXT NOT NULL DEFAULT '',acct_language TEXT NOT NULL DEFAULT '',lang_desc TEXT NOT NULL DEFAULT '',acct_src TEXT NOT NULL DEFAULT '',acct_src_desc TEXT NOT NULL DEFAULT '',acct_industry TEXT NOT NULL DEFAULT '',acct_industry_desc TEXT NOT NULL DEFAULT '',inco_term TEXT NOT NULL DEFAULT '',acct_inco_term_desc TEXT NOT NULL DEFAULT '',no_of_staff TEXT NOT NULL DEFAULT '',nomin_agent_list TEXT NOT NULL DEFAULT '',freehand_region_list TEXT NOT NULL DEFAULT '',coload_region_list TEXT NOT NULL DEFAULT '',commodity_list TEXT NOT NULL DEFAULT '',handle_sales_list TEXT NOT NULL DEFAULT '',is_svc_customs TEXT NOT NULL DEFAULT '',is_svc_truck TEXT NOT NULL DEFAULT '',is_svc_fob TEXT NOT NULL DEFAULT '',is_svc_cnf TEXT NOT NULL DEFAULT '',is_svc_dap TEXT NOT NULL DEFAULT '',is_svc_other TEXT NOT NULL DEFAULT '',is_nomin_by TEXT NOT NULL DEFAULT '',is_freehand TEXT NOT NULL DEFAULT '',is_co_loader TEXT NOT NULL DEFAULT '',accttgt_probability TEXT NOT NULL DEFAULT '',accttgt_desc TEXT NOT NULL DEFAULT '',accttgt_load_code TEXT NOT NULL DEFAULT '',accttgt_load_name TEXT NOT NULL DEFAULT '',accttgt_dest_code TEXT NOT NULL DEFAULT '',accttgt_dest_name TEXT NOT NULL DEFAULT '',accttgt_vol TEXT NOT NULL DEFAULT '')";
        
          NSString *ls_sql_region = @"CREATE TABLE IF NOT EXISTS region( unique_id INTEGER PRIMARY KEY,type TEXT NOT NULL DEFAULT '',display TEXT NOT NULL DEFAULT '',data TEXT NOT NULL DEFAULT '',desc TEXT NOT NULL DEFAULT '',image TEXT NOT NULL DEFAULT '')";
        NSString *ls_sql_systemIcon = @"CREATE TABLE IF NOT EXISTS systemIcon( unique_id INTEGER PRIMARY KEY,ic_name TEXT NOT NULL DEFAULT '',ic_content TEXT NOT NULL DEFAULT '',upd_date TEXT NOT NULL DEFAULT '')";
         NSString *ls_sql_crmopp_browse = @"CREATE TABLE IF NOT EXISTS crmopp_browse( unique_id INTEGER PRIMARY KEY,uid TEXT NOT NULL DEFAULT '',opp_id TEXT NOT NULL DEFAULT '',opp_code TEXT NOT NULL DEFAULT '',opp_ref_type TEXT NOT NULL DEFAULT '',opp_ref_id TEXT NOT NULL DEFAULT '',opp_ref_code TEXT NOT NULL DEFAULT '',opp_ref_name TEXT NOT NULL DEFAULT '',opp_ref_addr TEXT NOT NULL DEFAULT '',opp_ref_addr_01 TEXT NOT NULL DEFAULT '',opp_ref_addr_02 TEXT NOT NULL DEFAULT '',opp_ref_addr_03 TEXT NOT NULL DEFAULT '',opp_ref_addr_04 TEXT NOT NULL DEFAULT '',opp_name TEXT NOT NULL DEFAULT '',contact_id TEXT NOT NULL DEFAULT '',contact_code TEXT NOT NULL DEFAULT '',contact_name TEXT NOT NULL DEFAULT '',contact_tel TEXT NOT NULL DEFAULT '',contact_email TEXT NOT NULL DEFAULT '',contact_mobile TEXT NOT NULL DEFAULT '',opp_stage TEXT NOT NULL DEFAULT '',opp_stage_desc TEXT NOT NULL DEFAULT '',exp_close_date TEXT NOT NULL DEFAULT '',opp_remark TEXT NOT NULL DEFAULT '',opp_probability TEXT NOT NULL DEFAULT '',assign_to TEXT NOT NULL DEFAULT '',assign_to_name TEXT NOT NULL DEFAULT '',campaign_id TEXT NOT NULL DEFAULT '',campaign_name TEXT NOT NULL DEFAULT '',op_type TEXT NOT NULL DEFAULT '',load_main_region_code TEXT NOT NULL DEFAULT '',load_main_region_name TEXT NOT NULL DEFAULT '',load_sub_region_code TEXT NOT NULL DEFAULT '',load_sub_region_name TEXT NOT NULL DEFAULT '',load_region_code TEXT NOT NULL DEFAULT '',load_region_name TEXT NOT NULL DEFAULT '',load_code TEXT NOT NULL DEFAULT '',load_name TEXT NOT NULL DEFAULT '',dish_main_region_code TEXT NOT NULL DEFAULT '',dish_main_region_name TEXT NOT NULL DEFAULT '',dish_sub_region_code TEXT NOT NULL DEFAULT '',dish_sub_region_name TEXT NOT NULL DEFAULT '',dish_region_code TEXT NOT NULL DEFAULT '',dish_region_name TEXT NOT NULL DEFAULT '',dish_code TEXT NOT NULL DEFAULT '',dish_name TEXT NOT NULL DEFAULT '',dest_code TEXT NOT NULL DEFAULT '',dest_name TEXT NOT NULL DEFAULT '',srvc_code TEXT NOT NULL DEFAULT '',srvc_desc TEXT NOT NULL DEFAULT '',movement_code TEXT NOT NULL DEFAULT '',movement_desc TEXT NOT NULL DEFAULT '',inco_term TEXT NOT NULL DEFAULT '',inco_term_desc TEXT NOT NULL DEFAULT '',brand TEXT NOT NULL DEFAULT '',competitor_rmk TEXT NOT NULL DEFAULT '',volume TEXT NOT NULL DEFAULT '',cbm_annual TEXT NOT NULL DEFAULT '',teu_annual TEXT NOT NULL DEFAULT '',kgs_annual TEXT NOT NULL DEFAULT '',fcl_lcl TEXT NOT NULL DEFAULT '',voided TEXT NOT NULL DEFAULT '',rec_crt_user TEXT NOT NULL DEFAULT '',rec_upd_user TEXT NOT NULL DEFAULT '',rec_crt_date TEXT NOT NULL DEFAULT '',rec_upd_date TEXT NOT NULL DEFAULT '',rec_upd_type TEXT NOT NULL DEFAULT '',rec_savable TEXT NOT NULL DEFAULT '',rec_deletable TEXT NOT NULL DEFAULT '')";
        
         NSString *ls_sql_maintForm = @"CREATE TABLE IF NOT EXISTS maintForm( unique_id INTEGER PRIMARY KEY,form_id TEXT NOT NULL DEFAULT '',seq TEXT NOT NULL DEFAULT '',col_code TEXT NOT NULL DEFAULT '',col_label TEXT NOT NULL DEFAULT '',col_type TEXT NOT NULL DEFAULT '',col_option TEXT NOT NULL DEFAULT '',col_def TEXT NOT NULL DEFAULT '',group_name TEXT NOT NULL DEFAULT '',is_mandatory TEXT NOT NULL DEFAULT '',is_enable TEXT NOT NULL DEFAULT '',icon_name TEXT NOT NULL DEFAULT '')";
        
         NSString *ls_sql_crmtask_browse = @"CREATE TABLE IF NOT EXISTS crmtask_browse( unique_id INTEGER PRIMARY KEY,uid TEXT NOT NULL DEFAULT '',task_id TEXT NOT NULL DEFAULT'',task_ref_id TEXT NOT NULL DEFAULT '',task_ref_type TEXT NOT NULL DEFAULT '',task_ref_code TEXT NOT NULL DEFAULT '',task_ref_name TEXT NOT NULL DEFAULT '',contact_id TEXT NOT NULL DEFAULT '',contact_code TEXT NOT NULL DEFAULT '',contact_name TEXT NOT NULL DEFAULT '',contact_email TEXT NOT NULL DEFAULT '',contact_mobile TEXT NOT NULL DEFAULT '', contact_tel TEXT NOT NULL DEFAULT '',task_ref_addr TEXT NOT NULL DEFAULT '',task_ref_addr_01 TEXT NOT NULL DEFAULT '',task_ref_addr_02 TEXT NOT NULL DEFAULT '',task_ref_addr_03 TEXT NOT NULL DEFAULT '',task_ref_addr_04 TEXT NOT NULL DEFAULT '',task_title TEXT NOT NULL DEFAULT '',task_desc TEXT NOT NULL DEFAULT '',task_start_date TEXT NOT NULL DEFAULT '',task_end_date TEXT NOT NULL DEFAULT '',task_report TEXT NOT NULL DEFAULT '',task_sm_report TEXT NOT NULL DEFAULT '',duration_ttl TEXT NOT NULL DEFAULT '',duration_hr TEXT NOT NULL DEFAULT '',duration_min TEXT NOT NULL DEFAULT '',duration_str TEXT NOT NULL DEFAULT '',assign_to TEXT NOT NULL DEFAULT '',assign_to_name TEXT NOT NULL DEFAULT '',voided TEXT NOT NULL DEFAULT '',rec_crt_user TEXT NOT NULL DEFAULT '',rec_upd_user TEXT NOT NULL DEFAULT '',rec_crt_date TEXT NOT NULL DEFAULT '',rec_upd_date TEXT NOT NULL DEFAULT '',rec_upd_type TEXT NOT NULL DEFAULT '',rec_savable TEXT NOT NULL DEFAULT '',rec_deletable TEXT NOT NULL DEFAULT '',task_type TEXT NOT NULL DEFAULT '',task_type_desc TEXT NOT NULL DEFAULT '',task_status TEXT NOT NULL DEFAULT '',task_status_desc TEXT NOT NULL DEFAULT '',quo_uid TEXT NOT NULL DEFAULT '',quo_no TEXT NOT NULL DEFAULT '',task_date_period TEXT NOT NULL DEFAULT '',report_mail TEXT NOT NULL DEFAULT '',report_submit TEXT NOT NULL DEFAULT '')";
        NSString *ls_sql_crmhbl_browse = @"CREATE TABLE IF NOT EXISTS crmhbl_browse( unique_id INTEGER PRIMARY KEY,acct_id TEXT NOT NULL DEFAULT '',hbl_uid TEXT NOT NULL DEFAULT '',acct_name TEXT NOT NULL DEFAULT '',op_type TEXT NOT NULL DEFAULT '',desc TEXT NOT NULL DEFAULT '')";
        [database executeUpdate:ls_sql_Resplogin];
        [database executeUpdate:ls_sql_loginInfo];
        [database executeUpdate:ls_sql_searchCriteria];
        [database executeUpdate:ls_sql_formatlist];
        [database executeUpdate:ls_sql_crmacct_browse];
        [database executeUpdate:ls_sql_region];
        [database executeUpdate:ls_sql_systemIcon];
        [database executeUpdate:ls_sql_crmopp_browse];
        [database executeUpdate:ls_sql_maintForm];
        [database executeUpdate:ls_sql_crmtask_browse];
        [database executeUpdate:ls_sql_crmhbl_browse];
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

//
//  DB_crmopp_browse.h
//  itcrm
//
//  Created by itdept on 14-6-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBManager;
@interface DB_crmopp_browse : NSObject

@property(nonatomic,strong)DBManager *idb;

-(BOOL)fn_save_crmopp_browse:(NSMutableArray*)alist_result;

-(BOOL)fn_update_crmopp_data:(NSMutableDictionary*)idic_opp unique_id:(NSString*)unique_id;

-(BOOL)fn_update_crmopp_ismodified:(NSString*)is_modified unique_id:(NSString*)unique_id;

-(NSMutableArray*)fn_get_crmopp_data:(NSString*)opp_name select_sql:(NSString*)select_sql;

-(NSMutableArray*)fn_get_relate_crmopp_data:(NSString *)opp_ref_id select_sql:(NSString *)select_sql;

-(NSMutableArray*)fn_get_detail_crmopp_data:(NSMutableArray*)alist_searchData select_sql:(NSString*)select_sql;

-(NSMutableArray*)fn_get_crmopp_with_id:(NSString*)opp_id;

-(NSMutableArray*)fn_get_all_crmopp_data;

-(BOOL)fn_delete_all_data;

@end

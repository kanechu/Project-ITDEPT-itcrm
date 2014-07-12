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

-(NSMutableArray*)fn_get_crmopp_data:(NSString*)op_type;

-(NSMutableArray*)fn_get_relate_crmopp_data:(NSString *)opp_ref_id select_sql:(NSString *)select_sql;

-(NSMutableArray*)fn_get_crmopp_with_id:(NSString*)opp_id;

-(BOOL)fn_delete_all_data;

@end

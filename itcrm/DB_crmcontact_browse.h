//
//  DB_crmcontact_browse.h
//  itcrm
//
//  Created by itdept on 14-7-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBManager;
@interface DB_crmcontact_browse : NSObject
@property(nonatomic,strong)DBManager *idb;
-(BOOL)fn_save_crmcontact_browse:(NSMutableArray*)alist_result;
-(NSMutableArray*)fn_get_crmcontact_browse_data:(NSString*)contact_ref_name select_sql:(NSString *)select_sql;
-(BOOL)fn_delete_all_crmcontact_data;
@end

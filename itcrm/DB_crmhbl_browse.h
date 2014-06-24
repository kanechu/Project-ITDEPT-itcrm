//
//  DB_crmhbl_browse.h
//  itcrm
//
//  Created by itdept on 14-6-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBManager;
@interface DB_crmhbl_browse : NSObject
@property(nonatomic,strong)DBManager *idb;

-(BOOL)fn_save_crmhbl_browse:(NSMutableArray*)alist_result;

-(BOOL)fn_delete_all_data;

-(NSMutableArray*)fn_get_crmhbl_data:(NSString*)acct_name;

@end

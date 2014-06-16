//
//  DB_crmacct_browse.h
//  itcrm
//
//  Created by itdept on 14-6-4.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBManager;
@interface DB_crmacct_browse : NSObject

@property(nonatomic,strong)DBManager *idb;

-(BOOL)fn_save_crmacct_browse:(NSMutableArray*)alist_result;
-(NSMutableArray*)fn_get_data:(NSString*)acct_name;
-(BOOL)fn_delete_all_data;
-(NSMutableArray*)fn_get_detail_crmacct_data:(NSMutableArray*)alist_searchData;

@end

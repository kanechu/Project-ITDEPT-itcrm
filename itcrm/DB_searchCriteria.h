//
//  DB_searchCriteria.h
//  itcrm
//
//  Created by itdept on 14-6-3.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBManager;
@interface DB_searchCriteria : NSObject

@property(nonatomic,strong)DBManager *idb;
-(BOOL)fn_save_data:(NSMutableArray*)ilist_result;
-(NSMutableArray*)fn_get_all_data;
-(BOOL)fn_delete_all_data;
@end

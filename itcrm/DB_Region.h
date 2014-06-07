//
//  DB_Region.h
//  itcrm
//
//  Created by itdept on 14-6-5.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBManager;
@interface DB_Region : NSObject

@property(nonatomic,strong)DBManager *idb;
-(BOOL)fn_save_region_data:(NSMutableArray*)ilist_result;
-(NSMutableArray*)fn_get_region_data:(NSString*)type;
-(NSMutableArray*)fn_get_lookup_data:(NSString*)display type:(NSString*)type;
-(BOOL)fn_delete_region_data;

@end

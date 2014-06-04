//
//  DB_formatlist.h
//  itcrm
//
//  Created by itdept on 14-6-4.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBManager;
@interface DB_formatlist : NSObject

@property(nonatomic,strong)DBManager *idb;

-(BOOL)fn_save_formatlist_data:(NSMutableArray*)arr;
-(NSMutableArray*)fn_get_list_data:(NSString*)list_id;
-(BOOL)fn_delete_all_data;

@end

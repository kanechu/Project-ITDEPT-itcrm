//
//  DB_formatlist.h
//  itcrm
//
//  Created by itdept on 14-6-4.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatabaseQueue;
@interface DB_formatlist : NSObject
@property(nonatomic,strong)DatabaseQueue *queue;

-(BOOL)fn_save_formatlist_data:(NSMutableArray*)arr;

-(NSMutableArray*)fn_get_list_data:(NSString*)list_id;

-(NSString*)fn_get_select_sql:(NSString*)list_id;

-(BOOL)fn_delete_all_data;

@end

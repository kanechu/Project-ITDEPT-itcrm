//
//  DB_systemIcon.h
//  itcrm
//
//  Created by itdept on 14-6-6.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatabaseQueue;
@interface DB_systemIcon : NSObject

@property(nonatomic,strong)DatabaseQueue *queue;

-(BOOL)fn_save_systemIcon_data:(NSMutableArray*)ilist_result;

-(BOOL)fn_update_systemIcon_data:(NSString*)ic_content ic_name:(NSString*)ic_name;

-(NSMutableArray*)fn_get_systemIcon_data:(NSString*)ic_name;

-(NSMutableArray*)fn_get_last_update_time;

-(BOOL)fn_delete_systemIcon_data;

@end

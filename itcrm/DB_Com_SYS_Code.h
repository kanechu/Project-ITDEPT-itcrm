//
//  DB_Com_SYS_Code.h
//  itcrm
//
//  Created by itdept on 14-8-29.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatabaseQueue;
@interface DB_Com_SYS_Code : NSObject

@property(nonatomic,strong)DatabaseQueue *queue;

-(BOOL)fn_save_com_sys_code:(NSString*)sys_code lang_code:(NSString*)lang_code;
-(NSMutableArray*)fn_get_com_sys_code:(NSString*)lang_code;

-(BOOL)fn_delete_all_com_sys_code;

@end

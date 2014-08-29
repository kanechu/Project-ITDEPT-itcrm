//
//  DB_Com_SYS_Code.h
//  itcrm
//
//  Created by itdept on 14-8-29.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBManager;
@interface DB_Com_SYS_Code : NSObject

@property(nonatomic,strong)DBManager *idb;

-(BOOL)fn_save_com_sys_code:(NSString*)sys_code;
-(NSMutableArray*)fn_get_com_sys_code;

-(BOOL)fn_delete_all_com_sys_code;

@end

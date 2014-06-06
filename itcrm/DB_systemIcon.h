//
//  DB_systemIcon.h
//  itcrm
//
//  Created by itdept on 14-6-6.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBManager;
@interface DB_systemIcon : NSObject

@property(nonatomic,strong)DBManager *idb;

-(BOOL)fn_save_systemIcon_data:(NSMutableArray*)ilist_result;
-(NSMutableArray*)fn_get_systemIcon_data:(NSString*)ic_name;
-(BOOL)fn_delete_systemIcon_data;

@end

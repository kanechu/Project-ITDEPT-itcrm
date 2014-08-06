//
//  DB_Login.h
//  itcrm
//
//  Created by itdept on 14-5-31.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBManager;
@class AuthContract;
@interface DB_Login : NSObject
@property(nonatomic,strong)DBManager *idb;

-(BOOL)fn_save_data:(NSString*)user_id password:(NSString*)user_pass system:(NSString*)systemCode user_logo:(NSString*)user_logo;

-(NSMutableArray*)fn_get_allData;

-(BOOL)fn_delete_data;

-(AuthContract*)fn_request_auth;

@end

//
//  DB_RespLogin.h
//  itcrm
//
//  Created by itdept on 14-5-30.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, kAppConfig_field){
    kWeb_addr,
    kCompany_code,
    kPhp_addr
};
@class DatabaseQueue;
@interface DB_RespLogin : NSObject

@property(nonatomic,strong)DatabaseQueue *queue;

-(BOOL)fn_save_data:(NSMutableArray*)arr;
-(NSMutableArray*)fn_get_all_data;
-(BOOL)fn_delete_all_data;
-(NSString*)fn_get_field_content:(kAppConfig_field)field_name;
@end

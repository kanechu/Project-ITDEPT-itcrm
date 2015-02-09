//
//  CheckUpdate.h
//  itcrm
//
//  Created by itdept on 14-8-4.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckUpdate : NSObject

-(BOOL)fn_check_isNetworking;
-(void)fn_checkUpdate_all_db:(NSString*)acct_id;

@end

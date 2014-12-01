//
//  DB_crmquo_browse.h
//  itcrm
//
//  Created by itdept on 14-7-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatabaseQueue;
@interface DB_crmquo_browse : NSObject
@property(nonatomic,strong)DatabaseQueue *queue;

-(BOOL)fn_save_crmquo_browse_data:(NSMutableArray*)alist_result;
-(NSMutableArray*)fn_get_crmquo_browse_data:(NSString*)quo_no select_sql:(NSString *)select_sql;
-(BOOL)fn_delete_all_crmquo_data;
@end

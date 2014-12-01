//
//  DB_MaintForm.h
//  itcrm
//
//  Created by itdept on 14-6-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatabaseQueue;
@interface DB_MaintForm : NSObject

@property(nonatomic,strong)DatabaseQueue *queue;
-(BOOL)fn_save_MaintForm_data:(NSMutableArray*)ilist_result;
-(NSMutableArray*)fn_get_MaintForm_data:(NSString*)form_id;
-(BOOL)fn_delete_all_data;
-(NSMutableArray*)fn_get_groupNameAndNum:(NSString*)form_id;

@end

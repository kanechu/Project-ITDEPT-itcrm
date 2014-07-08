//
//  Web_updateData.h
//  itcrm
//
//  Created by itdept on 14-7-8.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UpdateFormContract;
typedef void (^CallBack_data)(NSMutableArray *arr_result);
@interface Web_updateData : NSObject

- (void) fn_get_updateStatus_data:(UpdateFormContract*)UpdateForm :(CallBack_data)callback;

@end

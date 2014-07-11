//
//  Web_updateData.m
//  itcrm
//
//  Created by itdept on 14-7-8.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Web_updateData.h"
#import "UploadingContract.h"
#import "UpdateFormContract.h"
#import "RespUpdateStatus.h"
#import "NSDictionary.h"
#import "DB_Login.h"
#import "DB_RespLogin.h"
#import "Web_base.h"
#import "NSArray.h"
#import "AppConstants.h"

@implementation Web_updateData

#pragma mark update
- (void) fn_get_updateStatus_data:(UpdateFormContract*)UpdateForm :(CallBack_data)callback{
    DB_RespLogin *db=[[DB_RespLogin alloc]init];
    NSMutableArray *arr=[db fn_get_all_data];
    NSString* base_url=nil;
    if (arr!=nil && [arr count]!=0) {
        base_url=[[arr objectAtIndex:0] valueForKey:@"web_addr"];
    }
    UploadingContract *req_form = [[UploadingContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    DB_Login *dbLogin=[[DB_Login alloc]init];
    auth=[dbLogin fn_request_auth];
    req_form.Auth =auth;
    req_form.UpdateForm = [NSSet setWithObjects:UpdateForm, nil];
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_CRMTASK_UPDATE_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespUpdateStatus class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespUpdateStatus class]];
    web_base.callback=^(NSMutableArray *arr_resp_result){
        callback(arr_resp_result);
    };
    [web_base fn_update_data:req_form];
}
@end
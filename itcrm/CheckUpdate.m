//
//  CheckUpdate.m
//  itcrm
//
//  Created by itdept on 14-8-4.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "CheckUpdate.h"
#import "Reachability.h"
#import "Web_updateData.h"
#import "RespCrmtask_browse.h"
#import "RespCrmcontact_browse.h"
#import "RespCrmopp_browse.h"
#import "DB_crmtask_browse.h"
#import "DB_crmcontact_browse.h"
#import "DB_crmopp_browse.h"
@implementation CheckUpdate
-(BOOL)fn_check_isNetworking{
    if (([Reachability reachabilityForInternetConnection].currentReachabilityStatus!=NotReachable)||([Reachability reachabilityForLocalWiFi].currentReachabilityStatus!=NotReachable)) {
        return YES;
    }else{
        return NO;
    }
}
-(void)fn_checkUpdate_all_db{
    if ([self fn_check_isNetworking]) {
        [self fn_checkUpdate_crmtask];
        [self fn_checkUpdate_crmcontact];
        [self fn_checkUpdate_crmopp];
    }
}
-(void)fn_checkUpdate_crmtask{
    Web_updateData *web_update=[[Web_updateData alloc]init];
    DB_crmtask_browse *db_crmtask=[[DB_crmtask_browse alloc]init];
    NSMutableArray *arr_crmtask=[db_crmtask fn_get_all_crmtask_data];
    for (NSMutableDictionary *idic in arr_crmtask) {
        NSString *is_modified=[idic valueForKey:@"is_modified"];
        if ([is_modified isEqualToString:@"1"]) {
            Respcrmtask_browse *upd_form=[[Respcrmtask_browse alloc]init];
            [web_update fn_get_updateStatus_data:[self fn_init_updateform:idic upd_form:upd_form ]path:STR_CRMTASK_UPDATE_URL :^(NSMutableArray *arr){
                NSString *status=nil;
                if ([arr count]!=0) {
                    status=[[arr objectAtIndex:0]valueForKey:@"status"];
                }
                if ([status isEqualToString:@"1"]) {
                    [db_crmtask fn_update_crmtask_ismodified:@"0" unique_id:[idic valueForKey:@"unique_id"]];
                }
            }];
        }
    }
}

-(void)fn_checkUpdate_crmcontact{
    Web_updateData *web_update=[[Web_updateData alloc]init];
    DB_crmcontact_browse *db_crmcontact=[[DB_crmcontact_browse alloc]init];
    NSMutableArray *arr_crmcontact=[db_crmcontact fn_get_all_crmcontact_data];
    for (NSMutableDictionary *idic in arr_crmcontact) {
        NSString *is_modified=[idic valueForKey:@"is_modified"];
        if ([is_modified isEqualToString:@"1"]) {
            RespCrmcontact_browse *upd_form=[[RespCrmcontact_browse alloc]init];
            [web_update fn_get_updateStatus_data:[self fn_init_updateform:idic upd_form:upd_form] path:STR_CRMCONTACT_UPDATE_URL :^(NSMutableArray *arr){
                NSString *status=nil;
                if ([arr count]!=0) {
                    status=[[arr objectAtIndex:0]valueForKey:@"status"];
                }
                if ([status isEqualToString:@"1"]) {
                    [db_crmcontact fn_update_crmcontact_ismodified:@"0" unique_id:[idic valueForKey:@"unique_id"]];
                }
            }];
        }
    }
}
-(void)fn_checkUpdate_crmopp{
    Web_updateData *web_update=[[Web_updateData alloc]init];
    DB_crmopp_browse *db_crmopp=[[DB_crmopp_browse alloc]init];
    NSMutableArray *arr_crmopp=[db_crmopp fn_get_all_crmopp_data];
    for (NSMutableDictionary *idic in arr_crmopp) {
        NSString *is_modified=[idic valueForKey:@"is_modified"];
        if ([is_modified isEqualToString:@"1"]) {
            RespCrmopp_browse *upd_form=[[RespCrmopp_browse alloc]init];
            [web_update fn_get_updateStatus_data:[self fn_init_updateform:idic upd_form:upd_form] path:STR_CRMOPP_UPDATE_URL :^(NSMutableArray *arr){
                NSString *status=nil;
                if ([arr count]!=0) {
                    status=[[arr objectAtIndex:0]valueForKey:@"status"];
                }
                if ([status isEqualToString:@"1"]) {
                    [db_crmopp fn_update_crmopp_ismodified:@"0" unique_id:[idic valueForKey:@"unique_id"]];
                }
            }];
        }
    }
}


-(id)fn_init_updateform:(NSMutableDictionary*)idic upd_form:(id)upd_form{
    NSString *unique_id=[idic valueForKey:@"unique_id"];
    [idic removeObjectForKey:@"unique_id"];
    [idic removeObjectForKey:@"is_modified"];
    [upd_form setValuesForKeysWithDictionary:idic];
    [idic setObject:unique_id forKey:@"unique_id"];
    return upd_form;
}


@end

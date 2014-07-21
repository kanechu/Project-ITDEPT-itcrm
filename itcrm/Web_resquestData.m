//
//  Web_resquestData.m
//  itcrm
//
//  Created by itdept on 14-6-4.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Web_resquestData.h"
#import "AuthContract.h"
#import "RequestContract.h"
#import "SearchFormContract.h"
#import "RespPermit.h"
#import "RespSearchCriteria.h"
#import "RespFormatlist.h"
#import "RespCrmacct_browse.h"
#import "RespRegion.h"
#import "RespSystemIcon.h"
#import "RespCrmopp_browse.h"
#import "RespMaintForm.h"
#import "RespCrmtask_browse.h"
#import "RespCrmhbl_browse.h"
#import "RespCrmcontact_browse.h"
#import "RespCrmquo_browse.h"
#import "Web_base.h"
#import "NSArray.h"
#import "NSDictionary.h"
#import "DB_searchCriteria.h"
#import "DB_Login.h"
#import "DB_formatlist.h"
#import "DB_crmacct_browse.h"
#import "DB_Region.h"
#import "DB_systemIcon.h"
#import "DB_crmopp_browse.h"
#import "DB_crmtask_browse.h"
#import "DB_MaintForm.h"
#import "DB_crmhbl_browse.h"
#import "DB_crmcontact_browse.h"
#import "DB_crmquo_browse.h"
#import "SVProgressHUD.h"
@implementation Web_resquestData

#pragma mark 请求permit的数据
- (void) fn_get_permit_data:(NSString*)base_url
{
    
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    DB_Login *dbLogin=[[DB_Login alloc]init];
    auth=[dbLogin fn_request_auth];
    req_form.Auth =auth;
    SearchFormContract *search = [[SearchFormContract alloc]init];
    search.os_column = @"app_code";
    search.os_value = @"ITNEW";
    SearchFormContract *search1 = [[SearchFormContract alloc]init];
    search1.os_column = @"type";
    search1.os_value = @"all";
    req_form.SearchForm = [NSSet setWithObjects:search1,search, nil];
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_PERMIT_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespPermit class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespPermit class]];
    web_base.callback=^(NSMutableArray *arr_resp_result){
        
    };
    [web_base fn_get_data:req_form];
    
}

#pragma mark 请求searchCriteria的数据
- (void) fn_get_search_data:(NSString*)base_url
{
    
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    DB_Login *dbLogin=[[DB_Login alloc]init];
    auth=[dbLogin fn_request_auth];
    req_form.Auth =auth;
    SearchFormContract *search = [[SearchFormContract alloc]init];
    search.os_column = @"form";
    search.os_value = @"crm";
    req_form.SearchForm = [NSSet setWithObjects:search, nil];
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_SEARCHCRITERIA_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespSearchCriteria class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespSearchCriteria class]];
    web_base.callback=^(NSMutableArray *arr_resp_result){
        DB_searchCriteria *db=[[DB_searchCriteria alloc]init];
        [db fn_save_searchCriteria_data:arr_resp_result];
    };
    [web_base fn_get_data:req_form];
    
}

#pragma mark 请求formatlist的数据
- (void) fn_get_formatlist_data:(NSString*)base_url{
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    DB_Login *dbLogin=[[DB_Login alloc]init];
    auth=[dbLogin fn_request_auth];
    req_form.Auth =auth;
    SearchFormContract *search = [[SearchFormContract alloc]init];
    search.os_column = @"list_id";
    search.os_value = @"crm";
    req_form.SearchForm = [NSSet setWithObjects:search, nil];
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_FORMATLIST_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespFormatlist class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespFormatlist class]];
    web_base.callback=^(NSMutableArray *arr_resp_result){
        DB_formatlist *db=[[DB_formatlist alloc]init];
        [db fn_save_formatlist_data:arr_resp_result];
    };
    [web_base fn_get_data:req_form];
}

#pragma mark 请求crmacct_browse的数据
- (void) fn_get_crmacct_browse_data:(NSString*)base_url{
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    DB_Login *dbLogin=[[DB_Login alloc]init];
    auth=[dbLogin fn_request_auth];
    req_form.Auth =auth;
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_CRMACCT_BROWSE_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespCrmacct_browse class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespCrmacct_browse class]];
    web_base.callback=^(NSMutableArray *arr_resp_result){
        DB_crmacct_browse *db=[[DB_crmacct_browse alloc]init];
        [db fn_save_crmacct_browse:arr_resp_result];
    };
    [web_base fn_get_data:req_form];
}

#pragma mark 请求lookup的数据
- (void) fn_get_mslookup_data:(NSString*)base_url
{
    
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    DB_Login *dbLogin=[[DB_Login alloc]init];
    auth=[dbLogin fn_request_auth];
    req_form.Auth =auth;
    SearchFormContract *search = [[SearchFormContract alloc]init];
    search.os_column = @"type";
    search.os_value = @"";
    req_form.SearchForm = [NSSet setWithObjects:search,nil];
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_REGION_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespRegion class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespRegion class]];
    web_base.callback=^(NSMutableArray *arr_resp_result){
        DB_Region *db=[[DB_Region alloc]init];
        [db fn_save_region_data:arr_resp_result];
    };

    [web_base fn_get_data:req_form];
    
}

#pragma mark 请求systemIcon的数据
- (void) fn_get_systemIcon_data:(NSString*)base_url os_value:(NSString*)value
{
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    DB_Login *dbLogin=[[DB_Login alloc]init];
    auth=[dbLogin fn_request_auth];
    req_form.Auth =auth;
    SearchFormContract *search = [[SearchFormContract alloc]init];
    search.os_column = @"rec_upd_date";
    search.os_value =value;
    req_form.SearchForm = [NSSet setWithObjects:search,nil];
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_SYSTEMICON_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespSystemIcon class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespSystemIcon class]];
    web_base.callback=^(NSMutableArray *arr_resp_result){
        DB_systemIcon *db=[[DB_systemIcon alloc]init];
        [db fn_save_systemIcon_data:arr_resp_result];
    };

    [web_base fn_get_data:req_form];
}

#pragma mark 请求crmopp_browse的数据
- (void) fn_get_crmopp_browse_data:(NSString*)base_url
{
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    DB_Login *dbLogin=[[DB_Login alloc]init];
    auth=[dbLogin fn_request_auth];
    req_form.Auth =auth;
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_CRMOOP_BROWSE_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespCrmopp_browse class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespCrmopp_browse class]];
    web_base.callback=^(NSMutableArray *arr_resp_result){
        DB_crmopp_browse *db=[[DB_crmopp_browse alloc]init];
        [db fn_save_crmopp_browse:arr_resp_result];
    };
    [web_base fn_get_data:req_form];
}

#pragma mark 请求maintForm的数据
- (void) fn_get_maintForm_data:(NSString*)base_url
{
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    DB_Login *dbLogin=[[DB_Login alloc]init];
    auth=[dbLogin fn_request_auth];
    req_form.Auth =auth;
    SearchFormContract *search = [[SearchFormContract alloc]init];
    search.os_column = @"form";
    search.os_value = @"crm";
    req_form.SearchForm = [NSSet setWithObjects:search, nil];
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_MAINTFORM_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespMaintForm class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespMaintForm class]];
    web_base.callback=^(NSMutableArray *arr_resp_result){
        DB_MaintForm *db=[[DB_MaintForm alloc]init];
        [db fn_save_MaintForm_data:arr_resp_result];
    };

    [web_base fn_get_data:req_form];
    
}

#pragma mark 请求crmtask_browse的数据
- (void) fn_get_crmtask_browse_data:(NSString*)base_url
{
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    DB_Login *dbLogin=[[DB_Login alloc]init];
    auth=[dbLogin fn_request_auth];
    req_form.Auth =auth;
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_CRMTASK_BROWSE_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[Respcrmtask_browse class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[Respcrmtask_browse class]];
    web_base.callback=^(NSMutableArray *arr_resp_result){
        DB_crmtask_browse *db=[[DB_crmtask_browse alloc]init];
        [db fn_save_crmtask_browse:arr_resp_result];
    };

    [web_base fn_get_data:req_form];
}

#pragma mark 请求crmhbl_browse的数据
- (void) fn_get_crmhbl_browse_data:(NSString*)base_url
{
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    DB_Login *dbLogin=[[DB_Login alloc]init];
    auth=[dbLogin fn_request_auth];
    req_form.Auth =auth;
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_CRMHBL_BROWSE_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespCrmhbl_browse class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespCrmhbl_browse class]];
    web_base.callback=^(NSMutableArray *arr_resp_result){
        DB_crmhbl_browse *db=[[DB_crmhbl_browse alloc]init];
        [db fn_save_crmhbl_browse:arr_resp_result];
    };

    [web_base fn_get_data:req_form];
}
#pragma mark 请求crmcontact_browse的数据
- (void) fn_get_crmcontact_browse_data:(NSString*)base_url{
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    DB_Login *dbLogin=[[DB_Login alloc]init];
    auth=[dbLogin fn_request_auth];
    req_form.Auth =auth;
    SearchFormContract *search = [[SearchFormContract alloc]init];
    search.os_column = @"form";
    search.os_value = @"crm";
    req_form.SearchForm = [NSSet setWithObjects:search, nil];
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_CRMCONTACT_BROWSE_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespCrmcontact_browse class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespCrmcontact_browse class]];
    web_base.callback=^(NSMutableArray *arr_resp_result){
        DB_crmcontact_browse *db=[[DB_crmcontact_browse alloc]init];
        [db fn_save_crmcontact_browse:arr_resp_result];
    };
    
    [web_base fn_get_data:req_form];
}
#pragma mark 请求crmquo_browse的数据
- (void) fn_get_crmquo_browse_data:(NSString*)base_url{
    RequestContract *req_form = [[RequestContract alloc] init];
    AuthContract *auth=[[AuthContract alloc]init];
    DB_Login *dbLogin=[[DB_Login alloc]init];
    auth=[dbLogin fn_request_auth];
    req_form.Auth =auth;
    SearchFormContract *search = [[SearchFormContract alloc]init];
    search.os_column = @"form";
    search.os_value = @"crm";
    req_form.SearchForm = [NSSet setWithObjects:search, nil];
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_CRMQUO_BROWSE_URL;
    web_base.base_url=base_url;
    web_base.iresp_class=[RespCrmquo_browse class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespCrmquo_browse class]];
    web_base.callback=^(NSMutableArray *arr_resp_result){
        DB_crmquo_browse *db_crmquo=[[DB_crmquo_browse alloc]init];
        [db_crmquo fn_save_crmquo_browse_data:arr_resp_result];
        [SVProgressHUD dismiss];
    };
    
    [web_base fn_get_data:req_form];
}

@end

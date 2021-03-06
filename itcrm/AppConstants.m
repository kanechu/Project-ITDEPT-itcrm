//
//  AppConstants.m
//  worldtrans
//
//  Created by itdept on 2/27/14.
//  Copyright (c) 2014 itdept. All rights reserved.
//

#import "AppConstants.h"

#ifdef DEBUG 
NSString* const STR_BASE_URL = @"http://demo.itdept.com.hk/itcrm_web_api/";
NSString* const STR_SERVER_URL=@"http://www.itdept.com.hk/dl/kie";
NSString* const STR_LOGIN_URL=@"api/System/app_config";

//这部分是固定的，用户选择系统登陆后，会返回一个基本的路径，与其拼接
NSString* const STR_SEARCHCRITERIA_URL=@"api/search/searchcriteria";
NSString* const STR_PERMIT_URL=@"api/users/permit";
NSString* const STR_FORMATLIST_URL=@"api/Search/formatlist";
NSString* const STR_CRMACCT_BROWSE_URL=@"api/Crm/crmacct_browse";

NSString* const STR_REGION_URL=@"api/Master/mslookup";
NSString* const STR_SYSTEMICON_URL=@"api/system/icon";
NSString* const STR_CRMOOP_BROWSE_URL=@"api/Crm/crmopp_browse";
NSString* const STR_MAINTFORM_URL=@"api/Maint/maintform";
NSString* const STR_CRMTASK_BROWSE_URL=@"api/crm/crmtask_browse";
NSString* const STR_CRMHBL_BROWSE_URL=@"api/crm/crmhbl_browse";
NSString* const STR_USERSLOGIN_URL=@"api/users/login";
NSString* const STR_CRMCONTACT_BROWSE_URL=@"api/crm/crmcontact_browse";
NSString* const STR_CRMQUO_BROWSE_URL=@"api/crm/crmquo_browse";
NSString* const STR_CRMTASK_UPDATE_URL=@"api/crm/crmtask_update";
NSString* const STR_CRMCONTACT_UPDATE_URL=@"api/crm/crmcontact_update";
NSString* const STR_CRMOPP_UPDATE_URL=@"api/crm/crmopp_update";
NSString* const STR_CRMACCT_DOWNLOAD_URL=@"api/Crm/crmacct_download";
NSString* const STR_UPLOAD_ATTACHMENT_URL=@"api/Crm/crm_account_attachment_upload";

#else

NSString* const STR_BASE_URL = @"http://demo.itdept.com.hk/itcrm_web_api/";
NSString* const STR_SERVER_URL=@"http://www.itdept.com.hk/dl/kie";
NSString* const STR_LOGIN_URL=@"api/System/app_config";

//这部分是固定的，用户选择系统登陆后，会返回一个基本的路径，与其拼接
NSString* const STR_SEARCHCRITERIA_URL=@"api/search/searchcriteria";
NSString* const STR_PERMIT_URL=@"api/users/permit";
NSString* const STR_FORMATLIST_URL=@"api/Search/formatlist";
NSString* const STR_CRMACCT_BROWSE_URL=@"api/Crm/crmacct_browse";

NSString* const STR_REGION_URL=@"api/Master/mslookup";
NSString* const STR_SYSTEMICON_URL=@"api/system/icon";
NSString* const STR_CRMOOP_BROWSE_URL=@"api/Crm/crmopp_browse";
NSString* const STR_MAINTFORM_URL=@"api/Maint/maintform";
NSString* const STR_CRMTASK_BROWSE_URL=@"api/crm/crmtask_browse";
NSString* const STR_CRMHBL_BROWSE_URL=@"api/crm/crmhbl_browse";
NSString* const STR_USERSLOGIN_URL=@"api/users/login";
NSString* const STR_CRMCONTACT_BROWSE_URL=@"api/crm/crmcontact_browse";
NSString* const STR_CRMQUO_BROWSE_URL=@"api/crm/crmquo_browse";
NSString* const STR_CRMTASK_UPDATE_URL=@"api/crm/crmtask_update";
NSString* const STR_CRMCONTACT_UPDATE_URL=@"api/crm/crmcontact_update";
NSString* const STR_CRMOPP_UPDATE_URL=@"api/crm/crmopp_update";
NSString* const STR_CRMACCT_DOWNLOAD_URL=@"api/Crm/crmacct_download";
NSString* const STR_UPLOAD_ATTACHMENT_URL=@"api/Crm/crm_account_attachment_upload";

#endif
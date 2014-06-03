//
//  AppConstants.m
//  worldtrans
//
//  Created by itdept on 2/27/14.
//  Copyright (c) 2014 itdept. All rights reserved.
//

#import "AppConstants.h"

#ifdef DEBUG 
NSString* const STR_BASE_URL = @"http://192.168.1.17/";
NSString* const STR_SERVER_URL=@"http://www.itdept.com.hk/dl/kie";
NSString* const STR_LOGIN_URL=@"kie_web_api/api/system/app_config";
NSString* const STR_SEARCHCRITERIA_URL=@"api/search/searchcriteria";
//这部分是固定的，用户选择系统登陆后，会返回一个基本的路径，与其拼接
NSString* const STR_PERMIT_URL=@"api/users/permit";

#else
NSString* const STR_BASE_URL = @"http://223.255.167.158/";
#endif
//
//  UploadingContract.h
//  itcrm
//
//  Created by itdept on 14-7-7.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthContract.h"
@interface UploadingContract : NSObject

@property(nonatomic, strong) NSSet *UpdateForm;
@property(nonatomic, strong) AuthContract *Auth;

@end

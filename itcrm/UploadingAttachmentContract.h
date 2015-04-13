//
//  UploadingAttachmentContract.h
//  itcrm
//
//  Created by itdept on 15/4/10.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UpdateFormAttachment.h"
#import "AuthContract.h"
@interface UploadingAttachmentContract : NSObject

@property(nonatomic, strong) UpdateFormAttachment *UpdateForm;
@property(nonatomic, strong) AuthContract *Auth;

@end

//
//  KeyboardNoticeManager.h
//  itcrm
//
//  Created by itdept on 14-6-18.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol keyNotificationPro<NSObject>
@optional
-(void)keyboardWillHide:(NSNotification*)notification;
- (void)keyboardWillShow:(NSNotification*)notification;
@end;
@interface KeyboardNoticeManager : NSObject

+(void)fn_registKeyBoardNotification:(NSObject*)object;
+(void)fn_removeKeyBoarNotificaton:(NSObject*)object;

@end

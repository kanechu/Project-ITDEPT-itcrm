//
//  KeyboardNoticeManager.m
//  itcrm
//
//  Created by itdept on 14-6-18.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "KeyboardNoticeManager.h"

@implementation KeyboardNoticeManager

+(void)fn_registKeyBoardNotification:(NSObject*)object{
    if ([object respondsToSelector:@selector(keyboardWillShow:)]) {
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:object selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    
    if ([object respondsToSelector:@selector(keyboardWillHide:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:object selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}
+(void)fn_removeKeyBoarNotificaton:(NSObject*)object{
    [[NSNotificationCenter defaultCenter]removeObserver:object name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:object name:UIKeyboardWillHideNotification object:nil];
}



@end

//
//  KeyboardNoticeManager.m
//  itcrm
//
//  Created by itdept on 14-6-18.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "KeyboardNoticeManager.h"
#define Key_IOS7_OR_LATER ([[[UIDevice currentDevice]systemVersion] compare:@"7.0"]!=NSOrderedAscending)
#define key_iPhoneHeight [UIScreen mainScreen].bounds.size.height
@implementation KeyboardNoticeManager {
    UIView *oldView;
    CGRect oldTableFrame;
    float  oldOffSet_Y;
}
+(id)sharedKeyboardNoticeManager{
    static dispatch_once_t pred = 0;
    __strong static id keyboardManager = nil;
    dispatch_once(&pred, ^{
        keyboardManager = [[self alloc] init];
        [keyboardManager fn_registKeyBoardNotification];
    });
    return keyboardManager;
}
//监听键盘隐藏和显示事件
-(void)fn_registKeyBoardNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//注销监听事件
-(void)fn_removeKeyBoarNotificaton{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
//键盘弹出触发的事件
-(void)keyboardWillShow:(NSNotification *)notification {
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    UITableView *tableview=(UITableView *)[self fn_getTableview];
    if (tableview==nil) {
        return;
    }
    if (!oldView) {
        oldView = tableview;
        oldTableFrame=oldView.frame;
    }
    oldOffSet_Y = tableview.contentOffset.y;
    CGRect newFrame=oldTableFrame;
    //取Tableview在屏幕的固定位置
    CGRect constant_Frame = [tableview convertRect:tableview.bounds toView:[tableview superview]];
    tableview.frame=newFrame;
    newFrame.size.height-=(height - (key_iPhoneHeight - constant_Frame.origin.y-constant_Frame.size.height));
    NSNumber *dur = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[dur floatValue] animations:^{
        tableview.frame=newFrame;
    }];
    NSIndexPath *indexPath = [tableview indexPathForRowAtPoint:[self fn_getTableViewCell].frame.origin];
    [tableview selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
}
-(void)keyboardWillHide:(NSNotification *)notification {
    UITableView *tableview=(UITableView *)[self fn_getTableview];
    tableview.frame=oldTableFrame;
    [tableview setContentOffset:CGPointMake(tableview.contentOffset.x, oldOffSet_Y) animated:YES];
}

//获得当前的第一响应者及所在的tableview
-(UIView*)fn_getTableview{
    UIView *firstResponder = [self fn_getFirstResponder];
    UIView *superView=[firstResponder superview];
    while (![superView isKindOfClass:[UITableView class]]) {
        superView=[superView superview];
        if (superView==nil) {
            return nil;
        }
        if ([superView isKindOfClass:[UIWindow class]]) {
            return nil;
        }
    }
    return superView;
}

-(UIView*)fn_getTableViewCell{
    UIView *firstResponder = [self fn_getFirstResponder];
    UIView *superView=[firstResponder superview];
    while (![superView isKindOfClass:[UITableViewCell class]]) {
        superView=[superView superview];
    }
    return superView;
}

-(UIView*)fn_getFirstResponder{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    return firstResponder;
}
-(void)dealloc{
    [self fn_removeKeyBoarNotificaton];
}

@end

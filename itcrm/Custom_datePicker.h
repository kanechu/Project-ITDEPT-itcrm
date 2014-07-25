//
//  Custom_datePicker.h
//  itcrm
//
//  Created by itdept on 14-7-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DatepickerDelegate;
@interface Custom_datePicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,assign)id<DatepickerDelegate> delegate;

@end
@protocol DatepickerDelegate <NSObject>

-(void)fn_Clicked_done:(NSString*)str;
-(void)fn_Clicked_cancel:(NSString *)str;

@end
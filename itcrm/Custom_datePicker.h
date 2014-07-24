//
//  Custom_datePicker.h
//  itcrm
//
//  Created by itdept on 14-7-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^callBack_selectDate)(NSString *);
@interface Custom_datePicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)callBack_selectDate selectDate;

@end

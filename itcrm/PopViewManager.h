//
//  PopViewManager.h
//  worldtrans
//
//  Created by itdept on 14-5-7.
//  Copyright (c) 2014年 Worldtrans Logistics Services Ltd. . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopViewManager : NSObject
-(void)PopupView:(UIViewController*)VC Size:(CGSize) sheetSize uponView:(UIViewController*)VC1;
@end

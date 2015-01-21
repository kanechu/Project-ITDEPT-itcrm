//
//  Custom_BtnGraphicMixed.m
//  itleo
//
//  Created by itdept on 14-8-11.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Custom_BtnGraphicMixed.h"

@implementation Custom_BtnGraphicMixed

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.titleLabel.textAlignment=NSTextAlignmentRight;
        self.imageView.contentMode=UIViewContentModeLeft;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}*/
//更改button的rect设定并返回文本label的rect
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleW=contentRect.size.width-30;
    CGFloat titleH=contentRect.size.height;
    CGFloat titleX=32;
    CGFloat titleY=0;
    contentRect=(CGRect){{titleX,titleY},{titleW,titleH}};
    return contentRect;
}
//更改button的rect设定并返回UIImageView的rect
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW=30;
    CGFloat imageH=contentRect.size.height;
    CGFloat imageX=0;
    CGFloat imageY=0;
    contentRect=(CGRect){{imageX,imageY},{imageW,imageH}};
    return contentRect;
}
@end

//
// Created by Dawson Walker on 15-08-20.
// Copyright (c) 2015 Rise Digital. All rights reserved.
//

#import "UIButton+DMButtonAttributes.h"


@implementation UIButton (DMButtonAttributes)
+ (void) styleButton:(UIButton*)button
{
    CALayer *shadowLayer = [CALayer new];
    shadowLayer.frame = button.frame;

    shadowLayer.cornerRadius = 5;

    shadowLayer.backgroundColor = [UIColor clearColor].CGColor;
    shadowLayer.opacity = 0.5;
    shadowLayer.shadowColor = [UIColor blackColor].CGColor;
    shadowLayer.shadowOpacity = 0.6;
    shadowLayer.shadowOffset = CGSizeMake(1,1);
    shadowLayer.shadowRadius = 3;

    button.layer.cornerRadius = 10;
    button.layer.masksToBounds = YES;

    UIView* parent = button.superview;
    [parent.layer insertSublayer:shadowLayer below:button.layer];
}
@end
//
// Created by Dawson Walker on 15-08-20.
// Copyright (c) 2015 Rise Digital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIColor (DMHexColors)
+ (UIColor *)bt_colorWithHexValue:(uint32_t )hexValue;
+ (UIColor *)bt_colorWithHexValue:(uint32_t)hexValue alpha:(float)alpha;

@end
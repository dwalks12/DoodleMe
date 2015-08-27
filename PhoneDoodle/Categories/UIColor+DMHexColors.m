//
// Created by Dawson Walker on 15-08-20.
// Copyright (c) 2015 Rise Digital. All rights reserved.
//

#import "UIColor+DMHexColors.h"


@implementation UIColor (DMHexColors)
+ (UIColor *)bt_colorWithHexValue:(uint32_t )hexValue {

    return [UIColor bt_colorWithHexValue:hexValue alpha:1.0f];
}

+ (UIColor *)bt_colorWithHexValue:(uint32_t)hexValue alpha:(float)alpha {
    // default values
    uint32_t r = 0xff;
    uint32_t g = 0xff;
    uint32_t b = 0xff;

    r = (hexValue & 0xff0000) >> 8*2;
    g = (hexValue & 0x00ff00) >> 8*1;
    b = (hexValue & 0x0000ff);

    UIColor *newColor = [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:alpha];

    return newColor;
}
@end
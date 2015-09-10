//
// Created by Dawson Walker on 15-08-28.
// Copyright (c) 2015 Rise Digital. All rights reserved.
//

#import "BorderedButton.h"
#import "UIColor+DMHexColors.h"

static UIColor *BorderColor()
{
    return [UIColor clearColor];
}

static UIColor *HighlightedBorderColor()
{
    return [UIColor bt_colorWithHexValue:0x5AC8FA alpha:1.0f];
}

@implementation BorderedButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = BorderColor().CGColor;
        self.layer.cornerRadius = 4.0;
        self.layer.borderWidth = 1.0;
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.layer.borderColor = (selected) ? HighlightedBorderColor().CGColor : BorderColor().CGColor;
}

@end
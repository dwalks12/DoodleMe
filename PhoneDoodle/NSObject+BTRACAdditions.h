//
// Created by Dawson Walker on 15-08-10.
// Copyright (c) 2015 Rise Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BTRACAdditions)
- (RACSignal *)bt_liftSelector:(SEL)selector withSignal:(RACSignal *)signal;
@end
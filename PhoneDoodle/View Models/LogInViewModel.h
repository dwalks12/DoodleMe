//
// Created by Dawson Walker on 15-08-10.
// Copyright (c) 2015 Rise Digital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>



@interface LogInViewModel : NSObject
typedef NS_ENUM(NSInteger, ViewControllerState) {
    ViewControllerStateDefault,
    ViewControllerStateLoading,
    ViewControllerStateCompleted,
    ViewControllerStateEmpty,
    ViewControllerStateError,
};
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, readonly) BOOL loginEnabled;
@property (nonatomic, strong) RACCommand *loginCommand;
@end
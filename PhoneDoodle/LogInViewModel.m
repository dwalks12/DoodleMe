//
// Created by Dawson Walker on 15-08-10.
// Copyright (c) 2015 Rise Digital. All rights reserved.
//

#import "LogInViewModel.h"


@implementation LogInViewModel {

}
- (instancetype)init {
    self = [super init];
    if (self) {
        RAC(self, loginEnabled) = [[RACSignal combineLatest:@[RACObserve(self, username), RACObserve(self, password)]] map:^id(RACTuple *tuple) {
            RACTupleUnpack(NSString *username, NSString *password) = tuple;
            return @([username length] > 0 && [password length] > 0);
        }];

    }

    return self;
}

#pragma mark - Properties

- (RACCommand *)loginCommand {
    if (!_loginCommand) {
        _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
                int64_t delayInMilliSeconds = 2000;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInMilliSeconds * NSEC_PER_MSEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                });
                return nil;
            }];
        }];
    }
    return _loginCommand;
}
@end
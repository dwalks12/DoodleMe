//
//  SettingsViewController.m
//  PhoneDoodle
//
//  Created by Dawson Walker on 2015-08-20.
//  Copyright (c) 2015 Rise Digital. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "SettingsViewController.h"
#import <Parse/Parse.h>
#import "UIColor+DMHexColors.h"
#import "LoginViewController.h"


@interface SettingsViewController ()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *logOutButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *bannerBackground;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation SettingsViewController {
    
}
-(void)viewDidLoad {
    self.activityIndicatorView.hidden = YES;
    [self addSubviews];
    [self defineLayouts];
    
    
}

-(void)addSubviews{
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.logOutButton];
    [self.view addSubview:self.bannerBackground];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.activityIndicatorView];
}

-(void)defineLayouts{
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(20.0f);
        make.width.equalTo(self.view);
        make.height.equalTo(@60);
    }];
    [self.bannerBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@80);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_left).offset(35.0f);
        make.centerY.equalTo(self.titleLabel);
        make.width.equalTo(@60);
        make.height.equalTo(@40);
    }];
    [self.logOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.bannerBackground.mas_bottom).offset(20.0f);
        make.width.equalTo(self.view).offset(-40.0f);
        make.height.equalTo(@80);
    }];
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];
    
}

-(void)logOut{
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
    [PFQuery clearAllCachedResults];
    [PFUser logOut];
    LogInViewController *loginController = [LogInViewController new];
    
    [self presentViewController:loginController animated:YES completion:^{
        [self.activityIndicatorView stopAnimating];
    }];
}
-(void)backToMain{
    UIViewAnimationTransition trans = UIViewAnimationTransitionCurlUp;
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition: trans forView: [self.view window] cache: YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIView commitAnimations];
}

#pragma mark -- Properties

- (UIButton *)logOutButton {
    if (!_logOutButton) {
        _logOutButton = [UIButton new];
        _logOutButton.backgroundColor = [UIColor bt_colorWithHexValue:0xFF2D55 alpha:1.0f];
        _logOutButton.layer.cornerRadius = 10.0f;
        _logOutButton.layer.masksToBounds = YES;
        [_logOutButton addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
        _logOutButton.titleLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:30];
        [_logOutButton setTitle:@"Log out" forState:UIControlStateNormal];
    }
    return _logOutButton;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [UIColor colorWithRed:222.0f/255.0f green:232.0f/255.0f blue:240.0f/255.0f alpha:1.0];
    }
    return _backgroundView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:50];
        _titleLabel.textColor = [UIColor bt_colorWithHexValue:0xFFFFFF alpha:1.0f];
        _titleLabel.text = @"Settings";
        _titleLabel.minimumScaleFactor = 0.5;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (UIImageView *)bannerBackground {
    if (!_bannerBackground) {
        _bannerBackground = [UIImageView new];
        _bannerBackground.backgroundColor = [UIColor bt_colorWithHexValue:0x5AC8FA alpha:1.0f];
    }
    return _bannerBackground;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton new];
        _backButton.titleLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:25];
        [_backButton setTitle:@"Back" forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [UIActivityIndicatorView new];
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_activityIndicatorView setColor:[UIColor colorWithRed:1.0 green:0.4 blue:0.3 alpha:1.0]];
        [_activityIndicatorView setHidesWhenStopped:YES];
        
    }
    return _activityIndicatorView;
}

@end

//
// Created by Dawson Walker on 15-08-10.
// Copyright (c) 2015 Rise Digital. All rights reserved.
//

#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import "LogInViewController.h"
#import "LogInViewModel.h"
#import "ViewController.h"
#import "Parse/Parse.h"
#import "NSObject+BTRACAdditions.h"
#import "UIColor+DMHexColors.h"

@interface LogInViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UITextField *usernameField;
@property (strong, nonatomic) UITextField *passwordField;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) LogInViewModel *viewModel;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSArray *gameArray;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *bannerBackground;

@end

@implementation LogInViewController {

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
    [self defineLayout];
    [self setUpBindings];
}

-(void)setUpBindings{
    RAC(self.loginButton, enabled) = RACObserve(self.viewModel, loginEnabled);
    RAC(self.viewModel, username) = self.usernameField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordField.rac_textSignal;

    RACSignal *loginCommandSignal = [self.viewModel.loginCommand.executionSignals flatten];
    [self bt_liftSelector:@selector(closeLoginView) withSignal:loginCommandSignal];
}
- (void)defineLayout {
    UIEdgeInsets insets = UIEdgeInsetsMake(16.f, 16.f, 16.f, 16.f);
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

    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    
    [self.usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView).insets(insets);
        make.height.equalTo(@50);
        make.top.equalTo(self.containerView.mas_top).offset(16.0f);
    }];



    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView).insets(insets);
        make.height.equalTo(self.usernameField);
        make.top.equalTo(self.usernameField.mas_bottom).offset(16.f);
    }];

    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.mas_bottom).offset(25.f);
        make.left.right.equalTo(self.containerView).insets(insets);
        make.height.equalTo(@60);
    }];

    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-30.f);
        make.width.equalTo(@(self.view.frame.size.width - 40));
        make.height.equalTo(@(250));
    }];
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(100.0f);
    }];
}
-(void)setUpSubviews{
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.usernameField];
    [self.containerView addSubview:self.passwordField];
    [self.containerView addSubview:self.loginButton];
    [self.view addSubview:self.activityIndicatorView];
    [self.view addSubview:self.bannerBackground];
    [self.view addSubview:self.titleLabel];
}
#pragma mark Actions

-(void)loginButtonPressed:(id)sender{
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([username length] == 0 || [password length] == 0||[username length]> 25){
        if([username length]>25){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Make Sure Your Username is within 25 Characters" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alertView show];
            self.activityIndicatorView.hidden = YES;
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Make sure you enter a username/password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alertView show];
            self.activityIndicatorView.hidden = YES;
        }
    }
    else{
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
       
        [self.usernameField resignFirstResponder];
        [self.passwordField resignFirstResponder];
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error){
                
                [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
                    if(error){
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"Username taken! Try again!"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        
                        [alertView show];
                        self.activityIndicatorView.hidden = YES;
                        
                    }
                    else{
                        NSLog(@"Pfuser = %@",[PFUser currentUser].username);
                        
                        NSString *personString = [PFUser currentUser].username;
                        NSString *yourNameEdited = [personString stringByReplacingOccurrencesOfString:@" " withString:@""];
                        NSString * strippedNumber = [yourNameEdited stringByReplacingOccurrencesOfString:@"[^a-zA-Z]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [yourNameEdited length])];
                        
                        [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
                        [[PFInstallation currentInstallation] addUniqueObject:strippedNumber forKey:@"channels"];
                        
                        
                        
                        [[PFInstallation currentInstallation] saveInBackground];
                        
                        [self.viewModel.loginCommand execute:nil];
                        
                    }
                    
                }];

            }
            else{
              
                NSLog(@"Pfuser = %@",[PFUser currentUser].username);
                
                NSString *personString = [PFUser currentUser].username;
                NSString *yourNameEdited = [personString stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSString * strippedNumber = [yourNameEdited stringByReplacingOccurrencesOfString:@"[^a-zA-Z]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [yourNameEdited length])];
                
                [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
                [[PFInstallation currentInstallation] addUniqueObject:strippedNumber forKey:@"channels"];
                
                
                
                [[PFInstallation currentInstallation] saveInBackground];
                
                [self.viewModel.loginCommand execute:nil];
               
            }
            
        }];
    }
    
    
}
- (void)closeLoginView {
   
    self.activityIndicatorView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
   
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([self.usernameField isFirstResponder]) {
        [self.passwordField becomeFirstResponder];
    }

    if([self.passwordField isFirstResponder]) {
        [textField resignFirstResponder];
    }

    return YES;
}


- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton new];
        _loginButton.titleLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:20];
        [_loginButton setTitle:@"Log in/Sign up" forState:UIControlStateNormal];
        
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:[UIColor bt_colorWithHexValue:0xFF3B300 alpha:1.0f]];
        
        _loginButton.layer.cornerRadius = 10.0f;
        _loginButton.layer.masksToBounds = YES;
        [_loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UITextField *)usernameField {
    if (!_usernameField) {
        _usernameField = [UITextField new];
        _usernameField.background = [UIImage imageNamed:@"searchfield.png"];
        //_usernameField.font = [UIFont bt_regularFontOfSize:14];
        _usernameField.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:20];
        _usernameField.textAlignment = NSTextAlignmentCenter;
        _usernameField.textColor = [UIColor grayColor];
        _usernameField.placeholder = @"Username";
        _usernameField.returnKeyType = UIReturnKeyNext;
        _usernameField.delegate = self;
    }
    return _usernameField;
}

- (UITextField *)passwordField {
    if (!_passwordField) {
        _passwordField = [UITextField new];
        _passwordField.background = [UIImage imageNamed:@"searchfield.png"];
        //_passwordField.font = [UIFont bt_regularFontOfSize:14];
        _passwordField.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:20];
        _passwordField.textAlignment = NSTextAlignmentCenter;
        _passwordField.textColor = [UIColor grayColor];
        _passwordField.placeholder = @"Password";
        _passwordField.returnKeyType = UIReturnKeyNext;
        _passwordField.delegate = self;
        _passwordField.secureTextEntry = YES;
    }
    return _passwordField;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
    }
    return _containerView;
}

- (LogInViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [LogInViewModel new];
    }
    return _viewModel;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [UIColor colorWithRed:222.0f/255.0f green:232.0f/255.0f blue:240.0f/255.0f alpha:1.0];
    }
    return _backgroundView;
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

- (NSArray *)gameArray {
    if (!_gameArray) {
        _gameArray = [NSArray new];
    }
    return _gameArray;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:50];
        _titleLabel.textColor = [UIColor bt_colorWithHexValue:0xFFFFFF alpha:1.0f];
        _titleLabel.text = @"DoodleMe";
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

@end
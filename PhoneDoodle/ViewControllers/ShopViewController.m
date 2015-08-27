//
//  ShopViewController.m
//  PhoneDoodle
//
//  Created by Dawson Walker on 2015-08-27.
//  Copyright (c) 2015 Rise Digital. All rights reserved.
//

#import "ShopViewController.h"
#import "UIColor+DMHexColors.h"
#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import "MainMenuViewController.h"

@interface ShopViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UIView *backgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *bannerBackground;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UITableView *itemTableView;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubviews];
    [self defineLayouts];
    // Do any additional setup after loading the view.
}

-(void)addSubviews{
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.bannerBackground];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.backButton];
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
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_left).offset(35.0f);
        make.centerY.equalTo(self.titleLabel);
        make.width.equalTo(@60);
        make.height.equalTo(@40);
    }];
    [self.bannerBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@80);
    }];

}

-(void)backToMain{
    MainMenuViewController *viewController = [MainMenuViewController new];
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark -- TableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

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
        _titleLabel.text = @"Shop";
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
        _backButton.titleLabel.textColor = [UIColor bt_colorWithHexValue:0xFF9500 alpha:1.0f];
        _backButton.titleLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:25];
        [_backButton setTitle:@"Back" forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
@end

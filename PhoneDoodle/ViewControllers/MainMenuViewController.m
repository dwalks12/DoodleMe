//
// Created by Dawson Walker on 15-08-20.
// Copyright (c) 2015 Rise Digital. All rights reserved.
//

#import "MainMenuViewController.h"
#import "UIColor+DMHexColors.h"
#import "UIButton+DMButtonAttributes.h"
#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import "SettingsViewController.h"
#import "NewChainViewController.h"
#import "ViewController.h"
#import "YourGamesViewController.h"
#import "ShopViewController.h"
#import <StartApp/StartApp.h>

@interface MainMenuViewController ()<STABannerDelegateProtocol>{
     STABannerView* bannerView;
}
@property (nonatomic, strong) UIButton * startNewGame;
@property (nonatomic, strong) UIButton * joinAGame;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *bannerBackground;
@property (nonatomic, strong) UIButton *settingsButton;
@property (nonatomic, strong) UIButton *yourGamesButton;
@property (nonatomic, strong) UIButton * shopButton;

@end
@implementation MainMenuViewController {

}
- (void)viewDidLoad {
    //[super viewDidLoad];
   
    [self addSubviews];
    [self defineLayouts];
    [self showBannerAds];

}
-(void)showBannerAds{
    bannerView = [[STABannerView alloc] initWithSize:STA_AutoAdSize
                                              origin:CGPointMake(0, self.view.frame.size.height - 50)
                                            withView:self.view
                                        withDelegate:self];
    [self.view addSubview:bannerView];
    [bannerView showBanner];
}
-(void)addSubviews{
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.startNewGame];
    [self.view addSubview:self.bannerBackground];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.joinAGame];
    [self.view addSubview:self.settingsButton];
    [self.view addSubview:self.yourGamesButton];
    [self.view addSubview:self.shopButton];
   
    

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
    [self.startNewGame mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.bannerBackground.mas_bottom).offset(20.0f);
        make.width.equalTo(self.view).offset(-40.0f);
        make.height.equalTo(@((self.view.frame.size.height - self.bannerBackground.frame.size.height)/4 - 80.0f));
    }];
    [self.joinAGame mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.startNewGame.mas_bottom).offset(20.0f);
        make.width.equalTo(self.startNewGame);
        make.height.equalTo(self.startNewGame);
    }];
    [self.yourGamesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.joinAGame.mas_bottom).offset(20.0f);
        make.width.equalTo(self.startNewGame);
        make.height.equalTo(self.startNewGame);
    }];
    [self.settingsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_right).offset(-35.0f);
        make.centerY.equalTo(self.titleLabel);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    [self.shopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.yourGamesButton.mas_bottom).offset(20.0f);
        make.width.equalTo(self.yourGamesButton);
        make.height.equalTo(self.yourGamesButton);
    }];
}
- (void) didDisplayBannerAd:(STABannerView*)banner{
    
}
- (void) failedLoadBannerAd:(STABannerView*)banner withError:(NSError *)error{
    
}
- (void) didClickBannerAd:(STABannerView*)banner{
    
}
-(void)joinAGameAction{
    //[self.joinAGame setBackgroundColor:[UIColor bt_colorWithHexValue:0xFF2C96 alpha:1.0f]];
    ViewController *joinGameViewController = [ViewController new];
    UIViewAnimationTransition trans = UIViewAnimationTransitionCurlUp;
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition: trans forView: [self.view window] cache: YES];
    [self presentViewController:joinGameViewController animated:NO completion:nil];
    [UIView commitAnimations];
    
}
-(void)yourGamesAction{
    YourGamesViewController *yourGamesController = [YourGamesViewController new];
    UIViewAnimationTransition trans = UIViewAnimationTransitionCurlUp;
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition: trans forView: [self.view window] cache: YES];
    [self presentViewController:yourGamesController animated:NO completion:nil];
    [UIView commitAnimations];
}
-(void)startNewGameAction{
    //[self.startNewGame setBackgroundColor:[UIColor bt_colorWithHexValue:0x4CCA50 alpha:1.0f]];
    NewChainViewController *newGameController = [NewChainViewController new];
    UIViewAnimationTransition trans = UIViewAnimationTransitionCurlUp;
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition: trans forView: [self.view window] cache: YES];
    [self presentViewController:newGameController animated:NO completion:nil];
    [UIView commitAnimations];
}
-(void)shopAction{
    ShopViewController *shopController = [ShopViewController new];
    UIViewAnimationTransition trans = UIViewAnimationTransitionCurlUp;
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition: trans forView: [self.view window] cache: YES];
    [self presentViewController:shopController animated:NO completion:nil];
    [UIView commitAnimations];
}
-(void)goToSettings{
    SettingsViewController *settingsViewController = [SettingsViewController new];
    UIViewAnimationTransition trans = UIViewAnimationTransitionCurlUp;
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition: trans forView: [self.view window] cache: YES];
    [self presentViewController:settingsViewController animated:NO completion:nil];
    [UIView commitAnimations];
}
- (void) styleButton:(UIButton*)button
{
    CALayer *shadowLayer = [CALayer new];
    shadowLayer.frame = button.frame;

    shadowLayer.cornerRadius = 10;

    shadowLayer.backgroundColor = [UIColor blackColor].CGColor;
    shadowLayer.opacity = 0.6;
    shadowLayer.shadowColor = [UIColor blackColor].CGColor;
    shadowLayer.shadowOpacity = 0.6;
    shadowLayer.shadowOffset = CGSizeMake(-2,-2);
    shadowLayer.shadowRadius = 3;

    button.layer.cornerRadius = 10;
    button.layer.masksToBounds = YES;
    
    UIView* parent = button.superview;
    [parent.layer insertSublayer:shadowLayer below:button.layer];
}
#pragma mark - Properties

- (UIButton *)startNewGame {
    if (!_startNewGame) {
        _startNewGame = [UIButton new];
        _startNewGame.backgroundColor = [UIColor bt_colorWithHexValue:0x4CD964 alpha:1.0f];
        [self styleButton:_startNewGame];
        [_startNewGame addTarget:self action:@selector(startNewGameAction) forControlEvents:UIControlEventTouchUpInside];
        _startNewGame.titleLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:30];
        [_startNewGame setTitle:@"Start New Game" forState:UIControlStateNormal];
    }
    return _startNewGame;
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
        _titleLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:35];
        _titleLabel.textColor = [UIColor bt_colorWithHexValue:0xFFFFFF alpha:1.0f];
        _titleLabel.text = @"SketchyDoodle";
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

- (UIButton *)joinAGame {
    if (!_joinAGame) {
        _joinAGame = [UIButton new];
        _joinAGame.backgroundColor = [UIColor bt_colorWithHexValue:0xFF2D55 alpha:1.0f];
        [self styleButton:_joinAGame];
        [_joinAGame addTarget:self action:@selector(joinAGameAction) forControlEvents:UIControlEventTouchUpInside];
        _joinAGame.titleLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:30];
        [_joinAGame setTitle:@"Join A Game" forState:UIControlStateNormal];
    }
    return _joinAGame;
}

- (UIButton *)settingsButton {
    if (!_settingsButton) {
        _settingsButton = [UIButton new];
        [_settingsButton setBackgroundImage:[UIImage imageNamed:@"setting-icon.png"] forState:UIControlStateNormal];

        [_settingsButton addTarget:self action:@selector(goToSettings) forControlEvents:UIControlEventTouchUpInside];
        //add function later

    }
    return _settingsButton;
}

- (UIButton *)yourGamesButton {
    if (!_yourGamesButton) {
        _yourGamesButton = [UIButton new];
        _yourGamesButton.backgroundColor = [UIColor bt_colorWithHexValue:0xFF9500 alpha:1.0f];
        [self styleButton:_yourGamesButton];
        [_yourGamesButton addTarget:self action:@selector(yourGamesAction) forControlEvents:UIControlEventTouchUpInside];
        _yourGamesButton.titleLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:30];
        [_yourGamesButton setTitle:@"Your Games" forState:UIControlStateNormal];
    }
    return _yourGamesButton;
}

- (UIButton *)shopButton {
    if(!_shopButton){
        _shopButton = [UIButton new];
        _shopButton.backgroundColor = [UIColor bt_colorWithHexValue:0x007AFF alpha:1.0f];
        [self styleButton:_shopButton];
        [_shopButton addTarget:self action:@selector(shopAction) forControlEvents:UIControlEventTouchUpInside];
        _shopButton.titleLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:30];
        [_shopButton setTitle:@"Shop" forState:UIControlStateNormal];
    }
    return _shopButton;
}

@end
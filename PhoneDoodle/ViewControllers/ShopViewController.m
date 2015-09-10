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
#import "ColorPurchases.h"
#import <StartApp/StartApp.h>
#import <VungleSDK/VungleSDK.h>
#import <Parse/Parse.h>

@interface ShopViewController ()<UITableViewDelegate, UITableViewDataSource,STADelegateProtocol,VungleSDKDelegate>{
    STAStartAppAd* startAppAd;
    BOOL alreadyPurchased;
}
@property (nonatomic, strong)UIView *backgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *bannerBackground;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UITableView *itemTableView;
@property (nonatomic, strong) NSMutableArray *alreadyRecievedItems;


@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    self.alreadyRecievedItems = [NSMutableArray new];
    startAppAd = [[STAStartAppAd alloc] init];
    [startAppAd loadAdWithDelegate:self];
    [self checkUserColors];
    [self addSubviews];
    [self defineLayouts];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [startAppAd loadAdWithDelegate:self];
}
-(void)checkUserColors{
    NSArray *array = [[PFUser currentUser]objectForKey:@"purchased"];
    self.alreadyRecievedItems = [NSMutableArray arrayWithArray:array];
}
-(void)addSubviews{
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.bannerBackground];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.itemTableView];
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
    [self.itemTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.bannerBackground.mas_bottom).offset(10.0f);
        make.width.equalTo(@(self.view.frame.size.width - 40));
        make.height.equalTo(@(self.view.frame.size.height - self.bannerBackground.frame.size.height - 120));
    }];

}

-(void)backToMain{
    MainMenuViewController *viewController = [MainMenuViewController new];
    [self presentViewController:viewController animated:YES completion:nil];
}
#pragma mark -- StartAppAd Delegate

- (void) didLoadAd:(STAAbstractAd*)ad{
    
}
- (void) failedLoadAd:(STAAbstractAd*)ad withError:(NSError *)error{
    
}
- (void) didShowAd:(STAAbstractAd*)ad{
    
}
- (void) failedShowAd:(STAAbstractAd*)ad withError:(NSError *)error{
    
}
- (void) didCloseAd:(STAAbstractAd*)ad{
    NSArray *itemArray = [[NSArray alloc]init];
    itemArray = [NSArray arrayWithArray:self.alreadyRecievedItems];
    [[PFUser currentUser] setObject:itemArray forKey:@"purchased"];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL success, NSError *error){
        if(!error){
            [self.itemTableView reloadData];
        }
    }];
    
}
- (void) didClickAd:(STAAbstractAd*)ad{
    NSArray *itemArray = [[NSArray alloc]init];
    itemArray = [NSArray arrayWithArray:self.alreadyRecievedItems];
    [[PFUser currentUser] setObject:itemArray forKey:@"purchased"];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL success, NSError *error){
        if(!error){
            [self.itemTableView reloadData];
        }
    }];
}
#pragma mark -- TableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ColorPurchases nameOfColors].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    alreadyPurchased = NO;
    UITableViewCell * cell = [[UITableViewCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *selectionView = [UIView new];
    selectionView.backgroundColor = [UIColor clearColor];
    [[UITableViewCell appearance] setSelectedBackgroundView:selectionView];
   
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.layer.borderWidth = 1.0f;
    backgroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backgroundView.layer.cornerRadius = 8.0f;
    backgroundView.layer.masksToBounds = YES;
    cell.backgroundView = backgroundView;
    for(int i = 0;i<self.alreadyRecievedItems.count;i++){
            if([self.alreadyRecievedItems[i]isEqualToString:[ColorPurchases nameOfColors][indexPath.row]]){
                alreadyPurchased = YES;
            }
        
    }
    if(!alreadyPurchased){
        SEL method;
        method = NSSelectorFromString( [NSString stringWithFormat:@"colorScheme%li",(long)indexPath.row+1]);
   
        NSArray *colorScheme1 = [ColorPurchases performSelector:method];
        for(int i = 0;i<colorScheme1.count;i++){
            
            unsigned colorInt = 0;
            
            [[NSScanner scannerWithString:colorScheme1[i]] scanHexInt:&colorInt];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5+(i*30), 20, 30, 30)];
            imageView.backgroundColor = [UIColor bt_colorWithHexValue:colorInt alpha:1.0f];
            imageView.layer.cornerRadius = 4.0f;
            imageView.layer.masksToBounds = YES;
            [cell addSubview:imageView];
        }
    
    }
    else{
        UILabel *soldLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 20, 155, 30)];
        soldLabel.text = @"Acquired";
        soldLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:20];
        soldLabel.adjustsFontSizeToFitWidth = YES;
        soldLabel.minimumScaleFactor = 0.5;
        soldLabel.textColor = [UIColor redColor];
        soldLabel.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:soldLabel];
    }
    UILabel *nameOfPalette = [[UILabel alloc]initWithFrame:CGRectMake(160, 20, 100, 30)];
    nameOfPalette.text = [NSString stringWithFormat:@"%@",[ColorPurchases nameOfColors][indexPath.row]];
    nameOfPalette.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:20];
    nameOfPalette.adjustsFontSizeToFitWidth = YES;
    nameOfPalette.minimumScaleFactor = 0.4;
    
    [cell addSubview:nameOfPalette];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[startAppAd showAd];
    alreadyPurchased = NO;
    for(int i = 0;i<self.alreadyRecievedItems.count;i++){
        if([self.alreadyRecievedItems[i]isEqualToString:[ColorPurchases nameOfColors][indexPath.row]]){
            alreadyPurchased = YES;
        }
        
    }
    if(!alreadyPurchased){
        if(![[PFUser currentUser]objectForKey:@"purchased"]){
            self.alreadyRecievedItems = [[NSMutableArray alloc]init];
            [self.alreadyRecievedItems addObject:[ColorPurchases nameOfColors][indexPath.row]];
        
        }
        else{
            self.alreadyRecievedItems = [NSMutableArray arrayWithArray:[[PFUser currentUser]objectForKey:@"purchased"]];
            [self.alreadyRecievedItems addObject:[ColorPurchases nameOfColors][indexPath.row]];
        
        }
   
        VungleSDK* sdk = [VungleSDK sharedSDK];
        if([sdk isAdPlayable])
        {
        }
        else{
            [startAppAd showAd];
        }
        [sdk setDelegate:self];
        NSError *error = [[NSError alloc]init];
        [sdk playAd:self error:&error];
    }else{
    }
}




- (void)vungleSDKhasCachedAdAvailable{
    
}
- (void)vungleSDKAdPlayableChanged:(BOOL)isAdPlayable{
    if(isAdPlayable == NO){
        NSLog(@"there are no ads available");
    }
}
/**
 * If implemented, this will get called when the SDK is about to show an ad. This point
 * might be a good time to pause your game, and turn off any sound you might be playing.
 */
- (void)vungleSDKwillShowAd{
    
}

/**
 * If implemented, this will get called when the SDK closes the ad view, but that doesn't always mean
 * the ad experience is complete. There might be a product sheet that will be presented.
 * This point might be a good place to resume your game if there's no product sheet being presented.
 * If the product sheet will be shown, we recommend waiting for it to close before you resume,
 * show a reward confirmation to the user, etc. The viewInfo dictionary will contain the following keys:
 * - "completedView": NSNumber representing a BOOL whether or not the video can be considered a
 *                full view.
 * - "playTime": NSNumber representing the time in seconds that the user watched the video.
 * - "didDownlaod": NSNumber representing a BOOL whether or not the user clicked the download
 *                  button.
 */
- (void)vungleSDKwillCloseAdWithViewInfo:(NSDictionary*)viewInfo willPresentProductSheet:(BOOL)willPresentProductSheet{
    
    if([[viewInfo objectForKey:@"completedView"]isEqualToNumber:@1]){
        //reward them
        NSLog(@"you have been rewarded!");
        NSArray *itemArray = [[NSArray alloc]init];
        itemArray = [NSArray arrayWithArray:self.alreadyRecievedItems];
        [[PFUser currentUser] setObject:itemArray forKey:@"purchased"];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL success, NSError *error){
            if(!error){
                [self.itemTableView reloadData];
            }
        }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry!" message:@"Please watch the full ad in order to recieve your colors!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay", nil];
        [alert show];
        NSLog(@"please watch the whole video, or download the app");
        [self.alreadyRecievedItems removeLastObject];
    }
}

/**
 * If implemented, this will get called when the product sheet is about to be closed.
 * It will only be called if the product sheet was shown.
 */
- (void)vungleSDKwillCloseProductSheet:(id)productSheet{
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // To "clear" the footer view
    UIView *view = [UIView new];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f;
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

- (UITableView *)itemTableView {
    if (!_itemTableView) {
        _itemTableView = [UITableView new];
        _itemTableView.delegate = self;
        _itemTableView.dataSource = self;
        _itemTableView.rowHeight = 70;
        _itemTableView.backgroundColor = [UIColor clearColor];
        _itemTableView.separatorColor = [UIColor clearColor];
        //_itemTableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _itemTableView;
}

@end

//
//  YourGamesViewController.m
//  PhoneDoodle
//
//  Created by Dawson Walker on 2015-08-20.
//  Copyright (c) 2015 Rise Digital. All rights reserved.
//

#import "YourGamesViewController.h"
#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "UIColor+DMHexColors.h"
#import "MainMenuViewController.h"
#import <GMGridView/GMGridView.h>
#import "AppDelegate.h"
#import "SelectedGameViewController.h"


@interface YourGamesViewController ()<GMGridViewActionDelegate,GMGridViewDataSource>
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *bannerBackground;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) GMGridView * gmGridView;
@property (nonatomic, strong) NSMutableArray *yourGames;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *textArray;
@end

@implementation YourGamesViewController

- (void)viewDidLoad {

    self.backgroundView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.activityIndicatorView.frame = CGRectMake(self.view.frame.size.width/2 - self.activityIndicatorView.frame.size.width/2, self.view.frame.size.height/2 - self.activityIndicatorView.frame.size.height/2, self.activityIndicatorView.frame.size.width, self.activityIndicatorView.frame.size.height);
    [self addSubviews];
    [self checkGames];
}

-(void)checkGames{
    [self.activityIndicatorView startAnimating];
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            //[timer invalidate];
            self.yourGames = [[NSMutableArray alloc]init];
            if(objects.count == 0){
                [self.activityIndicatorView stopAnimating];
            }
            for(int i = 0;i<objects.count;i++){
                NSMutableArray *array = [NSMutableArray arrayWithArray:
                                     [objects[i] valueForKey:@"usersInvolved"]];
                NSNumber *gameCount = [objects[i]valueForKey:@"chainLength"];
                
               
                for(int l = 0; l<array.count;l++){
                    if([array[l] isEqualToString:[PFUser currentUser].username]){
                        if([gameCount intValue] >=2){
                            [self.yourGames addObject:objects[i]];
                        }
                       
                    }
                }
                
            }
            [self defineLayouts];
            [self attachImages];
           
            
        }
        else{
            //[self backToMain];
        }
        
    }];
    
    
}
-(void)errorHandler{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sorry!" message:@"Please make sure you are connected to the internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.delegate = self;
    [alertView show];
    [self backToMain];
}
-(void)attachImages{
    
    self.imagesArray = [[NSMutableArray alloc]initWithCapacity:self.yourGames.count];
    UIImageView *loadingImages = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width-45)/2, (self.view.frame.size.width-45)/2)];
    UIActivityIndicatorView *activityInd = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4, self.view.frame.size.width/4, self.view.frame.size.width/4, self.view.frame.size.width/4)];
    activityInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [activityInd setColor:[UIColor colorWithRed:1.0 green:0.4 blue:0.3 alpha:1.0]];
    [activityInd setHidesWhenStopped:YES];
    [activityInd startAnimating];
    [loadingImages addSubview:activityInd];
    if(self.yourGames.count == 0){
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView.hidden = YES;
    }
    for(int i = 0;i<self.yourGames.count;i++){
        [self.imagesArray addObject:loadingImages];
    }
    for(int l = 0;l<self.yourGames.count; l ++){
        NSMutableArray *array = [NSMutableArray arrayWithArray:[self.yourGames[l] valueForKey:@"imagesArray"]];
        NSMutableArray *arrayOfText = [NSMutableArray arrayWithArray:[self.yourGames[l]valueForKey:@"sentText"]];
        [self.textArray addObject:arrayOfText[0]];
        NSMutableArray *fileArray = [[NSMutableArray alloc]init];
        fileArray = [NSMutableArray arrayWithArray:array];
        
            PFFile *imageFile = fileArray[0];
            PFImageView *imageView = [[PFImageView alloc]init];
            imageView.file = imageFile;
            [imageView loadInBackground:^(UIImage *img, NSError *error){
                UIImageView *imageReplacement = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width-45)/2, (self.view.frame.size.width-45)/2)];
                imageReplacement.image = img;
                //[self.view addSubview:self.activityIndicatorView];
                [self.imagesArray replaceObjectAtIndex:l withObject:imageReplacement];
                [self.activityIndicatorView stopAnimating];
                
                [self.gmGridView reloadData];
                
            }];
            
        
    }
  
}
-(void)addSubviews{
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.bannerBackground];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.activityIndicatorView];
    [self.view addSubview:self.gmGridView];
    
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
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];
    [self.gmGridView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.bannerBackground.mas_bottom).offset(10.0f);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).offset(-100.0f);
    }];
}

-(void)backToMain{
    MainMenuViewController *viewController = [MainMenuViewController new];
    UIViewAnimationTransition trans = UIViewAnimationTransitionCurlUp;
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition: trans forView: [self.view window] cache: YES];
    [self presentViewController:viewController animated:NO completion:nil];
    [UIView commitAnimations];
}

#pragma mark GMGridViewDataSource


//////////////////////////////////////////////////////////////
- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowMovingCell:(GMGridViewCell *)view atIndex:(NSInteger)index{
    return NO;
}
- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowMovingCell:(GMGridViewCell *)view toIndex:(NSInteger)index{
    return NO;
}
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return self.yourGames.count;
   
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    
        return CGSizeMake((self.view.frame.size.width-45)/2, (self.view.frame.size.width-45)/2 + 60);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    
    //cell.selectionStyle = AQGridViewCellSelectionStyleGlow;
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    
    GMGridViewCell* cell = [[GMGridViewCell alloc] initWithFrame:CGRectMake(0, 200, size.width, size.height)];
    UIView *theView =[[UIView alloc]initWithFrame:CGRectMake(0, 200, size.width, size.height)];
    theView.backgroundColor = [UIColor clearColor];
    theView.layer.shadowColor = [UIColor blackColor].CGColor;
    theView.layer.shadowOffset = CGSizeMake(5, 5);
    theView.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
    theView.layer.shadowRadius = 8;
    cell.contentView = theView;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    UIImageView *imgvew = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.width)];
    imgvew = self.imagesArray[index];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.width, cell.frame.size.width, 60)];
    textLabel.text = [NSString stringWithFormat:@"%@",self.textArray[index]];
    textLabel.numberOfLines = 5;
    textLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:28];
    textLabel.minimumScaleFactor = 0.2;
    textLabel.adjustsFontSizeToFitWidth = YES;
    [cell addSubview:imgvew];
    [cell addSubview:textLabel];
    
    cell.layer.cornerRadius = 3;
    cell.layer.masksToBounds = YES;
        
    
        
        

    
    
    
    
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return NO;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
   // NSLog(@"yourgames = %@", self.yourGames[position]);
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.gameArray = self.yourGames[position];
    //NSLog(@"%@", appDelegate.gameArray);
    SelectedGameViewController *viewController = [SelectedGameViewController new];
    [self presentViewController:viewController animated:YES completion:nil];
    //Advance to that thread...
    
    // NSLog(@"Did tap at index %d", position);
    
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
   
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
    }
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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:40];
        _titleLabel.textColor = [UIColor bt_colorWithHexValue:0xFFFFFF alpha:1.0f];
        _titleLabel.text = @"Your Games";
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

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [UIColor colorWithRed:222.0f/255.0f green:232.0f/255.0f blue:240.0f/255.0f alpha:1.0];
    }
    return _backgroundView;
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

- (GMGridView *)gmGridView {
    if (!_gmGridView) {
        _gmGridView = [GMGridView new];
        NSInteger spacing =  15;
        _gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _gmGridView.backgroundColor = [UIColor clearColor];
        _gmGridView.style = GMGridViewStyleSwap;
        _gmGridView.clipsToBounds = YES;
        _gmGridView.itemSpacing = spacing;
        _gmGridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
        _gmGridView.centerGrid = NO;
        _gmGridView.dataSource = self;
        _gmGridView.actionDelegate = self;
        
        _gmGridView.scrollEnabled = YES;
    }
    return _gmGridView;
}

- (NSMutableArray *)yourGames {
    if (!_yourGames) {
        _yourGames = [NSMutableArray new];
    }
    return _yourGames;
}
- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray new];
    }
    return _imagesArray;
}
- (NSMutableArray *)textArray {
    if (!_textArray) {
        _textArray = [NSMutableArray new];
    }
    return _textArray;
}
@end

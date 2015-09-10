//
//  SelectedGameViewController.m
//  PhoneDoodle
//
//  Created by Dawson Walker on 2015-08-21.
//  Copyright (c) 2015 Rise Digital. All rights reserved.
//

#import "SelectedGameViewController.h"
#import "AppDelegate.h"
#import <GMGridView/GMGridView.h>
#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "UIColor+DMHexColors.h"
#import "YourGamesViewController.h"


@interface SelectedGameViewController ()<GMGridViewActionDelegate,GMGridViewDataSource,UIAlertViewDelegate>{
    BOOL reportedUser;
}
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *bannerBackground;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) GMGridView * gmGridView;
@property (nonatomic, strong) NSMutableArray *textArray;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *nameArray;
@property (nonatomic, strong) UIView *opacityView;
@property (nonatomic, strong) UIImageView *boxView;
@property (nonatomic, strong) UIButton *reportButton;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) NSString *reportedPlayer;

@end

@implementation SelectedGameViewController{
    int numberOfRounds;
    int counter;
    int secondCounter;
}

- (void)viewDidLoad {
    numberOfRounds = 0;
    counter = 1;
    secondCounter = 1;
    reportedUser = NO;
    self.backgroundView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.activityIndicatorView.frame = CGRectMake(self.view.frame.size.width/2 - self.activityIndicatorView.frame.size.width/2, self.view.frame.size.height/2 - self.activityIndicatorView.frame.size.height/2, self.activityIndicatorView.frame.size.width, self.activityIndicatorView.frame.size.height);
    [self addSubviews];
    [self loadTheViews];
    // Do any additional setup after loading the view.
}

-(void)loadTheViews{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSNumber *count = [appDelegate.gameArray valueForKey:@"chainLength"];
    numberOfRounds = [count intValue];
       UIImageView *loadingImages = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width-45)/2, (self.view.frame.size.width-45)/2)];
    UIActivityIndicatorView *activityInd = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-45)/4 - self.activityIndicatorView.frame.size.width/2, (self.view.frame.size.width-45)/4 - self.activityIndicatorView.frame.size.height/2, self.activityIndicatorView.frame.size.width, self.activityIndicatorView.frame.size.height)];
    activityInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [activityInd setColor:[UIColor colorWithRed:1.0 green:0.4 blue:0.3 alpha:1.0]];
    [activityInd setHidesWhenStopped:YES];
    [activityInd startAnimating];
    [loadingImages addSubview:activityInd];
    
    NSMutableArray *array = [appDelegate.gameArray valueForKey:@"imagesArray"];
    for(int i = 0;i<array.count;i++){
        
        [self.imagesArray addObject:loadingImages];
       // NSLog(@"images array = %lu",(unsigned long)self.imagesArray.count);
        
    }
    self.textArray = [appDelegate.gameArray valueForKey:@"sentText"];
    self.nameArray = [appDelegate.gameArray valueForKey:@"usersInvolved"];
    [self defineLayouts];
    NSMutableArray *imageTempArray = self.imagesArray;
   // NSLog(@"imageTemp Array = %@ ", imageTempArray);
    
    for(int l = 0;l<array.count; l ++){
       
       
        if(imageTempArray != nil){
            
            PFFile *imageFile = array[l];
            //NSLog(@"imageFile = %@",imageFile);
            PFImageView *imageView = [[PFImageView alloc]init];
            imageView.file = imageFile;
           // NSLog(@"You make it here fine");
            
            [imageView loadInBackground:^(UIImage *img, NSError *error){
                if(!error){
                    UIImageView *imageReplacement = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width-45)/2, (self.view.frame.size.width-45)/2)];
                    
                        [imageReplacement setImage: img];
                         [self.imagesArray replaceObjectAtIndex:l withObject:imageReplacement];
                         counter = 1;
                         secondCounter = 1;
                         
                         [self performSelector:@selector(reloadGrid) withObject:nil afterDelay:0.1];
                        //[self reloadGrid];
                    
                    
                //
                    
                }
            }];
          
            
        }
        [self reloadGrid];
    }
    //[self performSelector:@selector(reloadGrid) withObject:nil afterDelay:0.1];
    
    
}
-(void)reloadGrid{
    [self.gmGridView reloadData];
}
-(void)addSubviews{
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.bannerBackground];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.activityIndicatorView];
    [self.view addSubview:self.gmGridView];
    
}

-(void)backToMain{
    YourGamesViewController *viewController = [YourGamesViewController new];
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(reportedUser){
        [self.reportButton removeFromSuperview];
        [self.boxView removeFromSuperview];
        [self.opacityView removeFromSuperview];
        [self.userLabel removeFromSuperview];
    }
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
    //return the count of things
    NSLog(@"number of Rounds = %i",numberOfRounds);
    counter = 1;
    secondCounter = 1;
    return numberOfRounds;
    
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    
    return CGSizeMake((self.view.frame.size.width-45)/2, (self.view.frame.size.width-45)/2 + 60);
    
    
    
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    NSLog(@"index = %li",(long)index);
    NSLog(@"second counter = %i",secondCounter);
    NSLog(@"counter = %i",counter);
    NSLog(@"index - counter = %li",index - counter);
    NSLog(@"index - secondCounter = %li",index - secondCounter);
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
    if(index%2 == 0 || index == 0){//odd
        
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.width)];
        if(index != 0){
            //NSLog(@"%@ text",self.textArray[index-secondCounter]);
            textLabel.text = [NSString stringWithFormat:@"%@",self.textArray[index-secondCounter]];
            secondCounter ++;
        }
        else{
            textLabel.text = [NSString stringWithFormat:@"%@", self.textArray[0]];
        }
        
        textLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:24];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.minimumScaleFactor = 0.2;
        textLabel.adjustsFontSizeToFitWidth = YES;
        textLabel.numberOfLines = 5;
        [cell addSubview:textLabel];
    }
    else{
        UIImageView *imgvew = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.width)];
       
        imgvew = self.imagesArray[index-counter];
        counter ++;
        [cell addSubview:imgvew];
    }
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.width, cell.frame.size.width, 60)];
    nameLabel.text = [NSString stringWithFormat:@"%@",self.nameArray[index]];
    nameLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:28];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.minimumScaleFactor = 0.2;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    numberLabel.text = [NSString stringWithFormat:@"%ld",(long)index+1];
    numberLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:18];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.minimumScaleFactor = 0.2;
    numberLabel.adjustsFontSizeToFitWidth = YES;
    
    [cell addSubview:nameLabel];
    [cell addSubview:numberLabel];
    if(index == numberOfRounds -1){
        counter = 1;
        secondCounter = 1;
    }
    
    
    
    
    
    
    
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return NO; //index % 2 == 0;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////
-(void)reportUser{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Report" message:[NSString stringWithFormat:@"Are you sure you want to report %@ for inappropriate content?",self.reportedPlayer] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Report", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self.opacityView removeFromSuperview];
        [self.boxView removeFromSuperview];
        [self.reportButton removeFromSuperview];
        [self.userLabel removeFromSuperview];
        self.reportedPlayer = nil;
    }
    else{
        PFObject *message = [PFObject objectWithClassName:@"ReportedUsers"];
        [message setObject:self.reportedPlayer forKey:@"reportedUser"];
        [message setObject:[PFUser currentUser].username forKey:@"userThatReported"];
        
        [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!error){
                UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"Report" message:@"Your report has been sent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert2 show];
            }
        }];
        
    }
    
}
- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    reportedUser = YES;
    self.opacityView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.opacityView.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:230.0f/255.0f blue:200.0f/255.0f alpha:0.6];
    
    self.boxView = [[UIImageView alloc]init];
    self.boxView.backgroundColor = [UIColor bt_colorWithHexValue:0x5AC8FA];
    self.boxView.layer.cornerRadius = 10.0f;
    self.boxView.layer.masksToBounds = YES;
    
    self.reportButton = [[UIButton alloc]init];
    self.reportButton.backgroundColor = [UIColor redColor];
    [self.reportButton setTitle:@"Report inappropriate content" forState:UIControlStateNormal];
    self.reportButton.titleLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:22];
    self.reportButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.reportButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.reportButton.titleLabel.minimumScaleFactor = 0.4;
    self.reportButton.layer.cornerRadius = 10.0f;
    self.reportButton.layer.masksToBounds = YES;
    [self.reportButton addTarget:self action:@selector(reportUser) forControlEvents:UIControlEventTouchUpInside];
    self.userLabel = [[UILabel alloc]init];
    self.userLabel.textAlignment = NSTextAlignmentCenter;
    self.userLabel.text = [NSString stringWithFormat:@"%@'s drawing/writing",self.nameArray[position]];
    self.userLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:22];
    self.userLabel.adjustsFontSizeToFitWidth = YES;
    self.userLabel.minimumScaleFactor = 0.4;
    self.userLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:self.opacityView];
    [self.view addSubview:self.boxView];
    [self.view addSubview:self.reportButton];
    [self.view addSubview:self.userLabel];
    
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.width.equalTo(self.view).offset(-40.0f);
        make.height.equalTo(@200);
    }];
    
    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.boxView);
        make.width.equalTo(self.boxView).offset(-20.0f);
        make.height.equalTo(@45);
    }];
    [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.reportButton.mas_top).offset(-30.0f);
        make.width.equalTo(self.reportButton);
        make.height.equalTo(self.reportButton);
    }];
    self.reportedPlayer = [NSString stringWithFormat:@"%@",self.nameArray[position]];
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelegate.gameArray = [NSArray arrayWithArray:self.yourGames[position]];
    
    //SelectedGameViewController *viewController = [SelectedGameViewController new];
    //[self presentViewController:viewController animated:YES completion:nil];
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
    
    //_lastDeleteItemIndexAsked = index;
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
        _titleLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:50];
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
        _gmGridView.scrollEnabled = YES;
        _gmGridView.actionDelegate = self;
    }
    return _gmGridView;
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
- (NSMutableArray *)nameArray {
    if (!_nameArray) {
        _nameArray = [NSMutableArray new];
    }
    return _nameArray;
}
@end

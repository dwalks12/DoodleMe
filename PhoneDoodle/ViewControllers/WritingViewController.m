//
//  WritingViewController.m
//  PhoneDoodle
//
//  Created by Dawson Walker on 2015-08-20.
//  Copyright (c) 2015 Rise Digital. All rights reserved.
//

#import "WritingViewController.h"
#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "UIColor+DMHexColors.h"
#import "AppDelegate.h"
#import "MainMenuViewController.h"
#import "ACEDrawingView.h"

@interface WritingViewController ()<UITextViewDelegate,ACEDrawingViewDelegate>
@property (nonatomic, strong) UITextView *descriptionTextView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSString *sentText;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *bannerBackground;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIImageView *drawnImage;
@property (nonatomic, strong) UIImageView *blockingImage;
@property (nonatomic, strong) ACEDrawingView *drawingView;
@property (nonatomic, strong) UIView *preview;



@end

@implementation WritingViewController

- (void)viewDidLoad {
    //[super viewDidLoad];
    
    [self addSubviews];
    [self defineLayouts];
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
    [self acquireImage];
    
    // Do any additional setup after loading the view.
}


-(void)acquireImage{
    self.blockingImage.frame = self.drawnImage.frame;
    self.blockingImage.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.blockingImage];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *fileArray = [[NSMutableArray alloc]init];
    fileArray = [appDelegate.gameArray valueForKey:@"imagesArray"];
    if(fileArray != nil){
            PFFile *imageFile = fileArray[fileArray.count-1];
        
            PFImageView *imageView = [[PFImageView alloc]init];
            imageView.file = imageFile;
        
                [imageView loadInBackground:^(UIImage *img, NSError *error){
                    //[self.view addSubview:self.activityIndicatorView];
                    [self.activityIndicatorView stopAnimating];
                    
                    self.activityIndicatorView.hidden = YES;
                    self.drawnImage.image = img;
                    
            }];

    }
    [self drawTheImage];
}
-(void)drawTheImage{
   AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSData *bezierData = [appDelegate.gameArray valueForKey:@"pathArray"];
    NSMutableArray *pathArray = [NSKeyedUnarchiver unarchiveObjectWithData:bezierData];
    
    NSData *colorData = [appDelegate.gameArray valueForKey:@"chosenColors"];
    NSMutableArray *chosenColors = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    NSMutableArray *chosenWidth = [appDelegate.gameArray valueForKey:@"chosenWidth"];
    
    
  
   
    NSTimeInterval total = 0.0;
    int i = 0;
    for (UIBezierPath *path in pathArray)
    {
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = [path CGPath];
        shapeLayer.strokeColor = [chosenColors[i] CGColor];
        shapeLayer.fillColor = nil;
        shapeLayer.lineWidth = [chosenWidth[i]floatValue];
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 0.3;
        pathAnimation.fromValue = @(0.0f);
        pathAnimation.toValue = @(1.0f);
        i++;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, total * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
            [self.preview.layer addSublayer:shapeLayer];
            
        });
        
        total += 0.1;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, total * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.preview removeFromSuperview];
    });
    
    
}

-(void)addSubviews{
    //self.activityIndicatorView.hidden = YES;
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.descriptionTextView];
   
    [self.view addSubview:self.bannerBackground];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.backButton];
     [self.view addSubview:self.submitButton];
    [self.view addSubview:self.drawnImage];
    [self.view addSubview:self.activityIndicatorView];
    [self.view addSubview:self.preview];
}

-(void)defineLayouts{
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_left).offset(35.0f);
        make.centerY.equalTo(self.titleLabel);
        make.width.equalTo(@60);
        make.height.equalTo(@40);
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
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_right).offset(-40.0f);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.width.equalTo(@80);
        make.height.equalTo(@40);
    }];
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];
    [self.descriptionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.bannerBackground.mas_bottom).offset(10.0f);
        make.width.equalTo(self.view);
        make.height.equalTo(@(self.view.frame.size.height - 10.0f - self.bannerBackground.frame.size.height - self.view.frame.size.width - self.view.frame.size.height/5));
    }];
    [self.drawnImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.descriptionTextView.mas_bottom).offset(10.0f);
        make.width.equalTo(self.view);
        make.height.equalTo(self.descriptionTextView.mas_width);
    }];
    
    [self.preview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.drawnImage);
        make.top.equalTo(self.descriptionTextView.mas_bottom).offset(10.0f);
        make.width.equalTo(self.drawnImage);
        make.height.equalTo(self.drawnImage);
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
    
    
    //[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITEXTVIEW DELEGATES

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([self.descriptionTextView isFirstResponder]){
        if(range.length + range.location > textView.text.length)
        {
            return NO;
        }
        if([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
        NSUInteger newLength = [textView.text length] + [text length] - range.length;
        return newLength <= 150;
    }
    else return NO;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    textView.textColor = [UIColor blackColor];
    textView.text = @"";
    
    
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    if([self.descriptionTextView isFirstResponder]){
        self.sentText = textView.text;
        //NSLog(@"%@",sentText);
    }
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    
    
    
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if(![self.descriptionTextView isFirstResponder]){
        
        
        
        [self.descriptionTextView resignFirstResponder];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.view endEditing:YES];
    //NSInteger i = textField.tag;
    //Count = 1;
    self.sentText = self.descriptionTextView.text;
    if([self.descriptionTextView.text isEqualToString:@""]){
        self.descriptionTextView.textColor = [UIColor grayColor];
        self.descriptionTextView.text =  @"Write what you see!";
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if([self.descriptionTextView isFirstResponder]){
    }
    [self.descriptionTextView resignFirstResponder];
}


-(void)submit{
    UIActivityIndicatorView *activityInd = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:activityInd];
    [activityInd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.submitButton);
        make.centerY.equalTo(self.submitButton);
    }];
    activityInd.hidesWhenStopped = YES;
    
    
    [activityInd startAnimating];
    self.submitButton.hidden = YES;
    if(self.sentText.length >= 1){
        //NSLog(@"send that text");
        
        //self.activityIndicatorView.hidden = NO;
        //[self.activityIndicatorView startAnimating];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSMutableArray *userArray = [NSMutableArray arrayWithArray:[appDelegate.gameArray valueForKey:@"usersInvolved"]];
            [userArray addObject:[PFUser currentUser].username];
            NSArray *userArrayCopy = [NSArray arrayWithArray:userArray];
        
            NSMutableArray *sentTextArray = [NSMutableArray arrayWithArray:[appDelegate.gameArray valueForKey:@"sentText"]];
           
            [sentTextArray addObject:self.sentText];
        
        NSArray *sentTextArrayCopy = [NSArray arrayWithArray:sentTextArray];
        
            PFObject *object = [PFObject objectWithoutDataWithClassName:@"Game" objectId:[appDelegate.gameArray valueForKey:@"objectId"]];
            [object setObject:userArrayCopy forKey:@"usersInvolved"];
            [object setObject:sentTextArrayCopy forKey:@"sentText"];
            [object setObject:[NSString stringWithFormat:@"drawing"] forKey:@"whatsNext"];
            [object incrementKey:@"chainLength"];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(!error){
                   
                }
                activityInd.hidden = YES;
                [self backToMain];
                
                
            }];
        
    }
    else{
        NSLog(@"Please write a description");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Please write a description for the next Player"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
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
        _titleLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:35];
        _titleLabel.textColor = [UIColor bt_colorWithHexValue:0xFFFFFF alpha:1.0f];
        _titleLabel.text = @"Description";
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
- (UIImageView *)drawnImage {
    if (!_drawnImage) {
        _drawnImage = [UIImageView new];
        
    }
    return _drawnImage;
}
- (UITextView *)descriptionTextView {
    if (!_descriptionTextView) {
        _descriptionTextView = [UITextView new];
        _descriptionTextView.delegate = self;
        _descriptionTextView.backgroundColor = [UIColor whiteColor];
        _descriptionTextView.textAlignment = NSTextAlignmentCenter;
        _descriptionTextView.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:26];
        _descriptionTextView.text = @"Write what you see!";
        _descriptionTextView.textColor = [UIColor bt_colorWithHexValue:0x8E8E93 alpha:1.0f];
    }
    return _descriptionTextView;
}
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [UIColor colorWithRed:222.0f/255.0f green:232.0f/255.0f blue:240.0f/255.0f alpha:1.0];
    }
    return _backgroundView;
}
- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton new];
        _submitButton.titleLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:25];
        _submitButton.titleLabel.textColor = [UIColor whiteColor];
        [_submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}
- (UIImageView *)blockingImage{
    if(!_blockingImage){
        _blockingImage = [UIImageView new];
        _blockingImage.backgroundColor = [UIColor whiteColor];
    }
    return _blockingImage;
}
- (UIView *)preview{
    if(!_preview){
        _preview = [UIView new];
        _preview.backgroundColor = [UIColor whiteColor];
        
    }
    return _preview;
}

@end

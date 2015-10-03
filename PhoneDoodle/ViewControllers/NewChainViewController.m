//
// Created by Dawson Walker on 15-08-18.
// Copyright (c) 2015 Rise Digital. All rights reserved.
//

#import "NewChainViewController.h"
#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import <Parse/Parse.h>
#import "LogInViewController.h"
#import "UIColor+DMHexColors.h"

@interface NewChainViewController ()<UITextViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UITextView *descriptionTextView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSString *sentText;
@property (nonatomic) CGRect keyboardRect;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *bannerBackground;
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation NewChainViewController {

}
- (void)viewDidLoad {
    //[super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self addSubviews];
    [self defineLayouts];

}


-(void)addSubviews{
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.descriptionTextView];
    [self.view addSubview:self.submitButton];
    [self.view addSubview:self.activityIndicatorView];
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
    [self.descriptionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.bannerBackground.mas_bottom).offset(20.0f);
        make.width.equalTo(self.view);
        make.height.equalTo(@200);
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-80.0f);
        make.width.equalTo(self.view).offset(-40.0f);
        make.height.equalTo(@50);
    }];
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];
    
}
-(void)keyboardWillChange:(NSNotification *)notification{
    self.keyboardRect = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    self.keyboardRect = [self.view convertRect:self.keyboardRect fromView:nil];

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
        self.descriptionTextView.text =  @"Write a description of something to draw and start a new chain";
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    if([self.descriptionTextView isFirstResponder]){
    }
    [self.descriptionTextView resignFirstResponder];
}


-(void)submit{
    if(self.sentText.length >= 1){
        //NSLog(@"send that text");
        self.activityIndicatorView.hidden = NO;
        [self.activityIndicatorView startAnimating];

        NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithObjects:[PFUser currentUser].username, nil];
        NSMutableArray *textChainArray = [[NSMutableArray alloc]initWithObjects:self.sentText, nil];
        NSArray *textArray = [NSArray arrayWithArray:textChainArray];
        NSArray *userArray = [NSArray arrayWithArray:mutableArray];
       // NSArray *imagesArray = [[NSArray alloc]init];
        //NSLog(@"new image = %@",imagesArray);
        NSNumber *chainLength = @1;
        PFObject *game = [PFObject objectWithClassName:@"Game"];
        [game setObject:textArray forKey:@"sentText"];
        [game setObject:userArray forKey:@"usersInvolved"];
        [game setObject:[NSString stringWithFormat:@"drawing"] forKey:@"whatsNext"];
        [game setObject:chainLength forKey:@"chainLength"];
        //[game setObject:imagesArray forKey:@"imagesArray"];
        [game saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!error){
               
            }
            [self navigateToNewGame];
        }];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Please write a description for the next Player"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}
-(void)backToMain{
    UIViewAnimationTransition trans = UIViewAnimationTransitionCurlUp;
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition: trans forView: [self.view window] cache: YES];
    [self dismissViewControllerAnimated:NO completion:nil];
    [UIView commitAnimations];
}
-(void)navigateToNewGame{
    UIViewAnimationTransition trans = UIViewAnimationTransitionCurlUp;
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition: trans forView: [self.view window] cache: YES];
    [self dismissViewControllerAnimated:NO completion:nil];
    [UIView commitAnimations];
   

}
- (UITextView *)descriptionTextView {
    if (!_descriptionTextView) {
        _descriptionTextView = [UITextView new];
        _descriptionTextView.delegate = self;
        _descriptionTextView.textAlignment = NSTextAlignmentCenter;
        _descriptionTextView.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:26];
        _descriptionTextView.text = @"Write a description of something to draw and start a new chain";
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
        _submitButton.titleLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:30];
        [_submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton setBackgroundColor:[UIColor bt_colorWithHexValue:0xFF3B30 alpha:1.0f]];
        _submitButton.layer.cornerRadius = 10.0f;
        _submitButton.layer.masksToBounds = YES;
        [_submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
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
        _titleLabel.text = @"Start Chain";
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
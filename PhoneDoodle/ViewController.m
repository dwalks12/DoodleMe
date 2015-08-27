//
//  ViewController.m
//  PhoneDoodle
//
//  Created by Dawson Walker on 2015-08-02.
//  Copyright (c) 2015 Rise Digital. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "ACEDrawingView.h"
#import <Masonry/Masonry.h>
#import <Parse/Parse.h>
#import "NewChainViewController.h"
#import "AppDelegate.h"
#import "WritingViewController.h"
#import "UIColor+DMHexColors.h"

@interface ViewController ()<ACEDrawingViewDelegate,UIAlertViewDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) ACEDrawingView *drawingView;
@property (strong, nonatomic) UIScrollView *colorScrollView;
@property (strong, nonatomic) UIButton *undoButton;
@property (nonatomic, strong) UIView *containerView;
@property (strong, nonatomic) UIButton *color1;
@property (strong, nonatomic) UIButton *color2;
@property (strong, nonatomic) UIButton *color3;
@property (strong, nonatomic) UIButton *color4;
@property (strong, nonatomic) UIButton *color5;
@property (strong, nonatomic) UIButton *color6;
@property (strong, nonatomic) UIButton *color7;
@property (strong, nonatomic) UIButton *color8;
@property (strong, nonatomic) UIButton *color9;
@property (strong, nonatomic) UIButton *color10;
@property (strong, nonatomic) UIButton *color11;
@property (strong, nonatomic) UIButton *color12;
@property (strong, nonatomic) UISlider *slider;
@property (strong, nonatomic) UIImageView *backgroundColor;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIButton *replayButton;
@property (strong, nonatomic) NSArray *gameArray;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *bannerBackground;
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation ViewController {
    int attempts;
    int numberOfColors;
    float colorWidth;
}

- (void)viewDidLoad {
    //[super viewDidLoad];
    colorWidth = (self.view.frame.size.width - 60)/11;
    numberOfColors = 12;
    attempts = 0;
    self.activityIndicatorView.frame = CGRectMake(self.view.frame.size.width/2 - self.activityIndicatorView.frame.size.width/2, self.view.frame.size.height/2 - self.activityIndicatorView.frame.size.height/2  , self.activityIndicatorView.frame.size.width, self.activityIndicatorView.frame.size.width);
    self.backgroundColor.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.backgroundColor];
    [self.view addSubview:self.activityIndicatorView];
    
    [self.activityIndicatorView startAnimating];
    self.activityIndicatorView.hidden = NO;
    
    [self checkGames];
}
-(void)checkGames{
    PFQuery * query = [PFQuery queryWithClassName:@"Game"];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
           // NSLog(@"%@",objects);
            NSUInteger randomIndex = arc4random() % [objects count];
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:
                                         [objects[randomIndex] valueForKey:@"usersInvolved"]];
            BOOL yourPlaying = NO;
            for(int i = 0; i< array.count;i++){
                if([array[i] isEqualToString:[PFUser currentUser].username]){
                                       yourPlaying = YES;
                }
                else{
                }
            }
            
            if(yourPlaying == NO){
                self.activityIndicatorView.hidden = YES;
                self.gameArray = nil;
                NSMutableArray *check = [NSMutableArray arrayWithObject:objects[randomIndex]];
                self.gameArray = [NSArray arrayWithArray:check];
                if([[self.gameArray[0] valueForKey:@"whatsNext"]isEqualToString:@"drawing"]){
                   NSLog(@"GO TO DRAWING VIEW YOU HAVE THE LATEST DESCRIPTION");
                    
                    NSMutableArray *textArray = [self.gameArray[0] valueForKey:@"sentText"];
                    
                    self.descriptionLabel.text = [NSString stringWithFormat:@"%@",textArray[textArray.count-1]];
                    
                    [self addSubviews];
                    [self defineLayouts];
                    
                }
                else if([[self.gameArray[0] valueForKey:@"whatsNext"]isEqualToString:@"writing"]){
                    NSLog(@"GO TO WRITING VIEW");
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    appDelegate.gameArray = self.gameArray[0];
                    WritingViewController *writingController = [WritingViewController new];
                    [self presentViewController:writingController animated:YES completion:nil];
                    
                    
                }
                
            }
            else{
                //self.activityIndicatorView.hidden = YES;
                attempts++;
                if(attempts <= 10){
                    [self checkGames];
                }
                else{
                    attempts = 0;
                    self.activityIndicatorView.hidden = YES;
                    [self startNewGame];
                }
            }
        }
        else{
        }
        
    }];
}
-(void)addSubviews{
    [self.view addSubview:self.backgroundColor];
    [self.view addSubview:self.colorScrollView];
    //[self.view addSubview:self.containerView];
    [self.colorScrollView addSubview:self.color1];
    [self.colorScrollView addSubview:self.color2];
    [self.colorScrollView addSubview:self.color3];
    [self.colorScrollView addSubview:self.color4];
    [self.colorScrollView addSubview:self.color5];
    [self.colorScrollView addSubview:self.color6];
    [self.colorScrollView addSubview:self.color7];
    [self.colorScrollView addSubview:self.color8];
    [self.colorScrollView addSubview:self.color9];
    [self.colorScrollView addSubview:self.color10];
    [self.colorScrollView addSubview:self.color11];
    [self.colorScrollView addSubview:self.color12];
    [self.view addSubview:self.undoButton];
    [self.view addSubview:self.slider];
    [self.view addSubview:self.drawingView];
    [self.view addSubview:self.descriptionLabel];
    [self.view addSubview:self.bannerBackground];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.submitButton];
    [self.view addSubview:self.backButton];
    //[self.view bringSubviewToFront:self.activityIndicatorView];

}
-(void)defineLayouts{
    
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
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.bannerBackground.mas_bottom).offset(5.0f);
        make.width.equalTo(self.view);
        make.height.equalTo(@80);
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_right).offset(-40.0f);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.width.equalTo(@80);
        make.height.equalTo(@40);
    }];
    [self.backgroundColor mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [self.colorScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.descriptionLabel.mas_bottom).offset(5.0f);
        make.width.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    [self.color1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.centerY.equalTo(self.colorScrollView);
        make.width.equalTo(@(colorWidth));
        make.height.equalTo(@(colorWidth));
    }];
    [self.color2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.color1.mas_right).offset(5.0f + self.color1.frame.size.width);
        make.centerY.equalTo(self.colorScrollView);
        make.width.equalTo(self.color1);
        make.height.equalTo(self.color1);
    }];
    [self.color3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.color2.mas_right).offset(5.0f + self.color2.frame.size.width);
        make.centerY.equalTo(self.colorScrollView);
        make.width.equalTo(self.color1);
        make.height.equalTo(self.color1);
    }];
    [self.color4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.color3.mas_right).offset(5.0f + self.color3.frame.size.width);
        make.centerY.equalTo(self.colorScrollView);
        make.width.equalTo(self.color1);
        make.height.equalTo(self.color1);
    }];
    [self.color5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.color4.mas_right).offset(5.0f + self.color4.frame.size.width);
        make.centerY.equalTo(self.colorScrollView);
        make.width.equalTo(self.color1);
        make.height.equalTo(self.color1);
    }];
    [self.color6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.color5.mas_right).offset(5.0f + self.color5.frame.size.width);
        make.centerY.equalTo(self.colorScrollView);
        make.width.equalTo(self.color1);
        make.height.equalTo(self.color1);
    }];
    [self.color7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.color6.mas_right).offset(5.0f + self.color6.frame.size.width);
        make.centerY.equalTo(self.colorScrollView);
        make.width.equalTo(self.color1);
        make.height.equalTo(self.color1);
    }];
    [self.color8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.color7.mas_right).offset(5.0f + self.color7.frame.size.width);
        make.centerY.equalTo(self.colorScrollView);
        make.width.equalTo(self.color1);
        make.height.equalTo(self.color1);
    }];
    [self.color9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.color8.mas_right).offset(5.0f + self.color8.frame.size.width);
        make.centerY.equalTo(self.colorScrollView);
        make.width.equalTo(self.color1);
        make.height.equalTo(self.color1);
    }];
    [self.color10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.color9.mas_right).offset(5.0f + self.color9.frame.size.width);
        make.centerY.equalTo(self.colorScrollView);
        make.width.equalTo(self.color1);
        make.height.equalTo(self.color1);
    }];
    [self.color11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.color10.mas_right).offset(5.0f + self.color10.frame.size.width);
        make.centerY.equalTo(self.colorScrollView);
        make.width.equalTo(self.color1);
        make.height.equalTo(self.color1);
    }];
    [self.color12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.color11.mas_right).offset(5.0f + self.color11.frame.size.width);
        make.centerY.equalTo(self.colorScrollView);
        make.width.equalTo(self.color1);
        make.height.equalTo(self.color1);
    }];
    [self.drawingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.colorScrollView.mas_bottom);
        make.width.equalTo(self.view);
        make.height.equalTo(self.drawingView.mas_width);
    }];
    [self.undoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.top.equalTo(self.drawingView.mas_bottom).offset(5.0f);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.undoButton.mas_right).offset(10.0f);
        make.centerY.equalTo(self.undoButton);
        make.width.equalTo(@(self.view.frame.size.width - self.undoButton.frame.size.width*2 - 70.0f));
        make.height.equalTo(@20);
    }];
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];

}

#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else
    {
       [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Actions
-(void)startNewGame{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sorry!" message:@"There are no available matches at this moment. Please try again later." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.delegate = self;
    [alertView show];
    
    //NewChainViewController *newGameController = [NewChainViewController new];
    //[self presentViewController:newGameController animated:YES completion:nil];
}

- (void)updateButtonStatus
{
    self.undoButton.enabled = [self.drawingView canUndo];
    self.submitButton.enabled = [self.drawingView canUndo];
    //self.redoButton.enabled = [self.drawingView canRedo];
}

- (IBAction)redo:(id)sender
{
    [self.drawingView redoLatestStep];
    [self updateButtonStatus];
}

- (IBAction)clear:(id)sender
{
    [self.drawingView clear];
    [self updateButtonStatus];
}

-(void)replay{
    [self.drawingView replay];
}

#pragma mark - ACEDrawing View Delegate

- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;
{
    [self updateButtonStatus];
}

#pragma mark - Actions

-(void)sliderAction:(id)sender{
    UISlider *slider = (UISlider*)sender;
    float value = slider.value;
    self.drawingView.lineWidth = value;
}

-(void)submitDrawing{
    UIActivityIndicatorView *activityInd = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:activityInd];
    [activityInd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.submitButton);
        make.centerY.equalTo(self.submitButton);
    }];
    activityInd.hidesWhenStopped = YES;
    
    
    [activityInd startAnimating];
    self.submitButton.hidden = YES;
    
    [self takeSnapShot];
}
-(void)takeSnapShot{
    //CAPTURE IMAGE!
    //self.activityIndicatorView.hidden = NO;
    //[self.activityIndicatorView startAnimating];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.frame.size.width, self.view.frame.size.width), NO, [UIScreen mainScreen].scale);
    [self.view drawViewHierarchyInRect:CGRectMake(0, -self.drawingView.frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height) afterScreenUpdates:YES];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSMutableArray *pathArray = [[NSMutableArray alloc]init];
    pathArray = self.drawingView.accessFinishedPathsArray;
    
    NSTimeInterval timeInterval = self.drawingView.accessTimeInterval;
    NSMutableArray *chosenColors = self.drawingView.accessChosenColors;
    NSMutableArray *chosenWidth = self.drawingView.accessChosenWidths;
    NSInteger timeInt = timeInterval;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:pathArray];
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:chosenColors];

    NSData * fileData = UIImagePNGRepresentation(capturedImage);
    PFFile* file = [PFFile fileWithName:@"image.png" data:fileData];
    [file saveInBackground];
   // NSMutableArray *arrayofimages = [[NSMutableArray alloc]initWithArray:[self.gameArray valueForKey:@"imagesArray"]];
    NSLog(@"games imagesarray = %@",[self.gameArray[0]valueForKey:@"imagesArray"]);
    if([self.gameArray[0] valueForKey:@"imagesArray"] == nil){
        NSLog(@"First image saved");
        NSMutableArray *imageArray = [[NSMutableArray alloc]initWithObjects:file, nil];
        NSArray *imageArrayCopy = [NSArray arrayWithArray:imageArray];
        NSMutableArray *userArray = [NSMutableArray arrayWithArray:[self.gameArray[0] valueForKey:@"usersInvolved"]];
        
        [userArray addObject:[PFUser currentUser].username];
        NSArray *userArrayCopy = [NSArray arrayWithArray:userArray];
        
        
        PFObject *object = [PFObject objectWithoutDataWithClassName:@"Game" objectId:[self.gameArray[0]valueForKey:@"objectId"]];
        [object setObject:userArrayCopy forKey:@"usersInvolved"];
        [object setObject:imageArrayCopy forKey:@"imagesArray"];
        [object setObject:[NSString stringWithFormat:@"writing"] forKey:@"whatsNext"];
        [object setObject:data forKey:@"pathArray"];
        [object setObject:colorData forKey:@"chosenColors"];
        [object setObject:chosenWidth forKey:@"chosenWidth"];
        [object setObject:[NSNumber numberWithInteger:timeInt] forKey:@"timeInterval"];
        [object incrementKey:@"chainLength"];
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!error){
                [self.activityIndicatorView stopAnimating];
                self.activityIndicatorView.hidden = YES;
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            //CONTINUE ON! GO TO CHOICE VIEW CONTROLLER WHERE YOU CAN EITHER START A NEW GAME OR FIND A GAME.
            
            
        }];
    }
    else{
        NSMutableArray *imageArray = [[NSMutableArray alloc]initWithArray:[self.gameArray[0] valueForKey:@"imagesArray"]];
        [imageArray addObject:file];
        NSArray *imageArrayCopy = [NSArray arrayWithArray:imageArray];
        NSMutableArray *userArray = [NSMutableArray arrayWithArray:[self.gameArray[0]  valueForKey:@"usersInvolved"]];
        [userArray addObject:[PFUser currentUser].username];
        
        NSArray *userArrayCopy = [NSArray arrayWithArray:userArray];
        
        
        PFObject *object = [PFObject objectWithoutDataWithClassName:@"Game" objectId:[self.gameArray[0]valueForKey:@"objectId"]];
        [object setObject:userArrayCopy forKey:@"usersInvolved"];
        [object setObject:imageArrayCopy forKey:@"imagesArray"];
        [object setObject:data forKey:@"pathArray"];
        [object setObject:colorData forKey:@"chosenColors"];
        [object setObject:chosenWidth forKey:@"chosenWidth"];
        [object setObject:[NSNumber numberWithInteger:timeInt] forKey:@"timeInterval"];
        [object setObject:[NSString stringWithFormat:@"writing"] forKey:@"whatsNext"];
        [object incrementKey:@"chainLength"];
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!error){
                [self.activityIndicatorView stopAnimating];
                self.activityIndicatorView.hidden = YES;
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            //CONTINUE ON! GO TO CHOICE VIEW CONTROLLER WHERE YOU CAN EITHER START A NEW GAME OR FIND A GAME.
            
            
        }];
    }
    
    
}
-(void)small{
    //[touchTracker chooseSize:8];
    self.drawingView.lineWidth = 5.0f;
}
-(void)medium{
    self.drawingView.lineWidth = 10.0f;
    //[touchTracker chooseSize:12];
}
-(void)large{
    self.drawingView.lineWidth = 20.0f;
    //[touchTracker chooseSize:16];
}
-(void)xLarge{
    self.drawingView.lineWidth = 30.0f;
    //[touchTracker chooseSize:20];
}
-(void)Color:(id)sender{
    UIButton *clicked = (UIButton *) sender;
    clicked.layer.borderColor = [UIColor bt_colorWithHexValue:0x5AC8FA alpha:1.0f ].CGColor;
    self.drawingView.lineColor = clicked.backgroundColor;
}

-(void)undo{
    [self.drawingView undoLatestStep];
    [self updateButtonStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backToMain{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    //[aScrollView setContentOffset: CGPointMake(aScrollView.contentOffset.x, 0)];
    // or if you are sure you wanna it always on top:
    // [aScrollView setContentOffset: CGPointMake(aScrollView.contentOffset.x, 0)];
}

#pragma mark - Properties

- (ACEDrawingView *)drawingView {
    if (!_drawingView) {
        _drawingView = [ACEDrawingView new];
        _drawingView.delegate = self;

        _drawingView.lineColor = [UIColor blackColor];
        _drawingView.lineWidth = 5.0f;
        _drawingView.drawMode = ACEDrawingModeOriginalSize;
        _drawingView.drawTool = ACEDrawingToolTypePen;
    }
    return _drawingView;
}

- (UIImageView *)backgroundColor {
    if (!_backgroundColor) {
        _backgroundColor = [UIImageView new];
        _backgroundColor.backgroundColor = [UIColor colorWithRed:222.0f/255.0f green:232.0f/255.0f blue:240.0f/255.0f alpha:1.0];
    }
    return _backgroundColor;
}

- (UIButton *)color1 {
    if (!_color1) {
        _color1 = [UIButton new];
        _color1.backgroundColor = [UIColor whiteColor];
        _color1.layer.cornerRadius = 4.0f;
        _color1.layer.masksToBounds = YES;
        [_color1 addTarget:self action:@selector(Color:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _color1;
}

- (UIButton *)color2 {
    if (!_color2) {
        _color2 = [UIButton new];
        _color2.backgroundColor = [UIColor blackColor];
        _color2.layer.cornerRadius = 4.0f;
        _color2.layer.masksToBounds = YES;
        _color2.layer.borderWidth = 2.0f;
        _color2.layer.borderColor = [UIColor bt_colorWithHexValue:0x5AC8FA alpha:1.0f ].CGColor;
        [_color2 addTarget:self action:@selector(Color:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _color2;
}

- (UIButton *)color3 {
    if (!_color3) {
        _color3 = [UIButton new];
        _color3.backgroundColor = [UIColor redColor];
        _color3.layer.cornerRadius = 4.0f;
        _color3.layer.masksToBounds = YES;
        [_color3 addTarget:self action:@selector(Color:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _color3;
}

- (UIButton *)color4 {
    if (!_color4) {
        _color4 = [UIButton new];
        _color4.backgroundColor = [UIColor orangeColor];
        _color4.layer.cornerRadius = 4.0f;
        _color4.layer.masksToBounds = YES;
        [_color4 addTarget:self action:@selector(Color:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _color4;
}

- (UIButton *)color5 {
    if (!_color5) {
        _color5 = [UIButton new];
        _color5.backgroundColor = [UIColor yellowColor];
        _color5.layer.cornerRadius = 4.0f;
        _color5.layer.masksToBounds = YES;
        [_color5 addTarget:self action:@selector(Color:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _color5;
}

- (UIButton *)color6 {
    if (!_color6) {
        _color6 = [UIButton new];
        _color6.backgroundColor = [UIColor greenColor];
        _color6.layer.cornerRadius = 4.0f;
        _color6.layer.masksToBounds = YES;
        [_color6 addTarget:self action:@selector(Color:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _color6;
}

- (UIButton *)color7 {
    if (!_color7) {
        _color7 = [UIButton new];
        _color7.backgroundColor = [UIColor blueColor];
        _color7.layer.cornerRadius = 4.0f;
        _color7.layer.masksToBounds = YES;
        [_color7 addTarget:self action:@selector(Color:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _color7;
}

- (UIButton *)color8 {
    if (!_color8) {
        _color8 = [UIButton new];
        _color8.backgroundColor = [UIColor purpleColor];
        _color8.layer.cornerRadius = 4.0f;
        _color8.layer.masksToBounds = YES;
        [_color8 addTarget:self action:@selector(Color:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _color8;
}

- (UIButton *)color9 {
    if (!_color9) {
        _color9 = [UIButton new];
        _color9.backgroundColor = [UIColor brownColor];
        _color9.layer.cornerRadius = 4.0f;
        _color9.layer.masksToBounds = YES;
        [_color9 addTarget:self action:@selector(Color:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _color9;
}

- (UIButton *)color10 {
    if (!_color10) {
        _color10 = [UIButton new];
        _color10.backgroundColor = [UIColor grayColor];
        _color10.layer.cornerRadius = 4.0f;
        _color10.layer.masksToBounds = YES;
        [_color10 addTarget:self action:@selector(Color:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _color10;
}

- (UIButton *)color11 {
    if (!_color11) {
        _color11 = [UIButton new];
        _color11.backgroundColor = [UIColor lightGrayColor];
        _color11.layer.cornerRadius = 4.0f;
        _color11.layer.masksToBounds = YES;
        [_color11 addTarget:self action:@selector(Color:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _color11;
}

-(UIButton *)color12{
    if(!_color12){
        _color12 = [UIButton new];
        _color12.backgroundColor = [UIColor bt_colorWithHexValue:0x5856D6 alpha:1.0f];
        _color12.layer.cornerRadius = 4.0f;
        _color12.layer.masksToBounds = YES;
        [_color12 addTarget:self action:@selector(Color:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _color12;
}


- (UIButton *)undoButton {
    if (!_undoButton) {
        _undoButton = [UIButton new];
        [_undoButton setBackgroundImage:[UIImage imageNamed:@"undoIcon.png"] forState:UIControlStateNormal];
        [self undo];
        //[_undoButton setTitle:@"UNDO" forState:UIControlStateNormal];
        [_undoButton addTarget:self action:@selector(undo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _undoButton;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton new];
        _submitButton.titleLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:25];
        _submitButton.titleLabel.textColor = [UIColor whiteColor];
        [_submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        
        [_submitButton addTarget:self action:@selector(submitDrawing) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor clearColor];
    }
    return _containerView;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [UISlider new];
        [_slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        
        UIImage *sliderMinTrackImage = [[UIImage imageNamed: @"customSlider2.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        
        UIImage *sliderMaxTrackImage = [UIImage imageNamed: @"customSlider.png"];
        [_slider setBackgroundColor:[UIColor clearColor]];
        [_slider setMinimumTrackImage:sliderMinTrackImage forState:UIControlStateNormal];
        [_slider setMaximumTrackImage:sliderMaxTrackImage forState:UIControlStateNormal];
        _slider.minimumValue = 1.0;
        _slider.maximumValue = 50.0;
        _slider.continuous = YES;
        _slider.value = 5.0;
    }
    return _slider;
}

- (UIButton *)replayButton {
    if (!_replayButton) {
        _replayButton = [UIButton new];
        [_replayButton addTarget:self action:@selector(replay) forControlEvents:UIControlEventTouchUpInside];
        [_replayButton setTitle:@"REPLAY" forState:UIControlStateNormal];
    }
    return _replayButton;
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

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [UILabel new];
        _descriptionLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:26];
        _descriptionLabel.numberOfLines = 9;
        _descriptionLabel.minimumScaleFactor = 0.2;
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.adjustsFontSizeToFitWidth = YES;
        _descriptionLabel.backgroundColor = [UIColor whiteColor];

    }
    return _descriptionLabel;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"BubblegumSans-Regular" size:50];
        _titleLabel.textColor = [UIColor bt_colorWithHexValue:0xFFFFFF alpha:1.0f];
        _titleLabel.text = @"Draw it";
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

-(UIScrollView *)colorScrollView{
    if(!_colorScrollView){
        _colorScrollView = [UIScrollView new];
        _colorScrollView.delegate = self;
        _colorScrollView.contentSize = CGSizeMake(5.0f + (numberOfColors *(colorWidth+5.0f)), 50);
       
    }
    return _colorScrollView;
}
@end

//
//  GCPlayerPanelController.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/22/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCPlayerPanelController.h"

#import "GCPlayer.h"

@implementation GCPlayerPanelController

#pragma mark - Memory lifecycle

- (id) initWithGame: (id<GCGame>) _game
{
    self = [super initWithNibName: nil bundle: nil];
    
    if (self)
    {
        game = _game;
    }
    
    return self;
}


- (void) dealloc
{
    [super dealloc];
}


#pragma mark - GCModalDrawerPanelDelegate

- (void) drawerWillAppear
{
    GCPlayer *leftPlayer  = [game leftPlayer];
    GCPlayer *rightPlayer = [game rightPlayer];
    
    [leftTextField setText: [leftPlayer name]];
    [rightTextField setText: [rightPlayer name]];
    
    NSUInteger leftIndex  = ([leftPlayer type] == GC_HUMAN) ? 0 : 1;
    NSUInteger rightIndex = ([rightPlayer type] == GC_HUMAN) ? 0 : 1;
    [leftPlayerType setSelectedSegmentIndex: leftIndex];
    [leftPlayerType sendActionsForControlEvents: UIControlEventValueChanged];
    [rightPlayerType setSelectedSegmentIndex: rightIndex];
    [rightPlayerType sendActionsForControlEvents: UIControlEventValueChanged];
    
    NSInteger leftPerfectness  = (NSInteger) round(10 * [leftPlayer percentPerfect]);
    NSInteger rightPerfectness = (NSInteger) round(10 * [rightPlayer percentPerfect]);
    
    [leftPercentSlider setValue: leftPerfectness];
    [leftPercentSlider sendActionsForControlEvents: UIControlEventValueChanged];
    [rightPercentSlider setValue: rightPerfectness];
    [rightPercentSlider sendActionsForControlEvents: UIControlEventValueChanged];
}


- (void) drawerWillDisappear
{
    [leftTextField resignFirstResponder];
    [rightTextField resignFirstResponder];
}


- (void) saveButtonTapped
{
    GCPlayer *leftPlayer  = [game leftPlayer];
    GCPlayer *rightPlayer = [game rightPlayer];
    
    [leftPlayer setName: [leftTextField text]];
    [rightPlayer setName: [rightTextField text]];
    
    [leftPlayer setType: ([leftPlayerType selectedSegmentIndex] == 0) ? GC_HUMAN : GC_COMPUTER];
    [rightPlayer setType: ([rightPlayerType selectedSegmentIndex] == 0) ? GC_HUMAN : GC_COMPUTER];
    
    [leftPlayer setPercentPerfect: leftPercentSlider.value / 10];
    [rightPlayer setPercentPerfect: rightPercentSlider.value / 10];
}


- (BOOL) wantsSaveButton
{
    return YES;
}


- (BOOL) wantsCancelButton
{
    return YES;
}


- (BOOL) wantsDoneButton
{
    return NO;
}


- (NSString *) title
{
    return @"Players";
}


#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - Segmented controls

- (void) segmentedControlChanged: (UISegmentedControl *) segmentedControl
{
    if (segmentedControl.tag == 1)
    {
        NSInteger index = [segmentedControl selectedSegmentIndex];
        BOOL hidden = (index == 0);
        [leftPercentHeader setHidden: hidden];
        [leftPercentLabel setHidden: hidden];
        [leftPercentSlider setHidden: hidden];
        [leftInfoLabel setHidden: hidden];
    }
    else if (segmentedControl.tag == 2)
    {
        NSInteger index = [segmentedControl selectedSegmentIndex];
        BOOL hidden = (index == 0);
        [rightPercentHeader setHidden: hidden];
        [rightPercentLabel setHidden: hidden];
        [rightPercentSlider setHidden: hidden];
        [rightInfoLabel setHidden: hidden];
    }
}


#pragma mark - Sliders

- (void) sliderChanged: (UISlider *) slider
{
    CGFloat value = [slider value];
    CGFloat rounded = round(value);
    [slider setValue: rounded];
    
    NSInteger integerValue = (NSInteger) rounded;
    
    UILabel *receiver = nil;
    if (slider.tag == 1)
        receiver = leftPercentLabel;
    else if (slider.tag == 2)
        receiver = rightPercentLabel;
    [receiver setText: [NSString stringWithFormat: @"%d%%", 10 * integerValue]];
    
    receiver = nil;
    if (slider.tag == 1)
        receiver = leftInfoLabel;
    else if (slider.tag == 2)
        receiver = rightInfoLabel;
    
    NSString *infoMessage = @"";
    if (integerValue == 0)
        infoMessage = @"Computer will play randomly every turn.";
    else if (integerValue == 10)
        infoMessage = @"Computer will play perfectly every turn.";
    else
        infoMessage = [NSString stringWithFormat: @"Computer will play perfectly on %d%% of its turns and randomly on %d%% of its turns.", 10 * integerValue, 10 * (10 - integerValue)];
    
    [receiver setText: infoMessage];
}


#pragma mark - View lifecycle

- (void) loadView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.view = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 460 - 20, 280 - 32)] autorelease];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.view = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 460 - 20, 280 - 44)] autorelease];
    
    CGFloat width  = self.view.bounds.size.width;
    
    CGFloat leftInset, rightInset;
    CGFloat leftHeaderY, rightHeaderY;
    CGFloat playerWidth;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        leftInset = 20;
        rightInset = 20 + (width / 2.0f);
        leftHeaderY = 8;
        rightHeaderY = 8;
        playerWidth = (width - 40) / 2.0f;
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        leftInset = 20;
        rightInset = 20 + (width / 2.0f);
        leftHeaderY = 8;
        rightHeaderY = 8;
        playerWidth = (width - 40) / 2.0f;
    }
    else
    {
        leftInset = rightInset = leftHeaderY = rightHeaderY = playerWidth = 0;
    }
    
    /* Left player */
    
    UILabel *leftHeader = [[UILabel alloc] initWithFrame: CGRectMake(leftInset, leftHeaderY, playerWidth, 25)];
    [leftHeader setBackgroundColor: [UIColor clearColor]];
    [leftHeader setFont: [UIFont boldSystemFontOfSize: 18]];
    [leftHeader setTextAlignment: UITextAlignmentCenter];
    [leftHeader setTextColor: [UIColor whiteColor]];
    [leftHeader setText: @"Left Player"];
    
    [self.view addSubview: leftHeader];
    [leftHeader release];
    
    leftTextField = [[UITextField alloc] initWithFrame: CGRectMake(leftInset, CGRectGetMaxY(leftHeader.frame) + 5, playerWidth, 31)];
    [leftTextField setBorderStyle: UITextBorderStyleRoundedRect];
    [leftTextField setReturnKeyType: UIReturnKeyDone];
    [leftTextField setTextColor: [UIColor colorWithRed: 56.0f / 256 green: 84.0f / 256 blue: 135.0f / 256 alpha: 1]];
    [leftTextField setContentVerticalAlignment: UIControlContentVerticalAlignmentCenter];
    [leftTextField setFont: [UIFont systemFontOfSize: 16]];
    [leftTextField setPlaceholder: @"Left Player Name"];
    [leftTextField setDelegate: self];
    
    [self.view addSubview: leftTextField];
    
    NSArray *items = [NSArray arrayWithObjects: @"Human", @"Computer", nil];
    leftPlayerType = [[UISegmentedControl alloc] initWithItems: items];
    [leftPlayerType setFrame: CGRectMake(leftInset, CGRectGetMaxY(leftTextField.frame) + 10, playerWidth, 30)];
    [leftPlayerType setSelectedSegmentIndex: 0];
    [leftPlayerType setTag: 1];
    [leftPlayerType addTarget: self action: @selector(segmentedControlChanged:) forControlEvents: UIControlEventValueChanged];
    
    [self.view addSubview: leftPlayerType];
    
    leftPercentHeader = [[UILabel alloc] initWithFrame: CGRectMake(leftInset, CGRectGetMaxY(leftPlayerType.frame) + 10, playerWidth, 20)];
    [leftPercentHeader setBackgroundColor: [UIColor clearColor]];
    [leftPercentHeader setFont: [UIFont systemFontOfSize: 16]];
    [leftPercentHeader setTextAlignment: UITextAlignmentLeft];
    [leftPercentHeader setTextColor: [UIColor whiteColor]];
    [leftPercentHeader setText: @"Percent Perfect"];
    [leftPercentHeader setHidden: YES];
    
    [self.view addSubview: leftPercentHeader];
    
    leftPercentLabel = [[UILabel alloc] initWithFrame: CGRectMake(leftInset, CGRectGetMaxY(leftPlayerType.frame) + 10, playerWidth, 20)];
    [leftPercentLabel setBackgroundColor: [UIColor clearColor]];
    [leftPercentLabel setFont: [UIFont systemFontOfSize: 16]];
    [leftPercentLabel setTextAlignment: UITextAlignmentRight];
    [leftPercentLabel setTextColor: [UIColor whiteColor]];
    [leftPercentLabel setText: @"100%"];
    [leftPercentLabel setHidden: YES];
    
    [self.view addSubview: leftPercentLabel];
    
    leftPercentSlider = [[UISlider alloc] initWithFrame: CGRectMake(leftInset, CGRectGetMaxY(leftPercentLabel.frame) + 10, playerWidth, 20)];
    [leftPercentSlider setMinimumValue: 0];
    [leftPercentSlider setMaximumValue: 10];
    [leftPercentSlider setValue: 10];
    [leftPercentSlider setTag: 1];
    [leftPercentSlider addTarget: self action: @selector(sliderChanged:) forControlEvents: UIControlEventValueChanged];
    [leftPercentSlider setHidden: YES];
    
    [self.view addSubview: leftPercentSlider];
    
    leftInfoLabel = [[UILabel alloc] initWithFrame: CGRectMake(leftInset, CGRectGetMaxY(leftPercentSlider.frame) + 5, playerWidth, 50)];
    [leftInfoLabel setBackgroundColor: [UIColor clearColor]];
    [leftInfoLabel setFont: [UIFont systemFontOfSize: 14]];
    [leftInfoLabel setNumberOfLines: 3];
    [leftInfoLabel setLineBreakMode: UILineBreakModeWordWrap];
    [leftInfoLabel setTextAlignment: UITextAlignmentLeft];
    [leftInfoLabel setTextColor: [UIColor whiteColor]];
    [leftInfoLabel setHidden: YES];
    
    [self.view addSubview: leftInfoLabel];
    
    
    
    /* Right player */
    
    UILabel *rightHeader = [[UILabel alloc] initWithFrame: CGRectMake(rightInset, rightHeaderY, playerWidth, 25)];
    [rightHeader setBackgroundColor: [UIColor clearColor]];
    [rightHeader setFont: [UIFont boldSystemFontOfSize: 18]];
    [rightHeader setTextAlignment: UITextAlignmentCenter];
    [rightHeader setTextColor: [UIColor whiteColor]];
    [rightHeader setText: @"Right Player"];
    
    [self.view addSubview: rightHeader];
    [rightHeader release];
    
    rightTextField = [[UITextField alloc] initWithFrame: CGRectMake(rightInset, CGRectGetMaxY(rightHeader.frame) + 5, playerWidth, 31)];
    [rightTextField setBorderStyle: UITextBorderStyleRoundedRect];
    [rightTextField setReturnKeyType: UIReturnKeyDone];
    [rightTextField setTextColor: [UIColor colorWithRed: 56.0f / 256 green: 84.0f / 256 blue: 135.0f / 256 alpha: 1]];
    [rightTextField setContentVerticalAlignment: UIControlContentVerticalAlignmentCenter];
    [rightTextField setFont: [UIFont systemFontOfSize: 16]];
    [rightTextField setPlaceholder: @"Right Player Name"];
    [rightTextField setDelegate: self];
    
    [self.view addSubview: rightTextField];
    
    rightPlayerType = [[UISegmentedControl alloc] initWithItems: items];
    [rightPlayerType setFrame: CGRectMake(rightInset, CGRectGetMaxY(rightTextField.frame) + 10, playerWidth, 30)];
    [rightPlayerType setSelectedSegmentIndex: 0];
    [rightPlayerType setTag: 2];
    [rightPlayerType addTarget: self action: @selector(segmentedControlChanged:) forControlEvents: UIControlEventValueChanged];
    
    [self.view addSubview: rightPlayerType];
    
    rightPercentHeader = [[UILabel alloc] initWithFrame: CGRectMake(rightInset, CGRectGetMaxY(rightPlayerType.frame) + 10, playerWidth, 20)];
    [rightPercentHeader setBackgroundColor: [UIColor clearColor]];
    [rightPercentHeader setFont: [UIFont systemFontOfSize: 16]];
    [rightPercentHeader setTextAlignment: UITextAlignmentLeft];
    [rightPercentHeader setTextColor: [UIColor whiteColor]];
    [rightPercentHeader setText: @"Percent Perfect"];
    [rightPercentHeader setHidden: YES];
    
    [self.view addSubview: rightPercentHeader];
    
    rightPercentLabel = [[UILabel alloc] initWithFrame: CGRectMake(rightInset, CGRectGetMaxY(rightPlayerType.frame) + 10, playerWidth, 20)];
    [rightPercentLabel setBackgroundColor: [UIColor clearColor]];
    [rightPercentLabel setFont: [UIFont systemFontOfSize: 16]];
    [rightPercentLabel setTextAlignment: UITextAlignmentRight];
    [rightPercentLabel setTextColor: [UIColor whiteColor]];
    [rightPercentLabel setText: @"100%"];
    [rightPercentLabel setHidden: YES];
    
    [self.view addSubview: rightPercentLabel];
    
    rightPercentSlider = [[UISlider alloc] initWithFrame: CGRectMake(rightInset, CGRectGetMaxY(rightPercentLabel.frame) + 10, playerWidth, 20)];
    [rightPercentSlider setMinimumValue: 0];
    [rightPercentSlider setMaximumValue: 10];
    [rightPercentSlider setValue: 10];
    [rightPercentSlider setTag: 2];
    [rightPercentSlider addTarget: self action: @selector(sliderChanged:) forControlEvents: UIControlEventValueChanged];
    [rightPercentSlider setHidden: YES];
    
    [self.view addSubview: rightPercentSlider];
    
    rightInfoLabel = [[UILabel alloc] initWithFrame: CGRectMake(rightInset, CGRectGetMaxY(rightPercentSlider.frame) + 5, playerWidth, 50)];
    [rightInfoLabel setBackgroundColor: [UIColor clearColor]];
    [rightInfoLabel setFont: [UIFont systemFontOfSize: 14]];
    [rightInfoLabel setNumberOfLines: 3];
    [rightInfoLabel setLineBreakMode: UILineBreakModeWordWrap];
    [rightInfoLabel setTextAlignment: UITextAlignmentLeft];
    [rightInfoLabel setTextColor: [UIColor whiteColor]];
    [rightInfoLabel setHidden: YES];
    
    [self.view addSubview: rightInfoLabel];
}


- (void) viewDidLoad
{
    [super viewDidLoad];
}


- (void) viewDidUnload
{
    [super viewDidUnload];
    
    [leftTextField release];
    [rightTextField release];
    
    [leftPlayerType release];
    [rightPlayerType release];
    
    [leftPercentHeader release];
    [rightPercentHeader release];
    
    [leftPercentLabel release];
    [rightPercentLabel release];
    
    [leftPercentSlider release];
    [rightPercentSlider release];
    
    [leftInfoLabel release];
    [rightInfoLabel release];
}

@end

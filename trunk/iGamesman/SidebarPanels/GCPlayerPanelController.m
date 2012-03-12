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

- (id) initWithGame: (id<GCGame>) game
{
    self = [super initWithNibName: nil bundle: nil];
    
    if (self)
    {
        _game = game;
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
    GCPlayer *leftPlayer  = [_game leftPlayer];
    GCPlayer *rightPlayer = [_game rightPlayer];
    
    [_leftTextField setText: [leftPlayer name]];
    [_rightTextField setText: [rightPlayer name]];
    
    NSUInteger leftIndex  = ([leftPlayer type] == GC_HUMAN) ? 0 : 1;
    NSUInteger rightIndex = ([rightPlayer type] == GC_HUMAN) ? 0 : 1;
    [_leftPlayerType setSelectedSegmentIndex: leftIndex];
    [_leftPlayerType sendActionsForControlEvents: UIControlEventValueChanged];
    [_rightPlayerType setSelectedSegmentIndex: rightIndex];
    [_rightPlayerType sendActionsForControlEvents: UIControlEventValueChanged];
    
    NSInteger leftPerfectness  = (NSInteger) round(10 * [leftPlayer percentPerfect]);
    NSInteger rightPerfectness = (NSInteger) round(10 * [rightPlayer percentPerfect]);
    
    [_leftPercentSlider setValue: leftPerfectness];
    [_leftPercentSlider sendActionsForControlEvents: UIControlEventValueChanged];
    [_rightPercentSlider setValue: rightPerfectness];
    [_rightPercentSlider sendActionsForControlEvents: UIControlEventValueChanged];
}


- (void) drawerWillDisappear
{
    [_leftTextField resignFirstResponder];
    [_rightTextField resignFirstResponder];
}


- (void) saveButtonTapped
{
    GCPlayer *leftPlayer  = [_game leftPlayer];
    GCPlayer *rightPlayer = [_game rightPlayer];
    
    [leftPlayer setName: [_leftTextField text]];
    [rightPlayer setName: [_rightTextField text]];
    
    [leftPlayer setType: ([_leftPlayerType selectedSegmentIndex] == 0) ? GC_HUMAN : GC_COMPUTER];
    [rightPlayer setType: ([_rightPlayerType selectedSegmentIndex] == 0) ? GC_HUMAN : GC_COMPUTER];
    
    [leftPlayer setPercentPerfect: [_leftPercentSlider value] / 10];
    [rightPlayer setPercentPerfect: [_rightPercentSlider value] / 10];
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
    if ([segmentedControl tag] == 1)
    {
        NSInteger index = [segmentedControl selectedSegmentIndex];
        BOOL hidden = (index == 0);
        [_leftPercentHeader setHidden: hidden];
        [_leftPercentLabel setHidden: hidden];
        [_leftPercentSlider setHidden: hidden];
        [_leftInfoLabel setHidden: hidden];
    }
    else if ([segmentedControl tag] == 2)
    {
        NSInteger index = [segmentedControl selectedSegmentIndex];
        BOOL hidden = (index == 0);
        [_rightPercentHeader setHidden: hidden];
        [_rightPercentLabel setHidden: hidden];
        [_rightPercentSlider setHidden: hidden];
        [_rightInfoLabel setHidden: hidden];
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
    if ([slider tag] == 1)
        receiver = _leftPercentLabel;
    else if ([slider tag] == 2)
        receiver = _rightPercentLabel;
    [receiver setText: [NSString stringWithFormat: @"%d%%", 10 * integerValue]];
    
    receiver = nil;
    if ([slider tag] == 1)
        receiver = _leftInfoLabel;
    else if ([slider tag] == 2)
        receiver = _rightInfoLabel;
    
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
        [self setView: [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 460 - 20, 280 - 32)] autorelease]];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self setView: [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 460 - 20, 280 - 44)] autorelease]];
    
    CGFloat width  = [[self view] bounds].size.width;
    
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
    
    [[self view] addSubview: leftHeader];
    [leftHeader release];
    
    _leftTextField = [[UITextField alloc] initWithFrame: CGRectMake(leftInset, CGRectGetMaxY([leftHeader frame]) + 5, playerWidth, 31)];
    [_leftTextField setBorderStyle: UITextBorderStyleRoundedRect];
    [_leftTextField setReturnKeyType: UIReturnKeyDone];
    [_leftTextField setTextColor: [UIColor colorWithRed: 56.0f / 256 green: 84.0f / 256 blue: 135.0f / 256 alpha: 1]];
    [_leftTextField setContentVerticalAlignment: UIControlContentVerticalAlignmentCenter];
    [_leftTextField setFont: [UIFont systemFontOfSize: 16]];
    [_leftTextField setPlaceholder: @"Left Player Name"];
    [_leftTextField setDelegate: self];
    
    [[self view] addSubview: _leftTextField];
    
    NSArray *items = [NSArray arrayWithObjects: @"Human", @"Computer", nil];
    _leftPlayerType = [[UISegmentedControl alloc] initWithItems: items];
    [_leftPlayerType setFrame: CGRectMake(leftInset, CGRectGetMaxY([_leftTextField frame]) + 10, playerWidth, 30)];
    [_leftPlayerType setSelectedSegmentIndex: 0];
    [_leftPlayerType setTag: 1];
    [_leftPlayerType addTarget: self action: @selector(segmentedControlChanged:) forControlEvents: UIControlEventValueChanged];
    
    [[self view] addSubview: _leftPlayerType];
    
    _leftPercentHeader = [[UILabel alloc] initWithFrame: CGRectMake(leftInset, CGRectGetMaxY([_leftPlayerType frame]) + 10, playerWidth, 20)];
    [_leftPercentHeader setBackgroundColor: [UIColor clearColor]];
    [_leftPercentHeader setFont: [UIFont systemFontOfSize: 16]];
    [_leftPercentHeader setTextAlignment: UITextAlignmentLeft];
    [_leftPercentHeader setTextColor: [UIColor whiteColor]];
    [_leftPercentHeader setText: @"Percent Perfect"];
    [_leftPercentHeader setHidden: YES];
    
    [[self view] addSubview: _leftPercentHeader];
    
    _leftPercentLabel = [[UILabel alloc] initWithFrame: CGRectMake(leftInset, CGRectGetMaxY([_leftPlayerType frame]) + 10, playerWidth, 20)];
    [_leftPercentLabel setBackgroundColor: [UIColor clearColor]];
    [_leftPercentLabel setFont: [UIFont systemFontOfSize: 16]];
    [_leftPercentLabel setTextAlignment: UITextAlignmentRight];
    [_leftPercentLabel setTextColor: [UIColor whiteColor]];
    [_leftPercentLabel setText: @"100%"];
    [_leftPercentLabel setHidden: YES];
    
    [[self view] addSubview: _leftPercentLabel];
    
    _leftPercentSlider = [[UISlider alloc] initWithFrame: CGRectMake(leftInset, CGRectGetMaxY([_leftPercentLabel frame]) + 10, playerWidth, 20)];
    [_leftPercentSlider setMinimumValue: 0];
    [_leftPercentSlider setMaximumValue: 10];
    [_leftPercentSlider setValue: 10];
    [_leftPercentSlider setTag: 1];
    [_leftPercentSlider addTarget: self action: @selector(sliderChanged:) forControlEvents: UIControlEventValueChanged];
    [_leftPercentSlider setHidden: YES];
    
    [[self view] addSubview: _leftPercentSlider];
    
    _leftInfoLabel = [[UILabel alloc] initWithFrame: CGRectMake(leftInset, CGRectGetMaxY([_leftPercentSlider frame]) + 5, playerWidth, 50)];
    [_leftInfoLabel setBackgroundColor: [UIColor clearColor]];
    [_leftInfoLabel setFont: [UIFont systemFontOfSize: 14]];
    [_leftInfoLabel setNumberOfLines: 3];
    [_leftInfoLabel setLineBreakMode: UILineBreakModeWordWrap];
    [_leftInfoLabel setTextAlignment: UITextAlignmentLeft];
    [_leftInfoLabel setTextColor: [UIColor whiteColor]];
    [_leftInfoLabel setHidden: YES];
    
    [[self view] addSubview: _leftInfoLabel];
    
    
    
    /* Right player */
    
    UILabel *rightHeader = [[UILabel alloc] initWithFrame: CGRectMake(rightInset, rightHeaderY, playerWidth, 25)];
    [rightHeader setBackgroundColor: [UIColor clearColor]];
    [rightHeader setFont: [UIFont boldSystemFontOfSize: 18]];
    [rightHeader setTextAlignment: UITextAlignmentCenter];
    [rightHeader setTextColor: [UIColor whiteColor]];
    [rightHeader setText: @"Right Player"];
    
    [[self view] addSubview: rightHeader];
    [rightHeader release];
    
    _rightTextField = [[UITextField alloc] initWithFrame: CGRectMake(rightInset, CGRectGetMaxY([rightHeader frame]) + 5, playerWidth, 31)];
    [_rightTextField setBorderStyle: UITextBorderStyleRoundedRect];
    [_rightTextField setReturnKeyType: UIReturnKeyDone];
    [_rightTextField setTextColor: [UIColor colorWithRed: 56.0f / 256 green: 84.0f / 256 blue: 135.0f / 256 alpha: 1]];
    [_rightTextField setContentVerticalAlignment: UIControlContentVerticalAlignmentCenter];
    [_rightTextField setFont: [UIFont systemFontOfSize: 16]];
    [_rightTextField setPlaceholder: @"Right Player Name"];
    [_rightTextField setDelegate: self];
    
    [[self view] addSubview: _rightTextField];
    
    _rightPlayerType = [[UISegmentedControl alloc] initWithItems: items];
    [_rightPlayerType setFrame: CGRectMake(rightInset, CGRectGetMaxY([_rightTextField frame]) + 10, playerWidth, 30)];
    [_rightPlayerType setSelectedSegmentIndex: 0];
    [_rightPlayerType setTag: 2];
    [_rightPlayerType addTarget: self action: @selector(segmentedControlChanged:) forControlEvents: UIControlEventValueChanged];
    
    [[self view] addSubview: _rightPlayerType];
    
    _rightPercentHeader = [[UILabel alloc] initWithFrame: CGRectMake(rightInset, CGRectGetMaxY([_rightPlayerType frame]) + 10, playerWidth, 20)];
    [_rightPercentHeader setBackgroundColor: [UIColor clearColor]];
    [_rightPercentHeader setFont: [UIFont systemFontOfSize: 16]];
    [_rightPercentHeader setTextAlignment: UITextAlignmentLeft];
    [_rightPercentHeader setTextColor: [UIColor whiteColor]];
    [_rightPercentHeader setText: @"Percent Perfect"];
    [_rightPercentHeader setHidden: YES];
    
    [[self view] addSubview: _rightPercentHeader];
    
    _rightPercentLabel = [[UILabel alloc] initWithFrame: CGRectMake(rightInset, CGRectGetMaxY([_rightPlayerType frame]) + 10, playerWidth, 20)];
    [_rightPercentLabel setBackgroundColor: [UIColor clearColor]];
    [_rightPercentLabel setFont: [UIFont systemFontOfSize: 16]];
    [_rightPercentLabel setTextAlignment: UITextAlignmentRight];
    [_rightPercentLabel setTextColor: [UIColor whiteColor]];
    [_rightPercentLabel setText: @"100%"];
    [_rightPercentLabel setHidden: YES];
    
    [[self view] addSubview: _rightPercentLabel];
    
    _rightPercentSlider = [[UISlider alloc] initWithFrame: CGRectMake(rightInset, CGRectGetMaxY([_rightPercentLabel frame]) + 10, playerWidth, 20)];
    [_rightPercentSlider setMinimumValue: 0];
    [_rightPercentSlider setMaximumValue: 10];
    [_rightPercentSlider setValue: 10];
    [_rightPercentSlider setTag: 2];
    [_rightPercentSlider addTarget: self action: @selector(sliderChanged:) forControlEvents: UIControlEventValueChanged];
    [_rightPercentSlider setHidden: YES];
    
    [[self view] addSubview: _rightPercentSlider];
    
    _rightInfoLabel = [[UILabel alloc] initWithFrame: CGRectMake(rightInset, CGRectGetMaxY([_rightPercentSlider frame]) + 5, playerWidth, 50)];
    [_rightInfoLabel setBackgroundColor: [UIColor clearColor]];
    [_rightInfoLabel setFont: [UIFont systemFontOfSize: 14]];
    [_rightInfoLabel setNumberOfLines: 3];
    [_rightInfoLabel setLineBreakMode: UILineBreakModeWordWrap];
    [_rightInfoLabel setTextAlignment: UITextAlignmentLeft];
    [_rightInfoLabel setTextColor: [UIColor whiteColor]];
    [_rightInfoLabel setHidden: YES];
    
    [[self view] addSubview: _rightInfoLabel];
}


- (void) viewDidLoad
{
    [super viewDidLoad];
}


- (void) viewDidUnload
{
    [super viewDidUnload];
    
    [_leftTextField release];
    [_rightTextField release];
    
    [_leftPlayerType release];
    [_rightPlayerType release];
    
    [_leftPercentHeader release];
    [_rightPercentHeader release];
    
    [_leftPercentLabel release];
    [_rightPercentLabel release];
    
    [_leftPercentSlider release];
    [_rightPercentSlider release];
    
    [_leftInfoLabel release];
    [_rightInfoLabel release];
}

@end

//
//  GCValuesPanelController.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/10/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCValuesPanelController.h"

#import "GCValuesHelpViewController.h"

@implementation GCValuesPanelController

@synthesize delegate = _delegate;

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
    return @"Values & Predictions";
}


- (void) drawerWillAppear
{
    [_predictionsSwitch setOn: [_delegate isShowingPredictions]];
 
    if ([_game respondsToSelector: @selector(isShowingMoveValues)] && [_game respondsToSelector: @selector(setShowingMoveValues:)])
    {
        [_moveValueSwitch setOn: [_game isShowingMoveValues]];
        [_moveValueSwitch setEnabled: YES];
        [_moveValueLabel setEnabled: YES];
    }
    else
    {
        [_moveValueSwitch setOn: NO];
        [_moveValueSwitch setEnabled: NO];
        [_moveValueLabel setEnabled: NO];
    }
    
    
    if ([_moveValueSwitch isOn])
    {
        [_deltaRemotenessLabel setEnabled: YES];
        [_deltaRemotenessSwitch setEnabled: YES];
    }
    else
    {
        [_deltaRemotenessLabel setEnabled: NO];
        [_deltaRemotenessSwitch setEnabled: NO];
    }
    
    
    if ([_game respondsToSelector: @selector(isShowingDeltaRemoteness)] && [_game respondsToSelector: @selector(setShowingDeltaRemoteness:)])
    {
        [_deltaRemotenessSwitch setOn: [_game isShowingDeltaRemoteness]];
        [_deltaRemotenessSwitch setEnabled: YES];
    }
    else
    {
        [_deltaRemotenessSwitch setOn: NO];
        [_deltaRemotenessSwitch setEnabled: NO];
    }
}


- (void) saveButtonTapped
{
    [_delegate setShowingPredictions: [_predictionsSwitch isOn]];
    
    if ([_game respondsToSelector: @selector(setShowingMoveValues:)])
        [_game setShowingMoveValues: [_moveValueSwitch isOn]];
    
    if ([_game respondsToSelector: @selector(setShowingDeltaRemoteness:)])
    {
        if ([_moveValueSwitch isOn])
            [_game setShowingDeltaRemoteness: [_deltaRemotenessSwitch isOn]];
        else
            [_game setShowingDeltaRemoteness: NO];
    }
}


#pragma mark -

- (void) switchChanged: (UISwitch *) sender
{
    if ([sender isOn] && [_game respondsToSelector: @selector(isShowingDeltaRemoteness)] && [_game respondsToSelector: @selector(setShowingDeltaRemoteness:)])
    {
        [_deltaRemotenessLabel setEnabled: YES];
        [_deltaRemotenessSwitch setEnabled: YES];
    }
    else
    {
        [_deltaRemotenessLabel setEnabled: NO];
        [_deltaRemotenessSwitch setEnabled: NO];
    }
}


- (void) helpButtonTapped: (UIButton *) sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [_helpPopoverController presentPopoverFromRect: [sender frame] inView: self.view permittedArrowDirections: UIPopoverArrowDirectionLeft animated: YES];
    }
    else
    {
        GCValuesHelpViewController *helpController = [[GCValuesHelpViewController alloc] initWithNibName: @"GCValuesHelpView" bundle: nil];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: helpController];
        [helpController release];
        
        [_delegate presentViewController: nav];
        [nav release];
    }
}


#pragma mark - View lifecycle

- (void) loadView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self setView: [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 360, 280 - 32)] autorelease]];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self setView: [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 360, 250 - 44)] autorelease]];
    
    
    CGFloat width  = [[self view] bounds].size.width;
    CGFloat height = [[self view] bounds].size.height;
    
    UILabel *predictionsLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 20, width - 40, 25)];
    [predictionsLabel setBackgroundColor: [UIColor clearColor]];
    [predictionsLabel setTextColor: [UIColor whiteColor]];
    [predictionsLabel setFont: [UIFont boldSystemFontOfSize: 20]];
    [predictionsLabel setText: @"Show Predictions"];
    
    [[self view] addSubview: predictionsLabel];
    [predictionsLabel release];
    
    
    _predictionsSwitch = [[UISwitch alloc] init];
    [_predictionsSwitch setCenter: CGPointMake(width - 20 - [_predictionsSwitch frame].size.width / 2.0f, 20 + (25 / 2.0f))];
    
    [[self view] addSubview: _predictionsSwitch];
    
    
    
    _moveValueLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 80, width - 40, 25)];
    [_moveValueLabel setBackgroundColor: [UIColor clearColor]];
    [_moveValueLabel setTextColor: [UIColor whiteColor]];
    [_moveValueLabel setFont: [UIFont boldSystemFontOfSize: 20]];
    [_moveValueLabel setText: @"Show Move Values"];
    
    [[self view] addSubview: _moveValueLabel];
    
    
    _moveValueSwitch = [[UISwitch alloc] init];
    [_moveValueSwitch setCenter: CGPointMake(width - 20 - [_moveValueSwitch frame].size.width / 2.0f, 80 + (25 / 2.0f))];
    [_moveValueSwitch addTarget: self action: @selector(switchChanged:) forControlEvents: UIControlEventValueChanged];
    
    [[self view] addSubview: _moveValueSwitch];
    
    
    
    _deltaRemotenessLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 140, width - 40, 25)];
    [_deltaRemotenessLabel setBackgroundColor: [UIColor clearColor]];
    [_deltaRemotenessLabel setTextColor: [UIColor whiteColor]];
    [_deltaRemotenessLabel setFont: [UIFont boldSystemFontOfSize: 20]];
    [_deltaRemotenessLabel setText: @"Show Delta Remoteness"];
    [_deltaRemotenessLabel setEnabled: NO];
    
    [[self view] addSubview: _deltaRemotenessLabel];
    
    
    _deltaRemotenessSwitch = [[UISwitch alloc] init];
    [_deltaRemotenessSwitch setCenter: CGPointMake(width - 20 - [_deltaRemotenessSwitch frame].size.width / 2.0f, 140 + (25 / 2.0f))];
    [_deltaRemotenessSwitch setEnabled: NO];
    
    [[self view] addSubview: _deltaRemotenessSwitch];
    
    
    UIButton *infoButton = [UIButton buttonWithType: UIButtonTypeCustom];
    NSString *titleText = @"What do these mean?";
    CGSize textSize = [titleText sizeWithFont: [UIFont systemFontOfSize: 14]];
    [infoButton setTitle: titleText forState: UIControlStateNormal];
    [[infoButton titleLabel] setFont: [UIFont systemFontOfSize: 14]];
    [infoButton setFrame: CGRectMake(width - 10 - textSize.width, height - 10 - textSize.height, textSize.width, textSize.height)];
    [infoButton setShowsTouchWhenHighlighted: YES];
    [infoButton addTarget: self action: @selector(helpButtonTapped:) forControlEvents: UIControlEventTouchUpInside];
    [[self view] addSubview: infoButton];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIViewController *dummy = [[UIViewController alloc] initWithNibName: @"GCValuesHelpView" bundle: nil];
        _helpPopoverController = [[UIPopoverController alloc] initWithContentViewController: dummy];
        [_helpPopoverController setPopoverContentSize: CGSizeMake(480, 288)];
        [dummy release];
    }
}


- (void) viewDidUnload
{
    [super viewDidUnload];
    
    [_deltaRemotenessLabel release];
    [_moveValueLabel release];
    
    [_predictionsSwitch release];
    [_moveValueSwitch release];
    [_deltaRemotenessSwitch release];
    
    [_helpPopoverController release];
}

@end

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

@synthesize delegate;

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
    [predictionsSwitch setOn: [delegate isShowingPredictions]];
 
    if ([game respondsToSelector: @selector(isShowingMoveValues)] && [game respondsToSelector: @selector(setShowingMoveValues:)])
    {
        [moveValueSwitch setOn: [game isShowingMoveValues]];
        [moveValueSwitch setEnabled: YES];
        [moveValueLabel setEnabled: YES];
    }
    else
    {
        [moveValueSwitch setOn: NO];
        [moveValueSwitch setEnabled: NO];
        [moveValueLabel setEnabled: NO];
    }
    
    
    if ([game respondsToSelector: @selector(isShowingDeltaRemoteness)] && [game respondsToSelector: @selector(setShowingDeltaRemoteness:)])
    {
        [deltaRemotenessSwitch setOn: [game isShowingDeltaRemoteness]];
        [deltaRemotenessSwitch setEnabled: YES];
    }
    else
    {
        [deltaRemotenessSwitch setOn: NO];
        [deltaRemotenessSwitch setEnabled: NO];
    }
    
    
    if ([moveValueSwitch isOn])
    {
        [deltaRemotenessLabel setEnabled: YES];
        [deltaRemotenessSwitch setEnabled: YES];
    }
    else
    {
        [deltaRemotenessLabel setEnabled: NO];
        [deltaRemotenessSwitch setEnabled: NO];
    }
}


- (void) saveButtonTapped
{
    [delegate setShowingPredictions: [predictionsSwitch isOn]];
    
    if ([game respondsToSelector: @selector(setShowingMoveValues:)])
        [game setShowingMoveValues: [moveValueSwitch isOn]];
    
    if ([game respondsToSelector: @selector(setShowingDeltaRemoteness:)])
    {
        if ([moveValueSwitch isOn])
            [game setShowingDeltaRemoteness: [deltaRemotenessSwitch isOn]];
        else
            [game setShowingDeltaRemoteness: NO];
    }
}


#pragma mark -

- (void) switchChanged: (UISwitch *) sender
{
    if ([sender isOn] && [game respondsToSelector: @selector(isShowingDeltaRemoteness)] && [game respondsToSelector: @selector(setShowingDeltaRemoteness:)])
    {
        [deltaRemotenessLabel setEnabled: YES];
        [deltaRemotenessSwitch setEnabled: YES];
    }
    else
    {
        [deltaRemotenessLabel setEnabled: NO];
        [deltaRemotenessSwitch setEnabled: NO];
    }
}


- (void) helpButtonTapped: (UIButton *) sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [helpPopover presentPopoverFromRect: [sender frame] inView: self.view permittedArrowDirections: UIPopoverArrowDirectionLeft animated: YES];
    }
    else
    {
        GCValuesHelpViewController *helpController = [[GCValuesHelpViewController alloc] initWithNibName: @"GCValuesHelpView" bundle: nil];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: helpController];
        [helpController release];
        
        [delegate presentViewController: nav];
        [nav release];
    }
}


#pragma mark - View lifecycle

- (void) loadView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.view = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 360, 280 - 32)] autorelease];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.view = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 360, 250 - 44)] autorelease];
    
    
    CGFloat width  = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    
    UILabel *predictionsLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 20, width - 40, 25)];
    [predictionsLabel setBackgroundColor: [UIColor clearColor]];
    [predictionsLabel setTextColor: [UIColor whiteColor]];
    [predictionsLabel setFont: [UIFont boldSystemFontOfSize: 20]];
    [predictionsLabel setText: @"Show Predictions"];
    
    [self.view addSubview: predictionsLabel];
    [predictionsLabel release];
    
    
    predictionsSwitch = [[UISwitch alloc] init];
    predictionsSwitch.center = CGPointMake(width - 20 - predictionsSwitch.frame.size.width / 2.0f, 20 + (25 / 2.0f));
    
    [self.view addSubview: predictionsSwitch];
    
    
    
    moveValueLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 80, width - 40, 25)];
    [moveValueLabel setBackgroundColor: [UIColor clearColor]];
    [moveValueLabel setTextColor: [UIColor whiteColor]];
    [moveValueLabel setFont: [UIFont boldSystemFontOfSize: 20]];
    [moveValueLabel setText: @"Show Move Values"];
    
    [self.view addSubview: moveValueLabel];
    
    
    moveValueSwitch = [[UISwitch alloc] init];
    moveValueSwitch.center = CGPointMake(width - 20 - moveValueSwitch.frame.size.width / 2.0f, 80 + (25 / 2.0f));
    [moveValueSwitch addTarget: self action: @selector(switchChanged:) forControlEvents: UIControlEventValueChanged];
    
    [self.view addSubview: moveValueSwitch];
    
    
    
    deltaRemotenessLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 140, width - 40, 25)];
    [deltaRemotenessLabel setBackgroundColor: [UIColor clearColor]];
    [deltaRemotenessLabel setTextColor: [UIColor whiteColor]];
    [deltaRemotenessLabel setFont: [UIFont boldSystemFontOfSize: 20]];
    [deltaRemotenessLabel setText: @"Show Delta Remoteness"];
    [deltaRemotenessLabel setEnabled: NO];
    
    [self.view addSubview: deltaRemotenessLabel];
    
    
    deltaRemotenessSwitch = [[UISwitch alloc] init];
    [deltaRemotenessSwitch setCenter: CGPointMake(width - 20 - deltaRemotenessSwitch.frame.size.width / 2.0f, 140 + (25 / 2.0f))];
    [deltaRemotenessSwitch setEnabled: NO];
    
    [self.view addSubview: deltaRemotenessSwitch];
    
    
    UIButton *infoButton = [UIButton buttonWithType: UIButtonTypeCustom];
    NSString *titleText = @"What do these mean?";
    CGSize textSize = [titleText sizeWithFont: [UIFont systemFontOfSize: 14]];
    [infoButton setTitle: titleText forState: UIControlStateNormal];
    [[infoButton titleLabel] setFont: [UIFont systemFontOfSize: 14]];
    [infoButton setFrame: CGRectMake(width - 10 - textSize.width, height - 10 - textSize.height, textSize.width, textSize.height)];
    [infoButton setShowsTouchWhenHighlighted: YES];
    [infoButton addTarget: self action: @selector(helpButtonTapped:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: infoButton];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIViewController *dummy = [[UIViewController alloc] initWithNibName: @"GCValuesHelpView" bundle: nil];
        helpPopover = [[UIPopoverController alloc] initWithContentViewController: dummy];
        [helpPopover setPopoverContentSize: CGSizeMake(480, 288)];
        [dummy release];
    }
}


- (void) viewDidUnload
{
    [super viewDidUnload];
    
    [deltaRemotenessLabel release];
    [moveValueLabel release];
    
    [predictionsSwitch release];
    [moveValueSwitch release];
    [deltaRemotenessSwitch release];
    
    [helpPopover release];
}

@end

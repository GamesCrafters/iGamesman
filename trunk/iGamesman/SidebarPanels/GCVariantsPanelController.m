//
//  GCVariantsPanelController.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 3/12/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCVariantsPanelController.h"

#import "GCPlayer.h"

@implementation GCVariantsPanelController

@synthesize delegate = _delegate;

- (id) initWithGame: (id<GCGame>) game
{
    self = [super init];
    
    if (self)
    {
        _game = game;
    }
    
    return self;
}

#pragma mark - GCModalDrawerPanelDelegate

- (BOOL) wantsSaveButton
{
    return YES;
}


- (BOOL) wantsDoneButton
{
    return NO;
}


- (BOOL) wantsCancelButton
{
    return YES;
}


- (NSString *) title
{
    return @"Game Variants";
}


- (void) drawerWillAppear
{
    if ([_game respondsToSelector: @selector(isMisere)])
    {
        [_misereLabel setEnabled: YES];
        [_misereSwitch setEnabled: YES];
        [_misereSwitch setOn: [_game isMisere]];
    }
    else
    {
        [_misereLabel setEnabled: NO];
        [_misereSwitch setEnabled: NO];
        [_misereSwitch setOn: NO];
    }
}


- (void) saveButtonTapped
{
    NSString *message = @"Changing game variants will restart the game. All progress in the current game will be lost! Are you sure you want to change variants?";
    UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle: @"Change Variants"
                                                        message: message
                                                       delegate: self
                                              cancelButtonTitle: @"Cancel"
                                              otherButtonTitles: @"OK", nil];
    [infoAlert show];
    [infoAlert release];
}


- (BOOL) drawerShouldClose
{
    return NO;
}


#pragma mark - UIAlertViewDelegate

- (void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex
{
    /* OK button */
    if (buttonIndex == 1)
    {
        [_delegate closeDrawer];
    }
}


#pragma mark - View lifecycle

- (void) loadView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self setView: [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 460, 280 - 32)] autorelease]];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self setView: [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 460, 480 - 44)] autorelease]];
    
    
    CGFloat width  = self.view.bounds.size.width;
    
    _misereLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 20, width - 40, 25)];
    [_misereLabel setBackgroundColor: [UIColor clearColor]];
    [_misereLabel setTextColor: [UIColor whiteColor]];
    [_misereLabel setFont: [UIFont boldSystemFontOfSize: 20]];
    [_misereLabel setText: @"Misère"];
    
    [self.view addSubview: _misereLabel];
    
    
    _misereSwitch = [[UISwitch alloc] init];
    [_misereSwitch setCenter: CGPointMake(width - 20 - _misereSwitch.frame.size.width / 2.0f, 20 + (25 / 2.0f))];
    
    [self.view addSubview: _misereSwitch];
}


- (void) viewDidUnload
{
    [super viewDidUnload];
    
    [_misereLabel release];
    [_misereSwitch release];
}

@end

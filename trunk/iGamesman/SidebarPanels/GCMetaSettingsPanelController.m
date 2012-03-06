//
//  GCMetaSettingsPanelController.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/15/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCMetaSettingsPanelController.h"

#define GC_SIDE_INSET (20)


@implementation GCMetaSettingsPanelController

- (void) setDelegate: (id<GCMetaSettingsPanelDelegate>) _delegate
{
    delegate = _delegate;
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
    return @"Game Play Settings";
}


- (void) saveButtonTapped
{
    [delegate setComputerMoveDelay: [moveDelaySlider value]];
    [delegate setComputerGameDelay: [gameDelaySlider value]];
}


- (void) drawerWillAppear
{
    [moveDelaySlider setValue: [delegate computerMoveDelay]];
    [gameDelaySlider setValue: [delegate computerGameDelay]];
    
    [moveDelayLabel setText: [NSString stringWithFormat: @"Computer Move Delay: %.2fs", [moveDelaySlider value]]];
    [gameDelayLabel setText: [NSString stringWithFormat: @"Computer/Computer Game Delay: %.2fs", [gameDelaySlider value]]];
}


#pragma mark -

- (void) sliderValueChanged: (UISlider *) sender
{
    CGFloat value = [sender value];
    value = round(value * 10) / 10;
    [sender setValue: value];
    
    if (sender == moveDelaySlider)
    {
        [moveDelayLabel setText: [NSString stringWithFormat: @"Computer Move Delay: %.2fs", [moveDelaySlider value]]];
    }
    else if (sender == gameDelaySlider)
    {
        [gameDelayLabel setText: [NSString stringWithFormat: @"Computer/Computer Game Delay: %.2fs", [gameDelaySlider value]]];
    }
}


#pragma mark - View lifecycle

- (void) loadView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.view = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 360, 280 - 32)] autorelease];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.view = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 360, 240 - 44)] autorelease];
    
    
    CGFloat width  = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    
    moveDelayLabel = [[UILabel alloc] initWithFrame: CGRectMake(GC_SIDE_INSET, GC_SIDE_INSET, width - 2 * GC_SIDE_INSET, 25)];
    [self.view addSubview: moveDelayLabel];
    
    moveDelaySlider = [[UISlider alloc] initWithFrame: CGRectMake(GC_SIDE_INSET, GC_SIDE_INSET + 25, width - 2 * GC_SIDE_INSET, 25)];
    [self.view addSubview: moveDelaySlider];
    
    
    gameDelayLabel = [[UILabel alloc] initWithFrame: CGRectMake(GC_SIDE_INSET, height / 2.0f, width - 2 * GC_SIDE_INSET, 25)];
    [self.view addSubview: gameDelayLabel];
    
    gameDelaySlider = [[UISlider alloc] initWithFrame: CGRectMake(GC_SIDE_INSET, height / 2.0f + 25, width - 2 * GC_SIDE_INSET, 25)];
    [self.view addSubview: gameDelaySlider];
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [moveDelayLabel setBackgroundColor: [UIColor clearColor]];
    [moveDelayLabel setTextColor: [UIColor whiteColor]];
    
    [gameDelayLabel setBackgroundColor: [UIColor clearColor]];
    [gameDelayLabel setTextColor: [UIColor whiteColor]];
    
    [moveDelaySlider setMinimumValue: 0.0f];
    [moveDelaySlider setMaximumValue: 2.0f];
    [moveDelaySlider addTarget: self action: @selector(sliderValueChanged:) forControlEvents: UIControlEventValueChanged];
    
    [gameDelaySlider setMinimumValue: 0.0f];
    [gameDelaySlider setMaximumValue: 2.0f];
    [gameDelaySlider addTarget: self action: @selector(sliderValueChanged:) forControlEvents: UIControlEventValueChanged];
}


- (void) viewDidUnload
{
    [super viewDidUnload];
    
    [moveDelayLabel release];
    [moveDelaySlider release];
    
    [gameDelayLabel release];
    [gameDelaySlider release];
}

@end

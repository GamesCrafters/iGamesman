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
}


- (void) drawerWillAppear
{
    [moveDelaySlider setValue: [delegate computerMoveDelay]];
    [gameDelaySlider setValue: [delegate computerGameDelay]];
    
    [moveDelayLabel setText: [NSString stringWithFormat: @"Computer Move Delay: %.2fs", [moveDelaySlider value]]];
    [gameDelayLabel setText: [NSString stringWithFormat: @"Computer/Computer Game Delay: %.2fs", [gameDelaySlider value]]];
    [animationSpeedLabel setText: [NSString stringWithFormat: @"Animation Speed: %.2fs", [animationSpeedSlider value]]];
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
    else if (sender == animationSpeedSlider)
    {
        [animationSpeedLabel setText: [NSString stringWithFormat: @"Animation Speed: %.2fs", [animationSpeedSlider value]]];
    }
}


#pragma mark - View lifecycle

- (void) loadView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.view = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 360, 280 - 32)] autorelease];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.view = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 360, 280 - 44)] autorelease];
    
    
    CGFloat width  = self.view.bounds.size.width;
    
    moveDelayLabel = [[UILabel alloc] initWithFrame: CGRectMake(GC_SIDE_INSET, 0, width - 2 * GC_SIDE_INSET, 25)];
    [self.view addSubview: moveDelayLabel];
    
    moveDelaySlider = [[UISlider alloc] initWithFrame: CGRectMake(GC_SIDE_INSET, 25, width - 2 * GC_SIDE_INSET, 25)];
    [self.view addSubview: moveDelaySlider];
    
    
    gameDelayLabel = [[UILabel alloc] initWithFrame: CGRectMake(GC_SIDE_INSET, 50, width - 2 * GC_SIDE_INSET, 25)];
    [self.view addSubview: gameDelayLabel];
    
    gameDelaySlider = [[UISlider alloc] initWithFrame: CGRectMake(GC_SIDE_INSET, 75, width - 2 * GC_SIDE_INSET, 25)];
    [self.view addSubview: gameDelaySlider];
    
    
    animationSpeedLabel = [[UILabel alloc] initWithFrame: CGRectMake(GC_SIDE_INSET, 100, width - 2 * GC_SIDE_INSET, 25)];
    [self.view addSubview: animationSpeedLabel];
    
    animationSpeedSlider = [[UISlider alloc] initWithFrame: CGRectMake(GC_SIDE_INSET, 125, width - 2 * GC_SIDE_INSET, 25)];
    [self.view addSubview: animationSpeedSlider];
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [moveDelayLabel setBackgroundColor: [UIColor clearColor]];
    [moveDelayLabel setTextColor: [UIColor whiteColor]];
    
    [gameDelayLabel setBackgroundColor: [UIColor clearColor]];
    [gameDelayLabel setTextColor: [UIColor whiteColor]];
    
    [animationSpeedLabel setBackgroundColor: [UIColor clearColor]];
    [animationSpeedLabel setTextColor: [UIColor whiteColor]];
    
    [moveDelaySlider setMinimumValue: 0.0f];
    [moveDelaySlider setMaximumValue: 2.0f];
    [moveDelaySlider addTarget: self action: @selector(sliderValueChanged:) forControlEvents: UIControlEventValueChanged];
    
    [gameDelaySlider setMinimumValue: 0.0f];
    [gameDelaySlider setMaximumValue: 2.0f];
    [gameDelaySlider addTarget: self action: @selector(sliderValueChanged:) forControlEvents: UIControlEventValueChanged];
    
    [animationSpeedSlider addTarget: self action: @selector(sliderValueChanged:) forControlEvents: UIControlEventValueChanged];
}


- (void) viewDidUnload
{
    [super viewDidUnload];
    
    [moveDelayLabel release];
    [moveDelaySlider release];
    
    [gameDelayLabel release];
    [gameDelaySlider release];
    
    [animationSpeedLabel release];
    [animationSpeedSlider release];
}

@end

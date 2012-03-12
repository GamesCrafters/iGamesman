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

- (void) setDelegate: (id<GCMetaSettingsPanelDelegate>) delegate
{
    _delegate = delegate;
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
    [_delegate setComputerMoveDelay: [_moveDelaySlider value]];
    [_delegate setComputerGameDelay: [_gameDelaySlider value]];
}


- (void) drawerWillAppear
{
    [_moveDelaySlider setValue: [_delegate computerMoveDelay]];
    [_gameDelaySlider setValue: [_delegate computerGameDelay]];
    
    [_moveDelayLabel setText: [NSString stringWithFormat: @"Computer Move Delay: %.2fs", [_moveDelaySlider value]]];
    [_gameDelayLabel setText: [NSString stringWithFormat: @"Computer/Computer Game Delay: %.2fs", [_gameDelaySlider value]]];
}


#pragma mark -

- (void) sliderValueChanged: (UISlider *) sender
{
    CGFloat value = [sender value];
    value = round(value * 10) / 10;
    [sender setValue: value];
    
    if (sender == _moveDelaySlider)
    {
        [_moveDelayLabel setText: [NSString stringWithFormat: @"Computer Move Delay: %.2fs", [_moveDelaySlider value]]];
    }
    else if (sender == _gameDelaySlider)
    {
        [_gameDelayLabel setText: [NSString stringWithFormat: @"Computer/Computer Game Delay: %.2fs", [_gameDelaySlider value]]];
    }
}


#pragma mark - View lifecycle

- (void) loadView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self setView: [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 360, 280 - 32)] autorelease]];
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self setView: [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 360, 240 - 44)] autorelease]];
    
    
    CGFloat width  = [[self view] bounds].size.width;
    CGFloat height = [[self view] bounds].size.height;
    
    _moveDelayLabel = [[UILabel alloc] initWithFrame: CGRectMake(GC_SIDE_INSET, GC_SIDE_INSET, width - 2 * GC_SIDE_INSET, 25)];
    [[self view] addSubview: _moveDelayLabel];
    
    _moveDelaySlider = [[UISlider alloc] initWithFrame: CGRectMake(GC_SIDE_INSET, GC_SIDE_INSET + 25, width - 2 * GC_SIDE_INSET, 25)];
    [[self view] addSubview: _moveDelaySlider];
    
    
    _gameDelayLabel = [[UILabel alloc] initWithFrame: CGRectMake(GC_SIDE_INSET, height / 2.0f, width - 2 * GC_SIDE_INSET, 25)];
    [[self view] addSubview: _gameDelayLabel];
    
    _gameDelaySlider = [[UISlider alloc] initWithFrame: CGRectMake(GC_SIDE_INSET, height / 2.0f + 25, width - 2 * GC_SIDE_INSET, 25)];
    [[self view] addSubview: _gameDelaySlider];
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [_moveDelayLabel setBackgroundColor: [UIColor clearColor]];
    [_moveDelayLabel setTextColor: [UIColor whiteColor]];
    
    [_gameDelayLabel setBackgroundColor: [UIColor clearColor]];
    [_gameDelayLabel setTextColor: [UIColor whiteColor]];
    
    [_moveDelaySlider setMinimumValue: 0.0f];
    [_moveDelaySlider setMaximumValue: 2.0f];
    [_moveDelaySlider addTarget: self action: @selector(sliderValueChanged:) forControlEvents: UIControlEventValueChanged];
    
    [_gameDelaySlider setMinimumValue: 0.0f];
    [_gameDelaySlider setMaximumValue: 2.0f];
    [_gameDelaySlider addTarget: self action: @selector(sliderValueChanged:) forControlEvents: UIControlEventValueChanged];
}


- (void) viewDidUnload
{
    [super viewDidUnload];
    
    [_moveDelayLabel release];
    [_moveDelaySlider release];
    
    [_gameDelayLabel release];
    [_gameDelaySlider release];
}

@end

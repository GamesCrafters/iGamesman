//
//  GCVVHPanelController.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/15/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCVVHPanelController.h"

#import "GCVVHView.h"

@implementation GCVVHPanelController

- (id) initWithDataSource: (id<GCVVHViewDataSource>) dataSource
{
    self = [super init];
    
    if (self)
    {
        _dataSource = dataSource;
    }
    
    return self;
}


#pragma mark - GCModalDrawerPanelDelegate

- (BOOL) wantsSaveButton
{
    return NO;
}


- (BOOL) wantsDoneButton
{
    return YES;
}


- (BOOL) wantsCancelButton
{
    return NO;
}

- (NSString *) title
{
    return @"Visual Value History";
}


- (void) drawerWillAppear
{
    [_vvh setNeedsDisplay];
}


#pragma mark - View lifecycle

- (void) loadView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self setView: [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 460, 280 - 32)] autorelease]];
    
    _vvh = [[GCVVHView alloc] initWithFrame: [[self view] bounds]];
    [_vvh setDataSource: _dataSource];
    [[self view] addSubview: _vvh];
}


- (void) viewDidUnload
{
    [super viewDidUnload];
    
    [_vvh release];
}

@end

//
//  GCMessageOverlayView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/10/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCMessageOverlayView.h"

@implementation GCMessageOverlayView

#pragma mark - Memory lifecycle

- (id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        [self setOpaque: NO];
        [self setExclusiveTouch: NO];
        
        [self setAlpha: 0];
        
        
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
        [_spinner setCenter: [self center]];
        
        [self addSubview: _spinner];
    }
    
    return self;
}


- (void) dealloc
{
    [_spinner release];
    
    [super dealloc];
}


#pragma mark - Factory method

+ (GCMessageOverlayView *) sharedOverlayView
{
    static GCMessageOverlayView *sharedOverlayView = nil;
    
    if (sharedOverlayView)
        return sharedOverlayView;
    
    sharedOverlayView = [[GCMessageOverlayView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    return sharedOverlayView;
}


#pragma mark -

- (void) beginLoadingWithMessage: (NSString *) message
{
    [self setAlpha: 1];
    [_spinner startAnimating];
}


- (void) finishingLoading
{
    [self setAlpha: 0];
    [_spinner stopAnimating];
}

@end

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
        self.opaque = NO;
        self.exclusiveTouch = NO;
        
        [self setAlpha: 0];
        
        
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
        [spinner setCenter: [self center]];
        
        [self addSubview: spinner];
    }
    
    return self;
}


- (void) dealloc
{
    [spinner release];
    
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
    [spinner startAnimating];
}


- (void) finishingLoading
{
    [self setAlpha: 0];
    [spinner stopAnimating];
}

@end

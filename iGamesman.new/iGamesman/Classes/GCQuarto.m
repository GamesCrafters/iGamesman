//
//  GCQuarto.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 10/3/11.
//  Copyright 2011 GamesCrafters. All rights reserved.
//

#import "GCQuarto.h"

#import "GCQuartoPosition.h"
#import "GCQuartoView.h"


@implementation GCQuarto

#pragma mark -
#pragma mark Memory lifecycle

- (id) init
{
    self = [super init];
    
    if (self)
    {
        board = [[GCQuartoPosition alloc] init];
    }
    
    return self;
}


- (void) dealloc
{
    [board release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark GCGame protocol

- (UIView *) viewWithFrame: (CGRect) frame
{
    return [[[GCQuartoView alloc] initWithFrame: frame] autorelease];
}

@end

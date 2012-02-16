//
//  GCPlayer.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/10/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCPlayer.h"

@implementation GCPlayer

@synthesize name;
@synthesize epithet;
@synthesize type;
@synthesize percentPerfect;


- (void) dealloc
{
    [name release];
    [epithet release];
    
    [super dealloc];
}


@end

//
//  GCPlayer.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/10/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCPlayer.h"

@implementation GCPlayer

@synthesize name = _name;
@synthesize epithet = _epithet;
@synthesize type = _type;
@synthesize percentPerfect = _percentPerfect;


- (void) dealloc
{
    [_name release];
    [_epithet release];
    
    [super dealloc];
}


@end

//
//  GCConnectFourPosition.m
//  iGamesman
//
//  Created by Jordan Salter on 05/10/2011.
//  Copyright 2011 GamesCrafters. All rights reserved.
//

#import "GCConnectFourPosition.h"

#define BLANK @"+"

@implementation GCConnectFourPosition

@synthesize p1Turn = _p1Turn, board = _board;

- (id)initWithWidth:(int)width height:(int)height
{
    self = [super init];
    if (self) {
        _p1Turn = YES;
		_board = [[NSMutableArray alloc] initWithCapacity: width * height];
		for (int i = 0; i < width * height; i += 1)
			[_board addObject: BLANK];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    GCConnectFourPosition *copy = [[GCConnectFourPosition allocWithZone:zone] init];
    copy.p1Turn = _p1Turn;
    copy.board = [_board copy];
    return copy;
}



@end

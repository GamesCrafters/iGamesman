//
//  GCConnections.m
//  iGamesman
//
//  Created by Ian Ackerman on 07/10/11.
//  Copyright 2011 Gamescrafters. All rights reserved.
//

#import "GCConnections.h"

#define BLANK @"+"
#define X @"X"
#define XCON @"x"
#define O @"O"
#define OCON @"o"

@implementation GCConnections

@synthesize size;
@synthesize p1Turn;
@synthesize misere;
@synthesize predictions, moveValues;
@synthesize circling;

- (id) init {
	if (self = [super init]) {
		player1Name = @"Player 1"; //Use GCPlayer?
		player2Name = @"Player 2";
		
		size = 7;
		misere = NO;
		circling = NO;
		
		board = [[NSMutableArray alloc] initWithCapacity: size * size];
		for (int j = 0; j < size; j += 1) {
			for (int i = 0; i < size; i += 1) {
				if(i % 2 == j % 2){
					[board addObject:BLANK];
				}
				else if(i % 2 == 0){
					[board addObject: OCON];
				}
				else {
					[board addObject: XCON];
				}
			}
		}
	}
	
	return self;
}

- (Position) doMove: (Move) move {
	//(void) doMove: (NSNumber *) move {
	//[conView doMove: move];
		
	int slot = [move integerValue] - 1;
	[board replaceObjectAtIndex: slot withObject: (p1Turn ? X : O)];
	p1Turn = !p1Turn;
}



@end

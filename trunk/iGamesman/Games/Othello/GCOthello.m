//
//  GCOthello.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/21/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCOthello.h"

#import "GCOthelloPosition.h"
#import "GCPlayer.h"


#define PASS @"PASS"


@implementation GCOthello

#pragma mark - Memory lifecycle

- (id) init
{
    self = [super init];
    
    if (self)
    {
        position = nil;
        
        leftPlayer = nil;
        rightPlayer = nil;
        
        othelloView = nil;
    }
    
    return self;
}


- (void) dealloc
{
    [leftPlayer release];
    [rightPlayer release];
    
    [othelloView release];
    
    [super dealloc];
}


#pragma mark -

- (BOOL) isOutOfBounds: (int) loc offset: (int) offset
{
    int rows = position.rows;
    int cols = position.columns;
    
	if ((loc < 0) || (loc >= rows * cols))
    {
		return YES;
	}
    
	if ((offset == -1 || offset == -cols - 1 || offset == cols - 1) && (loc % cols == cols - 1))
    {
		return YES;
	}
    
	if ((offset == 1 || offset == cols + 1 || offset== -cols + 1) && (loc % cols == 0))
    {
		return YES;
	}
    
	return NO;
}


- (NSArray *) getFlips: (int) loc
{
    int rows = position.rows;
    int cols = position.columns;
	NSMutableArray *flips = [[NSMutableArray alloc] initWithCapacity: rows * cols];
	if ([[position.board objectAtIndex: loc] isEqualToString: GCOthelloBlankPiece])
    {
		NSString *myPiece = position.leftTurn ? GCOthelloBlackPiece : GCOthelloWhitePiece;
		int offsets[8] = {1, -1, cols, -cols, cols + 1, cols - 1, -cols + 1, -cols - 1};
		for (int i = 0; i < 8; i += 1)
        {
			int offset = offsets[i];
			NSMutableArray *tempFlips = [[NSMutableArray alloc] initWithCapacity: rows * cols];
			int tempLoc = loc;
			while (YES)
            {
				tempLoc += offset;
				if ([self isOutOfBounds: tempLoc offset: offset])
                    break;
				if ([[position.board objectAtIndex: tempLoc] isEqualToString: GCOthelloBlankPiece])
                    break; 
				if ([[position.board objectAtIndex: tempLoc] isEqualToString: myPiece])
                {
					[flips addObjectsFromArray: tempFlips];
					break;
				}
                
				[tempFlips addObject: [NSNumber numberWithInt: tempLoc]];
			}
		}
	}
	return [flips autorelease];
}


#pragma mark - UIAlertViewDelegate

- (void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex
{
	moveHandler([NSNumber numberWithInt: -1]);
}


#pragma mark - GCGame protocol

- (NSString *) name
{
    return @"Othello";
}


- (UIView *) viewWithFrame: (CGRect) frame center: (CGPoint) center
{
    if (othelloView)
        [othelloView release];
    
    othelloView = [[GCOthelloView alloc] initWithFrame: frame];
    [othelloView setDelegate: self];
    [othelloView setBackgroundCenter: center];
    return othelloView;
}


- (void) startGameWithLeft: (GCPlayer *) left right: (GCPlayer *) right
{
    [left retain];
    [right retain];
    
    if (leftPlayer)
        [leftPlayer release];
    if (rightPlayer)
        [rightPlayer release];
    
    leftPlayer = left;
    rightPlayer = right;
    
    [leftPlayer setEpithet: @"Black"];
    [rightPlayer setEpithet: @"White"];
    
    if (position)
        [position release];
    
    position = [[GCOthelloPosition alloc] initWithWidth: 8 height: 8];
    position.leftTurn = YES;
    
    int col = position.columns / 2 - 1;
    int row = position.rows / 2 - 1;
    [position.board replaceObjectAtIndex: col + row * position.columns withObject: GCOthelloBlackPiece];
    [position.board replaceObjectAtIndex: 1 + col + row * position.columns withObject: GCOthelloWhitePiece];
    [position.board replaceObjectAtIndex: col + (row + 1) * position.columns withObject: GCOthelloWhitePiece];
    [position.board replaceObjectAtIndex: 1 + col + (row + 1) * position.columns withObject: GCOthelloBlackPiece];
}


- (void) waitForHumanMoveWithCompletion: (GCMoveCompletionHandler) completionHandler
{
    moveHandler = completionHandler;
    
    if ([[[self generateMoves] objectAtIndex: 0] isEqual: @"PASS"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"No Legal Moves" 
                                                        message: @"Click OK to pass"
                                                       delegate: self
                                              cancelButtonTitle: @"OK" 
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else
    {
        [othelloView startReceivingTouches];
    }
}


- (GCPosition *) currentPosition
{
    return position;
}


- (GCPlayerSide) currentPlayerSide
{
    if (position.leftTurn)
        return GC_PLAYER_LEFT;
    else
        return GC_PLAYER_RIGHT;
}


- (GCPlayer *) leftPlayer
{
    return leftPlayer;
}


- (GCPlayer *) rightPlayer
{
    return rightPlayer;
}


- (void) doMove: (NSNumber *) move
{
    if ([move intValue] != -1)
    {
        NSArray *flips = [self getFlips: [move intValue]];
        NSString *playerPiece = (position.leftTurn ? GCOthelloBlackPiece : GCOthelloWhitePiece);
        for (NSNumber *slot in flips)
            [position.board replaceObjectAtIndex: [slot unsignedIntegerValue] withObject: playerPiece];
        [position.board replaceObjectAtIndex: [move unsignedIntValue] withObject: playerPiece];
    }
    
    position.leftTurn = !position.leftTurn;
    
    [othelloView setNeedsDisplay];
}


- (void) undoMove: (NSNumber *) move toPosition: (GCOthelloPosition *) previousPosition
{
    [position release];
    
    position = [previousPosition retain];
    
    [othelloView setNeedsDisplay];
}


- (GCGameValue *) primitive
{
	if ([[[self generateMoves] objectAtIndex: 0] isEqual: PASS])
    {
		position.leftTurn = !position.leftTurn;
		if ([[[self generateMoves] objectAtIndex: 0] isEqual: PASS])
        {
			position.leftTurn = !position.leftTurn;
            NSUInteger leftPlayerPieces = [position numberOfBlackPieces];
            NSUInteger rightPlayerPieces = [position numberOfWhitePieces];
			if (leftPlayerPieces > rightPlayerPieces)
            {
				if (position.leftTurn)
					return GCGameValueWin;
				else
					return GCGameValueLose;
			}
			else if (rightPlayerPieces > leftPlayerPieces)
            {
				if (position.leftTurn)
					return GCGameValueLose;
				else
					return GCGameValueWin;
			}
            else
            {
				return GCGameValueTie;
			}
		}
		position.leftTurn = !position.leftTurn;
	}
    
	return nil;
}


- (NSArray *) generateMoves
{
	NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity: position.rows * position.columns];
	for (int i = 0; i < position.rows * position.columns; i += 1)
    {
		if ([[position.board objectAtIndex:i] isEqualToString: GCOthelloBlankPiece])
        {
			if ([[self getFlips: i] count] > 0)
            {
				[moves addObject: [NSNumber numberWithInt:i]];
			}
		}
	}
    
	if ([moves count] == 0)
		[moves addObject: PASS];
    
	return [moves autorelease];
}


#pragma mark - GCOthelloViewDelegate

- (GCOthelloPosition *) position
{
    return position;
}


- (void) userChoseMove: (NSNumber *) slot
{
    [othelloView stopReceivingTouches];
    
    moveHandler(slot);
}

@end

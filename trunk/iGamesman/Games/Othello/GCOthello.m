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
        _position = nil;
        
        _leftPlayer = nil;
        _rightPlayer = nil;
        
        _othelloView = nil;
    }
    
    return self;
}


- (void) dealloc
{
    [_leftPlayer release];
    [_rightPlayer release];
    
    [_othelloView release];
    
    [super dealloc];
}


#pragma mark -

- (BOOL) isOutOfBounds: (int) loc offset: (int) offset
{
    int rows = [_position rows];
    int cols = [_position columns];
    
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
    int rows = [_position rows];
    int cols = [_position columns];
	NSMutableArray *flips = [[NSMutableArray alloc] initWithCapacity: rows * cols];
	if ([[[_position board] objectAtIndex: loc] isEqualToString: GCOthelloBlankPiece])
    {
		NSString *myPiece = [_position leftTurn] ? GCOthelloBlackPiece : GCOthelloWhitePiece;
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
				if ([[[_position board] objectAtIndex: tempLoc] isEqualToString: GCOthelloBlankPiece])
                    break; 
				if ([[[_position board] objectAtIndex: tempLoc] isEqualToString: myPiece])
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
	_moveHandler([NSNumber numberWithInt: -1]);
}


#pragma mark - GCGame protocol

- (NSString *) name
{
    return @"Othello";
}


- (UIView *) viewWithFrame: (CGRect) frame
{
    if (_othelloView)
        [_othelloView release];
    
    _othelloView = [[GCOthelloView alloc] initWithFrame: frame];
    [_othelloView setDelegate: self];
    return _othelloView;
}


- (void) startGameWithLeft: (GCPlayer *) left right: (GCPlayer *) right options: (NSDictionary *) options
{
    [left retain];
    [right retain];
    
    if (_leftPlayer)
        [_leftPlayer release];
    if (_rightPlayer)
        [_rightPlayer release];
    
    _leftPlayer = left;
    _rightPlayer = right;
    
    [_leftPlayer setEpithet: @"Black"];
    [_rightPlayer setEpithet: @"White"];
    
    if (_position)
        [_position release];
    
    _position = [[GCOthelloPosition alloc] initWithWidth: 8 height: 8];
    [_position setLeftTurn: YES];
    
    BOOL misere = [[options objectForKey: GCMisereOptionKey] boolValue];
    [_position setMisere: misere];
    
    int col = [_position columns] / 2 - 1;
    int row = [_position rows] / 2 - 1;
    [[_position board] replaceObjectAtIndex: col + row * [_position columns] withObject: GCOthelloBlackPiece];
    [[_position board] replaceObjectAtIndex: 1 + col + row * [_position columns] withObject: GCOthelloWhitePiece];
    [[_position board] replaceObjectAtIndex: col + (row + 1) * [_position columns] withObject: GCOthelloWhitePiece];
    [[_position board] replaceObjectAtIndex: 1 + col + (row + 1) * [_position columns] withObject: GCOthelloBlackPiece];
    
    [_othelloView setNeedsDisplay];
}


- (void) waitForHumanMoveWithCompletion: (GCMoveCompletionHandler) completionHandler
{
    _moveHandler = completionHandler;
    
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
        [_othelloView startReceivingTouches];
    }
}


- (GCPosition *) currentPosition
{
    return _position;
}


- (GCPlayerSide) currentPlayerSide
{
    if ([_position leftTurn])
        return GC_PLAYER_LEFT;
    else
        return GC_PLAYER_RIGHT;
}


- (GCPlayer *) leftPlayer
{
    return _leftPlayer;
}


- (GCPlayer *) rightPlayer
{
    return _rightPlayer;
}


- (void) doMove: (NSNumber *) move
{
    if ([move intValue] != -1)
    {
        NSArray *flips = [self getFlips: [move intValue]];
        NSString *playerPiece = ([_position leftTurn] ? GCOthelloBlackPiece : GCOthelloWhitePiece);
        for (NSNumber *slot in flips)
            [[_position board] replaceObjectAtIndex: [slot unsignedIntegerValue] withObject: playerPiece];
        [[_position board] replaceObjectAtIndex: [move unsignedIntValue] withObject: playerPiece];
    }
    
    [_position setLeftTurn: ![_position leftTurn]];
    
    [_othelloView setNeedsDisplay];
}


- (void) undoMove: (NSNumber *) move toPosition: (GCOthelloPosition *) previousPosition
{
    [_position release];
    
    _position = [previousPosition copy];
    
    [_othelloView setNeedsDisplay];
}


- (GCGameValue *) primitive
{
	if ([[[self generateMoves] objectAtIndex: 0] isEqual: PASS])
    {
		[_position setLeftTurn: ![_position leftTurn]];
		if ([[[self generateMoves] objectAtIndex: 0] isEqual: PASS])
        {
			[_position setLeftTurn: ![_position leftTurn]];
            NSUInteger leftPlayerPieces = [_position numberOfBlackPieces];
            NSUInteger rightPlayerPieces = [_position numberOfWhitePieces];
			if (leftPlayerPieces > rightPlayerPieces)
            {
				if ([_position leftTurn])
					return [_position isMisere] ? GCGameValueLose : GCGameValueWin;
				else
					return [_position isMisere] ? GCGameValueWin : GCGameValueLose;
			}
			else if (rightPlayerPieces > leftPlayerPieces)
            {
				if ([_position leftTurn])
					return [_position isMisere] ? GCGameValueWin : GCGameValueLose;
				else
					return [_position isMisere] ? GCGameValueLose : GCGameValueWin;
			}
            else
            {
				return GCGameValueTie;
			}
		}
		[_position setLeftTurn: ![_position leftTurn]];
	}
    
	return nil;
}


- (NSArray *) generateMoves
{
	NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity: [_position rows] * [_position columns]];
	for (int i = 0; i < [_position rows] * [_position columns]; i += 1)
    {
		if ([[[_position board] objectAtIndex:i] isEqualToString: GCOthelloBlankPiece])
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


- (BOOL) isMisere
{
    return [_position isMisere];
}


- (BOOL) canShowMoveValues
{
    return NO;
}


- (BOOL) canShowDeltaRemoteness
{
    return NO;
}


#pragma mark - GCOthelloViewDelegate

- (GCOthelloPosition *) position
{
    return _position;
}


- (void) userChoseMove: (NSNumber *) slot
{
    [_othelloView stopReceivingTouches];
    
    _moveHandler(slot);
}

@end

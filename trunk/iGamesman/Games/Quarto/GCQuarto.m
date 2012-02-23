//
//  GCQuarto.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/3/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCQuarto.h"

#import "GCPlayer.h"
#import "GCQuartoPiece.h"
#import "GCQuartoPosition.h"

@implementation GCQuarto

- (id) init
{
    self = [super init];
    
    if (self)
    {
        showMoveValues = showDeltaRemoteness = NO;
    }
    
    return self;
}


#pragma mark - GCGame protocol

- (NSString *) gcWebServiceName
{
    return @"quarto";
}


- (NSDictionary *) gcWebParameters
{
    return [NSDictionary dictionary];
}


- (NSString *) gcWebBoardString
{
    NSMutableString *boardString = [NSMutableString string];
    
    for (NSUInteger row = 0; row < 4; row += 1)
    {
        for (NSUInteger column = 0; column < 4; column += 1)
        {
            GCQuartoPiece *piece = [position pieceAtRow: row column: column];
            if ([piece isEqual: [GCQuartoPiece blankPiece]])
                [boardString appendString: @" "];
            else
            {
                int i = (piece.tall << 3) + (piece.square << 2) + (piece.hollow << 1) + (piece.white << 0);
                char pieceLetter = 'A' + i;
                [boardString appendFormat: @"%c", pieceLetter];
            }
        }
    }
    
    return [boardString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}


- (void) gcWebReportedPositionValue: (NSString *) value remoteness: (NSInteger) remoteness
{
    
}


- (void) gcWebReportedValues: (NSArray *) values remotenesses: (NSArray *) remotenesses forMoves: (NSArray *) moves
{
    
}


- (NSString *) name
{
    return @"Quarto";
}


- (UIView *) viewWithFrame: (CGRect) frame center: (CGPoint) center
{
    if (quartoView)
        [quartoView release];
    
    quartoView = [[GCQuartoView alloc] initWithFrame: frame];
    quartoView.delegate = self;
    quartoView.backgroundCenter = center;
    return quartoView;
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
    
    [leftPlayer setEpithet: nil];
    [rightPlayer setEpithet: nil];
    
    position = [[GCQuartoPosition alloc] init];
    position.phase = GCQ_LEFT_CHOOSE;
}


- (void) waitForHumanMoveWithCompletion: (GCMoveCompletionHandler) completionHandler
{
    moveHandler = completionHandler;
    
    [quartoView startReceivingTouches];
}


- (GCPosition *) currentPosition
{
    return position;
}


- (GCPlayerSide) currentPlayerSide
{
    if ((position.phase == GCQ_LEFT_CHOOSE) || (position.phase == GCQ_LEFT_PLACE))
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


- (void) doMove: (NSObject<NSCopying> *) move
{
    if ([move isKindOfClass: [NSString class]])
    {
        /* "Choose a piece" move */
        char pieceChar = (char) [(NSString *) move characterAtIndex: 0];
        
        NSUInteger pieceValue = pieceChar - 'A';
        
        BOOL tall   = ((pieceValue & 8) > 0);
        BOOL square = ((pieceValue & 4) > 0);
        BOOL hollow = ((pieceValue & 2) > 0);
        BOOL white  = ((pieceValue & 1) > 0);
        
        GCQuartoPiece *piece = [GCQuartoPiece pieceWithTall: tall square: square hollow: hollow white: white];
        
        [position setPlatformPiece: piece];
        
        [position.pieces removeObject: piece];
        
        if (position.phase == GCQ_LEFT_CHOOSE)
            position.phase = GCQ_RIGHT_PLACE;
        if (position.phase == GCQ_RIGHT_CHOOSE)
            position.phase = GCQ_LEFT_PLACE;
        
        [quartoView setNeedsDisplay];
    }
    else if ([move isKindOfClass: [NSNumber class]])
    {
        /* "Place a piece" move */
        NSUInteger slot = [(NSNumber *) move unsignedIntegerValue];
        
        [position placePiece: [position platformPiece] atRow: slot / 4 column: slot % 4];
        
        [position removePlatformPiece];
        
        if (position.phase == GCQ_LEFT_PLACE)
            position.phase = GCQ_LEFT_CHOOSE;
        if (position.phase == GCQ_RIGHT_PLACE)
            position.phase = GCQ_RIGHT_CHOOSE;
        
        [quartoView setNeedsDisplay];
    }
}


- (void) undoMove: (NSObject<NSCopying> *) move toPosition: (GCQuartoPosition *) previousPosition
{
    if ([move isKindOfClass: [NSString class]])
    {
        /* "Choose a piece" move */
        char pieceChar = (char) [(NSString *) move characterAtIndex: 0];
        NSUInteger pieceValue = pieceChar - 'A';
        
        BOOL tall   = ((pieceValue & 8) > 0);
        BOOL square = ((pieceValue & 4) > 0);
        BOOL hollow = ((pieceValue & 2) > 0);
        BOOL white  = ((pieceValue & 1) > 0);
        
        GCQuartoPiece *piece = [GCQuartoPiece pieceWithTall: tall square: square hollow: hollow white: white];
        
        [position.pieces addObject: piece];
        
        [position removePlatformPiece];
        
        if (position.phase == GCQ_LEFT_PLACE)
            position.phase = GCQ_RIGHT_CHOOSE;
        if (position.phase == GCQ_RIGHT_PLACE)
            position.phase = GCQ_LEFT_CHOOSE;
        
        [quartoView setNeedsDisplay];
    }
    else if ([move isKindOfClass: [NSNumber class]])
    {
        /* "Place a piece" move */
        NSUInteger slot = [(NSNumber *) move unsignedIntegerValue];
        
        [position setPlatformPiece: [position pieceAtRow: slot / 4 column: slot % 4]];
        
        [position removePieceAtRow: slot / 4 column: slot % 4];
        
        if (position.phase == GCQ_LEFT_CHOOSE)
            position.phase = GCQ_LEFT_PLACE;
        if (position.phase == GCQ_RIGHT_CHOOSE)
            position.phase = GCQ_RIGHT_PLACE;
        
        [quartoView setNeedsDisplay];
    }
}


- (GCGameValue *) primitive
{
    return [position primitive];
}


- (NSArray *) generateMoves
{
    return nil;
}


- (BOOL) isShowingMoveValues
{
    return showMoveValues;
}


- (BOOL) isShowingDeltaRemoteness
{
    return showDeltaRemoteness;
}


- (void) setShowingMoveValues: (BOOL) moveValues
{
    showMoveValues = moveValues;
    
    [quartoView setNeedsDisplay];
}


- (void) setShowingDeltaRemoteness: (BOOL) deltaRemoteness
{
    showDeltaRemoteness = deltaRemoteness;
    
    [quartoView setNeedsDisplay];
}


#pragma mark - GCQuartoViewDelegate

- (GCQuartoPosition *) position
{
    return position;
}


- (NSString *) leftPlayerName
{
    return [leftPlayer name];
}


- (NSString *) rightPlayerName
{
    return [rightPlayer name];
}


- (void) userChosePiece: (GCQuartoPiece *) piece
{
    [quartoView stopReceivingTouches];
    
    int i = (piece.tall << 3) + (piece.square << 2) + (piece.hollow << 1) + (piece.white << 0);
    char pieceLetter = 'A' + i;
    
    moveHandler([NSString stringWithFormat: @"%c", pieceLetter]);
}


- (void) userPlacedPiece: (NSUInteger) slot
{
    [quartoView stopReceivingTouches];
    
    moveHandler([NSNumber numberWithInt: slot]);
}

@end

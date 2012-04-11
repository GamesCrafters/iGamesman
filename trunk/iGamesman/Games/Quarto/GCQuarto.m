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
        _showMoveValues = _showDeltaRemoteness = NO;
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
            GCQuartoPiece *piece = [_position pieceAtRow: row column: column];
            if ([piece isEqual: [GCQuartoPiece blankPiece]])
                [boardString appendString: @" "];
            else
            {
                int i = ([piece tall] << 3) + ([piece square] << 2) + ([piece hollow] << 1) + ([piece white] << 0);
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


- (UIView *) viewWithFrame: (CGRect) frame
{
    if (_quartoView)
        [_quartoView release];
    
    _quartoView = [[GCQuartoView alloc] initWithFrame: frame];
    [_quartoView setDelegate: self];
    return _quartoView;
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
    
    [_leftPlayer setEpithet: nil];
    [_rightPlayer setEpithet: nil];
    
    _position = [[GCQuartoPosition alloc] init];
    [_position setPhase: GCQ_LEFT_CHOOSE];
    
    BOOL misere = [[options objectForKey: GCMisereOptionKey] boolValue];
    [_position setMisere: misere];
    
    [_quartoView setNeedsDisplay];
}


- (void) waitForHumanMoveWithCompletion: (GCMoveCompletionHandler) completionHandler
{
    _moveHandler = completionHandler;
    
    [_quartoView startReceivingTouches];
}


- (GCPosition *) currentPosition
{
    return _position;
}


- (GCPlayerSide) currentPlayerSide
{
    if (([_position phase] == GCQ_LEFT_CHOOSE) || ([_position phase] == GCQ_LEFT_PLACE))
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


- (void) doMove: (GCMove *) move
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
        
        [_position setPlatformPiece: piece];
        
        [[_position pieces] removeObject: piece];
        
        if ([_position phase] == GCQ_LEFT_CHOOSE)
            [_position setPhase: GCQ_RIGHT_PLACE];
        if ([_position phase] == GCQ_RIGHT_CHOOSE)
            [_position setPhase: GCQ_LEFT_PLACE];
        
        [_quartoView setNeedsDisplay];
    }
    else if ([move isKindOfClass: [NSNumber class]])
    {
        /* "Place a piece" move */
        NSUInteger slot = [(NSNumber *) move unsignedIntegerValue];
        
        [_position placePiece: [_position platformPiece] atRow: slot / 4 column: slot % 4];
        
        [_position removePlatformPiece];
        
        if ([_position phase] == GCQ_LEFT_PLACE)
            [_position setPhase: GCQ_LEFT_CHOOSE];
        if ([_position phase] == GCQ_RIGHT_PLACE)
            [_position setPhase: GCQ_RIGHT_CHOOSE];
        
        [_quartoView setNeedsDisplay];
    }
}


- (void) undoMove: (GCMove *) move toPosition: (GCQuartoPosition *) previousPosition
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
        
        [[_position pieces] addObject: piece];
        
        [_position removePlatformPiece];
        
        if ([_position phase] == GCQ_LEFT_PLACE)
            [_position setPhase: GCQ_RIGHT_CHOOSE];
        if ([_position phase] == GCQ_RIGHT_PLACE)
            [_position setPhase: GCQ_LEFT_CHOOSE];
        
        [_quartoView setNeedsDisplay];
    }
    else if ([move isKindOfClass: [NSNumber class]])
    {
        /* "Place a piece" move */
        NSUInteger slot = [(NSNumber *) move unsignedIntegerValue];
        
        [_position setPlatformPiece: [_position pieceAtRow: slot / 4 column: slot % 4]];
        
        [_position removePieceAtRow: slot / 4 column: slot % 4];
        
        if ([_position phase] == GCQ_LEFT_CHOOSE)
            [_position setPhase: GCQ_LEFT_PLACE];
        if ([_position phase] == GCQ_RIGHT_CHOOSE)
            [_position setPhase: GCQ_RIGHT_PLACE];
        
        [_quartoView setNeedsDisplay];
    }
}


- (GCGameValue *) primitive
{
    return [_position primitive];
}


- (NSArray *) generateMoves
{
    if (([_position phase] == GCQ_LEFT_CHOOSE) || ([_position phase] == GCQ_RIGHT_CHOOSE))
    {
        NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity: [[_position pieces] count]];
        for (GCQuartoPiece *piece in [_position pieces])
        {
            BOOL tall   = [piece tall];
            BOOL square = [piece square];
            BOOL hollow = [piece hollow];
            BOOL white  = [piece white];
            
            NSUInteger pieceValue = (tall << 3) + (square << 2) + (hollow << 1) + (white << 0);
            char pieceChar = pieceValue + 'A';
            
            [moves addObject: [NSString stringWithFormat: @"%c", pieceChar]];
        }
        
        return moves;
    }
    else
    {
        NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity: 16];
        for (NSUInteger row = 0; row < 4; row += 1)
        {
            for (NSUInteger col = 0; col < 4; col += 1)
            {
                GCQuartoPiece *piece = [_position pieceAtRow: row column: col];
                if ([piece blank])
                    [moves addObject: [NSNumber numberWithUnsignedInteger: row * 4 + col]];
            }
        }
        
        return moves;
    }
    
    return nil;
}


- (BOOL) isMisere
{
    return [_position isMisere];
}


- (BOOL) canShowMoveValues
{
    return YES;
}


- (BOOL) canShowDeltaRemoteness
{
    return YES;
}


- (BOOL) isShowingMoveValues
{
    return _showMoveValues;
}


- (BOOL) isShowingDeltaRemoteness
{
    return _showDeltaRemoteness;
}


- (void) setShowingMoveValues: (BOOL) moveValues
{
    _showMoveValues = moveValues;
    
    [_quartoView setNeedsDisplay];
}


- (void) setShowingDeltaRemoteness: (BOOL) deltaRemoteness
{
    _showDeltaRemoteness = deltaRemoteness;
    
    [_quartoView setNeedsDisplay];
}


#pragma mark - GCQuartoViewDelegate

- (GCQuartoPosition *) position
{
    return _position;
}


- (NSString *) leftPlayerName
{
    return [_leftPlayer name];
}


- (NSString *) rightPlayerName
{
    return [_rightPlayer name];
}


- (void) userChosePiece: (GCQuartoPiece *) piece
{
    [_quartoView stopReceivingTouches];
    
    int i = ([piece tall] << 3) + ([piece square] << 2) + ([piece hollow] << 1) + ([piece white] << 0);
    char pieceLetter = 'A' + i;
    
    _moveHandler([NSString stringWithFormat: @"%c", pieceLetter]);
}


- (void) userPlacedPiece: (NSUInteger) slot
{
    [_quartoView stopReceivingTouches];
    
    _moveHandler([NSNumber numberWithInt: slot]);
}

@end

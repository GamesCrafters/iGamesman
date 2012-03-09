//
//  GCGameController.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/12/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCGameController.h"

#import "GCGame.h"

#import "GCGameHistoryItem.h"
#import "GCMessageOverlayView.h"
#import "GCPlayer.h"
#import "GCStack.h"


@interface GCGameController ()
{
    GCMoveCompletionHandler moveHandler;
}

- (void) processHumanMove: (GCMove *) move;
- (void) goAfterDataFetch;

@end



@implementation GCGameController

#pragma mark - Memory lifecycle

- (id) initWithGame: (id<GCGame>) game andDelegate: (id<GCGameControllerDelegate>) delegate
{
    self = [super init];
    
    if (self)
    {
        _game = game;
        _delegate = delegate;
        
        [_delegate setUndoButtonEnabled: NO];
        [_delegate setRedoButtonEnabled: NO];
        
        _historyStack = [[GCStack alloc] init];
        _undoStack    = [[GCStack alloc] init];
        
        GCPosition *position = [[_game currentPosition] copy];
        GCGameHistoryItem *startingItem = [[GCGameHistoryItem alloc] initWithPosition: position
                                                                               player: [_game currentPlayerSide]
                                                                                 move: nil
                                                                                value: GCGameValueUnknown
                                                                           remoteness: -1];
        [position release];
        
        [_historyStack push: startingItem];
        [startingItem release];
        
        moveHandler = Block_copy(^(GCMove *move)
        {
            [self processHumanMove: move];
        });
        
        if ([_game respondsToSelector: @selector(gcWebServiceName)])
        {
            NSString *gcWebServiceName = [_game gcWebServiceName];
            NSDictionary *params = [_game gcWebParameters];
            _service = [[GCJSONService alloc] initWithServiceName: gcWebServiceName parameters: params];
            [_service setDelegate: self];
        }
        else
        {
            _service = nil;
        }
        
        _computerMoveDelay = 0.2f;
        _computerGameDelay = 1.0f;
        
        srandom(time(NULL));
    }
    
    return self;
}


- (void) dealloc
{
    [_historyStack release];
    [_undoStack release];
    
    Block_release(moveHandler);
    
    [_service release];
    
    [super dealloc];
}


#pragma mark - GCMetaSettingsPanelDelegate

- (CGFloat) computerMoveDelay
{
    return _computerMoveDelay;
}


- (void) setComputerMoveDelay: (CGFloat) delay
{
    _computerMoveDelay = delay;
}


- (CGFloat) computerGameDelay
{
    return _computerGameDelay;
}


- (void) setComputerGameDelay: (CGFloat) delay
{
    _computerGameDelay = delay;
}


#pragma mark - GCJSONServiceDelegate

- (void) jsonService: (GCJSONService *) service didReceivePositionValue: (GCGameValue *) value remoteness: (NSInteger) remoteness
{
    if ([_game respondsToSelector: @selector(gcWebReportedPositionValue:remoteness:)])
        [_game gcWebReportedPositionValue: value remoteness: remoteness];
    
    GCGameHistoryItem *historyItem = [_historyStack peek];
    [historyItem setGameValue: value];
    [historyItem setRemoteness: remoteness];
    
    [_delegate updateStatusLabel];
    [_delegate updateVVH];
}


- (void) jsonService: (GCJSONService *) service didReceiveValues: (NSArray *) values remotenesses: (NSArray *) remotenesses forMoves: (NSArray *) moves
{
    if ([_game respondsToSelector: @selector(gcWebReportedValues:remotenesses:forMoves:)])
        [_game gcWebReportedValues: values remotenesses: remotenesses forMoves: moves];
    
    if ([_game respondsToSelector: @selector(moveForGCWebMove:)])
    {
        for (NSUInteger i = 0; i < [moves count]; i += 1)
        {
            GCGameHistoryItem *currentItem = [_historyStack peek];
            [currentItem setGameValue: [values objectAtIndex: i]
                           remoteness: [[remotenesses objectAtIndex: i] integerValue]
                              forMove: [_game moveForGCWebMove: [moves objectAtIndex: i]]];
        }
    }
}


- (void) jsonService: (GCJSONService *) service didFailWithError: (NSError *) error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Server Error"
                                                    message: @"An error was encountered connecting to the GCWeb server"
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
    
    [[GCMessageOverlayView sharedOverlayView] finishingLoading];
}


- (void) jsonServiceDidFinish: (GCJSONService *) service
{
    [self goAfterDataFetch];
    
    [[GCMessageOverlayView sharedOverlayView] finishingLoading];
}


#pragma mark -

- (void) processHumanMove: (GCMove *) move
{
    [_undoStack flush];
    
    [_delegate setUndoButtonEnabled: YES];
    [_delegate setRedoButtonEnabled: NO];
    
    [_game doMove: move];
    
    [_delegate updateStatusLabel];
    [_delegate updateVVH];
    
    
    GCPosition *newPosition = [[_game currentPosition] copy];
    GCMove *moveCopy = [move copy];
    
    GCGameHistoryItem *historyItem = [[GCGameHistoryItem alloc] initWithPosition: newPosition
                                                                          player: [_game currentPlayerSide]
                                                                            move: moveCopy
                                                                           value: GCGameValueUnknown
                                                                      remoteness: -1];
    [_historyStack push: historyItem];
    [historyItem release];
    
    [newPosition release];
    [moveCopy release];
    
    
    [self go];
}


- (GCMove *) selectPerfectPlayMove
{
    GCGameHistoryItem *currentItem = [_historyStack peek];
    
    NSArray *moves = [currentItem moves];
    NSArray *legalMoves = [_game generateMoves];
    
    NSMutableArray *wins  = [[NSMutableArray alloc] initWithCapacity: [legalMoves count]];
    NSMutableArray *loses = [[NSMutableArray alloc] initWithCapacity: [legalMoves count]];
    NSMutableArray *ties  = [[NSMutableArray alloc] initWithCapacity: [legalMoves count]];
    NSMutableArray *draws = [[NSMutableArray alloc] initWithCapacity: [legalMoves count]];
    
    for (GCMove *M in legalMoves)
    {
        GCMove *itemMove = nil;
        for (GCMove *aMove in moves)
        {
            if ([aMove isEqual: M])
            {
                itemMove = aMove;
                break;
            }
        }
        
        if (!itemMove)
            continue;
        
        GCGameValue *mValue = [currentItem valueForMove: itemMove];
        
        if ([mValue isEqualToString: GCGameValueWin])
            [wins addObject: M];
        else if ([mValue isEqualToString: GCGameValueLose])
            [loses addObject: M];
        else if ([mValue isEqualToString: GCGameValueTie])
            [ties addObject: M];
        else if ([mValue isEqualToString: GCGameValueDraw])
            [draws addObject: M];
    }
    
    NSMutableArray *moveChoices = [[NSMutableArray alloc] initWithCapacity: [legalMoves count]];
    
    if ([wins count] > 0)
    {
        NSInteger minimumRemoteness = INT_MAX;
        for (GCMove *M in wins)
            minimumRemoteness = MIN(minimumRemoteness, [currentItem remotenessForMove: M]);
        
        for (GCMove *M in wins)
        {
            if ([currentItem remotenessForMove: M] == minimumRemoteness)
                [moveChoices addObject: M];
        }
    }
    else if ([ties count] > 0)
    {
        NSInteger maximumRemoteness = INT_MIN;
        for (GCMove *M in ties)
            maximumRemoteness = MAX(maximumRemoteness, [currentItem remotenessForMove: M]);
        
        for (GCMove *M in ties)
        {
            if ([currentItem remotenessForMove: M] == maximumRemoteness)
                [moveChoices addObject: M];
        }
    }
    else if ([draws count] > 0)
    {
        [moveChoices release];
        moveChoices = [draws copy];
    }
    else if ([loses count] > 0)
    {
        NSInteger maximumRemoteness = INT_MIN;
        for (GCMove *M in loses)
            maximumRemoteness = MAX(maximumRemoteness, [currentItem remotenessForMove: M]);
        
        for (GCMove *M in loses)
        {
            if ([currentItem remotenessForMove: M] == maximumRemoteness)
                [moveChoices addObject: M];
        }
    }
    else
    {
        [moveChoices release];
        moveChoices = [legalMoves mutableCopy];
    }
    
    NSUInteger choice = random() % [moveChoices count];
    GCMove *move = [moveChoices objectAtIndex: choice];
    
    [moveChoices release];
    
    [wins release];
    [loses release];
    [ties release];
    [draws release];
    
    return move;
}


- (void) makeComputerMove
{
    NSArray *legalMoves = [_game generateMoves];
    
    CGFloat percentPerfect;
    if ([_game currentPlayerSide] == GC_PLAYER_LEFT)
        percentPerfect = [[_game leftPlayer] percentPerfect];
    else
        percentPerfect = [[_game rightPlayer] percentPerfect];
    
    CGFloat perfectDecider = (random() % (1L << 16)) / ((CGFloat) (1L << 16));
    
    GCMove *move;
    
    if ([_game respondsToSelector: @selector(moveForGCWebMove:)] && (perfectDecider < percentPerfect))
    {
        move = [self selectPerfectPlayMove];
    }
    else
    {
        NSUInteger moveIndex = random() % [legalMoves count];
        move = [legalMoves objectAtIndex: moveIndex];
    }
    
    [NSThread sleepForTimeInterval: _computerMoveDelay];
    
    [_undoStack flush];
    
    [_delegate setUndoButtonEnabled: YES];
    [_delegate setRedoButtonEnabled: NO];
    
    [_game doMove: move];
    
    [_delegate updateStatusLabel];
    [_delegate updateVVH];
    
    [_runner cancel];
    [_runner release];
    _runner = nil;
    
    
    GCPosition *newPosition = [[_game currentPosition] copy];
    GCMove *moveCopy = [move copy];
    
    GCGameHistoryItem *historyItem = [[GCGameHistoryItem alloc] initWithPosition: newPosition
                                                                          player: [_game currentPlayerSide]
                                                                            move: moveCopy
                                                                           value: GCGameValueUnknown
                                                                      remoteness: -1];
    [_historyStack push: historyItem];
    [historyItem release];
    
    [newPosition release];
    [moveCopy release];
    
    
    [self performSelectorOnMainThread: @selector(go) withObject: nil waitUntilDone: NO];
}


- (void) startNewGame
{
    [NSThread sleepForTimeInterval: _computerGameDelay];
    
    [_game startGameWithLeft: [_game leftPlayer] right: [_game rightPlayer]];
    
    [_runner cancel];
    [_runner release];
    _runner = nil;
    
    [self performSelectorOnMainThread: @selector(go) withObject: nil waitUntilDone: NO];
}


- (void) go
{    
    if (_service)
    {
        GCPlayerSide currentSide = [_game currentPlayerSide];    
        
        NSString *boardString = [_game gcWebBoardString];
        
        [_service retrieveDataForBoard: boardString withKey: @"board" forPlayerSide: currentSide];
        
        [[GCMessageOverlayView sharedOverlayView] beginLoadingWithMessage: @"Hi"];
    }
    else
    {
        [self goAfterDataFetch];
    }
}
    
 
- (void) goAfterDataFetch
{
    GCPlayerSide currentSide = [_game currentPlayerSide];
    
    GCPlayer *currentPlayer;
    if (currentSide == GC_PLAYER_LEFT)
        currentPlayer = [_game leftPlayer];
    else if (currentSide == GC_PLAYER_RIGHT)
        currentPlayer = [_game rightPlayer];
    else
        currentPlayer = nil;

    if ([_game primitive] == nil)
    {
        if ([currentPlayer type] == GC_HUMAN)
        {
            [_game waitForHumanMoveWithCompletion: moveHandler];
        }
        else if ([currentPlayer type] == GC_COMPUTER)
        {
            _runner = [[NSThread alloc] initWithTarget: self selector: @selector(makeComputerMove) object: nil];
            [_runner start];
        }
    }
    else
    {
        if (([[_game leftPlayer] type] == GC_COMPUTER) && ([[_game rightPlayer] type] == GC_COMPUTER))
        {
            _runner = [[NSThread alloc] initWithTarget: self selector: @selector(startNewGame) object: nil];
            [_runner start];
        }
    }
}


- (void) undo
{
    GCGameHistoryItem *currentItem = [_historyStack peek];
    
    GCMove *previousMove = [[currentItem move] retain];
    
    [_undoStack push: currentItem];
    
    [_historyStack pop];
    
    
    GCGameHistoryItem *previousItem = [_historyStack peek];
    
    GCPosition *previousPosition = [[previousItem position] retain];
    
    
    [_delegate setRedoButtonEnabled: YES];
    
    if ([_historyStack count] == 1)
        [_delegate setUndoButtonEnabled: NO];
    else
        [_delegate setUndoButtonEnabled: YES];
    
    [_game undoMove: previousMove toPosition: previousPosition];
    [_delegate updateStatusLabel];
    [_delegate updateVVH];
    
    [previousPosition release];
    [previousMove release];
    
    GCPlayerType leftType  = [[_game leftPlayer] type];
    GCPlayerType rightType = [[_game rightPlayer] type];
    
    if (((leftType == GC_HUMAN) && (rightType == GC_COMPUTER)) ||
        ((leftType == GC_COMPUTER) && (rightType == GC_HUMAN)))
    {
        currentItem = [_historyStack peek];
        
        previousMove = [[currentItem move] retain];
        
        [_undoStack push: currentItem];
        
        [_historyStack pop];
        
        
        previousItem = [_historyStack peek];
        previousPosition = [[previousItem position] retain];
        
        
        [_delegate setRedoButtonEnabled: YES];
        
        if ([_historyStack count] == 1)
            [_delegate setUndoButtonEnabled: NO];
        else
            [_delegate setUndoButtonEnabled: YES];
        
        [_game undoMove: previousMove toPosition: previousPosition];
        [_delegate updateStatusLabel];
        [_delegate updateVVH];
        
        [previousPosition release];
        [previousMove release];
    }
    
    
    [self go];
}


- (void) redo
{
    GCGameHistoryItem *historyItem = [_undoStack peek];
    
    GCMove *nextMove = [[historyItem move] retain];
    
    [_historyStack push: historyItem];
    [_undoStack pop];
    
    [_delegate setUndoButtonEnabled: YES];
    
    if ([_undoStack isEmpty])
        [_delegate setRedoButtonEnabled: NO];
    else
        [_delegate setRedoButtonEnabled: YES];
    
    [_game doMove: nextMove];
    [_delegate updateStatusLabel];
    [_delegate updateVVH];
    
    [nextMove release];
    
    
    GCPlayerType leftType  = [[_game leftPlayer] type];
    GCPlayerType rightType = [[_game rightPlayer] type];
    
    if (((leftType == GC_HUMAN) && (rightType == GC_COMPUTER)) ||
        ((leftType == GC_COMPUTER) && (rightType == GC_HUMAN)))
    {
        historyItem = [_undoStack peek];
        
        nextMove = [[historyItem move] retain];
        
        [_historyStack push: historyItem];
        [_undoStack pop];
        
        if ([_undoStack isEmpty])
            [_delegate setRedoButtonEnabled: NO];
        else
            [_delegate setRedoButtonEnabled: YES];
        
        [_game doMove: nextMove];
        [_delegate updateStatusLabel];
        [_delegate updateVVH];
        
        [nextMove release];
    }
    
    [self go];
}


- (GCGameHistoryItem *) currentItem
{
    return [_historyStack peek];
}


- (NSEnumerator *) historyItemEnumerator
{
    return [_historyStack objectEnumerator];
}


@end

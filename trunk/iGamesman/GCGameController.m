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

- (id) initWithGame: (id<GCGame>) _game andDelegate: (id<GCGameControllerDelegate>) _delegate
{
    self = [super init];
    
    if (self)
    {
        game = _game;
        delegate = _delegate;
        
        [delegate setUndoButtonEnabled: NO];
        [delegate setRedoButtonEnabled: NO];
        
        historyStack = [[GCStack alloc] init];
        undoStack    = [[GCStack alloc] init];
        
        GCPosition *position = [[game currentPosition] copy];
        GCGameHistoryItem *startingItem = [[GCGameHistoryItem alloc] initWithPosition: position move: nil value: GCGameValueUnknown remoteness: -1];
        [position release];
        
        [historyStack push: startingItem];
        [startingItem release];
        
        moveHandler = Block_copy(^(GCMove *move)
        {
            [self processHumanMove: move];
        });
        
        if ([game respondsToSelector: @selector(gcWebServiceName)])
        {
            NSString *gcWebServiceName = [game gcWebServiceName];
            NSDictionary *params = [game gcWebParameters];
            service = [[GCJSONService alloc] initWithServiceName: gcWebServiceName parameters: params];
            service.delegate = self;
        }
        else
        {
            service = nil;
        }
        
        computerMoveDelay = 0.2f;
        computerGameDelay = 1.0f;
        
        srandom(time(NULL));
    }
    
    return self;
}


- (void) dealloc
{
    [historyStack release];
    [undoStack release];
    
    Block_release(moveHandler);
    
    [service release];
    
    [super dealloc];
}


#pragma mark - GCMetaSettingsPanelDelegate

- (CGFloat) computerMoveDelay
{
    return computerMoveDelay;
}


- (void) setComputerMoveDelay: (CGFloat) delay
{
    computerMoveDelay = delay;
}


- (CGFloat) computerGameDelay
{
    return computerGameDelay;
}


- (void) setComputerGameDelay: (CGFloat) delay
{
    computerGameDelay = delay;
}


#pragma mark - GCJSONServiceDelegate

- (void) jsonService: (GCJSONService *) service didReceivePositionValue: (GCGameValue *) value remoteness: (NSInteger) remoteness
{
    if ([game respondsToSelector: @selector(gcWebReportedPositionValue:remoteness:)])
        [game gcWebReportedPositionValue: value remoteness: remoteness];
    
    GCGameHistoryItem *historyItem = [historyStack peek];
    [historyItem setGameValue: value];
    [historyItem setRemoteness: remoteness];
    
    [delegate updateStatusLabel];
}


- (void) jsonService: (GCJSONService *) service didReceiveValues: (NSArray *) values remotenesses: (NSArray *) remotenesses forMoves: (NSArray *) moves
{
    if ([game respondsToSelector: @selector(gcWebReportedValues:remotenesses:forMoves:)])
        [game gcWebReportedValues: values remotenesses: remotenesses forMoves: moves];
    
    if ([game respondsToSelector: @selector(moveForGCWebMove:)])
    {
        for (NSUInteger i = 0; i < [moves count]; i += 1)
        {
            GCGameHistoryItem *currentItem = [historyStack peek];
            [currentItem setGameValue: [values objectAtIndex: i]
                           remoteness: [[remotenesses objectAtIndex: i] integerValue]
                              forMove: [game moveForGCWebMove: [moves objectAtIndex: i]]];
        }
    }
}


- (void) jsonServiceDidFinish: (GCJSONService *) service
{
    [self goAfterDataFetch];
    
    [[GCMessageOverlayView sharedOverlayView] finishingLoading];
}


#pragma mark -

- (void) processHumanMove: (GCMove *) move
{
    [undoStack flush];
    
    [delegate setUndoButtonEnabled: YES];
    [delegate setRedoButtonEnabled: NO];
    
    [game doMove: move];
    
    [delegate updateStatusLabel];
    
    
    GCPosition *newPosition = [[game currentPosition] copy];
    GCMove *moveCopy = [move copy];
    
    GCGameHistoryItem *historyItem = [[GCGameHistoryItem alloc] initWithPosition: newPosition move: moveCopy value: GCGameValueUnknown remoteness: -1];
    [historyStack push: historyItem];
    [historyItem release];
    
    [newPosition release];
    [moveCopy release];
    
    
    [self go];
}


- (GCMove *) selectPerfectPlayMove
{
    GCGameHistoryItem *currentItem = [historyStack peek];
    
    NSArray *moves = [currentItem moves];
    NSArray *legalMoves = [game generateMoves];
    
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
    NSArray *legalMoves = [game generateMoves];
    
    CGFloat percentPerfect;
    if ([game currentPlayerSide] == GC_PLAYER_LEFT)
        percentPerfect = [[game leftPlayer] percentPerfect];
    else
        percentPerfect = [[game rightPlayer] percentPerfect];
    
    CGFloat perfectDecider = (random() % (1L << 16)) / ((CGFloat) (1L << 16));
    
    GCMove *move;
    
    if ([game respondsToSelector: @selector(moveForGCWebMove:)] && (perfectDecider < percentPerfect))
    {
        move = [self selectPerfectPlayMove];
    }
    else
    {
        NSUInteger moveIndex = random() % [legalMoves count];
        move = [legalMoves objectAtIndex: moveIndex];
    }
    
    [NSThread sleepForTimeInterval: computerMoveDelay];
    
    [undoStack flush];
    
    [delegate setUndoButtonEnabled: YES];
    [delegate setRedoButtonEnabled: NO];
    
    [game doMove: move];
    
    [delegate updateStatusLabel];
    
    [runner cancel];
    [runner release];
    runner = nil;
    
    
    GCPosition *newPosition = [[game currentPosition] copy];
    GCMove *moveCopy = [move copy];
    
    GCGameHistoryItem *historyItem = [[GCGameHistoryItem alloc] initWithPosition: newPosition move: moveCopy value: GCGameValueUnknown remoteness: -1];
    [historyStack push: historyItem];
    [historyItem release];
    
    [newPosition release];
    [moveCopy release];
    
    
    [self performSelectorOnMainThread: @selector(go) withObject: nil waitUntilDone: NO];
}


- (void) startNewGame
{
    [NSThread sleepForTimeInterval: computerGameDelay];
    
    [game startGameWithLeft: [game leftPlayer] right: [game rightPlayer]];
    
    [runner cancel];
    [runner release];
    runner = nil;
    
    [self performSelectorOnMainThread: @selector(go) withObject: nil waitUntilDone: NO];
}


- (void) go
{    
    if (service)
    {
        GCPlayerSide currentSide = [game currentPlayerSide];    
        
        NSString *boardString = [game gcWebBoardString];
        
        [service retrieveDataForBoard: boardString withKey: @"board" forPlayerSide: currentSide];
        
        [[GCMessageOverlayView sharedOverlayView] beginLoadingWithMessage: @"Hi"];
    }
    else
    {
        [self goAfterDataFetch];
    }
}
    
 
- (void) goAfterDataFetch
{
    GCPlayerSide currentSide = [game currentPlayerSide];
    
    GCPlayer *currentPlayer;
    if (currentSide == GC_PLAYER_LEFT)
        currentPlayer = [game leftPlayer];
    else if (currentSide == GC_PLAYER_RIGHT)
        currentPlayer = [game rightPlayer];
    else
        currentPlayer = nil;

    if ([game primitive] == nil)
    {
        if ([currentPlayer type] == GC_HUMAN)
        {
            [game waitForHumanMoveWithCompletion: moveHandler];
        }
        else if ([currentPlayer type] == GC_COMPUTER)
        {
            runner = [[NSThread alloc] initWithTarget: self selector: @selector(makeComputerMove) object: nil];
            [runner start];
        }
    }
    else
    {
        if (([[game leftPlayer] type] == GC_COMPUTER) && ([[game rightPlayer] type] == GC_COMPUTER))
        {
            runner = [[NSThread alloc] initWithTarget: self selector: @selector(startNewGame) object: nil];
            [runner start];
        }
    }
}


- (void) undo
{
    GCGameHistoryItem *currentItem = [historyStack peek];
    
    GCMove *previousMove = [[currentItem move] retain];
    
    [undoStack push: currentItem];
    
    [historyStack pop];
    
    
    GCGameHistoryItem *previousItem = [historyStack peek];
    
    GCPosition *previousPosition = [[previousItem position] retain];
    
    
    [delegate setRedoButtonEnabled: YES];
    
    if ([historyStack count] == 1)
        [delegate setUndoButtonEnabled: NO];
    else
        [delegate setUndoButtonEnabled: YES];
    
    [game undoMove: previousMove toPosition: previousPosition];
    [delegate updateStatusLabel];
    
    [previousPosition release];
    [previousMove release];
    
    GCPlayerType leftType  = [[game leftPlayer] type];
    GCPlayerType rightType = [[game rightPlayer] type];
    
    if (((leftType == GC_HUMAN) && (rightType == GC_COMPUTER)) ||
        ((leftType == GC_COMPUTER) && (rightType == GC_HUMAN)))
    {
        currentItem = [historyStack peek];
        
        previousMove = [[currentItem move] retain];
        
        [undoStack push: currentItem];
        
        [historyStack pop];
        
        
        previousItem = [historyStack peek];
        previousPosition = [[previousItem position] retain];
        
        
        [delegate setRedoButtonEnabled: YES];
        
        if ([historyStack count] == 1)
            [delegate setUndoButtonEnabled: NO];
        else
            [delegate setUndoButtonEnabled: YES];
        
        [game undoMove: previousMove toPosition: previousPosition];
        [delegate updateStatusLabel];
        
        [previousPosition release];
        [previousMove release];
    }
    
    
    [self go];
}


- (void) redo
{
    GCGameHistoryItem *historyItem = [undoStack peek];
    
    GCMove *nextMove = [[historyItem move] retain];
    
    [historyStack push: historyItem];
    [undoStack pop];
    
    [delegate setUndoButtonEnabled: YES];
    
    if ([undoStack isEmpty])
        [delegate setRedoButtonEnabled: NO];
    else
        [delegate setRedoButtonEnabled: YES];
    
    [game doMove: nextMove];
    [delegate updateStatusLabel];
    
    [nextMove release];
    
    
    GCPlayerType leftType  = [[game leftPlayer] type];
    GCPlayerType rightType = [[game rightPlayer] type];
    
    if (((leftType == GC_HUMAN) && (rightType == GC_COMPUTER)) ||
        ((leftType == GC_COMPUTER) && (rightType == GC_HUMAN)))
    {
        historyItem = [undoStack peek];
        
        nextMove = [[historyItem move] retain];
        
        [historyStack push: historyItem];
        [undoStack pop];
        
        if ([undoStack isEmpty])
            [delegate setRedoButtonEnabled: NO];
        else
            [delegate setRedoButtonEnabled: YES];
        
        [game doMove: nextMove];
        [delegate updateStatusLabel];
        
        [nextMove release];
    }
    
    [self go];
}


- (GCGameHistoryItem *) currentItem
{
    return [historyStack peek];
}


@end

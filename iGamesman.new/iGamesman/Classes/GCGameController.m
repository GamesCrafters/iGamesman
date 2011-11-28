//
//  GCGameController.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/22/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import "GCGameController.h"

#import "GCGame.h"

#import "GCGameHistoryItem.h"
#import "GCPlayer.h"
#import "GCStack.h"


@implementation GCGameController


- (id) initWithGame: (id<GCGame>) _game andDelegate: (id<GCGameControllerDelegate>) _delegate
{
    self = [super init];
    
    if (self)
    {
        game = _game;
        
        historyStack = [[GCStack alloc] init];
        undoStack    = [[GCStack alloc] init];
        
        delegate = _delegate;
        
        [delegate setUndoButtonEnabled: NO];
        [delegate setRedoButtonEnabled: NO];
    }
    
    return self;
}


- (void) dealloc
{
    [historyStack release];
    [undoStack release];
    
    [super dealloc];
}


- (void) processHumanMove: (GCMove *) move
{
    GCPosition *position = [[game currentPosition] copy];
    GCMove *moveCopy = [move copy];
    
    GCGameHistoryItem *historyItem = [[GCGameHistoryItem alloc] initWithPosition: position andMove: moveCopy];
    [historyStack push: historyItem];
    [historyItem release];
    
    [position release];
    [moveCopy release];
    
    [undoStack flush];
    
    [delegate setUndoButtonEnabled: YES];
    [delegate setRedoButtonEnabled: NO];
    
    [game doMove: move];
    
    [self go];
}


- (void) go
{
    PlayerSide currentPlayerSide = [game currentPlayer];
    
    GCPlayer *currentPlayer;
    if (currentPlayerSide == PLAYER_LEFT)
        currentPlayer = [game leftPlayer];
    else
        currentPlayer = [game rightPlayer];
    
    
    void (^moveCompletion) (GCMove *) = ^(GCMove *move)
    {
        [self processHumanMove: move];
    };
    
    
    if ([game primitive] == nil)
    {
        if ([currentPlayer type] == HUMAN)
        {
            [game waitForHumanMoveWithCompletion: moveCompletion];
        }
        else
        {
            
        }
    }
}


- (void) undo
{
    GCGameHistoryItem *historyItem = [historyStack peek];
    
    GCPosition *pastPosition = [[historyItem position] retain];
    GCMove *pastMove = [[historyItem move] retain];
    
    [undoStack push: historyItem];
    
    [historyStack pop];
    
    [delegate setRedoButtonEnabled: YES];
    
    if ([historyStack isEmpty])
        [delegate setUndoButtonEnabled: NO];
    else
        [delegate setUndoButtonEnabled: YES];
    
    [game undoMove: pastMove toPosition: pastPosition];
    
    [pastPosition release];
    [pastMove release];
    
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
    
    [nextMove release];
    
    [self go];
}

@end

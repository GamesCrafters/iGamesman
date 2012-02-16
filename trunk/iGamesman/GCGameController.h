//
//  GCGameController.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/12/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCJSONService.h"

@protocol GCGame;
@protocol GCGameControllerDelegate;

@class GCStack;
@class GCGameHistoryItem;

@interface GCGameController : NSObject <GCJSONServiceDelegate>
{
    id<GCGame> game;
    id<GCGameControllerDelegate> delegate;
    
    GCStack *historyStack;
    GCStack *undoStack;
    
    GCJSONService *service;
    
    NSThread *runner;
}

- (id) initWithGame: (id<GCGame>) game andDelegate: (id<GCGameControllerDelegate>) delegate;

- (void) go;

- (void) undo;
- (void) redo;

- (GCGameHistoryItem *) currentItem;

@end



@protocol GCGameControllerDelegate

- (void) setUndoButtonEnabled: (BOOL) enabled;
- (void) setRedoButtonEnabled: (BOOL) enabled;
- (void) updateStatusLabel;

@end
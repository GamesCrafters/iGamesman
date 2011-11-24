//
//  GCGameController.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 11/22/11.
//  Copyright (c) 2011 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GCGame;
@protocol GCGameControllerDelegate;
@class GCStack;

@interface GCGameController : NSObject
{
    id<GCGame> game;
    id<GCGameControllerDelegate> delegate;
    
    GCStack *historyStack;
    GCStack *undoStack;
}

- (id) initWithGame: (id<GCGame>) game andDelegate: (id<GCGameControllerDelegate>) delegate;

- (void) go;

- (void) undo;
- (void) redo;

@end



@protocol GCGameControllerDelegate

- (void) setUndoButtonEnabled: (BOOL) enabled;
- (void) setRedoButtonEnabled: (BOOL) enabled;

@end

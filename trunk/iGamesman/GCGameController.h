//
//  GCGameController.h
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/12/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCJSONService.h"
#import "GCMetaSettingsPanelController.h"

@protocol GCGame;
@protocol GCGameControllerDelegate;

@class GCStack;
@class GCGameHistoryItem;

@interface GCGameController : NSObject <GCJSONServiceDelegate, GCMetaSettingsPanelDelegate>
{
    id<GCGame> _game;
    id<GCGameControllerDelegate> _delegate;
    
    GCStack *_historyStack;
    GCStack *_undoStack;
    
    GCJSONService *_service;
    
    NSThread *_runner;
    
    CGFloat _computerMoveDelay;
    CGFloat _computerGameDelay;
}

- (id) initWithGame: (id<GCGame>) game andDelegate: (id<GCGameControllerDelegate>) delegate;

- (void) start;
- (void) go;

- (void) undo;
- (void) redo;

- (GCGameHistoryItem *) currentItem;

- (NSEnumerator *) historyItemEnumerator;

@end



@protocol GCGameControllerDelegate

- (void) setUndoButtonEnabled: (BOOL) enabled;
- (void) setRedoButtonEnabled: (BOOL) enabled;
- (void) updateStatusLabel;
- (void) updateVVH;

@end